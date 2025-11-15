import 'package:flutter/material.dart';

class FieldsWrap extends StatelessWidget {
  final Map<String, dynamic> fields;
  const FieldsWrap({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final entries = fields.entries.where(
      (e) =>
          '${e.value}'.trim().isNotEmpty &&
          e.key != 'Reference' &&
          e.key != 'Year',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: entries
            .map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.5,
                      height: 1.4,
                      letterSpacing: 0.15,
                    ),
                    children: [
                      TextSpan(
                        text: '${e.key}: ',
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '${e.value}',
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
