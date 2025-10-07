import 'package:flutter/material.dart';

class ItemChips extends StatelessWidget {
  final int count;
  final int active;
  final ValueChanged<int> onSelect;
  final ValueChanged<int> onRemove;
  const ItemChips({super.key, required this.count, required this.active, required this.onSelect, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(count, (i) {
          final selected = i == active;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InputChip(
              label: Text('Item ${i + 1}'),
              selected: selected,
              onSelected: (_) => onSelect(i),
              onDeleted: count > 1 ? () => onRemove(i) : null,
            ),
          );
        }),
      ),
    );
  }
}
