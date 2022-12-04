import 'dart:math';

import 'package:flutter/widgets.dart';

class SquareBox extends StatelessWidget {
  final Widget child;

  const SquareBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final dimension = min(constraints.maxWidth, constraints.maxHeight);
        return SizedBox.square(
          dimension: dimension,
          child: child,
        );
      },
    );
  }
}
