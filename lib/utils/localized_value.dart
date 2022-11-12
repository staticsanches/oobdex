import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';

import 'extensions.dart';

@immutable
class LocalizedValue<T> {
  static const defaultKey = 'default';

  final T defaultValue;
  final Map<Locale, T> values;

  LocalizedValue({required this.defaultValue, Map<Locale, T> values = const {}})
      : values = Map.unmodifiable(values);

  T get value => this[Locale.tryParse(Intl.getCurrentLocale())];

  T operator [](Locale? locale) {
    if (locale == null || values.isEmpty) {
      return defaultValue;
    }
    return values[locale] ?? this[locale.parent];
  }

  Map<String, T> toJson() => {
        defaultKey: defaultValue,
        for (final e in values.entries) e.key.toLanguageTag(): e.value
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalizedValue &&
          other.defaultValue == defaultValue &&
          mapEquals(other.values, values));

  @override
  int get hashCode => Object.hash(defaultValue, values);

  @override
  String toString() => value.toString();
}
