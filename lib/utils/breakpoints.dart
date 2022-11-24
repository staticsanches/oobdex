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

  T choose(
    Size size, {
    double smSize = 576,
    double mdSize = 768,
    double lgSize = 992,
    double xlSize = 1200,
    double xxlSize = 1400,
  }) {
    final sizeComponent = axis == Axis.horizontal ? size.width : size.height;
    if (sizeComponent >= xxlSize && xxl != null) {
      return xxl!;
    }
    if (sizeComponent >= xlSize && xl != null) {
      return xl!;
    }
    if (sizeComponent >= lgSize && lg != null) {
      return lg!;
    }
    if (sizeComponent >= mdSize && md != null) {
      return md!;
    }
    if (sizeComponent >= smSize && sm != null) {
      return sm!;
    }
    return xs;
  }
}
