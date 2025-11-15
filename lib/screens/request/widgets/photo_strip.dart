import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'segmented_fancy_indicator.dart';

class PhotoStrip extends StatefulWidget {
  final List<Uint8List> bytes;
  const PhotoStrip({super.key, required this.bytes});

  @override
  State<PhotoStrip> createState() => _PhotoStripState();
}

class _PhotoStripState extends State<PhotoStrip> {
  late final PageController _ctrl = PageController(viewportFraction: 0.92);
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _page = _ctrl.initialPage.toDouble();
    _ctrl.addListener(_onScroll);
  }

  void _onScroll() {
    final p = _ctrl.page ?? _page;
    if (p != _page) setState(() => _page = p);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onScroll);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bytes.isEmpty) {
      return SizedBox(
        height: 260,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(color: Colors.black12),
          ),
        ),
      );
    }
    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            itemCount: widget.bytes.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  color: Colors.white,
                ),
                child: Image.memory(widget.bytes[i], fit: BoxFit.cover),
              ),
            ),
          ),
          if (widget.bytes.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: IgnorePointer(
                ignoring: true,
                child: Center(
                  child: SegmentedFancyIndicator(
                    count: widget.bytes.length,
                    page: _page,
                    activeWidth: 40,
                    inactiveWidth: 18,
                    thickness: 3,
                    gap: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
