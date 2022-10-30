import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../redux/redux.dart';
import 'locations_filter_widget.dart';
import 'variants_filter_widget.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              child: Text(appLocalizations.clearAll),
              onPressed: () async {
                nameFilterController.clear();
                await dispatch(clearVariantsLocationsOobletsFilterAction);
              },
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                const Expanded(child: Divider(endIndent: 20)),
                Text(appLocalizations.oobletVariants),
                const Expanded(child: Divider(indent: 20)),
              ],
            ),
          ),
          const VariantsFilterWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                const Expanded(child: Divider(endIndent: 20)),
                Text(appLocalizations.locations),
                const Expanded(child: Divider(indent: 20)),
              ],
            ),
          ),
          const LocationsFilterWidget(
            selectedSelectorProvider: _locationsSelectedSelector,
            addFilterActionProvider: addLocationOobletsFilterAction,
            removeFilterActionProvider: removeLocationOobletsFilterAction,
          )
        ],
      ),
    );
  }

  static Selector<bool> _locationsSelectedSelector(String locationID) =>
      (state) => state.oobletsSlice.locationsFilter.contains(locationID);
}
