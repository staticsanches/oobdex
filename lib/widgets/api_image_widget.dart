import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/api_data.dart';
import '../utils/api.dart';

class ApiImageWidget extends HookWidget {
  final ApiDataType<ApiImage> type;
  final String id;

  const ApiImageWidget(this.type, this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final reloadToggle = useState(false);
    final future = useMemoized(
      () => ApiManager.instance.fetch(type, id),
      [reloadToggle.value],
    );
    final snapshot = useFuture(future);

    final error = snapshot.error;
    final data = snapshot.data;

    if (error != null) {
      return Center(
        child: IconButton(
          onPressed: () => reloadToggle.value = !reloadToggle.value,
          icon: const Icon(Icons.refresh),
        ),
      );
    } else if (data != null) {
      return FittedBox(
        child: Image.memory(
          Uint8List.fromList(data.content),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}
