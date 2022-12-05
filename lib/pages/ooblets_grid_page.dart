import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../utils/extensions.dart';
import '../widgets/api_image_widget.dart';
import '../widgets/caught_status_toggle.dart';
import '../widgets/clickable_card.dart';
import '../widgets/ooblets_filter.dart';
import '../widgets/retry_fetch_widget.dart';

class OobletsGridPage extends HookWidget {
  const OobletsGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hasErrorLoadingOoblets =
        useSelector((state) => state.oobletsSlice.hasErrorLoadingOoblets);
    final loadingOoblets =
        useSelector((state) => state.oobletsSlice.loadingOoblets);

    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

    final Widget body;
    if (hasErrorLoadingOoblets) {
      body = const RetryFetchWidget(fetchOobletsAction);
    } else if (loadingOoblets) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = const SafeArea(child: _OobletsGridView());
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const _Title(),
        actions: [
          _FilterButton(
            () => scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      body: body,
      endDrawer: const Drawer(child: OobletsFilter()),
    );
  }
}

class _Title extends HookWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();
    final oobletsLenght = useSelector(
      (state) => state.oobletsSlice.oobletsWithVariants.length,
    );
    return Badge(
      toAnimate: false,
      badgeContent: Text('$oobletsLenght'),
      badgeColor: Theme.of(context).colorScheme.primaryContainer,
      position: const BadgePosition(end: -25),
      child: Text(appLocalizations.ooblets),
    );
  }
}

class _OobletsGridView extends HookWidget {
  const _OobletsGridView();

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();
    final oobletsWithVariants =
        useSelector((state) => state.oobletsSlice.oobletsWithVariants);
    final crossAxisCount = useResponsiveValue(
      const Breakpoints(xs: 3, sm: 4, md: 5, lg: 6, xl: 7, xxl: 8),
    );

    return oobletsWithVariants.isEmpty
        ? Center(child: Text(appLocalizations.noOobletsFound))
        : Padding(
            padding: const EdgeInsets.all(4),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 3 / 4,
              ),
              itemCount: oobletsWithVariants.length,
              itemBuilder: (_, index) =>
                  _OobletCard(oobletsWithVariants[index]),
            ),
          );
  }
}

class _OobletCard extends HookWidget {
  final OobletWithVariant oobletWithVariant;

  _OobletCard(this.oobletWithVariant) : super(key: ValueKey(oobletWithVariant));

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();
    return Stack(
      alignment: Alignment.center,
      children: [
        ClickableCard(
          margin: const EdgeInsets.all(4),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ApiImageWidget(
                    oobletWithVariant.variant.imageType,
                    oobletWithVariant.ooblet.id,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: Column(
                  children: [
                    Text(
                      oobletWithVariant.ooblet.name.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '(${oobletWithVariant.variant.getName(appLocalizations).toLowerCase()})',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: CaughtStatusToggle(
              size: 30,
              variant: oobletWithVariant.variant,
              ooblet: oobletWithVariant.ooblet.id,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterButton extends HookWidget {
  final void Function() onPressed;

  const _FilterButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    final withFilters = useSelector(
      (state) =>
          state.oobletsSlice.variantsFilter.isNotEmpty ||
          state.oobletsSlice.locationsFilter.isNotEmpty ||
          state.oobletsSlice.nameFilter.isNotEmpty ||
          state.oobletsSlice.caughtStatusFilter != OobletCaughtStatus.any,
    );
    return Padding(
      padding: const EdgeInsets.all(8),
      child: IconButton(
        onPressed: onPressed,
        icon: Badge(
          showBadge: withFilters,
          position: const BadgePosition(top: 0, end: 0),
          child: const Icon(Icons.filter_list),
        ),
      ),
    );
  }
}
