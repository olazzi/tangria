import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:tangria/screens/request/widgets/scroll_hint_arrows.dart';
import '../../repository/ai_logs_repository.dart';
import '../../local/db.dart';
import '../../services/velora_client.dart';
import 'widgets/detail_header.dart';
import 'widgets/price_ref_row.dart';
import 'widgets/photo_strip.dart';
import 'widgets/desc_block.dart';
import 'widgets/spec_grid.dart';
import 'widgets/price_editor.dart';
import '../request/widgets/candidate_picker.dart';

class RequestDetailCard extends StatefulWidget {
  final String requestId;
  const RequestDetailCard({super.key, required this.requestId});
  @override
  State<RequestDetailCard> createState() => _RequestDetailCardState();
}

class _RequestDetailCardState extends State<RequestDetailCard>
    with AutomaticKeepAliveClientMixin {
  late Future<_Data> _f;
  final _priceCtrl = TextEditingController();
  List<String> _paths = [];
  List<Uint8List> _bytes = [];
  bool _needsSelection = false;
  bool _loadingCandidates = false;
  bool _fetchAttempted = false;
  Map<String, dynamic> _identify = {};
  List<Map<String, dynamic>> _candidates = [];
  int _selectedCandidate = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _f = _load().then((d) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_needsSelection && !_fetchAttempted) {
          _loadingCandidates = true;
          setState(() {});
          await _ensureCandidates();
          _loadingCandidates = false;
          await _markFetchAttempted();
          if (mounted) setState(() {});
        }
      });
      return d;
    });
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  String _autoDescFrom(Map<String, dynamic> f) {
    final brand = (f['Brand'] ?? '').toString();
    final model = (f['Model'] ?? '').toString();
    final reference = (f['Reference'] ?? '').toString();
    final material = (f['Material'] ?? '').toString();
    final movement = (f['Movement'] ?? '').toString();
    final dial = (f['Dial Color'] ?? '').toString();
    final condition = (f['Condition'] ?? '').toString();
    final diameter = (f['Diameter (mm)'] ?? '').toString();
    final thickness = (f['Thickness (mm)'] ?? '').toString();
    final category = (f['Category'] ?? '').toString();
    final year = (f['Year'] ?? '').toString();
    final head = [
      if (brand.isNotEmpty) brand,
      if (model.isNotEmpty) model,
      if (reference.isNotEmpty) reference,
    ].join(' ').trim();
    final bits = <String>[];
    if (material.isNotEmpty) bits.add('$material case');
    if (movement.isNotEmpty) bits.add('$movement movement');
    if (dial.isNotEmpty) bits.add('$dial dial');
    if (category.isNotEmpty) bits.add(category);
    final dims = <String>[];
    if (diameter.isNotEmpty) dims.add('Diameter: ${diameter}mm');
    if (thickness.isNotEmpty) dims.add('Thickness: ${thickness}mm');
    if (dims.isNotEmpty) bits.add(dims.join(', '));
    if (condition.isNotEmpty) bits.add('Condition: $condition');
    if (year.isNotEmpty) bits.add('Year: $year');
    if (head.isEmpty && bits.isEmpty) return '';
    if (head.isEmpty) return bits.join(', ') + '.';
    return '$head — ${bits.join(', ')}.';
  }

  Future<_Data> _load() async {
    final db = await AppDb.instance();
    final req = (await db.listRequests(
      limit: 1000,
    )).firstWhere((e) => e.id == widget.requestId);
    final imgs = await AiLogsRepository().imagesOf(widget.requestId);
    String title = '';
    String price = '';
    String desc = '';
    Map<String, dynamic> fields = {};
    Map<String, dynamic> j = {};
    _needsSelection = false;
    _identify = {};
    _candidates = [];
    _fetchAttempted = false;
    if ((req.responseJson ?? '').isNotEmpty) {
      try {
        j = jsonDecode(req.responseJson!);
        _needsSelection = j['needs_selection'] == true;
        _fetchAttempted = j['candidate_fetch_attempted'] == true;
        final identify = j['identify'] ?? {};
        _identify = Map<String, dynamic>.from(identify is Map ? identify : {});
        final primary = (_identify['primary'] ?? {}) as Map<String, dynamic>;
        final cand = _identify['candidates'];
        final list = <Map<String, dynamic>>[];
        if (primary.isNotEmpty) {
          list.add(primary.map((k, v) => MapEntry(k.toString(), v)));
        }
        if (cand is List) {
          list.addAll(
            cand.whereType<Map>().map(
              (e) => e.map((k, v) => MapEntry(k.toString(), v)),
            ),
          );
        }
        _candidates = list.where((e) => e.isNotEmpty).toList();
        final brand = (primary['brand'] ?? '').toString();
        final model = (primary['model'] ?? '').toString();
        title = '$brand $model'.trim();
        final pricing = j['pricing'] ?? {};
        price = '${pricing['price_estimate'] ?? ''}';
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
        final detailed = (j['detailed_description'] ?? '').toString();
        desc = detailed.isNotEmpty ? detailed : _autoDescFrom(fields);
      } catch (_) {
        title = (req.responseText ?? '').split('\n').first;
      }
    } else {
      title = (req.responseText ?? '').split('\n').first;
    }
    _priceCtrl.text = price;
    final paths = imgs
        .map((e) => e.path ?? '')
        .where((p) => p.isNotEmpty)
        .toList();
    final bytes = <Uint8List>[];
    for (final p in paths) {
      try {
        bytes.add(await File(p).readAsBytes());
      } catch (_) {}
    }
    _paths = List.of(paths);
    _bytes = List.of(bytes);
    return _Data(
      reqId: req.id,
      title: title,
      price: price,
      desc: desc,
      fields: fields,
    );
  }

  Future<void> _markFetchAttempted() async {
    await _persistJsonPatch((j) {
      j['candidate_fetch_attempted'] = true;
      return jsonEncode(j);
    });
    _fetchAttempted = true;
  }

  Future<void> _persistJsonPatch(
    String Function(Map<String, dynamic>) mut,
  ) async {
    final db = await AppDb.instance();
    final req = (await db.listRequests(
      limit: 1000,
    )).firstWhere((e) => e.id == widget.requestId);
    Map<String, dynamic> j = {};
    if ((req.responseJson ?? '').isNotEmpty) {
      try {
        j = jsonDecode(req.responseJson!);
      } catch (_) {
        j = {};
      }
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
      await (db.update(db.aiRequestImage)..where(
            (t) =>
                t.requestId.equals(widget.requestId) & t.path.equals(_paths[i]),
          ))
          .write(AiRequestImageCompanion(idx: drift.Value(i)));
    }
  }

  Future<void> _removeAt(int index) async {
    if (_paths.length <= 1) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Can't remove the last photo.")),
        );
      }
      return;
    }
    if (index < 0 || index >= _paths.length) return;
    final path = _paths[index];
    setState(() {
      _paths.removeAt(index);
      _bytes.removeAt(index);
    });
    final db = await AppDb.instance();
    await (db.delete(db.aiRequestImage)..where(
          (t) => t.requestId.equals(widget.requestId) & t.path.equals(path),
        ))
        .go();
    try {
      final f = File(path);
      if (await f.exists()) {
        await f.delete();
      }
    } catch (_) {}
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

  Future<void> _ensureCandidates() async {
    if (_bytes.isEmpty) return;
    try {
      final id = await VeloraClient.identifyMulti(_bytes);
      _identify = Map<String, dynamic>.from(id is Map ? id : {});
      final primary = (_identify['primary'] ?? {}) as Map<String, dynamic>;
      final cand = _identify['candidates'];
      final list = <Map<String, dynamic>>[];
      if (primary.isNotEmpty) {
        list.add(primary.map((k, v) => MapEntry(k.toString(), v)));
      }
      if (cand is List) {
        list.addAll(
          cand.whereType<Map>().map(
            (e) => e.map((k, v) => MapEntry(k.toString(), v)),
          ),
        );
      }
      _candidates = list.where((e) => e.isNotEmpty).toList();
      _selectedCandidate = 0;
      await _persistJsonPatch((j) {
        j['identify'] = {'primary': primary, 'candidates': _candidates};
        j['needs_selection'] = true;
        return jsonEncode(j);
      });
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _useSelectedCandidate(_Data d) async {
    if (_candidates.isEmpty) return;
    final sel = _candidates[_selectedCandidate];
    try {
      final pricing = await VeloraClient.priceFromSelection(
        sel,
        primaryMeta: _identify['primary'] is Map<String, dynamic>
            ? _identify['primary']
            : null,
      );
      final primary = _mergePrimaryAfterSelection(_identify['primary'], sel);
      await _persistJsonPatch((j) {
        final jj = j is Map<String, dynamic> ? j : {};
        jj['identify'] = {'primary': primary, 'candidates': _candidates};
        jj['pricing'] = {'price_estimate': pricing['price_estimate'] ?? ''};
        jj['needs_selection'] = false;
        jj['candidate_fetch_attempted'] = true;
        return jsonEncode(jj);
      });
      final brand = (primary['brand'] ?? '').toString();
      final model = (primary['model'] ?? '').toString();
      final price = (pricing['price_estimate'] ?? '').toString();
      final fields = {
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
      setState(() {
        _needsSelection = false;
        _fetchAttempted = true;
        _priceCtrl.text = price;
        _f = Future.value(
          _Data(
            reqId: d.reqId,
            title: '$brand $model'.trim(),
            price: price,
            desc: _autoDescFrom(fields),
            fields: fields,
          ),
        );
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Item updated')));
      }
    } catch (_) {}
  }

  Map<String, dynamic> _mergePrimaryAfterSelection(
    dynamic primary,
    dynamic sel,
  ) {
    final p = Map<String, dynamic>.from(primary is Map ? primary : {});
    final s = Map<String, dynamic>.from(sel is Map ? sel : {});
    if ((s['brand'] ?? '').toString().isNotEmpty) p['brand'] = s['brand'];
    if ((s['model'] ?? '').toString().isNotEmpty) p['model'] = s['model'];
    if ((s['reference'] ?? '').toString().isNotEmpty)
      p['reference'] = s['reference'];
    if ((s['category'] ?? '').toString().isNotEmpty)
      p['category'] = s['category'];
    return p;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<_Data>(
      future: _f,
      builder: (c, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.hasError || !s.hasData) {
          return Center(
            child: Text(
              'Failed to load',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }
        final d = s.data!;
        final ref = (d.fields['Reference'] ?? '').toString();
        final year = (d.fields['Year'] ?? '').toString();
        final titleLine = [
          d.title.trim(),
          if (year.isNotEmpty) year,
          if (ref.isNotEmpty) '($ref)',
        ].where((e) => e.toString().trim().isNotEmpty).join(' ');
        final pickerItems = _candidates.take(3).toList();

        return Stack(
          children: [
            LayoutBuilder(
              builder: (context, vp) {
                if (_needsSelection && pickerItems.isNotEmpty) {
                  return SafeArea(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 45),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DetailHeader(
                                title: titleLine.isEmpty ? 'Item' : titleLine,
                                onDelete: _confirmDelete,
                              ),
                              const SizedBox(height: 2),
                              PriceRefRow(
                                priceText: d.price.isEmpty
                                    ? '\$— — — —'
                                    : d.price,
                                referenceText: ref,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: vp.maxHeight * 0.25,
                                child: PhotoStrip(bytes: _bytes),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: CandidatePicker(
                                  scrollable: true,
                                  candidates: pickerItems,
                                  selectedIndex: _selectedCandidate,
                                  onChanged: (i) =>
                                      setState(() => _selectedCandidate = i),
                                  onConfirm: () async =>
                                      await _useSelectedCandidate(d),
                                  onAddPhotos: () {},
                                  compact: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: MediaQuery.of(context).padding.bottom - 17,
                          child: Center(
                            child: ScrollHintArrows(
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SafeArea(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 56),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DetailHeader(
                              title: titleLine.isEmpty ? 'Item' : titleLine,
                              onDelete: _confirmDelete,
                            ),
                            const SizedBox(height: 2),
                            PriceRefRow(
                              priceText: d.price.isEmpty
                                  ? '\$— — — —'
                                  : d.price,
                              referenceText: ref,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: vp.maxHeight * 0.24,
                              child: PhotoStrip(bytes: _bytes),
                            ),
                            if (d.desc.trim().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              SizedBox(
                                height: vp.maxHeight * 0.12,
                                child: DescBlock(text: d.desc.trim()),
                              ),
                            ],
                            const SizedBox(height: 6),
                            SizedBox(
                              height: vp.maxHeight * 0.18,
                              child: SpecGrid(fields: d.fields),
                            ),
                            const SizedBox(height: 6),
                            PriceEditor(
                              controller: _priceCtrl,
                              onSave: () async {
                                final p = _priceCtrl.text.trim();
                                await _persistPrice(d, p);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Price updated'),
                                    ),
                                  );
                                }
                              },
                            ),
                            if (_needsSelection &&
                                pickerItems.isEmpty &&
                                !_loadingCandidates)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: FilledButton.tonal(
                                    onPressed: () async {
                                      setState(() => _loadingCandidates = true);
                                      await _ensureCandidates();
                                      _loadingCandidates = false;
                                      await _markFetchAttempted();
                                      if (mounted) setState(() {});
                                    },
                                    child: const Text('Load candidates'),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: MediaQuery.of(context).padding.bottom,
                        child: const ScrollHintArrows(
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (_needsSelection && (_loadingCandidates))
              IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(strokeWidth: 4),
                      ),
                      SizedBox(height: 12),
                      Text('Still loading…'),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete item?'),
        content: const Text(
          'This will remove the item and its photos from your collection. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonalIcon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        final db = await AppDb.instance();
        final images = await db.imagesOf(widget.requestId);
        for (final im in images) {
          final p = im.path ?? '';
          if (p.isNotEmpty) {
            try {
              final f = File(p);
              if (await f.exists()) await f.delete();
            } catch (_) {}
          }
        }
        await db.deleteRequest(widget.requestId);
      } catch (_) {}
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item deleted')));
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}

class _Data {
  final String reqId;
  final String title;
  final String price;
  final String desc;
  final Map<String, dynamic> fields;
  _Data({
    required this.reqId,
    required this.title,
    required this.price,
    required this.desc,
    required this.fields,
  });
}
