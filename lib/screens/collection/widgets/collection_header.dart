import 'package:flutter/material.dart';

class CollectionHeader extends StatelessWidget {
  final String totalValueText;
  final String countText;
  const CollectionHeader({super.key, required this.totalValueText, required this.countText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(0),
        border: const Border(
          bottom: BorderSide(color: Colors.black, width: 1.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Estimated Value',
            style: TextStyle(
              color: Color.fromARGB(179, 0, 0, 0),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                totalValueText,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Tektur',
                ),
              ),
              Text(
                countText,
                style: const TextStyle(
                  color: Color.fromARGB(179, 0, 0, 0),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
