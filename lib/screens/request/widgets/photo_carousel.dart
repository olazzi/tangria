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
  late final PageController ctrl = PageController(viewportFraction: 0.92);
  double page = 0;

  @override
  void initState() {
    super.initState();
    page = ctrl.initialPage.toDouble();
    ctrl.addListener(_onScroll);
  }

  void _onScroll() {
    final p = ctrl.page ?? page;
    if (p != page) setState(() => page = p);
  }

  @override
  void dispose() {
    ctrl.removeListener(_onScroll);
    ctrl.dispose();
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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: ctrl,
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
        ),
        if (widget.bytes.length > 1)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: SegmentedFancyIndicator(
              count: widget.bytes.length,
              page: page,
              activeWidth: 40,
              inactiveWidth: 18,
              thickness: 3,
              gap: 10,
            ),
          ),
      ],
    );
  }
}
