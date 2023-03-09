import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../utils/extensions.dart';
import '../utils/localized_value.dart';

class AboutPage extends HookWidget {
  static const routeName = '/about';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.aboutPageTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const LocalizedValue(
                    defaultValue: _AboutDefaultText(),
                  ).value,
                  const SizedBox(height: 40),
                  Text(
                    appLocalizations.attribution,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  const LocalizedValue(
                    defaultValue: _AttributionDefaultText(),
                  ).value,
                  const SizedBox(height: 40),
                  ElevatedButton(
                    child: Text(appLocalizations.showLicensesButton),
                    onPressed: () => showLicensePage(context: context),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutDefaultText extends HookWidget {
  const _AboutDefaultText();

  @override
  Widget build(BuildContext context) {
    final recognizer = useTapGestureRecognizer()
      ..onTap = () async => await Uri.parse('https://ooblets.com').launch();
    return RichText(
      textAlign: TextAlign.center,
      textScaleFactor: 1.3,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          const TextSpan(text: 'An '),
          const TextSpan(
            text: 'UNOFFICIAL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: 'Ooblets',
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: recognizer,
          ),
          const TextSpan(
            text: ' index to help reach the completion of this fantastic game.',
          ),
        ],
      ),
    );
  }
}

class _AttributionDefaultText extends HookWidget {
  const _AttributionDefaultText();

  @override
  Widget build(BuildContext context) {
    final wikiRecognizer = useTapGestureRecognizer()
      ..onTap = () async =>
          await Uri.parse('https://ooblets.fandom.com/wiki/Ooblets_Wiki')
              .launch();
    final licenseRecognizer = useTapGestureRecognizer()
      ..onTap = () async =>
          await Uri.parse('https://creativecommons.org/licenses/by-sa/3.0')
              .launch();
    return RichText(
      textAlign: TextAlign.center,
      textScaleFactor: 1.15,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          const TextSpan(
            text: 'The information used was based on the content of the ',
          ),
          TextSpan(
            text: 'Ooblets Wiki',
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: wikiRecognizer,
          ),
          const TextSpan(text: ' which is licensed under '),
          TextSpan(
            text: 'CC BY-NC-SA 3.0',
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: licenseRecognizer,
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
