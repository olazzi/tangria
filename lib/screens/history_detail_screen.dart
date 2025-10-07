import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../repository/ai_logs_repository.dart';
import '../local/db.dart';
import 'package:flutter/services.dart';

class HistoryDetailScreen extends StatefulWidget {
  final String requestId;
  const HistoryDetailScreen({super.key, required this.requestId});
  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  late Future<_Data> _f;

  Future<_Data> _load() async {
    final db = await AppDb.instance();
    final all = await db.listRequests(limit: 1000);
    final req = all.firstWhere((e) => e.id == widget.requestId);
    final imgs = await AiLogsRepository().imagesOf(widget.requestId);
    return _Data(req, imgs);
  }

  @override
  void initState() {
    super.initState();
    _f = _load();
  }

  Color _statusColor(int? code, BuildContext c) {
    if (code == null) return Theme.of(c).colorScheme.outlineVariant;
    if (code >= 200 && code < 300) return Colors.green;
    if (code >= 400 && code < 500) return Colors.amber;
    if (code >= 500) return Colors.red;
    return Theme.of(c).colorScheme.secondary;
  }

  String _prettyJson(String raw) {
    try {
      final obj = jsonDecode(raw);
      return const JsonEncoder.withIndent('  ').convert(obj);
    } catch (_) {
      return raw;
    }
  }

  Future<void> _copy(String v) async {
    await Clipboard.setData(ClipboardData(text: v));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
  }

  void _openImage(String path) {
    if (path.isEmpty) return;
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: InteractiveViewer(
            child: Hero(
              tag: path,
              child: Image.file(File(path), fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Detail'),
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder<_Data>(
        future: _f,
        builder: (c, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: cs.error),
                    const SizedBox(height: 12),
                    Text('Failed to load', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('${s.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(onPressed: () => setState(() => _f = _load()), icon: const Icon(Icons.refresh), label: const Text('Retry')),
                  ],
                ),
              ),
            );
          }
          final d = s.data!;
          final t = d.req.createdAt.toLocal();
          final ts = '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        label: Text(d.req.model ?? 'Unknown'),
                        avatar: const Icon(Icons.memory, size: 18),
                        side: BorderSide(color: cs.outlineVariant),
                      ),
                      Chip(
                        label: Text(ts),
                        avatar: const Icon(Icons.schedule, size: 18),
                        side: BorderSide(color: cs.outlineVariant),
                      ),
                      Chip(
                        label: Text('${d.req.latencyMs ?? 0} ms'),
                        avatar: const Icon(Icons.speed, size: 18),
                        side: BorderSide(color: cs.outlineVariant),
                      ),
                      Chip(
                        label: Text('Status ${d.req.statusCode ?? 0}'),
                        avatar: const Icon(Icons.check_circle, size: 18, color: Colors.white),
                        backgroundColor: _statusColor(d.req.statusCode, context),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              if (d.imgs.isNotEmpty)
                _SectionCard(
                  title: 'Images',
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: d.imgs.length,
                    itemBuilder: (c, i) {
                      final p = d.imgs[i].path ?? '';
                      if (p.isEmpty) return const SizedBox();
                      return GestureDetector(
                        onTap: () => _openImage(p),
                        child: Hero(
                          tag: p,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(File(p), fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if ((d.req.responseText ?? '').isNotEmpty)
                _SectionCard(
                  title: 'Response',
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copy(d.req.responseText!),
                    tooltip: 'Copy',
                  ),
                  child: SelectableText(
                    d.req.responseText!,
                    style: const TextStyle(fontFamily: 'monospace', height: 1.4),
                  ),
                ),
              if ((d.req.responseJson ?? '').isNotEmpty)
                _SectionCard(
                  title: 'Response JSON',
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: const Icon(Icons.code),
                      onPressed: () {},
                      tooltip: 'Pretty',
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _copy(_prettyJson(d.req.responseJson!)),
                      tooltip: 'Copy',
                    ),
                  ]),
                  child: SelectableText(
                    _prettyJson(d.req.responseJson!),
                    style: const TextStyle(fontFamily: 'monospace', height: 1.4),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  const _SectionCard({required this.title, required this.child, this.trailing});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              if (trailing != null) trailing!,
            ]),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _Data {
  final AiRequestData req;
  final List<AiRequestImageData> imgs;
  _Data(this.req, this.imgs);
}
