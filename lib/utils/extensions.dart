import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

extension OobletVariantExtension on OobletVariant {
  String getName(AppLocalizations appLocalizations) {
    switch (this) {
      case OobletVariant.common:
        return appLocalizations.oobletVariantCommon;
      case OobletVariant.unusual:
        return appLocalizations.oobletVariantUnusual;
      case OobletVariant.gleamy:
        return appLocalizations.oobletVariantGleamy;
    }
  }
}

extension OobletCaughtStatusExtension on OobletCaughtStatus {
  String getName(AppLocalizations appLocalizations) {
    switch (this) {
      case OobletCaughtStatus.any:
        return appLocalizations.oobletCaughtStatusAny;
      case OobletCaughtStatus.caught:
        return appLocalizations.oobletCaughtStatusCaught;
      case OobletCaughtStatus.missing:
        return appLocalizations.oobletCaughtStatusMissing;
    }
  }
}

extension MapExtension<K, V> on Map<K, V> {
  V? get(K key) => this[key];
}
