import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../utils/extensions.dart';

class VariantsFilterWidget extends StatelessWidget {
  const VariantsFilterWidget({super.key});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: const [
          _VariantChip(OobletVariant.common),
          _VariantChip(OobletVariant.unusual),
          _VariantChip(OobletVariant.gleamy),
        ],
      );
}

class _VariantChip extends HookWidget {
  final OobletVariant variant;

  const _VariantChip(this.variant);

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
