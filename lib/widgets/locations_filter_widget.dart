import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';

class LocationsFilterWidget extends HookWidget {
  final Selector<bool> Function(String) selectedSelectorProvider;
  final ThunkAction<void> Function(String) addFilterActionProvider;
  final ThunkAction<void> Function(String) removeFilterActionProvider;

  const LocationsFilterWidget({
    super.key,
    required this.selectedSelectorProvider,
    required this.addFilterActionProvider,
    required this.removeFilterActionProvider,
  });

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    final appLocalizations = useAppLocalizations();
    final locationsSlice = useSelector((state) => state.locationsSlice);

    final Widget body;
    if (locationsSlice.hasErrorLoadingLocations) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            const SizedBox(height: 10),
            SelectableText(appLocalizations.anErrorOccurred),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => dispatch(fetchLocationsAction),
              child: Text(appLocalizations.retry),
            ),
          ],
        ),
      );
    } else if (locationsSlice.loadingLocations) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      body = Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          for (final location in locationsSlice.locations)
            _LocationChip(
              location: location,
              selectedSelector: selectedSelectorProvider(location.id),
              addFilterAction: addFilterActionProvider(location.id),
              removeFilterAction: removeFilterActionProvider(location.id),
            )
        ],
      );
    }

    return body;
  }
}

class _LocationChip extends HookWidget {
  final Location location;
  final Selector<bool> selectedSelector;
  final ThunkAction<void> addFilterAction;
  final ThunkAction<void> removeFilterAction;

  const _LocationChip({
    required this.location,
    required this.selectedSelector,
    required this.addFilterAction,
    required this.removeFilterAction,
  });

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    final selected = useSelector(selectedSelector);
    return FilterChip(
      label: Text(location.name.toString()),
      selected: selected,
      onSelected: (value) {
        if (value) {
          dispatch(addFilterAction);
        } else {
          dispatch(removeFilterAction);
        }
      },
    );
  }
}
