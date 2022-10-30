part of 'redux.dart';

@sealed
@immutable
class LocationsSlice {
  final List<Location> locations;
  final bool loadingLocations;
  final bool hasErrorLoadingLocations;

  const LocationsSlice._({
    this.locations = const [],
    this.loadingLocations = true,
    this.hasErrorLoadingLocations = false,
  });

  LocationsSlice _copyWith({
    List<Location>? locations,
    bool? loadingLocations,
    bool? hasErrorLoadingLocations,
  }) =>
      LocationsSlice._(
        locations: locations ?? this.locations,
        loadingLocations: loadingLocations ?? this.loadingLocations,
        hasErrorLoadingLocations:
            hasErrorLoadingLocations ?? this.hasErrorLoadingLocations,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationsSlice &&
          listEquals(locations, other.locations) &&
          loadingLocations == other.loadingLocations &&
          hasErrorLoadingLocations == other.hasErrorLoadingLocations);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(locations),
        loadingLocations,
        hasErrorLoadingLocations,
      );
}

// Actions - start

Future<void> fetchLocationsAction(Store<OobdexState> store) async {
  store.dispatch(const _UpdateLocationsSliceAction(
    locations: [],
    loadingLocations: true,
    hasErrorLoadingLocations: false,
  ));
  try {
    final allLocations = await ApiManager.instance.fetchAllLocations();
    final locations = <Location>[];
    await for (final location in allLocations.fetchLocations()) {
      locations.add(location);
    }
    store.dispatch(_UpdateLocationsSliceAction(
      locations: List.unmodifiable(locations),
      loadingLocations: false,
      hasErrorLoadingLocations: false,
    ));
  } catch (_) {
    store.dispatch(const _UpdateLocationsSliceAction(
      loadingLocations: false,
      hasErrorLoadingLocations: true,
    ));
  }
}

class _UpdateLocationsSliceAction {
  final List<Location>? locations;
  final bool? loadingLocations;
  final bool? hasErrorLoadingLocations;

  const _UpdateLocationsSliceAction({
    this.locations,
    this.loadingLocations,
    this.hasErrorLoadingLocations,
  });
}

// Actions - end

// Reducers - start

LocationsSlice _updateLocationsReducer(
  LocationsSlice state,
  _UpdateLocationsSliceAction action,
) =>
    state._copyWith(
      locations: action.locations,
      loadingLocations: action.loadingLocations,
      hasErrorLoadingLocations: action.hasErrorLoadingLocations,
    );

final _locationsReducer = combineReducers<LocationsSlice>([
  TypedReducer<LocationsSlice, _UpdateLocationsSliceAction>(
    _updateLocationsReducer,
  ),
]);

// Reducers - end
