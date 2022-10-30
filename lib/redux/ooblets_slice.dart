part of 'redux.dart';

@sealed
@immutable
class OobletsSlice {
  final List<OobletWithVariant> ooblets;
  final bool loadingOoblets;
  final bool hasErrorLoadingOoblets;

  final Set<OobletVariant> variantsFilter;
  final Set<String> locationsFilter;
  final String nameFilter;

  const OobletsSlice._({
    this.ooblets = const [],
    this.loadingOoblets = true,
    this.hasErrorLoadingOoblets = false,
    this.variantsFilter = const {},
    this.locationsFilter = const {},
    this.nameFilter = '',
  });

  OobletsSlice _copyWith({
    List<OobletWithVariant>? ooblets,
    bool? loadingOoblets,
    bool? hasErrorLoadingOoblets,
    Set<OobletVariant>? variantsFilter,
    Set<String>? locationsFilter,
    String? nameFilter,
  }) =>
      OobletsSlice._(
        ooblets: ooblets ?? this.ooblets,
        loadingOoblets: loadingOoblets ?? this.loadingOoblets,
        hasErrorLoadingOoblets:
            hasErrorLoadingOoblets ?? this.hasErrorLoadingOoblets,
        variantsFilter: variantsFilter ?? this.variantsFilter,
        locationsFilter: locationsFilter ?? this.locationsFilter,
        nameFilter: nameFilter ?? this.nameFilter,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OobletsSlice &&
          listEquals(ooblets, other.ooblets) &&
          loadingOoblets == other.loadingOoblets &&
          hasErrorLoadingOoblets == other.hasErrorLoadingOoblets &&
          setEquals(variantsFilter, other.variantsFilter) &&
          setEquals(locationsFilter, other.locationsFilter) &&
          nameFilter == other.nameFilter);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(ooblets),
        loadingOoblets,
        hasErrorLoadingOoblets,
        Object.hashAll(variantsFilter),
        Object.hashAll(locationsFilter),
        nameFilter,
      );
}

// Actions - start

Future<void> fetchOobletsAction(Store<OobdexState> store) async {
  store.dispatch(const _UpdateOobletsSliceAction(
    ooblets: [],
    loadingOoblets: true,
    hasErrorLoadingOoblets: false,
  ));
  try {
    final variantsFilter = store.state.oobletsSlice.variantsFilter;
    final locationsFilter = store.state.oobletsSlice.locationsFilter;
    final nameFilter = store.state.oobletsSlice.nameFilter.trim().toUpperCase();

    final ooblets = <OobletWithVariant>[];
    final allOoblets = await ApiManager.instance.fetchAllOoblets();
    await for (final ooblet in allOoblets.fetchOoblets()) {
      if (locationsFilter.isNotEmpty &&
          !locationsFilter.contains(ooblet.locationID)) {
        continue; // invalid location
      }
      if (nameFilter.isNotEmpty &&
          !ooblet.name.toString().toUpperCase().contains(nameFilter)) {
        continue; // invalid name
      }
      for (final variant in OobletVariant.values) {
        if (variantsFilter.isNotEmpty && !variantsFilter.contains(variant)) {
          continue; // invalid variant
        }
        ooblets.add(OobletWithVariant(ooblet, variant));
      }
    }

    store.dispatch(_UpdateOobletsSliceAction(
      ooblets: List.unmodifiable(ooblets).cast(),
      loadingOoblets: false,
      hasErrorLoadingOoblets: false,
    ));
  } catch (_) {
    store.dispatch(const _UpdateOobletsSliceAction(
      loadingOoblets: false,
      hasErrorLoadingOoblets: true,
    ));
  }
}

ThunkAction<void> addVariantOobletsFilterAction(OobletVariant variant) =>
    (store) async {
      store.dispatch(_UpdateOobletsSliceAction(
        variantsFilter: Set.unmodifiable(
          {...store.state.oobletsSlice.variantsFilter, variant},
        ),
      ));
      await store.dispatch(fetchOobletsAction);
    };

ThunkAction<void> removeVariantOobletsFilterAction(OobletVariant variant) =>
    (store) async {
      store.dispatch(_UpdateOobletsSliceAction(
        variantsFilter: Set.unmodifiable(
          {...store.state.oobletsSlice.variantsFilter}..remove(variant),
        ),
      ));
      await store.dispatch(fetchOobletsAction);
    };

ThunkAction<void> addLocationOobletsFilterAction(String locationID) =>
    (store) async {
      store.dispatch(_UpdateOobletsSliceAction(
        locationsFilter: Set.unmodifiable(
          {...store.state.oobletsSlice.locationsFilter, locationID},
        ),
      ));
      await store.dispatch(fetchOobletsAction);
    };

ThunkAction<void> removeLocationOobletsFilterAction(String locationID) =>
    (store) async {
      store.dispatch(_UpdateOobletsSliceAction(
        locationsFilter: Set.unmodifiable(
          {...store.state.oobletsSlice.locationsFilter}..remove(locationID),
        ),
      ));
      await store.dispatch(fetchOobletsAction);
    };

ThunkAction<void> updateNameOobletsFilterAction(String nameFilter) =>
    (store) async {
      store.dispatch(_UpdateOobletsSliceAction(nameFilter: nameFilter));
      await store.dispatch(fetchOobletsAction);
    };

Future<void> clearVariantsLocationsOobletsFilterAction(
  Store<OobdexState> store,
) async {
  store.dispatch(const _UpdateOobletsSliceAction(
    variantsFilter: {},
    locationsFilter: {},
  ));
  await store.dispatch(fetchOobletsAction);
}

class _UpdateOobletsSliceAction {
  final List<OobletWithVariant>? ooblets;
  final bool? loadingOoblets;
  final bool? hasErrorLoadingOoblets;

  final Set<OobletVariant>? variantsFilter;
  final Set<String>? locationsFilter;
  final String? nameFilter;

  const _UpdateOobletsSliceAction({
    this.ooblets,
    this.loadingOoblets,
    this.hasErrorLoadingOoblets,
    this.variantsFilter,
    this.locationsFilter,
    this.nameFilter,
  });
}

// Actions - end

// Reducers - start

OobletsSlice _oobletsReducer(OobletsSlice state, dynamic action) {
  if (action is _UpdateOobletsSliceAction) {
    return state._copyWith(
      ooblets: action.ooblets,
      loadingOoblets: action.loadingOoblets,
      hasErrorLoadingOoblets: action.hasErrorLoadingOoblets,
      variantsFilter: action.variantsFilter,
      locationsFilter: action.locationsFilter,
      nameFilter: action.nameFilter,
    );
  }
  return state;
}

// Reducers - end
