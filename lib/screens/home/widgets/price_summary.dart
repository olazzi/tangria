import 'package:flutter/material.dart';
import '../../../models/price_quote.dart';

class PriceSummary extends StatelessWidget {
  final PriceQuote? quote;
  final int photos;
  final int activeIndex;
  const PriceSummary({super.key, required this.quote, required this.photos, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (quote != null && quote!.hasError) {
      return Card(
        color: cs.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error: ${quote!.error}', style: TextStyle(color: cs.onErrorContainer, fontWeight: FontWeight.w600)),
        ),
      );
    }
    if (quote != null) {
      final q = quote!;
      final title = [q.brand, q.model].where((e) => e.isNotEmpty).join(' ').trim();
      final tags = [
        if (q.category.isNotEmpty) q.category,
        if (q.condition.isNotEmpty) q.condition,
        'Photos: $photos',
        'Item ${activeIndex + 1}',
      ];
      return _PriceSummaryCard(price: q.priceRange.isEmpty ? 'No estimate' : q.priceRange, title: title.isEmpty ? 'Unnamed item' : title, tags: tags);
    }
    return _PriceSummaryPlaceholder(photos: photos, activeIndex: activeIndex);
  }
}

class _PriceSummaryCard extends StatelessWidget {
  final String price;
  final String title;
  final List<String> tags;
  const _PriceSummaryCard({required this.price, required this.title, required this.tags});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [cs.primaryContainer, cs.secondaryContainer]),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(price, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: cs.onPrimaryContainer)),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(fontSize: 16, color: cs.onPrimaryContainer.withOpacity(0.9))),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: -6, children: tags.map((t) => Chip(label: Text(t))).toList()),
        ]),
      ),
    );
  }
}

class _PriceSummaryPlaceholder extends StatelessWidget {
  final int photos;
  final int activeIndex;
  const _PriceSummaryPlaceholder({required this.photos, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Icon(Icons.local_offer_outlined, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(photos == 0 ? 'Add photos for Item ${activeIndex + 1} to get an estimated price.' : 'Ready to estimate price for Item ${activeIndex + 1} ($photos photos).')),
        ]),
      ),
    );
  }
}
