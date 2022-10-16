import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:oobdex/models/i18n_string.dart';

void main() {
  test('Check the locale hierarchy traversal of I18nString', () {
    final i18nString = I18nString.fromJson(const {
      'default': 'Default',
      'en': 'Value',
      'en-US': 'Value US',
      'pt-BR': 'Valor',
    });

    expect(Intl.withLocale('en', () => i18nString.toString()), 'Value');
    expect(Intl.withLocale('en-US', () => i18nString.toString()), 'Value US');
    expect(Intl.withLocale('en-UK', () => i18nString.toString()), 'Value');
    expect(Intl.withLocale('pt', () => i18nString.toString()), 'Default');
    expect(Intl.withLocale('pt-BR', () => i18nString.toString()), 'Valor');
    expect(Intl.withLocale('pt-PT', () => i18nString.toString()), 'Default');
  });
}
