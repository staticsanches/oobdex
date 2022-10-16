import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/home_page.dart';
import 'utils/api.dart';

void main() async {
  registerApiGetItTypes();

  Hive.registerAdapter(ApiDataTypeAdapter());
  await Hive.initFlutter('ooblets_tracker');

  runApp(const OobletsTrackerApp());
}

class OobletsTrackerApp extends StatelessWidget {
  const OobletsTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ooblets Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (_) => const HomePage(),
      },
    );
  }
}
