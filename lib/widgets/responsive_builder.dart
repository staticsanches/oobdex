import 'package:flutter/widgets.dart';

import '../hooks/hooks.dart';

class ResponsiveBuilder extends HookWidget {
  final Breakpoints<WidgetBuilder> builders;

  const ResponsiveBuilder(this.builders, {super.key});

  @override
  Widget build(BuildContext context) {
    final builder = useResponsiveValue(builders);
    return builder(context);
  }
}
