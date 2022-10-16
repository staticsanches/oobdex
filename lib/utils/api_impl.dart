part of 'api.dart';

void registerApiGetItTypes() {
  GetIt.I.registerSingleton<ApiManager>(_ApiManager());
  GetIt.I.registerSingleton<ApiCacheService>(_ApiHiveService());
  GetIt.I.registerSingleton<ApiRemoteService>(_ApiHttpsService());
  GetIt.I.registerSingleton<ApiJsonConverter>(_ApiJsonConverter());
}

class _ApiManager extends ApiManager {
  final Map<ApiDataType, Map<String, ApiFetcher>> _cache = {};

  @override
  Future<T> fetch<T extends ApiData>(ApiDataType<T> type, String id) async =>
      fetcher(type, id).fetch();

  @override
  ApiFetcher<T> fetcher<T extends ApiData>(ApiDataType<T> type, String id) {
    final fetchers = _cache[type] ??= {};
    final fetcher = fetchers[id] ??= _ApiFetcher<T>(type, id);
    return fetcher as ApiFetcher<T>;
  }

  @override
  Future<void> clearAll([ApiDataType<ApiData>? type]) async {
    if (type == null) {
      await Future.wait(ApiDataType.values.map(clearAll));
    } else {
      final fetchers = _cache[type]?.values ?? const [];
      for (final fetcher in fetchers) {
        fetcher.reset();
      }
      await GetIt.I<ApiCacheService>().clearAll(type);
    }
  }
}

class _ApiFetcher<T extends ApiData> implements ApiFetcher<T> {
  @override
  final ApiDataType<T> type;
  @override
  final String id;

  _ApiFetcher(this.type, this.id);

  final _mutex = Mutex();

  T? _loadedData;
  var _status = ApiFetcherStatus.notLoaded;

  @override
  ApiFetcherStatus get status => _status;

  @override
  Future<T> fetch() async {
    try {
      return await _fetch();
    } catch (e, stack) {
      throw ApiFetcherException(
          type: type, id: id, cause: e, causeStack: stack);
    }
  }

  @override
  void reset() {
    _loadedData = null;
    _status = ApiFetcherStatus.notLoaded;
  }

  Future<T> _fetch() async {
    var data = _loadedData;
    if (data != null) {
      return data; // data already loaded
    }

    data = await _mutex.protect(_fetchFromCache);
    if (data != null) {
      return data;
    }

    return _mutex.protect(_fetchFromRemote);
  }

  Future<T?> _fetchFromCache() async {
    var data = _loadedData;
    if (data != null) {
      return data; // data already loaded
    }

    data = await GetIt.I<ApiCacheService>().fetch(type, id);
    if (data != null) {
      _loadedData = data;
      _status = ApiFetcherStatus.loadedFromCache;
    }
    return data;
  }

  Future<T> _fetchFromRemote() async {
    var data = _loadedData;
    if (data != null) {
      return data; // data already loaded
    }

    data = await GetIt.I<ApiRemoteService>().fetch(type, id);

    _loadedData = data;
    _status = ApiFetcherStatus.loadedFromRemote;

    // Store the retrieved data in persistent cache
    await GetIt.I<ApiCacheService>().store(data);

    return data;
  }
}

class _ApiHiveService implements ApiCacheService {
  final Map<ApiDataType, ReadWriteMutex> _mutexMap = {};

  String _boxName(ApiDataType type) => '${type.name}ApiCacheBox';

  ReadWriteMutex _mutex(ApiDataType type) =>
      _mutexMap[type] ??= ReadWriteMutex();

  @override
  Future<void> store<T extends ApiData>(T data) async {
    final type = data.apiDataType;
    final mutex = _mutex(type);
    await mutex.acquireWrite();
    try {
      final box = await Hive.openLazyBox<T>(_boxName(type));
      await box.put(data.id, data);
    } finally {
      mutex.release();
    }
  }

  @override
  Future<T?> fetch<T extends ApiData>(ApiDataType<T> type, String id) async {
    final mutex = _mutex(type);
    await mutex.acquireRead();
    try {
      final box = await Hive.openLazyBox<T>(_boxName(type));
      return await box.get(id);
    } finally {
      mutex.release();
    }
  }

