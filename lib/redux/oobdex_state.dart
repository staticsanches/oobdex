part of 'redux.dart';

@sealed
@immutable
class OobdexState {
  final OobletsSlice oobletsSlice;
  final LocationsSlice locationsSlice;

  const OobdexState._({
    this.oobletsSlice = const OobletsSlice._(),
    this.locationsSlice = const LocationsSlice._(),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OobdexState &&
          oobletsSlice == other.oobletsSlice &&
          locationsSlice == other.locationsSlice);

  @override
  int get hashCode => Object.hash(oobletsSlice, locationsSlice);
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
    );

// Reducers - end
