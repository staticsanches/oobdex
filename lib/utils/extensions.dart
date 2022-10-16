import 'package:http/http.dart' as http;
import 'package:intl/locale.dart';

extension IsResponseOk on http.Response {
  bool get ok => (statusCode ~/ 100) == 2;
}

extension LocaleParent on Locale {
  Locale? get parent => countryCode != null
      ? Locale.fromSubtags(languageCode: languageCode)
      : null;
}
