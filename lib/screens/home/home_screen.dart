import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../repository/ai_logs_repository.dart';
import '../../models/price_quote.dart';
import '../../services/velora_client.dart';
import '../../utils/image_shrink.dart';
import '../../local/db.dart';
import 'widgets/history_list.dart';
import '../../services/history_service.dart';
import 'widgets/selected_item_sheet.dart';
import 'widgets/watch_search_bar.dart';
import 'package:tangria/app/collection_events.dart';
import '../collection/collection_paper_page.dart';
import 'package:flutter/services.dart';
import './widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _Item {
  final List<Uint8List> photos;
  PriceQuote? quote;
  _Item(this.photos);
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final _picker = ImagePicker();
  final _repo = AiLogsRepository();
  final List<_Item> _items = [_Item([])];
  int _active = 0;
  late Future<List<HistoryCardData>> _historyF;
  bool _sheetVisible = false;
  void Function(VoidCallback fn)? _sheetSetState;
  String _q = '';
  Timer? _qDebounce;
  bool _creating = false;

  _Item get _current => _items[_active];
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _historyF = HistoryService.load();
  }

  @override
  void dispose() {
    _qDebounce?.cancel();
    super.dispose();
  }

  void _refreshHistory() {
    setState(() {
      _historyF = HistoryService.load();
    });
  }

  Future<Set<int>> _snapshotHistoryIds() async {
    try {
      final list = await HistoryService.load();
      return list
          .map((e) {
            final id = e.id;
            if (id is int) return id;
            if (id is String) return int.tryParse(id);
            return null;
          })
          .whereType<int>()
          .toSet();
    } catch (_) {
      return <int>{};
    }
  }

  Future<int?> _findNewestIdDiff(Set<int> before) async {
    try {
      final list = await HistoryService.load();
      for (final h in list) {
        final dynamic id = h.id;
        int? parsed;
        if (id is int) {
          parsed = id;
        } else if (id is String) {
          parsed = int.tryParse(id);
        } else {
          parsed = null;
        }
        if (parsed != null && !before.contains(parsed)) return parsed;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _addFromGallery(BuildContext ctx) async {
    try {
      final picked = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1280,
        maxHeight: 1280,
      );
      if (picked.isEmpty) return;
      final raws = await Future.wait(picked.map((x) => x.readAsBytes()));
      final shrunk = await shrinkBatch(raws);
      if (!mounted) return;
      setState(() => _current.photos.addAll(shrunk));
      _sheetSetState?.call(() {});
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gallery unavailable')));
    }
  }

  Future<void> _addFromCamera(BuildContext ctx) async {
    final wasSheetOpen = _sheetVisible;
    try {
      if (wasSheetOpen) {
        Navigator.of(ctx).maybePop();
        await Future.delayed(const Duration(milliseconds: 120));
      }
      final x = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1280,
        maxHeight: 1280,
      );
      if (x == null) {
        if (wasSheetOpen && mounted) _openSheet(expanded: true);
        return;
      }
      final s = await shrinkOne(await x.readAsBytes());
      if (!mounted) return;
      setState(() => _current.photos.add(s));
      _sheetSetState?.call(() {});
      if (wasSheetOpen && mounted) _openSheet(expanded: true);
    } on PlatformException catch (_) {
      try {
        final y = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 1280,
          maxHeight: 1280,
        );
        if (y == null) {
          if (wasSheetOpen && mounted) _openSheet(expanded: true);
          return;
        }
        final s = await shrinkOne(await y.readAsBytes());
        if (!mounted) return;
        setState(() => _current.photos.add(s));
        _sheetSetState?.call(() {});
        if (wasSheetOpen && mounted) _openSheet(expanded: true);
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Camera unavailable')));
        if (wasSheetOpen && mounted) _openSheet(expanded: true);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera unavailable')));
      if (wasSheetOpen && mounted) _openSheet(expanded: true);
    }
  }

  void _clearCurrent() {
    setState(() {
      _current.photos.clear();
      _current.quote = null;
    });
    _sheetSetState?.call(() {});
  }

  Future<void> _identifyAndPatch(int createdId, List<Uint8List> photos) async {
    try {
      final res = await VeloraClient.identifyMulti(photos);
      final db = await AppDb.instance();
      await db.updateRequestResponseJson(
        createdId.toString(),
        '{"identify":${_safeJson(res)},"needs_selection":true}',
      );
      CollectionEvents.bump();
      if (!mounted) return;
      _refreshHistory();
    } catch (_) {}
  }

  String _safeJson(dynamic v) {
    try {
      return v == null ? 'null' : (v is String ? v : v.toString());
    } catch (_) {
      return 'null';
    }
  }

  Future<void> _sendCurrent() async {
    if (_creating) return;
    if (_current.photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add some beautiful photos of your item.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      _openSheet(expanded: true);
      return;
    }
    setState(() => _creating = true);
    final beforeIds = await _snapshotHistoryIds();
    final photos = List<Uint8List>.from(_current.photos);
    try {
      await _repo.logRequest(
        model: 'gpt-4o-mini',
        temperature: 0,
        statusCode: 200,
        latencyMs: 0,
        prompt: 'identify',
        responseText: '',
        responseJson: const {'needs_selection': true, 'pending': true},
        images: photos,
        imageMimeTypes: List.filled(photos.length, 'image/jpeg'),
      );
      _refreshHistory();
      final createdId = await _findNewestIdDiff(beforeIds);
      if (createdId != null) {
        unawaited(_identifyAndPatch(createdId, photos));
      }
      _clearCurrent();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to create item')));
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _openPagerForId(int id) async {
    final db = await AppDb.instance();
    final all = await db.listRequests(limit: 1000);
    final ids = all.map((e) => e.id.toString()).toList();
    final idx = ids.indexOf(id.toString());
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CollectionPagerPage(ids: ids, initialIndex: idx < 0 ? 0 : idx),
      ),
    );
    _refreshHistory();
  }

  void _openSheet({bool expanded = true}) {
    if (_sheetVisible) return;
    _sheetVisible = true;
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final ctrl = DraggableScrollableController();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ctrl.isAttached) {
            ctrl.animateTo(
              0.95,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            _sheetSetState = setModalState;
            return DraggableScrollableSheet(
              controller: ctrl,
              initialChildSize: expanded ? 0.95 : 0.95,
              minChildSize: 0.18,
              maxChildSize: 0.98,
              snap: true,
              snapSizes: const [0.5, 0.8, 0.98],
              builder: (_, scrollCtrl) {
                return ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: SelectedItemSheet(
                      photos: _current.photos,
                      sending: _creating,
                      collapsed: false,
                      scrollController: scrollCtrl,
                      onCamera: () => _addFromCamera(ctx),
                      onGallery: () => _addFromGallery(ctx),
                      onEstimate: () {
                        if (_creating) return;
                        Navigator.of(ctx).maybePop();
                        _sendCurrent();
                      },
                      onClear: _clearCurrent,
                      onClose: () => Navigator.of(ctx).maybePop(),
                      onRemovePhoto: (i) {
                        setState(() => _current.photos.removeAt(i));
                        _sheetSetState?.call(() {});
                      },
                      onToggleCollapse: () async {
                        if (!ctrl.isAttached) return;
                        final size = ctrl.size;
                        final target = size < 0.9 ? 0.95 : 0.5;
                        await ctrl.animateTo(
                          target,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).whenComplete(() {
      _sheetVisible = false;
      _sheetSetState = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: const AppDrawer(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Morbi',
          style: TextStyle(
            fontFamily: 'Tektur',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Tooltip(
              message: 'Add',
              child: SizedBox(
                width: 44,
                height: 44,
                child: Material(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _openSheet(expanded: true),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: WatchSearchBar(
              onChanged: (v) {
                _qDebounce?.cancel();
                _qDebounce = Timer(
                  const Duration(milliseconds: 250),
                  () => setState(() => _q = v),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<HistoryCardData>>(
            future: _historyF,
            builder: (c, s) {
              if (s.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (s.hasError) return const SizedBox();
              final items = s.data ?? [];
              final q = _q.trim().toLowerCase();
              final filtered = q.isEmpty
                  ? items
                  : items.where((h) {
                      final t = (h.title ?? '').toString().toLowerCase();
                      final d = (h.desc ?? '').toString().toLowerCase();
                      final p = (h.price ?? '').toString().toLowerCase();
                      return t.contains(q) || d.contains(q) || p.contains(q);
                    }).toList();
              if (filtered.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.watch_outlined,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No items found',
                          style: TextStyle(
                            fontFamily: 'Tektur',
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try adding items using the plus button above.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return HistoryList(
                items: filtered,
                onTap: (h) async {
                  final db = await AppDb.instance();
                  final all = await db.listRequests(limit: 1000);
                  final ids = all.map((e) => e.id.toString()).toList();
                  final idx = ids.indexOf(h.id.toString());
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CollectionPagerPage(
                        ids: ids,
                        initialIndex: idx < 0 ? 0 : idx,
                      ),
                    ),
                  );
                  _refreshHistory();
                },
                onDelete: (h) async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Remove from collection?'),
                      content: const Text(
                        'This will delete the item from your collection.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await HistoryService.delete(h.id.toString());
                    _refreshHistory();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item removed')),
                    );
                  }
                },
              );
            },
          ),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}
