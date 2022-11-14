part of 'hooks.dart';

TapGestureRecognizer useTapGestureRecognizer() {
  final recognizer = useMemoized(() => TapGestureRecognizer());
  useEffect(() => () => recognizer.dispose(), const []);
  return recognizer;
}
