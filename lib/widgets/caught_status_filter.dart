import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../utils/extensions.dart';

class CaughtStatusFilter extends StatelessWidget {
  const CaughtStatusFilter({super.key});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 10,
        alignment: WrapAlignment.center,
        children: const [
          _Chip(OobletCaughtStatus.any),
          _Chip(OobletCaughtStatus.caught),
          _Chip(OobletCaughtStatus.missing),
        ],
      );
}

class _Chip extends HookWidget {
  final OobletCaughtStatus status;

  const _Chip(this.status);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();
    final dispatch = useDispatch();
    final selected = useSelector(
      (state) => state.oobletsSlice.caughtStatusFilter == status,
    );
    return FilterChip(
      label: Text(status.getName(appLocalizations)),
      selected: selected,
      onSelected: (value) {
        if (value) {
          dispatch(updateCaughtStatusOobletsFilterAction(status));
        }
      },
    );
  }
}
