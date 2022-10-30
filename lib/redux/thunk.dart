part of 'redux.dart';

typedef ThunkAction<T> = Future<T> Function(Store<OobdexState> store);

dynamic _thunkMiddleware(
  Store<OobdexState> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is ThunkAction) {
    return action(store);
  } else {
    return next(action);
  }
}
