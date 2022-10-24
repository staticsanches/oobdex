import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../redux/redux.dart';
import '../widgets/api_image_widget.dart';

class AllOobletsPage extends HookWidget {
  static const routeName = '/all-ooblets';

  const AllOobletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    final oobletsSlice = useSelector((state) => state.oobletsSlice);

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
            const SelectableText('An error occurred'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => dispatch(fetchOobletsAction),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (oobletsSlice.loadingOoblets) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      body = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: oobletsSlice.ooblets.length,
        itemBuilder: (ctx, index) {
          final oobletWithVariant = oobletsSlice.ooblets[index];
          return ApiImageWidget(
            oobletWithVariant.variant.imageType,
            oobletWithVariant.id,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ooblets'),
      ),
      body: body,
    );
  }
}
