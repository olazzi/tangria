import 'dart:io';
import 'package:flutter/material.dart';
import '../../../models/collection_item.dart';
import '../../../services/collection_service.dart';

class CollectionList extends StatelessWidget {
  final List<CollectionItem> items;
  const CollectionList({super.key, required this.items});

  String _priceText(CollectionItem it) {
    final hasRange = (it.minPrice > 0 || it.maxPrice > 0) && (it.minPrice != it.maxPrice);
    if (hasRange) {
      final lo = it.minPrice > 0 ? it.minPrice : it.price;
      final hi = it.maxPrice > 0 ? it.maxPrice : it.price;
      return '${CollectionService.formatCurrency(lo)} – ${CollectionService.formatCurrency(hi)}';
    }
    final v = it.price > 0 ? it.price : (it.minPrice > 0 ? it.minPrice : it.maxPrice);
    if (v <= 0) return '';
    return CollectionService.formatCurrency(v);
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('No items yet', style: Theme.of(context).textTheme.bodyMedium),
        ),
      );
    }
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (c, i) {
        final it = items[i];
        final price = _priceText(it);
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              it.imagePath.isEmpty
                  ? Container(color: Theme.of(context).colorScheme.surfaceVariant)
                  : Image.file(File(it.imagePath), fit: BoxFit.cover),
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        it.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      if (price.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
