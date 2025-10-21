import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showCandidatePicker(BuildContext context, Map<String, dynamic> id) {
  final primary = (id['primary'] ?? {}) as Map<String, dynamic>;
  final candidates = (id['candidates'] ?? []) as List<dynamic>;
  final items = [primary, ...candidates.cast<Map<String, dynamic>>()].where((e) => e.isNotEmpty).toList();
  if (items.isEmpty) return Future.value(null);

  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) {
      int selected = 0;
      return StatefulBuilder(
        builder: (ctx, setSt) {
          final bottom = MediaQuery.of(ctx).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 6, bottom: 12), decoration: BoxDecoration(color: Theme.of(ctx).colorScheme.outlineVariant, borderRadius: BorderRadius.circular(100))),
                Row(
                  children: [
                    Expanded(child: Text('Is this the right item?', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close_rounded))
                  ],
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 12),
                    itemBuilder: (_, i) {
                      final it = items[i];
                      final parts = [
                        (it['brand'] ?? '').toString(),
                        (it['model'] ?? '').toString(),
                        (it['reference'] ?? '').toString()
                      ].where((e) => e.isNotEmpty).toList();
                      final title = parts.isEmpty ? 'Unknown' : parts.join(' ');
                      final conf = ((it['confidence'] ?? 0.0) as num).toDouble().clamp(0.0, 1.0);
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setSt(() => selected = i),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          child: Row(
                            children: [
                              _ConfidenceRing(value: conf),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text('Confidence ${(conf * 100).toStringAsFixed(0)}%', style: Theme.of(ctx).textTheme.bodySmall?.copyWith(color: Theme.of(ctx).colorScheme.onSurfaceVariant)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Radio<int>(value: i, groupValue: selected, onChanged: (v) => setSt(() => selected = v!))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(ctx, items[selected]),
                        child: const Text('Use this'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, {'__action__': 'add_more_photos', 'action': 'add_more_photos'}),
                        child: const Text('Add more photos'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _ConfidenceRing extends StatelessWidget {
  final double value;
  const _ConfidenceRing({required this.value});

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 4,
              backgroundColor: scheme.outlineVariant.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: scheme.surfaceContainerHighest, shape: BoxShape.circle),
            child: Text('$pct%', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
