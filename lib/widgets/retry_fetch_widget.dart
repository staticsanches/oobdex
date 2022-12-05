import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../redux/redux.dart';

class RetryFetchWidget extends HookWidget {
  final ThunkAction fetchAction;

  const RetryFetchWidget(this.fetchAction, {super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = useAppLocalizations();
    final dispatch = useDispatch();

    return Center(
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
            onPressed: () => dispatch(fetchAction),
            child: Text(appLocalizations.retry),
          ),
        ],
      ),
    );
  }
}
