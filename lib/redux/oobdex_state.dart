part of 'redux.dart';

@sealed
@immutable
class OobdexState {
  final OobletsSlice oobletsSlice;

  const OobdexState._({
    this.oobletsSlice = const OobletsSlice._(),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OobdexState && oobletsSlice == other.oobletsSlice);

  @override
  int get hashCode => oobletsSlice.hashCode;
}

// Actions - start

Future<void> clearCacheAction(Store<OobdexState> store) async {
  await ApiManager.instance.clearAll();
  store.dispatch(fetchOobletsAction);
}

// Actions - end

// Reducers - start

OobdexState _oobdexStateReducer(OobdexState state, action) => OobdexState._(
      oobletsSlice: _oobletsReducer(state.oobletsSlice, action),
    );

// Reducers - end
