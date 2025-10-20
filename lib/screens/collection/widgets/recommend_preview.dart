// lib/screens/collection/widgets/recommend_preview.dart
import 'package:flutter/material.dart';
import '../../../services/recommendation_service.dart';
import '../../../local/db.dart';

class RecommendPreview extends StatelessWidget {
  final VoidCallback onOpen;
  const RecommendPreview({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FutureBuilder<List<RecommendationData>>(
      future: RecommendationService.loadPreview(limit: 2),
      builder: (c, s) {
        if (s.connectionState == ConnectionState.waiting) return const SizedBox.shrink();
        final items = s.data ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: cs.surface, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Text('Saved recommendations', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: items.map((e) {
                      return Container(
                        width: 180,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cs.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          e.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(onPressed: onOpen, child: const Text('Open')),
            ],
          ),
        );
      },
    );
  }
}
