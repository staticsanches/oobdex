import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../utils/extensions.dart';
import '../widgets/api_image_widget.dart';
import '../widgets/clickable_card.dart';
import '../widgets/square_box.dart';

class LocationsGridPage extends HookWidget {
  const LocationsGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();
    final dispatch = useDispatch();

    final hasErrorLoadingLocations =
        useSelector((state) => state.locationsSlice.hasErrorLoadingLocations);
    final loadingLocations =
        useSelector((state) => state.locationsSlice.loadingLocations);

    final Widget body;
    if (hasErrorLoadingLocations) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            const SizedBox(height: 10),
            Text(appLocalizations.anErrorOccurred),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => dispatch(fetchLocationsAction),
              child: Text(appLocalizations.retry),
            ),
          ],
        ),
      );
    } else if (loadingLocations) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = const SafeArea(child: _LocationsGridView());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.locations),
      ),
      body: body,
    );
  }
}

class _LocationsGridView extends HookWidget {
  const _LocationsGridView();

  @override
  Widget build(BuildContext context) {
    final locations = useSelector((state) => state.locationsSlice.locations);
    final crossAxisCount = useResponsiveValue(
      const Breakpoints(xs: 1, sm: 2, lg: 3, xxl: 4),
    );

    return Padding(
      padding: const EdgeInsets.all(4),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 15 / 7,
        ),
        itemCount: locations.length,
        itemBuilder: (_, index) => _LocationItem(locations[index]),
      ),
    );
  }
}

class _LocationItem extends HookWidget {
  final Location location;

  _LocationItem(this.location) : super(key: ValueKey(location));

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();

    return ClickableCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SquareBox(
              child: ApiImageWidget(ApiDataType.locationImage, location.id),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  location.name.toString(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                Text(
                  appLocalizations.ooblets,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LocationOobletsCaughtStatus(
                      location: location,
                      caught: true,
                    ),
                    const SizedBox(width: 20),
                    _LocationOobletsCaughtStatus(
                      location: location,
                      caught: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationOobletsCaughtStatus extends HookWidget {
  final Location location;
  final bool caught;

  const _LocationOobletsCaughtStatus({
    required this.location,
    required this.caught,
  });

  @override
  Widget build(BuildContext context) {
    final ooblets = useSelector(
      (state) => state.oobletsSlice.allOoblets
          .where((ooblet) => ooblet.locationID == location.id),
    );
    final variantCaughtStatus =
        useSelector((state) => state.oobletsSlice.variantCaughtStatus);

    var total = 0;
    for (final variant in OobletVariant.values) {
      for (final ooblet in ooblets) {
        final oobletCaught =
            variantCaughtStatus[variant]?.get(ooblet.id) ?? false;
        if (caught == oobletCaught) {
          total++;
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          caught ? Icons.lock : Icons.lock_open,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 10),
        Text(total.toString()),
      ],
    );
  }
}
