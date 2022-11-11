import 'dart:math';

import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../redux/redux.dart';
import 'caught_status_filter.dart';
import 'locations_filter.dart';
import 'variants_filter.dart';

class OobletsFilter extends HookWidget {
  const OobletsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();
    final dispatch = useDispatch();

    final nameFilterController = useTextEditingControllerWithStore(
      initialValueSelector: (state) => state.oobletsSlice.nameFilter,
      updateAction: updateNameOobletsFilterAction,
    );

    const startDivider = Expanded(child: Divider(endIndent: 20));
    const endDivider = Expanded(child: Divider(indent: 20));

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: max(10, MediaQuery.of(context).viewInsets.bottom),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(appLocalizations.clearAll),
                  onPressed: () async {
                    nameFilterController.clear();
                    await dispatch(
                        clearVariantsLocationsCaughtStatusOobletsFilterAction);
                  },
                ),
              ),
              TextField(
                controller: nameFilterController,
                decoration: InputDecoration(
                  hintText: appLocalizations.searchByName,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: nameFilterController.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  children: [
                    startDivider,
                    Text(appLocalizations.oobletCaughtStatus),
                    endDivider,
                  ],
                ),
              ),
              const CaughtStatusFilter(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    startDivider,
                    Text(appLocalizations.oobletVariants),
                    endDivider,
                  ],
                ),
              ),
              const VariantsFilter(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    startDivider,
                    Text(appLocalizations.locations),
                    endDivider,
                  ],
                ),
              ),
              const LocationsFilter(
                selectedSelectorProvider: _locationsSelectedSelector,
                addFilterActionProvider: addLocationOobletsFilterAction,
                removeFilterActionProvider: removeLocationOobletsFilterAction,
              )
            ],
          ),
        ),
      ),
    );
  }

  static Selector<bool> _locationsSelectedSelector(String locationID) =>
      (state) => state.oobletsSlice.locationsFilter.contains(locationID);
}
