part of 'redux.dart';

@sealed
@immutable
class OobletsSlice {
  final List<Ooblet> allOoblets;
  final List<Ooblet> ooblets;
  final List<OobletWithVariant> oobletsWithVariants;

  final bool loadingOoblets;
  final bool hasErrorLoadingOoblets;

  final Set<OobletVariant> variantsFilter;
  final Set<String> locationsFilter;
  final String nameFilter;
  final OobletCaughtStatus caughtStatusFilter;

  final Map<OobletVariant, Map<String, bool>> variantCaughtStatus;

  const OobletsSlice._({
    this.allOoblets = const [],
    this.ooblets = const [],
    this.oobletsWithVariants = const [],
    this.loadingOoblets = true,
    this.hasErrorLoadingOoblets = false,
    this.variantsFilter = const {},
    this.locationsFilter = const {},
    this.nameFilter = '',
    this.caughtStatusFilter = OobletCaughtStatus.any,
    this.variantCaughtStatus = const {},
  });

  OobletsSlice _copyWith({
    List<Ooblet>? allOoblets,
    List<Ooblet>? ooblets,
    List<OobletWithVariant>? oobletsWithVariants,
    bool? loadingOoblets,
    bool? hasErrorLoadingOoblets,
    Set<OobletVariant>? variantsFilter,
    Set<String>? locationsFilter,
    String? nameFilter,
    OobletCaughtStatus? caughtStatusFilter,
    Map<OobletVariant, Map<String, bool>>? variantCaughtStatus,
  }) =>
      OobletsSlice._(
        allOoblets: allOoblets ?? this.allOoblets,
        ooblets: ooblets ?? this.ooblets,
        oobletsWithVariants: oobletsWithVariants ?? this.oobletsWithVariants,
        loadingOoblets: loadingOoblets ?? this.loadingOoblets,
        hasErrorLoadingOoblets:
            hasErrorLoadingOoblets ?? this.hasErrorLoadingOoblets,
        variantsFilter: variantsFilter ?? this.variantsFilter,
        locationsFilter: locationsFilter ?? this.locationsFilter,
        nameFilter: nameFilter ?? this.nameFilter,
        caughtStatusFilter: caughtStatusFilter ?? this.caughtStatusFilter,
        variantCaughtStatus: variantCaughtStatus ?? this.variantCaughtStatus,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OobletsSlice &&
          listEquals(allOoblets, other.allOoblets) &&
          listEquals(ooblets, other.ooblets) &&
          listEquals(oobletsWithVariants, other.oobletsWithVariants) &&
          loadingOoblets == other.loadingOoblets &&
          hasErrorLoadingOoblets == other.hasErrorLoadingOoblets &&
          setEquals(variantsFilter, other.variantsFilter) &&
          setEquals(locationsFilter, other.locationsFilter) &&
          nameFilter == other.nameFilter &&
          caughtStatusFilter == other.caughtStatusFilter &&
          mapEquals(variantCaughtStatus, other.variantCaughtStatus));

  @override
  int get hashCode => Object.hash(
        Object.hashAll(allOoblets),
        Object.hashAll(ooblets),
        Object.hashAll(oobletsWithVariants),
        loadingOoblets,
        hasErrorLoadingOoblets,
        Object.hashAll(variantsFilter),
        Object.hashAll(locationsFilter),
        nameFilter,
        caughtStatusFilter,
        variantCaughtStatus,
      );
}

// Actions - start

