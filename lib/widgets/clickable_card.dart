import 'package:flutter/material.dart';

class ClickableCard extends StatelessWidget {
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final bool borderOnForeground;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;

  final void Function()? onTap;

  final Widget? child;

  const ClickableCard({
    super.key,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.onTap,
    this.child,
  }) : assert(elevation == null || elevation >= 0.0);

  @override
  Widget build(BuildContext context) {
    final CardTheme cardTheme = CardTheme.of(context);
    final CardTheme defaults = Theme.of(context).useMaterial3
        ? _CardDefaultsM3(context)
        : _CardDefaultsM2(context);

    return Container(
      margin: margin ?? cardTheme.margin ?? defaults.margin!,
      child: Material(
        type: MaterialType.card,
        color: color ?? cardTheme.color ?? defaults.color,
        shadowColor:
            shadowColor ?? cardTheme.shadowColor ?? defaults.shadowColor,
        surfaceTintColor: surfaceTintColor ??
            cardTheme.surfaceTintColor ??
            defaults.surfaceTintColor,
        elevation: elevation ?? cardTheme.elevation ?? defaults.elevation!,
        borderRadius: borderRadius,
        borderOnForeground: borderOnForeground,
        clipBehavior:
            clipBehavior ?? cardTheme.clipBehavior ?? defaults.clipBehavior!,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}

class _CardDefaultsM2 extends CardTheme {
  const _CardDefaultsM2(this.context)
      : super(
          clipBehavior: Clip.none,
          elevation: 1.0,
          margin: const EdgeInsets.all(4),
        );

  final BuildContext context;

  @override
  Color? get color => Theme.of(context).cardColor;

  @override
  Color? get shadowColor => Theme.of(context).shadowColor;
}

class _CardDefaultsM3 extends CardTheme {
  const _CardDefaultsM3(this.context)
      : super(
          clipBehavior: Clip.none,
          elevation: 1.0,
          margin: const EdgeInsets.all(4),
        );

  final BuildContext context;

  @override
  Color? get color => Theme.of(context).colorScheme.surface;

  @override
  Color? get shadowColor => Theme.of(context).colorScheme.shadow;

  @override
  Color? get surfaceTintColor => Theme.of(context).colorScheme.surfaceTint;
}
