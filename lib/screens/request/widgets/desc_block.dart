import 'package:flutter/material.dart';

class DescBlock extends StatelessWidget {
  final String text;
  final int maxLines;
  const DescBlock({super.key, required this.text, this.maxLines = 5});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 13,
          height: 1.45,
          letterSpacing: 0.15,
          color: cs.onSurface.withOpacity(0.85),
        ),
      ),
    );
  }
}
