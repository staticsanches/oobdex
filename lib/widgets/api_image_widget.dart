import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../hooks/hooks.dart';
import '../models/api_data.dart';
import '../utils/extensions.dart';

class ApiImageWidget extends HookWidget {
  final ApiDataType<ApiImage> type;
  final String id;

  final BoxFit? fit;

  const ApiImageWidget(this.type, this.id, {super.key, this.fit});

  @override
  Widget build(BuildContext context) {
    final reloadToggle = useState(false);
    final future = useMemoized(() => type.fetch(id), [reloadToggle.value]);
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
      return Image.memory(Uint8List.fromList(data.content), fit: fit);
    }
    return const Center(child: CircularProgressIndicator());
  }
}
