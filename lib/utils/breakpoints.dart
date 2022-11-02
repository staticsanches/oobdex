import 'package:flutter/rendering.dart';

export 'package:flutter/rendering.dart' show Axis;

class Breakpoints<T> {
  final Axis axis;

  final T xs;
  final T? sm, md, lg, xl, xxl;

  const Breakpoints({
    this.axis = Axis.horizontal,
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
  });

  T choose(Size size) {
    final sizeComponent = axis == Axis.horizontal ? size.width : size.height;
    if (sizeComponent >= 1400 && xxl != null) {
      return xxl!;
    }
    if (sizeComponent >= 1200 && xl != null) {
      return xl!;
    }
    if (sizeComponent >= 992 && lg != null) {
      return lg!;
    }
    if (sizeComponent >= 768 && md != null) {
      return md!;
    }
    if (sizeComponent >= 576 && sm != null) {
      return sm!;
    }
    return xs;
  }
}
