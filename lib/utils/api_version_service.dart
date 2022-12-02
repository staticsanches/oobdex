import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_uri.dart';
import 'extensions.dart';

void registerApiVersionServiceGetItTypes() {
  GetIt.I.registerSingleton<ApiVersionService>(_ApiVersionService());
}

abstract class ApiVersionService {
  static ApiVersionService get instance => GetIt.I<ApiVersionService>();

  Future<int> fetchTimestampVersion();

  Future<int?> retrieveStoredTimestampVersion();
  Future<void> updateStoredTimestampVersion(int timestampVersion);
  Future<void> clearStoredTimestampVersion();
}

class _ApiVersionService extends ApiVersionService {
  static const _sharedPreferencesKey = 'api_timestamp_version';

  @override
  Future<int> fetchTimestampVersion() async {
    final client = RetryClient(http.Client());
    final uri = apiUri('/timestamp_version.json');
    try {
      final response = await client.get(uri);
      if (!response.ok) {
        throw Exception('$uri: status ${response.statusCode}');
      }
      return int.parse(response.body);
    } finally {
      client.close();
    }
  }

  @override
  Future<int?> retrieveStoredTimestampVersion() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(_sharedPreferencesKey);
  }

  @override
  Future<void> updateStoredTimestampVersion(int timestampVersion) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(_sharedPreferencesKey, timestampVersion);
  }

  @override
  Future<void> clearStoredTimestampVersion() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_sharedPreferencesKey);
  }
}
