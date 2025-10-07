import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../repository/ai_logs_repository.dart';
import '../../models/price_quote.dart';
import '../../widgets/primary_button.dart';
import '../../services/velora_client.dart';
import '../../utils/image_shrink.dart';
import 'widgets/item_chips.dart';
import 'widgets/action_bar.dart';
import 'widgets/photos_grid.dart';
import 'widgets/price_summary.dart';
import 'widgets/candidate_picker.dart';

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
  final _picker = ImagePicker();
  final _repo = AiLogsRepository();
  final List<_Item> _items = [_Item([])];
  int _active = 0;
  bool _sending = false;

  _Item get _current => _items[_active];

  Future<void> _addFromGallery() async {
    final picked = await _picker.pickMultiImage(imageQuality: 85, maxWidth: 1280, maxHeight: 1280);
    if (picked.isEmpty) return;
    final raws = await Future.wait(picked.map((x) => x.readAsBytes()));
    final shrunk = await shrinkBatch(raws); // utils/image_shrink.dart
    setState(() => _current.photos.addAll(shrunk));
  }

  Future<void> _addFromCamera() async {
    final x = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85, maxWidth: 1280, maxHeight: 1280);
    if (x == null) return;
    final s = await shrinkOne(await x.readAsBytes());
    setState(() => _current.photos.add(s));
  }

  void _newItem() => setState(() { _items.add(_Item([])); _active = _items.length - 1; });
  void _removeItem(int i) { if (_items.length==1) return; setState(() { _items.removeAt(i); _active = _active.clamp(0, _items.length-1); }); }
  void _removePhoto(int i) => setState(() => _current.photos.removeAt(i));
  void _clearCurrent() => setState(() => _current..photos.clear()..quote = null);

  Future<void> _sendCurrent() async {
    if (_current.photos.isEmpty) return;
    setState(() => _sending = true);
    try {
      final id = await VeloraClient.identifyMulti(_current.photos);
      if ((id['error'] ?? '') == 'INCONSISTENT_IMAGES') {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photos belong to different items.')));
        return;
      }
      final sel = await showCandidatePicker(context, id); // widgets/candidate_picker.dart
      if (sel == null) return;
      final pricing = await VeloraClient.priceFromSelection(sel, primaryMeta: id['primary'] as Map<String,dynamic>?);

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
      await _repo.logRequest(model:'gpt-4o-mini', temperature:0, statusCode:200, latencyMs:0,
        prompt:'identify+price', responseText:'${pq.brand} ${pq.model} ${pq.priceRange}'.trim(),
        responseJson:{'identify': id, 'pricing': pricing}, images:_current.photos,
        imageMimeTypes: List.filled(_current.photos.length, 'image/jpeg'));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to get estimate')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final quote = _current.quote;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tangria'),
        backgroundColor: cs.inversePrimary,
        actions: [IconButton(onPressed: _newItem, icon: const Icon(Icons.add_photo_alternate))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PriceSummary(quote: quote, photos: _current.photos.length, activeIndex: _active), // widgets/price_summary.dart
          const SizedBox(height: 12),
          ItemChips(count: _items.length, active: _active, onSelect: (i)=> setState(()=> _active=i), onRemove: _removeItem), // item_chips.dart
          const SizedBox(height: 12),
          ActionBar(
            sending: _sending,
            onAddPhotos: _addFromGallery,
            onCamera: _addFromCamera,
            onEstimate: _sendCurrent,
            onClear: _clearCurrent,
          ), // action_bar.dart
          const SizedBox(height: 16),
          PhotosGrid(
            photos: _current.photos,
            sending: _sending,
            onRemoveAt: _removePhoto,
          ), // photos_grid.dart
          const SizedBox(height: 16),
          if (_sending) const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
