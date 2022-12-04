import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../hooks/hooks.dart';
import '../widgets/responsive_builder.dart';
import 'locations_grid_page.dart';
import 'ooblets_grid_page.dart';
import 'settings_page.dart';

class HomePage extends HookWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final appLocalizations = useAppLocalizations();

    return ResponsiveBuilder(Breakpoints(
      xs: (context) => Scaffold(
        body: _selectedBody(currentIndex.value),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex.value,
          onDestinationSelected: (value) => currentIndex.value = value,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            NavigationDestination(
              icon: const FaIcon(FontAwesomeIcons.seedling),
              label: appLocalizations.ooblets,
            ),
            NavigationDestination(
              icon: const FaIcon(FontAwesomeIcons.mapLocationDot),
              label: appLocalizations.locations,
            ),
            NavigationDestination(
              icon: const FaIcon(FontAwesomeIcons.rectangleList),
              label: appLocalizations.items,
            ),
            NavigationDestination(
              icon: const FaIcon(FontAwesomeIcons.chess),
              label: appLocalizations.moves,
            ),
            NavigationDestination(
              icon: const FaIcon(FontAwesomeIcons.sliders),
              label: appLocalizations.settings,
            ),
          ],
        ),
      ),
      md: (context) => Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex.value,
              onDestinationSelected: (value) => currentIndex.value = value,
              labelType: NavigationRailLabelType.none,
              groupAlignment: 0,
              destinations: [
                NavigationRailDestination(
                  icon: const FaIcon(FontAwesomeIcons.seedling),
                  label: Text(appLocalizations.ooblets),
                ),
                NavigationRailDestination(
                  icon: const FaIcon(FontAwesomeIcons.mapLocationDot),
                  label: Text(appLocalizations.locations),
                ),
                NavigationRailDestination(
                  icon: const FaIcon(FontAwesomeIcons.rectangleList),
                  label: Text(appLocalizations.items),
                ),
                NavigationRailDestination(
                  icon: const FaIcon(FontAwesomeIcons.chess),
                  label: Text(appLocalizations.moves),
                ),
                NavigationRailDestination(
                  icon: const FaIcon(FontAwesomeIcons.sliders),
                  label: Text(appLocalizations.settings),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: _selectedBody(currentIndex.value))
          ],
        ),
      ),
    ));
  }

  static Widget _selectedBody(int index) {
    switch (index) {
      case 0:
        return const OobletsGridPage();
      case 1:
        return const LocationsGridPage();
      case 4:
        return const SettingsPage();
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