Future<void> fetchOobletsAction(Store<OobdexState> store) async {
  store.dispatch(const _UpdateOobletsSliceAction(
    allOoblets: [],
    ooblets: [],
    oobletsWithVariants: [],
    loadingOoblets: true,
    hasErrorLoadingOoblets: false,
  ));
  try {
    final variantsFilter = store.state.oobletsSlice.variantsFilter;
    final locationsFilter = store.state.oobletsSlice.locationsFilter;
    final nameFilter = store.state.oobletsSlice.nameFilter.trim().toUpperCase();
    final caughtStatusFilter = store.state.oobletsSlice.caughtStatusFilter;
    final variantCaughtStatus = store.state.oobletsSlice.variantCaughtStatus;

    final allOoblets = await ApiManager.instance.fetchAllOoblets();

    final allOobletsSet = SplayTreeSet<Ooblet>(_compareOoblets);
    final ooblets = SplayTreeSet<Ooblet>(_compareOoblets);
    final oobletsWithVariants = SplayTreeSet<OobletWithVariant>((o1, o2) {
      var result = _compareOoblets(o1.ooblet, o2.ooblet);
      if (result == 0) {
        result = o1.variant.index - o2.variant.index;
      }
      return result;
    });
    await for (final ooblet in allOoblets.fetchOoblets()) {
      allOobletsSet.add(ooblet);
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
        if (caughtStatusFilter != OobletCaughtStatus.any) {
          final caught = variantCaughtStatus[variant]?.get(ooblet.id) ?? false;
          if (caught && caughtStatusFilter == OobletCaughtStatus.missing ||
              !caught && caughtStatusFilter == OobletCaughtStatus.caught) {
            continue;
          }
        }
        ooblets.add(ooblet);
        oobletsWithVariants.add(OobletWithVariant(ooblet, variant));
      }
    }

    store.dispatch(_UpdateOobletsSliceAction(
      allOoblets: List.unmodifiable(allOobletsSet).cast(),
      ooblets: List.unmodifiable(ooblets).cast(),
      oobletsWithVariants: List.unmodifiable(oobletsWithVariants).cast(),
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

int _compareOoblets(Ooblet o1, Ooblet o2) {
  if (o1 == o2) {
    return 0;
  }
  var result = o1.name.toString().compareTo(o2.name.toString());
  if (result == 0) {
    result = o1.id.compareTo(o2.id);
  }
  return result;
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

ThunkAction<void> updateCaughtStatusOobletsFilterAction(
  OobletCaughtStatus caughtStatusFilter,
) =>
    (store) async {
      store.dispatch(
        _UpdateOobletsSliceAction(caughtStatusFilter: caughtStatusFilter),
      );
      await store.dispatch(fetchOobletsAction);
    };

Future<void> clearVariantsLocationsCaughtStatusOobletsFilterAction(
  Store<OobdexState> store,
) async {
  store.dispatch(const _UpdateOobletsSliceAction(
    variantsFilter: {},
    locationsFilter: {},
    caughtStatusFilter: OobletCaughtStatus.any,
  ));
  await store.dispatch(fetchOobletsAction);
}

ThunkAction<void> updateOobletCaughtStatus(
  OobletVariant variant,
  String ooblet,
  bool caught,
  bool fetchOoblets,
) =>
    (store) async {
      await OobletsCaughtStatusService.instance
          .updateCaughtStatus(variant, ooblet, caught);

      final originalMap = store.state.oobletsSlice.variantCaughtStatus;
      final newMap = {
        ...originalMap,
        variant: Map.unmodifiable({
          ...originalMap[variant]!,
          ooblet: caught,
        }).cast<String, bool>()
      };

      store.dispatch(_UpdateOobletsSliceAction(
        variantCaughtStatus: Map.unmodifiable(newMap).cast(),
      ));

      if (fetchOoblets &&
          store.state.oobletsSlice.caughtStatusFilter !=
              OobletCaughtStatus.any) {
        await store.dispatch(fetchOobletsAction);
      }
    };

class LoadOobletsCaughtStatusAction {
  const LoadOobletsCaughtStatusAction();
}

class _UpdateOobletsSliceAction {
  final List<Ooblet>? allOoblets;
  final List<Ooblet>? ooblets;
  final List<OobletWithVariant>? oobletsWithVariants;

  final bool? loadingOoblets;
  final bool? hasErrorLoadingOoblets;

  final Set<OobletVariant>? variantsFilter;
  final Set<String>? locationsFilter;
  final String? nameFilter;
  final OobletCaughtStatus? caughtStatusFilter;

  final Map<OobletVariant, Map<String, bool>>? variantCaughtStatus;

  const _UpdateOobletsSliceAction({
    this.allOoblets,
    this.ooblets,
    this.oobletsWithVariants,
    this.loadingOoblets,
    this.hasErrorLoadingOoblets,
    this.variantsFilter,
    this.locationsFilter,
    this.nameFilter,
    this.caughtStatusFilter,
    this.variantCaughtStatus,
  });
}

// Actions - end

// Reducers - start

OobletsSlice _oobletsReducer(OobletsSlice state, dynamic action) {
  if (action is _UpdateOobletsSliceAction) {
    return state._copyWith(
      allOoblets: action.allOoblets,
      ooblets: action.ooblets,
      oobletsWithVariants: action.oobletsWithVariants,
      loadingOoblets: action.loadingOoblets,
      hasErrorLoadingOoblets: action.hasErrorLoadingOoblets,
      variantsFilter: action.variantsFilter,
      locationsFilter: action.locationsFilter,
      nameFilter: action.nameFilter,
      caughtStatusFilter: action.caughtStatusFilter,
      variantCaughtStatus: action.variantCaughtStatus,
    );
  }
  if (action is LoadOobletsCaughtStatusAction) {
    final variantCaughtStatus = {
      for (final variant in OobletVariant.values)
        variant: Map.unmodifiable(
          OobletsCaughtStatusService.instance.loadCaughtStatus(variant),
        ).cast<String, bool>()
    };
    return state._copyWith(
      variantCaughtStatus: Map.unmodifiable(variantCaughtStatus).cast(),
    );
  }
  return state;
}

// Reducers - end
