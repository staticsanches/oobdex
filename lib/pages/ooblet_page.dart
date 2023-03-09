import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../widgets/item_list_widget.dart';

class OobletPage extends HookWidget {
  static const routeName = '/ooblet';

  const OobletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ooblet = useRouteArguments<Ooblet>();

    return Scaffold(
      appBar: AppBar(
        title: Text(ooblet.name.toString()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            ooblet.quote.toString(),
            textAlign: TextAlign.center,
          ),
          ItemListWidget(ooblet.items),
        ],
      ),
    );
  }
}
