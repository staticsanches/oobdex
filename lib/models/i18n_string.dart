import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';
import 'package:meta/meta.dart';

import '../utils/extensions.dart';

@sealed
@immutable
class I18nString {
  static const _defaultKey = 'default';

  final String _defaultValue;
  final Map<Locale, String> _values;

  factory I18nString.fromJson(Map<String, dynamic> json) {
    final Map<Locale, String> values = {};
    for (final key in json.keys) {
      var value = (json[key] as String?)?.trim() ?? '';
      if (key != _defaultKey && value.isNotEmpty) {
        values[Locale.parse(key)] = value;
      }
    }
    return I18nString._(
      json[_defaultKey]?.trim() ?? '',
      Map.unmodifiable(values),
    );
  }

  const I18nString._(this._defaultValue, this._values);

  Map<String, String> toJson() => {
        _defaultKey: _defaultValue,
        for (final e in _values.entries) e.key.toLanguageTag(): e.value
      };

  String operator [](Locale? locale) {
    if (locale == null || _values.isEmpty) {
      return _defaultValue;
    }
    return _values[locale] ?? this[locale.parent];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is I18nString &&
          other._defaultValue == _defaultValue &&
          mapEquals(other._values, _values));

  @override
  int get hashCode => Object.hash(_defaultValue, _values);

  @override
  String toString() {
    return this[Locale.tryParse(Intl.getCurrentLocale())];
  }
}
