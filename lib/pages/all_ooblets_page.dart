import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../widgets/api_image_widget.dart';
import '../widgets/caught_status_toggle.dart';
import '../widgets/ooblets_filter.dart';
import '../widgets/ooblets_filter_button.dart';

class AllOobletsPage extends HookWidget {
  static const routeName = '/all-ooblets';

  const AllOobletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();
    final dispatch = useDispatch();

    final hasErrorLoadingOoblets =
        useSelector((state) => state.oobletsSlice.hasErrorLoadingOoblets);
    final loadingOoblets =
        useSelector((state) => state.oobletsSlice.loadingOoblets);

    final globalKey = useMemoized(() => GlobalKey<ScaffoldState>());

    final Widget body;
    if (hasErrorLoadingOoblets) {
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
              onPressed: () => dispatch(fetchOobletsAction),
              child: Text(appLocalizations.retry),
            ),
          ],
        ),
      );
    } else if (loadingOoblets) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = const SafeArea(child: _OobletsGridView());
    }

    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const _Title(),
        actions: [
          if (!hasErrorLoadingOoblets && !loadingOoblets)
            OobletsFilterButton(() => globalKey.currentState?.openEndDrawer()),
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
    return Text('${appLocalizations.ooblets} ($oobletsLenght)');
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
      const Breakpoints(xs: 3, sm: 4, md: 5, lg: 6, xl: 7),
    );

    return oobletsWithVariants.isEmpty
        ? Center(child: Text(appLocalizations.noOobletsFound))
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
            ),
            itemCount: oobletsWithVariants.length,
            itemBuilder: (_, index) => _OobletItem(oobletsWithVariants[index]),
          );
  }
}

class _OobletItem extends StatelessWidget {
  final OobletWithVariant oobletWithVariant;

  _OobletItem(this.oobletWithVariant) : super(key: ValueKey(oobletWithVariant));

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          ApiImageWidget(
            oobletWithVariant.variant.imageType,
            oobletWithVariant.ooblet.id,
          ),
          Align(
            alignment: Alignment.topRight,
            child: CaughtStatusToggle(
              size: 30,
              variant: oobletWithVariant.variant,
              ooblet: oobletWithVariant.ooblet.id,
            ),
          ),
        ],
      );
}
