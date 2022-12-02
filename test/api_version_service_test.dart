import 'package:flutter_test/flutter_test.dart';
import 'package:oobdex/utils/api_version_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  registerApiVersionServiceGetItTypes();
  SharedPreferences.setMockInitialValues({});

  setUp(() async {
    ApiVersionService.instance.clearStoredTimestampVersion();
  });

  test('Check the fetchTimestampVersion call', () async {
    final timestampVersion =
        await ApiVersionService.instance.fetchTimestampVersion();
    expect(timestampVersion > 0, true);
  });

  test('Check the manipulation of the stored version', () async {
    final initialStoredValue =
        await ApiVersionService.instance.retrieveStoredTimestampVersion();
    expect(initialStoredValue, null);

    await ApiVersionService.instance.updateStoredTimestampVersion(2);

    final newStoredValue =
        await ApiVersionService.instance.retrieveStoredTimestampVersion();
    expect(newStoredValue, 2);
  });
}
