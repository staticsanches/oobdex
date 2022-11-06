import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

import '../models/api_data.dart';
import '../utils/api.dart';
import '../utils/extensions.dart';
import '../utils/ooblets_caught_status_service.dart';

export 'package:redux/redux.dart';

part 'locations_slice.dart';
part 'oobdex_state.dart';
part 'ooblets_slice.dart';
part 'thunk.dart';

Store<OobdexState> createStore() => Store(
      _oobdexStateReducer,
      initialState: const OobdexState._(),
      middleware: [_thunkMiddleware],
    ).._initialDispatch();

extension _OobdexStore on Store<OobdexState> {
  _initialDispatch() {
    dispatch(const LoadOobletsCaughtStatusAction());
    dispatch(fetchOobletsAction);
    dispatch(fetchLocationsAction);
  }
}
