import 'dart:typed_data';
import 'package:flutter/material.dart';

class PhotosGrid extends StatefulWidget {
  final List<Uint8List> photos;
  final bool sending;
  final void Function(int index) onRemoveAt;
  final void Function(int index) onMakeMainAt;
  final int initialIndex;

  const PhotosGrid({
    super.key,
    required this.photos,
    required this.sending,
    required this.onRemoveAt,
    required this.onMakeMainAt,
    this.initialIndex = 0,
  });

  @override
  State<PhotosGrid> createState() => _PhotosGridState();
}

class _PhotosGridState extends State<PhotosGrid> {
  late final PageController _pc;
  int _ix = 0;

  @override
  void initState() {
    super.initState();
    _ix = widget.initialIndex.clamp(0, (widget.photos.length - 1).clamp(0, 999));
    _pc = PageController(initialPage: _ix);
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final canDelete = widget.photos.length > 1 && !widget.sending;

    return LayoutBuilder(
      builder: (c, cons) {
        final side = cons.maxWidth;
        return SizedBox(
          width: side,
          height: side,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.photos.isEmpty)
                Container(color: cs.surfaceContainerHighest)
              else
                PageView.builder(
                  controller: _pc,
                  onPageChanged: (i) => setState(() => _ix = i),
                  itemCount: widget.photos.length,
                  itemBuilder: (_, i) => Image.memory(widget.photos[i], fit: BoxFit.cover),
                ),
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    if (_ix != 0)
                      InkWell(
                        onTap: widget.sending ? null : () => widget.onMakeMainAt(_ix),
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.star, size: 18, color: Colors.white),
                              SizedBox(width: 6),
                              Text('Set main', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: canDelete ? () => widget.onRemoveAt(_ix) : null,
                      borderRadius: BorderRadius.circular(22),
                      child: Opacity(
                        opacity: canDelete ? 1.0 : 0.45,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(Icons.delete_outline, size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.photos.length > 1)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.photos.length,
                      (i) => Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _ix ? cs.onSurface : cs.onSurface.withOpacity(0.35),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
