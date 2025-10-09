// lib/screens/home/widgets/history_list.dart
import 'package:flutter/material.dart';
import '../../../services/history_service.dart';
import 'history_tile.dart';

class HistoryList extends StatelessWidget {
  final List<HistoryCardData> items;
  final void Function(HistoryCardData) onTap;
  const HistoryList({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (c, i) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: HistoryTile(item: items[i], onTap: () => onTap(items[i])),
      ),
    );
  }
}
