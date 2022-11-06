import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../utils/extensions.dart';

class CaughtStatusToggle extends HookWidget {
  final OobletVariant variant;
  final String ooblet;
  final bool fetchOoblets;

  final double? size;

  const CaughtStatusToggle({
    required this.variant,
    required this.ooblet,
    this.fetchOoblets = true,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    final caught = useSelector(
      (state) =>
          state.oobletsSlice.variantCaughtStatus[variant]?.get(ooblet) ?? false,
    );
    return IconButton(
      iconSize: size,
      icon: Icon(
        caught ? Icons.star : Icons.star_outline,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: () => dispatch(
        updateOobletCaughtStatus(variant, ooblet, !caught, fetchOoblets),
      ),
    );
  }
}
