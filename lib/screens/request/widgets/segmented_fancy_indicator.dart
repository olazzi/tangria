import 'package:flutter/material.dart';

class SegmentedFancyIndicator extends StatelessWidget {
  final int count;
  final double page;
  final double activeWidth;
  final double inactiveWidth;
  final double thickness;
  final double gap;
  final double activeOpacity;
  final double inactiveOpacity;
  final double activeScale;

  const SegmentedFancyIndicator({
    super.key,
    required this.count,
    required this.page,
    this.activeWidth = 36,
    this.inactiveWidth = 14,
    this.thickness = 3,
    this.gap = 8,
    this.activeOpacity = 1,
    this.inactiveOpacity = 0.35,
    this.activeScale = 1.25,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final d = (page - i).abs().clamp(0.0, 1.0);
        final t = 1 - Curves.easeOut.transform(d);
        final w = _lerp(inactiveWidth, activeWidth, t);
        final o = _lerp(inactiveOpacity, activeOpacity, t);
        final s = _lerp(1.0, activeScale, t);
        final c = Color.lerp(
          cs.onSurfaceVariant,
          cs.onSurface,
          t,
        )!.withOpacity(o);
        return Padding(
          padding: EdgeInsets.only(right: i == count - 1 ? 0 : gap),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            child: Transform.scale(
              scale: s,
              alignment: Alignment.center,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: t > 0.6
                      ? [
                          BoxShadow(
                            color: c.withOpacity(0.45),
                            blurRadius: 8,
                            spreadRadius: 0.5,
                          ),
                        ]
                      : const [],
                ),
                child: SizedBox(width: w, height: thickness),
              ),
            ),
          ),
        );
      }),
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}
