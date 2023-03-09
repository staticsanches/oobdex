import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/about_page.dart';
import 'pages/home_page.dart';
import 'pages/ooblet_page.dart';
import 'redux/redux.dart';
import 'utils/api.dart';
import 'utils/api_version_service.dart';
import 'utils/ooblets_caught_status_service.dart';

void main() async {
  registerApiGetItTypes();
  registerOobletsCaughtStatusGetItTypes();
  registerApiVersionServiceGetItTypes();

  Hive.registerAdapter(ApiDataTypeAdapter());
  await Hive.initFlutter('oobdex');

  await OobletsCaughtStatusService.instance.init();

  final store = createStore();

  try {
    await _checkApiVersion(store);
  } catch (_) {
    // ignores the error
  }

  runApp(OobdexApp(store));
}

Future<void> _checkApiVersion(Store<OobdexState> store) async {
  final apiVersionService = ApiVersionService.instance;
  final remoteVersion = await apiVersionService.fetchTimestampVersion();
  final localVersion = await apiVersionService.retrieveStoredTimestampVersion();
  if (localVersion == null || remoteVersion > localVersion) {
    await apiVersionService.updateStoredTimestampVersion(remoteVersion);
    await store.dispatch(clearCacheAction);
  }
}

class OobdexApp extends StatelessWidget {
  final Store<OobdexState> _store;

  const OobdexApp(this._store, {super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<OobdexState>(
      store: _store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.oobdex,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
            brightness: Brightness.dark,
          ),
        ),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (_) => const HomePage(),
          AboutPage.routeName: (_) => const AboutPage(),
          OobletPage.routeName: (_) => const OobletPage(),
        },
      ),
    );
  }
}
