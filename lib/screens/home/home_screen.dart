// lib/screens/home/home_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';
import '../../repository/ai_logs_repository.dart';
import '../../models/price_quote.dart';
import '../../services/velora_client.dart';
import '../../utils/image_shrink.dart';
import '../../local/db.dart';
import 'widgets/candidate_picker.dart';
import 'widgets/history_list.dart';
import 'widgets/request_detail_sheet.dart';
import '../../services/history_service.dart';
import 'widgets/selected_item_sheet.dart';
import 'widgets/watch_search_bar.dart';
import 'package:flutter/material.dart';
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

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  final _picker = ImagePicker();
  final _repo = AiLogsRepository();
  final List<_Item> _items = [_Item([])];
  int _active = 0;
  bool _sending = false;
  late Future<List<HistoryCardData>> _historyF;
  int? _pendingDetailId;
  bool _sheetVisible = false;
  void Function(VoidCallback fn)? _sheetSetState;
  String _q = '';

  _Item get _current => _items[_active];
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _historyF = HistoryService.load();
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

  bool _isAddMoreAction(dynamic sel) {
    if (sel is Map) {
      final v = (sel['__action__'] ?? sel['action'] ?? '').toString().toLowerCase().trim();
      return v == 'add_more_photos' || v == 'use_more_photos' || v == 'more_photos' || v == 'add_more';
    }
    if (sel is String) {
      final v = sel.toLowerCase().trim();
      return v == 'add_more_photos' || v == 'use_more_photos' || v == 'more_photos' || v == 'add_more';
    }
    return false;
  }

  Future<void> _addFromGallery(BuildContext ctx) async {
    final picked = await _picker.pickMultiImage(imageQuality: 85, maxWidth: 1280, maxHeight: 1280);
    if (picked.isEmpty) return;
    final raws = await Future.wait(picked.map((x) => x.readAsBytes()));
    final shrunk = await shrinkBatch(raws);
    setState(() => _current.photos.addAll(shrunk));
    _sheetSetState?.call(() {});
  }

  Future<void> _addFromCamera(BuildContext ctx) async {
    final x = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85, maxWidth: 1280, maxHeight: 1280);
    if (x == null) return;
    final s = await shrinkOne(await x.readAsBytes());
    setState(() => _current.photos.add(s));
    _sheetSetState?.call(() {});
  }

  void _clearCurrent() {
    setState(() => _current..photos.clear()..quote = null);
    _sheetSetState?.call(() {});
  }

  Future<void> _sendCurrent() async {
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
    setState(() {
      _pendingDetailId = null;
      _sending = true;
    });
    final beforeIds = await _snapshotHistoryIds();
    try {
      final id = await VeloraClient.identifyMulti(_current.photos);
      if ((id['error'] ?? '') == 'INCONSISTENT_IMAGES') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photos belong to different items.')));
        }
        setState(() => _sending = false);
        return;
      }
      final sel = await showCandidatePicker(context, id);
      if (sel == null) {
        setState(() => _sending = false);
        return;
      }
      if (_isAddMoreAction(sel)) {
        setState(() => _sending = false);
        _openSheet(expanded: true);
        return;
      }
      final pricing = await VeloraClient.priceFromSelection(sel, primaryMeta: id['primary'] as Map<String, dynamic>?);
      final pq = PriceQuote.fromJson({
        'category': id['primary']?['category'] ?? '',
        'brand': sel['brand'] ?? '',
        'model': sel['model'] ?? '',
        'condition': (id['primary']?['condition'] ?? '') as String,
        'price_estimate': pricing['price_estimate'] ?? '',
        'error': '',
        'company': sel['brand'] ?? '',
        'description': '',
        'reference number': sel['reference'] ?? '',
        'movement': id['primary']?['movement'] ?? '',
        'material': id['primary']?['material'] ?? '',
        'dial color': id['primary']?['dial_color'] ?? '',
        'diameter': id['primary']?['diameter_mm']?.toString() ?? '',
        'thickness': id['primary']?['thickness_mm']?.toString() ?? '',
        'depth rating': '',
      });
      setState(() => _current.quote = pq);
      await _repo.logRequest(
        model: 'gpt-4o-mini',
        temperature: 0,
        statusCode: 200,
        latencyMs: 0,
        prompt: 'identify+price',
        responseText: '${pq.brand} ${pq.model} ${pq.priceRange}'.trim(),
        responseJson: {'identify': id, 'pricing': pricing},
        images: _current.photos,
        imageMimeTypes: List.filled(_current.photos.length, 'image/jpeg'),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estimate ready')));
      _refreshHistory();
      final newestId = await _findNewestIdDiff(beforeIds);
      setState(() => _pendingDetailId = newestId);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to get estimate')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _openDetail(int id) async {
    await showRequestDetailSheet(context, requestId: id.toString());
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
            ctrl.animateTo(0.95, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: SelectedItemSheet(
                      photos: _current.photos,
                      sending: _sending,
                      collapsed: false,
                      scrollController: scrollCtrl,
                      onCamera: () => _addFromCamera(ctx),
                      onGallery: () => _addFromGallery(ctx),
                      onEstimate: () {
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
                        await ctrl.animateTo(target, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
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
    final showView = _pendingDetailId != null && !_sending;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Velora',
          style: TextStyle(
            fontFamily: 'Tektur',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: WatchSearchBar(
                  onChanged: (v) => setState(() => _q = v),
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
                  if (filtered.isEmpty) return const SizedBox();
                  return HistoryList(
                    items: filtered,
                    onTap: (h) async {
                      final updated = await showRequestDetailSheet(context, requestId: h.id.toString());
                      if (updated != null) {
                        await AppDb.instance();
                        _refreshHistory();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Price updated')),
                          );
                        }
                      }
                    },
                    onDelete: (h) async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Remove from collection?'),
                          content: const Text('This will delete the item from your collection.'),
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
                      if (ok != true) return;
                      await HistoryService.delete(h.id.toString());
                      _refreshHistory();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item removed')),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 96),
            ],
          ),
       

Positioned(
  right: 20,
  bottom: 16,
  child: SafeArea(
    top: false,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.25),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.25)),
            
          ),
          child: FloatingActionButton(
            heroTag: 'velora-overlay-fab',
            backgroundColor: Colors.transparent,
            elevation: 0,
            tooltip: showView ? 'View details' : (_sending ? 'Estimating…' : 'Open gallery sheet'),
            onPressed: () async {
              if (showView) {
                final id = _pendingDetailId!;
                setState(() => _pendingDetailId = null);
                await _openDetail(id);
                return;
              }
              _openSheet(expanded: true);
            },
            child: showView
                ? const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.visibility_outlined, color: Colors.white, size: 34),
                  )
                : (_sending
                    ? const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Icon(Icons.diamond, color: Colors.white, size: 41),
                      )),
          ),
        ),
      ),
    ),
  ),
)


        ],
      ),
    );
  }
}
