part of 'hooks.dart';

T useRouteArguments<T>() {
  final context = useContext();
  return ModalRoute.of(context)!.settings.arguments as T;
}
