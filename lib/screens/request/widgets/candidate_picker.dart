import 'package:flutter/material.dart';

class CandidatePicker extends StatelessWidget {
  final List<Map<String, dynamic>> candidates;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final VoidCallback onConfirm;
  final VoidCallback onAddPhotos;
  final bool scrollable;
  final bool compact;

  const CandidatePicker({
    super.key,
    required this.candidates,
    required this.selectedIndex,
    required this.onChanged,
    required this.onConfirm,
    required this.onAddPhotos,
    this.scrollable = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ringSize = compact ? 36.0 : 44.0;
    final ringInner = compact ? 28.0 : 34.0;
    final vPad = compact ? 4.0 : 6.0;
    final tagHPad = compact ? 8.0 : 10.0;
    final tagVPad = compact ? 4.0 : 6.0;

    final list = ListView.separated(
      shrinkWrap: !scrollable,
      physics: scrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: candidates.length,
      separatorBuilder: (_, __) => const Divider(height: 16),
      itemBuilder: (_, i) {
        final it = candidates[i];
        final parts = [
          (it['brand'] ?? '').toString(),
          (it['model'] ?? '').toString(),
          (it['reference'] ?? '').toString(),
        ].where((e) => e.isNotEmpty).toList();
        final title = parts.isEmpty ? 'Unknown' : parts.join(' ');
        final conf = ((it['confidence'] ?? 0.0) as num).toDouble().clamp(
          0.0,
          1.0,
        );
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onChanged(i),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: vPad, horizontal: 4),
              child: Row(
                children: [
                  _ConfidenceRing(
                    value: conf,
                    size: ringSize,
                    inner: ringInner,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            if ((it['brand'] ?? '').toString().isNotEmpty)
                              _Tag(
                                (it['brand'] ?? '').toString(),
                                hPad: tagHPad,
                                vPad: tagVPad,
                              ),
                            if ((it['model'] ?? '').toString().isNotEmpty)
                              _Tag(
                                (it['model'] ?? '').toString(),
                                hPad: tagHPad,
                                vPad: tagVPad,
                              ),
                            if ((it['reference'] ?? '').toString().isNotEmpty)
                              _Tag(
                                'Ref ${(it['reference'] ?? '').toString()}',
                                hPad: tagHPad,
                                vPad: tagVPad,
                              ),
                            if ((it['category'] ?? '').toString().isNotEmpty)
                              _Tag(
                                (it['category'] ?? '').toString(),
                                hPad: tagHPad,
                                vPad: tagVPad,
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Confidence ${(conf * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Radio<int>(
                    value: i,
                    groupValue: selectedIndex,
                    onChanged: (v) => onChanged(v!),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Is this the right item?',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Expanded(child: scrollable ? list : Flexible(child: list)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onConfirm,
                  child: const Text('Use this'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final double hPad;
  final double vPad;
  const _Tag(this.text, {required this.hPad, required this.vPad});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: cs.onSecondaryContainer),
      ),
    );
  }
}

class _ConfidenceRing extends StatelessWidget {
  final double value;
  final double size;
  final double inner;
  const _ConfidenceRing({
    required this.value,
    required this.size,
    required this.inner,
  });
  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,

      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 3,
              backgroundColor: cs.outlineVariant.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
          Container(
            width: inner,
            height: inner,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$pct%',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
