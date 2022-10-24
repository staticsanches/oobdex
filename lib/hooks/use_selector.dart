part of 'hooks.dart';

typedef Selector<Output> = Output Function(OobdexState state);
typedef EqualityFn<T> = bool Function(T a, T b);

Output useSelector<Output>(
  Selector<Output> selector, {
  EqualityFn<Output>? equalityFn,
  List<Object?> keysSelector = const <Object>[],
  List<Object?> keysEqualityFn = const <Object>[],
}) {
  final memoizedSelector = useMemoized(() => selector, keysSelector);
  final memoizedEqualityFn = useMemoized(() => equalityFn, keysEqualityFn);

  final store = useStore();
  final stream = useMemoized(
    () => store.onChange.map(memoizedSelector).distinct(memoizedEqualityFn),
    [store, memoizedSelector, memoizedEqualityFn],
  );
  final snapshot =
      useStream(stream, initialData: memoizedSelector(store.state));
  return snapshot.data as Output;
}
