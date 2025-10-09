// lib/screens/home/home_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _picker = ImagePicker();
  final _repo = AiLogsRepository();
  final List<_Item> _items = [_Item([])];
  int _active = 0;
  bool _sending = false;
  bool _sheetCollapsed = false;
  bool _sheetOpen = false;
  void Function(VoidCallback fn)? _modalSetState;
  late Future<List<HistoryCardData>> _historyF;
  DraggableScrollableController? _dragCtrl;

  _Item get _current => _items[_active];

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

  void _openSheetExpandedNextFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureSheet(openExpanded: true);
      setState(() {});
    });
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

  Future<void> _addFromGallery() async {
    final picked = await _picker.pickMultiImage(imageQuality: 85, maxWidth: 1280, maxHeight: 1280);
    if (picked.isEmpty) {
      _ensureSheet(openExpanded: true);
      return;
    }
    final raws = await Future.wait(picked.map((x) => x.readAsBytes()));
    final shrunk = await shrinkBatch(raws);
    setState(() => _current.photos.addAll(shrunk));
    _ensureSheet(openExpanded: true);
    _modalSetState?.call(() {});
  }

  Future<void> _addFromCamera() async {
    final x = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85, maxWidth: 1280, maxHeight: 1280);
    if (x == null) {
      _ensureSheet(openExpanded: true);
      return;
    }
    final s = await shrinkOne(await x.readAsBytes());
    setState(() => _current.photos.add(s));
    _ensureSheet(openExpanded: true);
    _modalSetState?.call(() {});
  }

  void _newItem() {
    setState(() {
      _items.add(_Item([]));
      _active = _items.length - 1;
    });
    _ensureSheet(openExpanded: true);
    _modalSetState?.call(() {});
  }



  void _clearCurrent() {
    setState(() => _current..photos.clear()..quote = null);
    _modalSetState?.call(() {});
  }

  Future<void> _animateSheet(double size) async {
    final c = _dragCtrl;
    if (c == null) return;
    if (!c.isAttached) return;
    await c.animateTo(size, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  Future<void> _collapseToPeek() => _animateSheet(0.18);
  Future<void> _expandSheet() => _animateSheet(0.88);

  Future<void> _sendCurrent() async {
    if (_current.photos.isEmpty) {
      _ensureSheet(openExpanded: true);
      return;
    }
    setState(() {
      _sending = true;
      _sheetCollapsed = true;
    });
    await _collapseToPeek();
    try {
      final id = await VeloraClient.identifyMulti(_current.photos);
      if ((id['error'] ?? '') == 'INCONSISTENT_IMAGES') {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photos belong to different items.')));
        setState(() => _sending = false);
        return;
      }
      final sel = await showCandidatePicker(context, id);
      if (sel == null) {
        setState(() => _sending = false);
        return;
      }
      if (_isAddMoreAction(sel)) {
        _openSheetExpandedNextFrame();
        setState(() => _sending = false);
        await _expandSheet();
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estimate ready')));
        _refreshHistory();
        setState(() => _sheetCollapsed = false);
        _modalSetState?.call(() {});
        await _expandSheet();
      }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to get estimate')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _ensureSheet({bool openExpanded = false}) {
    if (_sheetOpen) {
      setState(() => _sheetCollapsed = !openExpanded);
      _modalSetState?.call(() {});
      if (openExpanded) _expandSheet();
      return;
    }
    _sheetCollapsed = !openExpanded;
    _sheetOpen = true;
    _dragCtrl = DraggableScrollableController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            _modalSetState = setModalState;
            double currentExtent = openExpanded ? 0.88 : 0.24;

            return DraggableScrollableSheet(
              controller: _dragCtrl,
              initialChildSize: openExpanded ? 0.88 : 0.24,
              minChildSize: 0.18,
              maxChildSize: 0.95,
              snap: true,
              snapSizes: const [0.24, 0.7, 0.95],
              builder: (c, scrollCtrl) {
                return NotificationListener<DraggableScrollableNotification>(
                  onNotification: (n) {
                    currentExtent = n.extent;
                    final col = n.extent <= 0.26;
                    if (col != _sheetCollapsed) {
                      setState(() => _sheetCollapsed = col);
                      setModalState(() {});
                    }
                    return false;
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Material(
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        children: [
                          Expanded(
                            child: SelectedItemSheet(
                              photos: _current.photos,
                              sending: _sending,
                              collapsed: currentExtent <= 0.26,
                              scrollController: scrollCtrl,
                              onCamera: _addFromCamera,
                              onGallery: _addFromGallery,
                              onEstimate: _sendCurrent,
                              onClear: _clearCurrent,
                              onNewItem: _newItem,
                              onClose: () => Navigator.of(context).maybePop(),
                              onToggleCollapse: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        _sheetOpen = false;
        _modalSetState = null;
        _dragCtrl = null;
      });
    });
  }

  void _openSheet() => _ensureSheet(openExpanded: true);


@override
Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
 
  return Scaffold(
     backgroundColor: Colors.white,
    key: _scaffoldKey,
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
  

body: ListView(
  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
  children: [
    const SizedBox(height: 12),
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: WatchSearchBar(),
    ),
    const SizedBox(height: 12),
    FutureBuilder<List<HistoryCardData>>(
      future: _historyF,
      builder: (c, s) {
        if (s.connectionState == ConnectionState.waiting) return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
        if (s.hasError) return const SizedBox();
        final items = s.data ?? [];
        if (items.isEmpty) return const SizedBox();
        return HistoryList(
          items: items,
          onTap: (h) async {
            final updated = await showRequestDetailSheet(context, requestId: h.id);
            if (updated != null) {
              await AppDb.instance();
              _refreshHistory();
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Price updated')));
            }
          },
        );
      },
    ),
    const SizedBox(height: 16),
  ],
),

    floatingActionButton: FloatingActionButton(
      onPressed: _openSheet,
      child: const Icon(Icons.collections),
    ),
  );
}

}
