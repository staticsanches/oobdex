part of 'redux.dart';

typedef _ThunkAction = dynamic Function(Store<OobdexState> store);

dynamic _thunkMiddleware(
  Store<OobdexState> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is _ThunkAction) {
    return action(store);
  } else {
    return next(action);
  }
}
