import 'package:http/http.dart' as http;
import 'package:intl/locale.dart';

import '../models/api_data.dart';
import 'api.dart';

extension IsResponseOk on http.Response {
  bool get ok => (statusCode ~/ 100) == 2;
}

extension LocaleParent on Locale {
  Locale? get parent => countryCode != null
      ? Locale.fromSubtags(languageCode: languageCode)
      : null;
}

extension ApiDataTypeFetch<T extends ApiData> on ApiDataType<T> {
  Future<T> fetch(String id) => ApiManager.instance.fetch(this, id);
  Stream<T> fetchMany(Iterable<String> ids) =>
      ApiManager.instance.fetchMany(this, ids);
}
