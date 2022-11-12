import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../models/api_data.dart';

void registerOobletsCaughtStatusGetItTypes() {
  GetIt.I.registerSingleton<OobletsCaughtStatusService>(
    _OobletsCaughtStatusService(),
  );
}

abstract class OobletsCaughtStatusService {
  static OobletsCaughtStatusService get instance =>
      GetIt.I<OobletsCaughtStatusService>();

  Map<String, bool> loadCaughtStatus(OobletVariant variant);
  Future<void> updateCaughtStatus(
      OobletVariant variant, String ooblet, bool caught);

  Future<void> init();
  Future<void> clearAll([OobletVariant? variant]);
}

class _OobletsCaughtStatusService extends OobletsCaughtStatusService {
  late final Map<OobletVariant, Box<bool>> variantBoxes;

  @override
  Map<String, bool> loadCaughtStatus(OobletVariant variant) {
    final box = variantBoxes[variant]!;
    return {
      for (final ooblet in box.keys) ooblet: box.get(ooblet) ?? false,
    };
  }

  @override
  Future<void> updateCaughtStatus(
          OobletVariant variant, String ooblet, bool caught) async =>
      await variantBoxes[variant]!.put(ooblet, caught);

  @override
  Future<void> init() async {
    final boxes = <OobletVariant, Box<bool>>{};
    for (final variant in OobletVariant.values) {
      final box = await Hive.openBox<bool>('${variant.name}CaughtStatusBox');
      boxes[variant] = box;
    }
    variantBoxes = Map.unmodifiable(boxes);
  }

  @override
  Future<void> clearAll([OobletVariant? variant]) async {
    if (variant == null) {
      await Future.wait(OobletVariant.values.map(clearAll));
    } else {
      await variantBoxes[variant]!.clear();
    }
  }
}
