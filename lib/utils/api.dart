import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';

import '../models/all_items.dart';
import '../models/all_locations.dart';
import '../models/all_moves.dart';
import '../models/all_ooblets.dart';
import '../models/api_image.dart';
import '../models/item.dart';
import '../models/location.dart';
import '../models/move.dart';
import '../models/ooblet.dart';
import 'extensions.dart';

part 'api_impl.dart';

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

  Future<T> fetch(String id) => ApiManager.instance.fetch(this, id);
  Stream<T> fetchMany(Iterable<String> ids) =>
      ApiManager.instance.fetchMany(this, ids);
}

@immutable
abstract class ApiData {
  ApiDataType<ApiData> get apiDataType;

  String get id;

  toJson();
}

abstract class ApiManager {
  static ApiManager get instance => GetIt.I<ApiManager>();

  ApiFetcher<T> fetcher<T extends ApiData>(ApiDataType<T> type, String id);
  Future<T> fetch<T extends ApiData>(ApiDataType<T> type, String id);
  Stream<T> fetchMany<T extends ApiData>(
      ApiDataType<T> type, Iterable<String> ids) async* {
    for (final id in ids) {
      try {
        final element = await fetch(type, id);
        yield element;
      } catch (e, stack) {
        yield* Stream.error(e, stack);
      }
    }
  }

  Future<void> clearAll([ApiDataType? type]);

  ApiFetcher<AllItems> allItemsFetcher() =>
      fetcher(ApiDataType.allItems, ApiDataType.allItems.name);
  Future<AllItems> fetchAllItems() async => allItemsFetcher().fetch();

  ApiFetcher<AllLocations> allLocationsFetcher() =>
      fetcher(ApiDataType.allLocations, ApiDataType.allLocations.name);
  Future<AllLocations> fetchAllLocations() async =>
      allLocationsFetcher().fetch();

  ApiFetcher<AllOoblets> allOobletsFetcher() =>
      fetcher(ApiDataType.allOoblets, ApiDataType.allOoblets.name);
  Future<AllOoblets> fetchAllOoblets() async => allOobletsFetcher().fetch();

  ApiFetcher<AllMoves> allMovesFetcher() =>
      fetcher(ApiDataType.allMoves, ApiDataType.allMoves.name);
  Future<AllMoves> fetchAllMoves() async => allMovesFetcher().fetch();
}

abstract class ApiCacheService {
  FutureOr<T?> fetch<T extends ApiData>(ApiDataType<T> type, String id);
  FutureOr<void> store<T extends ApiData>(T data);
  FutureOr<void> clearAll(ApiDataType type);
}

abstract class ApiRemoteService {
  FutureOr<T> fetch<T extends ApiData>(ApiDataType<T> type, String id);
}

abstract class ApiJsonConverter {
  toJson<T extends ApiData>(ApiDataType<T> type, String id, Uint8List bytes);
  T fromJson<T extends ApiData>(ApiDataType<T> type, String id, dynamic json);
}

enum ApiFetcherStatus { notLoaded, loadedFromCache, loadedFromRemote }

abstract class ApiFetcher<T extends ApiData> {
  ApiDataType<T> get type;
  String get id;

  ApiFetcherStatus get status;

  FutureOr<T> fetch();

  void reset();
}

@sealed
@immutable
class ApiFetcherException<T extends ApiData> implements Exception {
  final ApiDataType<T> type;
  final String id;

  final Object? cause;
  final StackTrace? causeStack;

  const ApiFetcherException(
      {required this.type, required this.id, this.cause, this.causeStack});

  @override
  String toString() {
    var message = 'Unable to fetch ${type.name} with id $id';
    if (cause != null) {
      message += ': $cause';
    }
    return message;
  }
}

@sealed
class ApiDataTypeAdapter implements TypeAdapter<ApiData> {
  @override
  int get typeId => 100;

  @override
  ApiData read(BinaryReader reader) {
    final typeName = reader.readString();
    final type = ApiDataType.values.firstWhere((type) => type.name == typeName);
    final id = reader.readString();
    final json = jsonDecode(reader.readString());
    return GetIt.I<ApiJsonConverter>().fromJson(type, id, json);
  }

  @override
  void write(BinaryWriter writer, ApiData obj) {
    writer.writeString(obj.apiDataType.name);
    writer.writeString(obj.id);
    writer.writeString(jsonEncode(obj));
  }
}
