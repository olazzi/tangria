import 'dart:typed_data';
import 'package:flutter/material.dart';

class PhotosGrid extends StatelessWidget {
  final List<Uint8List> photos;
  final bool sending;
  final ValueChanged<int> onRemoveAt;
  const PhotosGrid({super.key, required this.photos, required this.sending, required this.onRemoveAt});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (photos.isEmpty) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: cs.outlineVariant)),
        child: const Text('No images for this item'),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
      itemBuilder: (_, i) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(photos[i], fit: BoxFit.cover, filterQuality: FilterQuality.low, cacheWidth: 400),
            ),
            Positioned(
              right: 4, top: 4,
              child: InkWell(
                onTap: sending ? null : () => onRemoveAt(i),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
