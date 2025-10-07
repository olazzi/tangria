import 'dart:io';
import 'package:flutter/material.dart';
import '../repository/ai_logs_repository.dart';
import '../local/db.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _repo = AiLogsRepository();
  final _q = TextEditingController();
  List<AiRequestData> _all = [];
  List<AiRequestData> _view = [];
  late Future<void> _f;
  String _sort = 'newest';
  int _statusFilter = 0;
  final Map<String, List<String>> _thumbs = {};

  @override
  void initState() {
    super.initState();
    _f = _load();
    _q.addListener(_applyFilter);
  }

  Future<void> _load() async {
    _all = await _repo.list(limit: 200);
    for (final r in _all) {
      final imgs = await _repo.imagesOf(r.id);
      _thumbs[r.id] = imgs.map((e) => e.path ?? '').where((p) => p.isNotEmpty).toList();
    }
    _applyFilter();
  }

  List<AiRequestData> _filter(List<AiRequestData> src, String q) {
    final s = q.trim().toLowerCase();
    Iterable<AiRequestData> it = src;
    if (_statusFilter == 1) {
      it = it.where((e) => (e.statusCode ?? 0) >= 200 && (e.statusCode ?? 0) < 300);
    } else if (_statusFilter == 2) {
      it = it.where((e) => (e.statusCode ?? 0) >= 400 && (e.statusCode ?? 0) < 500);
    } else if (_statusFilter == 3) {
      it = it.where((e) => (e.statusCode ?? 0) >= 500);
    }
    if (s.isNotEmpty) {
      it = it.where((e) {
        final a = e.prompt ?? '';
        final b = e.responseText ?? '';
        final c = e.responseJson ?? '';
        return e.model.toLowerCase().contains(s) || a.toLowerCase().contains(s) || b.toLowerCase().contains(s) || c.toLowerCase().contains(s);
      });
    }
    final list = it.toList();
    list.sort((a, b) => _sort == 'newest' ? b.createdAt.compareTo(a.createdAt) : a.createdAt.compareTo(b.createdAt));
    return list;
  }

  void _applyFilter() {
    setState(() => _view = _filter(_all, _q.text));
  }

  Future<void> _refresh() async {
    await _load();
    setState(() {});
  }

  Future<void> _deleteItem(AiRequestData x) async {
    final imgs = await _repo.imagesOf(x.id);
    for (final i in imgs) {
      final p = i.path ?? '';
      if (p.isNotEmpty) {
        final f = File(p);
        if (await f.exists()) {
          try {
            await f.delete();
          } catch (_) {}
        }
      }
    }
    await _repo.delete(x.id);
    await _refresh();
  }

  Color _statusColor(int? code, BuildContext c) {
    if (code == null) return Theme.of(c).colorScheme.outlineVariant;
    if (code >= 200 && code < 300) return Colors.green;
    if (code >= 400 && code < 500) return Colors.amber;
    if (code >= 500) return Colors.red;
    return Theme.of(c).colorScheme.secondary;
  }

  Widget _statusChip(int? code, BuildContext c) {
    final col = _statusColor(code, c);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: col.withOpacity(0.15), borderRadius: BorderRadius.circular(999), border: Border.all(color: col.withOpacity(0.35))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.circle, size: 8, color: col),
        const SizedBox(width: 6),
        Text(code?.toString() ?? '-', style: TextStyle(color: col, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  String _ts(DateTime t) {
    final tt = t.toLocal();
    return '${tt.year}-${tt.month.toString().padLeft(2, '0')}-${tt.day.toString().padLeft(2, '0')} ${tt.hour.toString().padLeft(2, '0')}:${tt.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'newest' || v == 'oldest') {
                _sort = v;
                _applyFilter();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'newest', child: Text('Sort: Newest')),
              PopupMenuItem(value: 'oldest', child: Text('Sort: Oldest')),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _f,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [cs.primaryContainer, cs.surface], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _q,
                      decoration: InputDecoration(
                        hintText: 'Search history',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _q.text.isEmpty ? null : IconButton(icon: const Icon(Icons.close), onPressed: () => _q.clear()),
                        isDense: true,
                        filled: true,
                        fillColor: cs.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('All'),
                          selected: _statusFilter == 0,
                          onSelected: (_) {
                            _statusFilter = 0;
                            _applyFilter();
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('2xx'),
                          selected: _statusFilter == 1,
                          onSelected: (_) {
                            _statusFilter = 1;
                            _applyFilter();
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('4xx'),
                          selected: _statusFilter == 2,
                          onSelected: (_) {
                            _statusFilter = 2;
                            _applyFilter();
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('5xx'),
                          selected: _statusFilter == 3,
                          onSelected: (_) {
                            _statusFilter = 3;
                            _applyFilter();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: _view.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(height: 120),
                            Icon(Icons.history, size: 64, color: cs.outline),
                            const SizedBox(height: 12),
                            Text('No history', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 6),
                            Text('Pull to refresh or adjust filters', textAlign: TextAlign.center, style: TextStyle(color: cs.outline)),
                          ],
                        )
                      : ListView.separated(
                          itemCount: _view.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (c, i) {
                            final x = _view[i];
                            final sub = x.responseText?.isNotEmpty == true ? x.responseText! : (x.responseJson ?? '');
                            final imgs = _thumbs[x.id] ?? [];
                            return Dismissible(
                              key: ValueKey(x.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: BoxDecoration(color: cs.error, borderRadius: BorderRadius.circular(8)),
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (_) async {
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete entry?'),
                                    content: const Text('This will remove the record and its local images.'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                      FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (_) => _deleteItem(x),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                leading: imgs.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.file(File(imgs.first), width: 40, height: 40, fit: BoxFit.cover),
                                      )
                                    : const Icon(Icons.image_not_supported),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        sub,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _statusChip(x.statusCode, context),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(_ts(x.createdAt), style: TextStyle(color: cs.outline)),
                                    const SizedBox(height: 6),
                                    Text(sub, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => HistoryDetailScreen(requestId: x.id))).then((_) => _refresh()),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
