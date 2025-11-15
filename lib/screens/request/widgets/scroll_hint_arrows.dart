import 'package:flutter/material.dart';

class ScrollHintArrows extends StatefulWidget {
  final Color color;
  final double size;
  final Duration period;
  const ScrollHintArrows({
    super.key,
    this.color = Colors.black,
    this.size = 26,
    this.period = const Duration(milliseconds: 1800),
  });
  @override
  State<ScrollHintArrows> createState() => _ScrollHintArrowsState();
}

class _ScrollHintArrowsState extends State<ScrollHintArrows>
    with SingleTickerProviderStateMixin {
  late final AnimationController c;
  late final List<Animation<double>> dy;
  late final List<Animation<double>> op;

  @override
  void initState() {
    super.initState();
    c = AnimationController(vsync: this, duration: widget.period)
      ..repeat(reverse: true);
    const starts = [0.00, 0.16, 0.32];
    dy = List.generate(3, (i) {
      final start = starts[i];
      final end = start + 0.60;
      return Tween(begin: 0.0, end: 6.0).animate(
        CurvedAnimation(
          parent: c,
          curve: Interval(start, end, curve: Curves.easeInOutCubic),
        ),
      );
    });
    op = List.generate(3, (i) {
      final start = starts[i];
      final end = start + 0.60;
      return Tween(begin: 0.25, end: 0.95).animate(
        CurvedAnimation(
          parent: c,
          curve: Interval(start, end, curve: Curves.easeInOutCubic),
        ),
      );
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: widget.size + 16,
        width: widget.size,
        child: AnimatedBuilder(
          animation: c,
          builder: (_, __) {
            final bases = [0.0, 10.0, 20.0];
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: List.generate(3, (i) {
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: bases[i] + dy[i].value,
                  child: Opacity(
                    opacity: op[i].value,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: widget.size,
                      color: widget.color,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
