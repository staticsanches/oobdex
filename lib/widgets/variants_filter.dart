import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../utils/extensions.dart';

class VariantsFilter extends StatelessWidget {
  const VariantsFilter({super.key});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: const [
          _Chip(OobletVariant.common),
          _Chip(OobletVariant.unusual),
          _Chip(OobletVariant.gleamy),
        ],
      );
}

class _Chip extends HookWidget {
  final OobletVariant variant;

  const _Chip(this.variant);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();
    final dispatch = useDispatch();
    final selected = useSelector(
      (state) => state.oobletsSlice.variantsFilter.contains(variant),
    );
    return FilterChip(
      label: Text(variant.getName(appLocalizations)),
      selected: selected,
      onSelected: (value) {
        if (value) {
          dispatch(addVariantOobletsFilterAction(variant));
        } else {
          dispatch(removeVariantOobletsFilterAction(variant));
        }
      },
    );
  }
}
