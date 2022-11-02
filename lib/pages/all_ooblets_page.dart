import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../widgets/api_image_widget.dart';
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

    final filtersAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 400),
      initialValue: 0,
    );

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
      body = Column(
        children: [
          SizeTransition(
            sizeFactor: filtersAnimationController,
            child: const OobletsFilter(),
          ),
          const Expanded(child: _OobletsGridView()),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.ooblets),
        actions: [
          OobletsFilterButton(() {
            if (filtersAnimationController.value > 0) {
              filtersAnimationController.reverse();
            } else {
              filtersAnimationController.forward();
            }
          }),
        ],
      ),
      body: body,
    );
  }
}

class _OobletsGridView extends HookWidget {
  const _OobletsGridView();

  @override
  Widget build(BuildContext context) {
    final ooblets = useSelector((state) => state.oobletsSlice.ooblets);
    final crossAxisCount = useResponsiveValue(
      const Breakpoints(xs: 3, sm: 4, md: 5, lg: 6, xl: 7),
    );

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      itemCount: ooblets.length,
      itemBuilder: (ctx, index) {
        final oobletWithVariant = ooblets[index];
        return ApiImageWidget(
          key: ValueKey(oobletWithVariant),
          oobletWithVariant.variant.imageType,
          oobletWithVariant.ooblet.id,
        );
      },
    );
  }
}
