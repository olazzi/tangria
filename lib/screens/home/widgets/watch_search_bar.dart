import 'package:flutter/material.dart';

class WatchSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmit;
  const WatchSearchBar({super.key, this.controller, this.onChanged, this.onSubmit});

  @override
  State<WatchSearchBar> createState() => _WatchSearchBarState();
}

class _WatchSearchBarState extends State<WatchSearchBar> {
  late final TextEditingController _c;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _c = TextEditingController();
      _ownsController = true;
    } else {
      _c = widget.controller!;
    }
    _c.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (_ownsController) _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasText = _c.text.isNotEmpty;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.search, color: cs.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _c,
              onChanged: widget.onChanged,
              onSubmitted: (_) => widget.onSubmit?.call(),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Brand, model, complication, keywords',
                isCollapsed: true,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 6),
          if (hasText)
            IconButton(
              onPressed: () {
                _c.clear();
                widget.onChanged?.call('');
              },
              icon: const Icon(Icons.close),
              tooltip: 'Clear',
            ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
