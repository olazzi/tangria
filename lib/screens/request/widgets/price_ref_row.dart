// lib/screens/request/widgets/price_ref_row.dart
import 'package:flutter/material.dart';

class PriceRefRow extends StatelessWidget {
  final String priceText;
  final String referenceText;
  const PriceRefRow({
    super.key,
    required this.priceText,
    required this.referenceText,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            priceText,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
        if (referenceText.trim().isNotEmpty)
          Text(
            'Ref. $referenceText',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
      ],
    );
  }
}
