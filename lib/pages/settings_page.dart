import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../redux/redux.dart';
import 'about_page.dart';

class SettingsPage extends HookWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.settings),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _ClearCacheButton(),
            const SizedBox(height: 20),
            const _ClearUserDataButton(),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(appLocalizations.aboutButtonLabel),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AboutPage.routeName),
            )
          ],
        ),
      ),
    );
  }
}

class _ClearCacheButton extends HookWidget {
  const _ClearCacheButton();

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    final appLocalizations = useAppLocalizations();

    return ElevatedButton(
      child: Text(appLocalizations.clearCache),
      onPressed: () async {
        final theme = Theme.of(context);
        final messenger = ScaffoldMessenger.of(context);
        try {
          await dispatch(clearCacheAction);
          messenger.showSnackBar(SnackBar(
            content: Text(appLocalizations.clearCacheSuccess),
          ));
        } catch (_) {
          messenger.showSnackBar(SnackBar(
            backgroundColor: theme.errorColor,
            content: Text(appLocalizations.clearCacheFail),
          ));
        }
      },
    );
  }
}

class _ClearUserDataButton extends HookWidget {
  const _ClearUserDataButton();

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    final appLocalizations = useAppLocalizations();

    dialogBuilder(BuildContext context) => AlertDialog(
          title: Text(appLocalizations.areYouSure),
          content: Text(appLocalizations.clearUserDataConfirmationMessage),
          actions: [
            TextButton(
              child: Text(appLocalizations.no),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(appLocalizations.yes),
              onPressed: () async {
                final theme = Theme.of(context);
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await dispatch(clearUserDataAction);
                  messenger.showSnackBar(SnackBar(
                    content: Text(appLocalizations.clearUserDataSuccess),
                  ));
                } catch (_) {
                  messenger.showSnackBar(SnackBar(
                    backgroundColor: theme.errorColor,
                    content: Text(appLocalizations.clearUserDataFail),
                  ));
                }
                navigator.pop();
              },
            ),
          ],
        );

    return ElevatedButton(
      child: Text(appLocalizations.clearUserData),
      onPressed: () => showDialog(context: context, builder: dialogBuilder),
    );
  }
}
