import 'package:flutter/material.dart';
import '../../../services/history_service.dart';
import 'history_tile.dart';

class HistoryList extends StatelessWidget {
  final List<HistoryCardData> items;
  final void Function(HistoryCardData h) onTap;
  final void Function(HistoryCardData h) onDelete;

  const HistoryList({
    super.key,
    required this.items,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) {
        final it = items[i];
        return HistoryTile(
          item: it,
          onTap: () => onTap(it),
          onDelete: () => onDelete(it),
        );
      },
    );
  }
}
