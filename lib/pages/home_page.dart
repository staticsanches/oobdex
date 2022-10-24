import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/hooks.dart';
import '../redux/redux.dart';
import 'all_ooblets_page.dart';

class HomePage extends HookWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    final appLocalizations = useAppLocalizations();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.oobdex),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text(appLocalizations.ooblets),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AllOobletsPage.routeName),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(appLocalizations.clearCache),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await dispatch(clearCacheAction);
                  messenger.showSnackBar(SnackBar(
                    content: SelectableText(appLocalizations.clearCacheSuccess),
                  ));
                } catch (_) {
                  messenger.showSnackBar(SnackBar(
                    content: SelectableText(appLocalizations.clearCacheFail),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
