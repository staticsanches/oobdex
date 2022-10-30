part of 'hooks.dart';

TextEditingController useTextEditingControllerWithStore({
  required Selector<String> initialValueSelector,
  required ThunkAction<void> Function(String) updateAction,
}) {
  final store = useStore();
  final dispatch = store.dispatch;

  final controller = useTextEditingController(
    text: initialValueSelector(store.state),
  );

  useEffect(() {
    listener() async => await dispatch(updateAction(controller.text));
    controller.addListener(listener);
    return () => controller.removeListener(listener);
  }, [controller]);

  return controller;
}
