import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/home_page.dart';
import 'redux/redux.dart';
import 'utils/api.dart';
import 'utils/ooblets_caught_status_service.dart';

void main() async {
  registerApiGetItTypes();
  registerOobletsCaughtStatusGetItTypes();

  Hive.registerAdapter(ApiDataTypeAdapter());
  await Hive.initFlutter('oobdex');

  await OobletsCaughtStatusService.instance.init();

  final store = createStore();
  runApp(OobdexApp(store));
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
          primarySwatch: Colors.lightGreen,
        ),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (_) => const HomePage(),
        },
      ),
    );
  }
}