  @override
  Future<void> clearAll(ApiDataType<ApiData> type) =>
      _mutex(type).protectWrite(() => Hive.deleteBoxFromDisk(_boxName(type)));
}

class _ApiHttpsService implements ApiRemoteService {
  static const _authority = 'staticsanches.github.io';
  static const _pathPrefix = '/ooblets_api/api/v1';

  @override
  Future<T> fetch<T extends ApiData>(ApiDataType<T> type, String id) async {
    final jsonConverter = GetIt.I<ApiJsonConverter>();
    final dynamic json;
    final client = RetryClient(http.Client());
    try {
      final uri = _uri(_path(type, id));
      final response = await client.get(uri);
      if (!response.ok) {
        throw Exception('$uri: status ${response.statusCode}');
      }
      json = jsonConverter.toJson(type, id, response.bodyBytes);
    } finally {
      client.close();
    }
    return jsonConverter.fromJson(type, id, json);
  }

  Uri _uri(String path) => Uri.https(_authority, _pathPrefix + path);

  String _path(ApiDataType type, String id) {
    switch (type) {
      case ApiDataType.allItems:
        return '/items/all.json';
      case ApiDataType.item:
        return '/items/$id/data.json';
      case ApiDataType.itemImage:
        return '/items/$id/image.png';
      case ApiDataType.allLocations:
        return '/locations/all.json';
      case ApiDataType.location:
        return '/locations/$id/data.json';
      case ApiDataType.allOoblets:
        return '/ooblets/all.json';
      case ApiDataType.ooblet:
        return '/ooblets/$id/data.json';
      case ApiDataType.oobletCommonImage:
        return '/ooblets/$id/common.png';
      case ApiDataType.oobletGleamyImage:
        return '/ooblets/$id/gleamy.png';
      case ApiDataType.oobletUnusualImage:
        return '/ooblets/$id/unusual.png';
      case ApiDataType.allMoves:
        return '/moves/all.json';
      case ApiDataType.move:
        return '/moves/$id/data.json';
      case ApiDataType.moveImage:
        return '/moves/$id/image.png';
    }
  }
}

class _ApiJsonConverter implements ApiJsonConverter {
  @override
  toJson<T extends ApiData>(ApiDataType<T> type, String id, Uint8List bytes) {
    if (_isImageType(type)) {
      return UnmodifiableUint8ListView(bytes);
    }
    return jsonDecode(utf8.decode(bytes));
  }

  @override
  T fromJson<T extends ApiData>(ApiDataType<T> type, String id, dynamic json) {
    if (_isImageType(type)) {
      final UnmodifiableUint8ListView content;
      if (json is UnmodifiableUint8ListView) {
        content = json;
      } else {
        content = UnmodifiableUint8ListView(
          Uint8List.fromList(json.cast<int>()),
        );
      }
      return ApiImage(type as ApiDataType<ApiImage>, id, content) as T;
    }
    if (type == ApiDataType.allItems) {
      return AllItems.fromJson(json) as T;
    }
    if (type == ApiDataType.item) {
      return Item.fromJson(json) as T;
    }
    if (type == ApiDataType.allLocations) {
      return AllLocations.fromJson(json) as T;
    }
    if (type == ApiDataType.location) {
      return Location.fromJson(json) as T;
    }
    if (type == ApiDataType.allOoblets) {
      return AllOoblets.fromJson(json) as T;
    }
    if (type == ApiDataType.ooblet) {
      return Ooblet.fromJson(json) as T;
    }
    if (type == ApiDataType.allMoves) {
      return AllMoves.fromJson(json) as T;
    }
    if (type == ApiDataType.move) {
      return Move.fromJson(json) as T;
    }
    throw UnimplementedError('$type is not supported');
  }

  static _isImageType(ApiDataType type) =>
      type == ApiDataType.itemImage ||
      type == ApiDataType.oobletCommonImage ||
      type == ApiDataType.oobletGleamyImage ||
      type == ApiDataType.oobletUnusualImage ||
      type == ApiDataType.moveImage;
}
