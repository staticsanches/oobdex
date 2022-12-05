part of 'redux.dart';

@sealed
@immutable
class OobdexState {
  final OobletsSlice oobletsSlice;
  final LocationsSlice locationsSlice;
  final ItemsSlice itemsSlice;

  const OobdexState._({
    this.oobletsSlice = const OobletsSlice._(),
    this.locationsSlice = const LocationsSlice._(),
    this.itemsSlice = const ItemsSlice._(),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OobdexState &&
          oobletsSlice == other.oobletsSlice &&
          locationsSlice == other.locationsSlice &&
          itemsSlice == other.itemsSlice);

  @override
  int get hashCode => Object.hash(oobletsSlice, locationsSlice, itemsSlice);
}

// Actions - start

Future<void> clearCacheAction(Store<OobdexState> store) async {
  await ApiManager.instance.clearAll();
  store._initialDispatch();
}

Future<void> clearUserDataAction(Store<OobdexState> store) async {
  await OobletsCaughtStatusService.instance.clearAll();
  store.dispatch(const LoadOobletsCaughtStatusAction());
  if (store.state.oobletsSlice.caughtStatusFilter != OobletCaughtStatus.any) {
    await store.dispatch(fetchOobletsAction);
  }
}

// Actions - end

// Reducers - start

OobdexState _oobdexStateReducer(OobdexState state, action) => OobdexState._(
      oobletsSlice: _oobletsReducer(state.oobletsSlice, action),
      locationsSlice: _locationsReducer(state.locationsSlice, action),
      itemsSlice: _itemsReducer(state.itemsSlice, action),
    );

// Reducers - end
