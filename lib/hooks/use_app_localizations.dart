part of 'hooks.dart';

AppLocalizations useAppLocalizations() {
  final context = useContext();
  final appLocalizations = AppLocalizations.of(context);
  if (appLocalizations == null) {
    throw Exception('AppLocalizations is not available');
  }
  return appLocalizations;
}
