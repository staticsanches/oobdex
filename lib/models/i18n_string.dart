import 'package:intl/locale.dart';
import 'package:meta/meta.dart';

import '../utils/localized_value.dart';

@sealed
class I18nString extends LocalizedValue<String> {
  factory I18nString.fromJson(Map<String, dynamic> json) {
    final values = <Locale, String>{};
    for (final key in json.keys) {
      var value = (json[key] as String?)?.trim() ?? '';
      if (key != LocalizedValue.defaultKey && value.isNotEmpty) {
        values[Locale.parse(key)] = value;
      }
    }
    return I18nString._(json[LocalizedValue.defaultKey]?.trim() ?? '', values);
  }

  I18nString._(String defaultValue, Map<Locale, String> values)
      : super(defaultValue: defaultValue, values: values);
}
