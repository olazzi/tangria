import 'package:flutter/material.dart';

class BreatheArrowDown extends StatefulWidget {
  final Color color;
  final double size;
  final Duration period;
  const BreatheArrowDown({
    super.key,
    this.color = Colors.black,
    this.size = 26,
    this.period = const Duration(milliseconds: 900),
  });
  @override
  State<BreatheArrowDown> createState() => _BreatheArrowDownState();
}

class _BreatheArrowDownState extends State<BreatheArrowDown>
    with SingleTickerProviderStateMixin {
  late final AnimationController c;
  late final Animation<double> dy;
  late final Animation<double> op;

  @override
  void initState() {
    super.initState();
    c = AnimationController(vsync: this, duration: widget.period)
      ..repeat(reverse: true);
    dy = Tween(
      begin: 0.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    op = Tween(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: c,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, dy.value),
        child: Opacity(
          opacity: op.value,
          child: Icon(
            Icons.keyboard_arrow_down,
            size: widget.size,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
