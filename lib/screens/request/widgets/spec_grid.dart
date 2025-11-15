import 'package:flutter/material.dart';

class SpecGrid extends StatelessWidget {
  final Map<String, dynamic> fields;
  const SpecGrid({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    final entries = fields.entries
        .where(
          (e) =>
              '${e.value}'.trim().isNotEmpty &&
              e.key != 'Reference' &&
              e.key != 'Year',
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      e.key,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${e.value}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
