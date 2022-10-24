import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

import '../models/api_data.dart';
import '../utils/api.dart';

export 'package:redux/redux.dart';

part 'oobdex_state.dart';
part 'ooblets_slice.dart';
part 'thunk.dart';

Store<OobdexState> createStore() => Store(
      _oobdexStateReducer,
      initialState: const OobdexState._(),
      middleware: [_thunkMiddleware],
    );

extension OobdexStore on Store<OobdexState> {
  initialDispatch() {
    dispatch(fetchOobletsAction);
  }
}
