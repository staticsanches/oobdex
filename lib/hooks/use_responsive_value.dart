part of 'hooks.dart';

T useResponsiveValue<T>(Breakpoints<T> breakpoints) {
  final context = useContext();
  return breakpoints.choose(MediaQuery.of(context).size);
}
