// lib/screens/collection/widgets/recommendation_sheet.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class RecommendSheet extends StatelessWidget {
  final Map<String, dynamic> data;
  const RecommendSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final List recs = (data['recommendations'] ?? []) as List;

    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.9,
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        cs.surface,
                        Color.alphaBlend(cs.primary.withOpacity(0.02), cs.surface),
                        cs.surface,
                      ],
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: cs.surface.withOpacity(0.92)),
                ),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: cs.outlineVariant,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Recommendations for your collection',
                              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.close_rounded),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: cs.outlineVariant),
                    Expanded(
                      child: recs.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome, size: 40, color: cs.onSurfaceVariant),
                                    const SizedBox(height: 10),
                                    Text('No recommendations yet', style: textTheme.titleMedium?.copyWith(color: cs.onSurfaceVariant)),
                                    const SizedBox(height: 6),
                                    Text('Generate ideas to see tailored picks here.', style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                                  ],
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                              itemCount: recs.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (c, i) {
                                final r = recs[i] as Map<String, dynamic>;
                                final title = (r['title'] ?? '').toString();
                                final reason = (r['reason'] ?? '').toString();
                                return _RecommendationCard(index: i + 1, title: title, reason: reason);
                              },
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final int index;
  final String title;
  final String reason;
  const _RecommendationCard({required this.index, required this.title, required this.reason});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cs.primary.withOpacity(0.25)),
            ),
            child: Center(child: Text(index.toString(), style: tt.titleSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w800))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.auto_awesome, size: 18, color: cs.onSurfaceVariant),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  reason,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.25),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Chip(label: 'Suggested', icon: Icons.lightbulb_outline),
                    const SizedBox(width: 8),
                    _Chip(label: 'From your set', icon: Icons.collections_bookmark_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _Chip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cs.onSurface)),
        ],
      ),
    );
  }
}
