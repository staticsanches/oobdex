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
    final oobletsSlice = useSelector((state) => state.oobletsSlice);

    final filtersAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 400),
      initialValue: 0,
    );

    final Widget body;
    if (oobletsSlice.hasErrorLoadingOoblets) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            const SizedBox(height: 10),
            SelectableText(appLocalizations.anErrorOccurred),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => dispatch(fetchOobletsAction),
              child: Text(appLocalizations.retry),
            ),
          ],
        ),
      );
    } else if (oobletsSlice.loadingOoblets) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      body = Column(
        children: [
          SizeTransition(
            sizeFactor: filtersAnimationController,
            child: const OobletsFilter(),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: oobletsSlice.ooblets.length,
              itemBuilder: (ctx, index) {
                final oobletWithVariant = oobletsSlice.ooblets[index];
                return ApiImageWidget(
                  key: ValueKey(oobletWithVariant),
                  oobletWithVariant.variant.imageType,
                  oobletWithVariant.ooblet.id,
                );
              },
            ),
          ),
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
