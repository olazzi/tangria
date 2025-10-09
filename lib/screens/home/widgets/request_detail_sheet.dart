import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../../repository/ai_logs_repository.dart';
import '../../../local/db.dart';
import 'photos_grid.dart';

Future<String?> showRequestDetailSheet(BuildContext context, {required String requestId}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _RequestDetailSheet(requestId: requestId),
  );
}

class _RequestDetailSheet extends StatefulWidget {
  final String requestId;
  const _RequestDetailSheet({required this.requestId});
  @override
  State<_RequestDetailSheet> createState() => _RequestDetailSheetState();
}

class _RequestDetailSheetState extends State<_RequestDetailSheet> {
  late Future<_Data> _f;
  final _priceCtrl = TextEditingController();
  List<String> _paths = [];
  List<Uint8List> _bytes = [];
  String _manualTitle = '';
  String _manualDesc = '';

  @override
  void initState() {
    super.initState();
    _f = _load();
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<_Data> _load() async {
    final db = await AppDb.instance();
    final req = (await db.listRequests(limit: 1000)).firstWhere((e) => e.id == widget.requestId);
    final imgs = await AiLogsRepository().imagesOf(widget.requestId);

    String title = '';
    String price = '';
    String desc = '';
    Map<String, dynamic> fields = {};
    Map<String, dynamic> j = {};

    if ((req.responseJson ?? '').isNotEmpty) {
      try {
        j = jsonDecode(req.responseJson!);
        final pricing = j['pricing'] ?? {};
        final identify = j['identify'] ?? {};
        final primary = (identify['primary'] ?? {}) as Map<String, dynamic>;
        final mt = (j['manual_title'] ?? '').toString();
        final md = (j['manual_desc'] ?? '').toString();
        title = mt.isNotEmpty ? mt : '${primary['brand'] ?? ''} ${primary['model'] ?? ''}'.trim();
        price = '${pricing['price_estimate'] ?? ''}';
        desc = md.isNotEmpty ? md : (primary['category']?.toString() ?? '');
        fields = {
          'Brand': primary['brand'] ?? '',
          'Model': primary['model'] ?? '',
          'Category': primary['category'] ?? '',
          'Condition': primary['condition'] ?? '',
          'Movement': primary['movement'] ?? '',
          'Material': primary['material'] ?? '',
          'Dial Color': primary['dial_color'] ?? '',
          'Diameter (mm)': primary['diameter_mm']?.toString() ?? '',
          'Thickness (mm)': primary['thickness_mm']?.toString() ?? '',
          'Reference': primary['reference'] ?? '',
          'Year': primary['year']?.toString() ?? '',
        };
      } catch (_) {
        title = (req.responseText ?? '').split('\n').first;
      }
    } else {
      title = (req.responseText ?? '').split('\n').first;
    }

    _priceCtrl.text = price;

    final paths = imgs.map((e) => e.path ?? '').where((p) => p.isNotEmpty).toList();
    final bytes = <Uint8List>[];
    for (final p in paths) {
      try {
        bytes.add(await File(p).readAsBytes());
      } catch (_) {}
    }
    _paths = List.of(paths);
    _bytes = List.of(bytes);
    _manualTitle = title;
    _manualDesc = desc;

    return _Data(
      reqId: req.id,
      title: title,
      price: price,
      desc: desc,
      fields: fields,
    );
  }

  Future<void> _persistJsonPatch(String Function(Map<String, dynamic>) mut) async {
    final db = await AppDb.instance();
    final req = (await db.listRequests(limit: 1000)).firstWhere((e) => e.id == widget.requestId);
    Map<String, dynamic> j = {};
    if ((req.responseJson ?? '').isNotEmpty) {
      try { j = jsonDecode(req.responseJson!); } catch (_) { j = {}; }
    }
    final updated = mut(j);
    await db.updateRequestResponseJson(widget.requestId, updated);
  }

  Future<void> _persistPrice(_Data d, String newPrice) async {
    await _persistJsonPatch((j) {
      final pricing = Map<String, dynamic>.from(j['pricing'] ?? {});
      pricing['price_estimate'] = newPrice;
      j['pricing'] = pricing;
      return jsonEncode(j);
    });
  }

  Future<void> _persistOrder() async {
    final db = await AppDb.instance();
    for (int i = 0; i < _paths.length; i++) {
      await (db.update(db.aiRequestImage)
            ..where((t) => t.requestId.equals(widget.requestId) & t.path.equals(_paths[i])))
          .write(AiRequestImageCompanion(idx: drift.Value(i)));
    }
  }

  Future<void> _removeAt(int index) async {
    if (index < 0 || index >= _paths.length) return;
    final path = _paths[index];
    setState(() {
      _paths.removeAt(index);
      _bytes.removeAt(index);
    });
    final db = await AppDb.instance();
    await (db.delete(db.aiRequestImage)
          ..where((t) => t.requestId.equals(widget.requestId) & t.path.equals(path)))
        .go();
    await _persistOrder();
  }

  Future<void> _makeMainAt(int index) async {
    if (index <= 0 || index >= _paths.length) return;
    final p = _paths.removeAt(index);
    final b = _bytes.removeAt(index);
    setState(() {
      _paths.insert(0, p);
      _bytes.insert(0, b);
    });
    await _persistOrder();
  }

  Future<void> _editTitle() async {
    final ctrl = TextEditingController(text: _manualTitle);
    final r = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit title'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    if (r == null) return;
    setState(() => _manualTitle = r);
    await _persistJsonPatch((j) {
      j['manual_title'] = r;
      return jsonEncode(j);
    });
  }

  Future<void> _editDesc() async {
    final ctrl = TextEditingController(text: _manualDesc);
    final r = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit description'),
        content: TextField(controller: ctrl, autofocus: true, maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    if (r == null) return;
    setState(() => _manualDesc = r);
    await _persistJsonPatch((j) {
      j['manual_desc'] = r;
      return jsonEncode(j);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);

    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.9,
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: FutureBuilder<_Data>(
              future: _f,
              builder: (c, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (s.hasError || !s.hasData) {
                  return SizedBox(
                    height: mq.size.height * 0.4,
                    child: Center(child: Text('Failed to load', style: Theme.of(context).textTheme.titleMedium)),
                  );
                }
                final d = s.data!;
                final ref = (d.fields['Reference'] ?? '').toString();
                final year = (d.fields['Year'] ?? '').toString();
                final titleLine = [
                  _manualTitle.trim(),
                  if (year.isNotEmpty) year,
                  if (ref.isNotEmpty) '($ref)',
                ].where((e) => e.toString().trim().isNotEmpty).join(' ');

                return LayoutBuilder(
                  builder: (_, __) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 24 + mq.padding.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 4,
                                    margin: const EdgeInsets.only(top: 2, right: 8),
                                    decoration: BoxDecoration(
                                      color: cs.outlineVariant,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                              ],
                            ),
                          ),

                          if (_bytes.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: PhotosGrid(
                                photos: _bytes,
                                sending: false,
                                onRemoveAt: _removeAt,
                                onMakeMainAt: _makeMainAt,
                                initialIndex: 0,
                              ),
                            ),

                          const SizedBox(height: 16),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    titleLine.isEmpty ? 'Item' : titleLine,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: _editTitle,
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit'),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    d.price.isEmpty ? '\$— — — —' : d.price,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                if (ref.isNotEmpty)
                                  Text('Ref. $ref', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          if (_manualDesc.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _manualDesc.trim(),
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton.icon(
                                    onPressed: _editDesc,
                                    icon: const Icon(Icons.tune),
                                    label: const Text('Edit'),
                                  ),
                                ],
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: OutlinedButton.icon(
                                  onPressed: _editDesc,
                                  icon: const Icon(Icons.tune),
                                  label: const Text('Add description'),
                                ),
                              ),
                            ),

                          const SizedBox(height: 12),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: d.fields.entries
                                  .where((e) => '${e.value}'.trim().isNotEmpty && e.key != 'Reference' && e.key != 'Year')
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: Text(e.key, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text('${e.value}', style: Theme.of(context).textTheme.bodyMedium)),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _priceCtrl,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(labelText: 'Price', prefixIcon: Icon(Icons.price_change)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  height: 48,
                                  child: FilledButton(
                                    onPressed: () async {
                                      final p = _priceCtrl.text.trim();
                                      await _persistPrice(d, p);
                                      if (mounted) Navigator.pop(context, p);
                                    },
                                    child: const Text('Save'),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Data {
  final String reqId;
  final String title;
  final String price;
  final String desc;
  final Map<String, dynamic> fields;
  _Data({required this.reqId, required this.title, required this.price, required this.desc, required this.fields});
}
