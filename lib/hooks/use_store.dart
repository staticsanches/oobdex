part of 'hooks.dart';

Store<OobdexState> useStore({bool listen = false}) {
  final context = useContext();
  final store = StoreProvider.of<OobdexState>(context, listen: listen);
  return store;
}
