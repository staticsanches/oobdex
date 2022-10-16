import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../utils/extensions.dart';
import 'i18n_string.dart';

part 'all_items.dart';
part 'all_locations.dart';
part 'all_moves.dart';
part 'all_ooblets.dart';
part 'api_image.dart';
part 'item.dart';
part 'item_list.dart';
part 'location.dart';
part 'move.dart';
part 'ooblet.dart';
part 'signature_move.dart';

enum ApiDataType<T extends ApiData> {
  allItems<AllItems>(),
  item<Item>(),
  itemImage<ApiImage>(),

  allLocations<AllLocations>(),
  location<Location>(),

  allOoblets<AllOoblets>(),
  ooblet<Ooblet>(),
  oobletCommonImage<ApiImage>(),
  oobletGleamyImage<ApiImage>(),
  oobletUnusualImage<ApiImage>(),

  allMoves<AllMoves>(),
  move<Move>(),
  moveImage<ApiImage>(),
  ;

  bool get _isImageType =>
      this == ApiDataType.itemImage ||
      this == ApiDataType.oobletCommonImage ||
      this == ApiDataType.oobletGleamyImage ||
      this == ApiDataType.oobletUnusualImage ||
      this == ApiDataType.moveImage;
}

@immutable
abstract class ApiData {
  ApiDataType<ApiData> get apiDataType;
  String get id;
  dynamic toJson();

  static T fromJson<T extends ApiData>(
    ApiDataType<T> type,
    String id,
    dynamic json,
  ) {
    if (type._isImageType) {
      final UnmodifiableUint8ListView content;
      if (json is UnmodifiableUint8ListView) {
        content = json;
      } else {
        content = UnmodifiableUint8ListView(
          Uint8List.fromList(json.cast<int>()),
        );
      }
      return ApiImage._(type as ApiDataType<ApiImage>, id, content) as T;
    }
    if (type == ApiDataType.allItems) {
      return AllItems._fromJson(json) as T;
    }
    if (type == ApiDataType.item) {
      return Item._fromJson(json) as T;
    }
    if (type == ApiDataType.allLocations) {
      return AllLocations._fromJson(json) as T;
    }
    if (type == ApiDataType.location) {
      return Location._fromJson(json) as T;
    }
    if (type == ApiDataType.allOoblets) {
      return AllOoblets._fromJson(json) as T;
    }
    if (type == ApiDataType.ooblet) {
      return Ooblet._fromJson(json) as T;
    }
    if (type == ApiDataType.allMoves) {
      return AllMoves._fromJson(json) as T;
    }
    if (type == ApiDataType.move) {
      return Move._fromJson(json) as T;
    }
    throw UnimplementedError('$type is not supported');
  }

  static T fromResponseBodyBytes<T extends ApiData>(
    ApiDataType<T> type,
    String id,
    Uint8List bytes,
  ) {
    final dynamic json;
    if (type._isImageType) {
      json = UnmodifiableUint8ListView(bytes);
    } else {
      json = jsonDecode(utf8.decode(bytes));
    }
    return fromJson(type, id, json);
  }
}
