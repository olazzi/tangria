import 'dart:io';
import 'package:flutter/material.dart';
import '../../../services/history_service.dart';

class HistoryTile extends StatelessWidget {
  final HistoryCardData item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HistoryTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  String _brandFrom(String t) {
    final s = t.trim();
    if (s.isEmpty) return 'Item';
    final parts = s.split(RegExp(r'\s+'));
    return parts.first;
  }

  String _modelFrom(String title, String brand, String desc) {
    String base = title.trim();
    if (base.toLowerCase().startsWith(brand.toLowerCase())) {
      base = base.substring(brand.length).trim();
    }
    if (base.isEmpty) base = desc.trim();
    final rxType = RegExp(
      r"\b(watch|wristwatch|men'?s|women'?s|ladies|gents|gent'?s|unisex)\b",
      caseSensitive: false,
    );
    base = base.replaceAll(rxType, '');
    base = base.replaceAll(RegExp(r'\s+'), ' ').trim();
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = w * 1.10;
    final title = item.title.trim().isEmpty ? 'Item' : item.title.trim();
    final brand = _brandFrom(title);
    final model = _modelFrom(title, brand, item.desc);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: w,
        height: h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.imagePath.isEmpty)
              Container(color: Theme.of(context).colorScheme.surfaceVariant)
            else
              Image.file(
                File(item.imagePath),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                errorBuilder: (_, __, ___) => Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.00),
                      Colors.black.withOpacity(0.28),
                      Colors.black.withOpacity(0.62),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Tektur',
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            height: 1.05,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (model.isNotEmpty)
                          Text(
                            model,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                              height: 1.15,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (item.price.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
