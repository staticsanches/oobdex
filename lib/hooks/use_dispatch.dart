part of 'hooks.dart';

typedef Dispatch = dynamic Function(dynamic action);

Dispatch useDispatch() => useStore().dispatch;
