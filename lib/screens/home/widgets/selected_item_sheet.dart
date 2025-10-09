// lib/screens/home/widgets/selected_item_sheet.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';

class SelectedItemSheet extends StatelessWidget {
  final List<Uint8List> photos;
  final bool sending;
  final bool collapsed;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onEstimate;
  final VoidCallback onClear;
  final VoidCallback onNewItem;
  final VoidCallback onClose;
  final VoidCallback onToggleCollapse;
  final ScrollController? scrollController;

  const SelectedItemSheet({
    super.key,
    required this.photos,
    required this.sending,
    required this.collapsed,
    required this.onCamera,
    required this.onGallery,
    required this.onEstimate,
    required this.onClear,
    required this.onNewItem,
    required this.onClose,
    required this.onToggleCollapse,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      bottom: true,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Selected photos',
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(onPressed: onToggleCollapse, icon: Icon(collapsed ? Icons.expand_less : Icons.expand_more)),
                        IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!collapsed)
              Expanded(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (c, i) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(photos[i], fit: BoxFit.cover),
                          ),
                          childCount: photos.length,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Row(
                          children: [
                            Expanded(child: FilledButton.icon(onPressed: sending ? null : onCamera, icon: const Icon(Icons.photo_camera), label: const Text('Camera'))),
                            const SizedBox(width: 8),
                            Expanded(child: OutlinedButton.icon(onPressed: sending ? null : onGallery, icon: const Icon(Icons.photo_library), label: const Text('Gallery'))),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Row(
                          children: [
                            Expanded(child: FilledButton.icon(onPressed: sending ? null : onEstimate, icon: const Icon(Icons.price_change), label: const Text('Estimate'))),
                            const SizedBox(width: 8),
                            Expanded(child: OutlinedButton.icon(onPressed: sending ? null : onClear, icon: const Icon(Icons.delete_sweep), label: const Text('Clear'))),
                            const SizedBox(width: 8),
                            IconButton(onPressed: sending ? null : onNewItem, icon: const Icon(Icons.add_box_outlined)),
                          ],
                        ),
                      ),
                    ),
                    if (sending)
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainer,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Estimating…'),
                              SizedBox(height: 8),
                              LinearProgressIndicator(),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            if (collapsed)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Estimating price…',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
