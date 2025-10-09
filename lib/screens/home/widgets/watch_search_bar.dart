import 'package:flutter/material.dart';

class WatchSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmit;
  const WatchSearchBar({super.key, this.controller, this.onChanged, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: (_) => onSubmit?.call(),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Brand, model, complication, keywords',
                isCollapsed: true,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(onPressed: onSubmit, icon: const Icon(Icons.tune)),
        ],
      ),
    );
  }
}