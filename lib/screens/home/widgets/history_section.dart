import 'package:flutter/material.dart';
import '../../../services/history_service.dart';
import 'history_list.dart';
import '../widgets/watch_search_bar.dart';

class HistorySection extends StatelessWidget {
  final Future<List<HistoryCardData>> futureHistory;
  final Future<void> Function(HistoryCardData h) onTapItem;
  final Future<void> Function(HistoryCardData h) onDeleteItem;

  const HistorySection({
    super.key,
    required this.futureHistory,
    required this.onTapItem,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      children: [
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: WatchSearchBar(),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<HistoryCardData>>(
          future: futureHistory,
          builder: (c, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (s.hasError) return const SizedBox();
            final items = s.data ?? [];
            if (items.isEmpty) return const SizedBox();
            return HistoryList(
              items: items,
              onTap: (h) => onTapItem(h),
              onDelete: (h) => onDeleteItem(h),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
