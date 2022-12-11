part of 'api.dart';

void registerApiGetItTypes() {
  GetIt.I.registerSingleton<ApiManager>(_ApiManager());
  GetIt.I.registerSingleton<ApiCacheService>(_ApiHiveService());
  GetIt.I.registerSingleton<ApiRemoteService>(_ApiHttpsService());
}

final _logger = Logger();

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

  WeakReference<T>? _loadedData;
  var _status = ApiFetcherStatus.notLoaded;

  @override
  ApiFetcherStatus get status {
    if (_loadedData?.target == null) {
      _status = ApiFetcherStatus.notLoaded;
    }
    return _status;
  }

  @override
  Future<T> fetch() async {
    try {
      return await _fetch();
    } catch (e, stack) {
      _logger.e('Error while fetching ${type.name} with id $id', e, stack);
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
    var data = _loadedData?.target;
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
    var data = _loadedData?.target;
    if (data != null) {
      return data; // data already loaded
    }

    data = await GetIt.I<ApiCacheService>().fetch(type, id);
    if (data != null) {
      _loadedData = WeakReference(data);
      _status = ApiFetcherStatus.loadedFromCache;
    }
    return data;
  }

  Future<T> _fetchFromRemote() async {
    var data = _loadedData?.target;
    if (data != null) {
      return data; // data already loaded
    }

    data = await GetIt.I<ApiRemoteService>().fetch(type, id);

    _loadedData = WeakReference(data);
    _status = ApiFetcherStatus.loadedFromRemote;

    // Store the retrieved data in persistent cache
    await GetIt.I<ApiCacheService>().store(data);

    return data;
  }
}

class _ApiHiveService implements ApiCacheService {
  final _boxMutex = ReadWriteMutex();
  final _mutexMap = <ApiDataType, ReadWriteMutex>{};

  final _boxByType = <ApiDataType, LazyBox>{};

  String _boxName(ApiDataType type) => '${type.name}ApiCacheBox';

  ReadWriteMutex _mutex(ApiDataType type) =>
      _mutexMap[type] ??= ReadWriteMutex();

  Future<LazyBox<T>> _lazyBox<T extends ApiData>(ApiDataType<T> type) async {
    var box = _boxByType[type] as LazyBox<T>?;
    if (box != null) {
      return box;
    }
    await _boxMutex.acquireWrite();
    try {
      box = _boxByType[type] as LazyBox<T>?;
      if (box != null) {
        return box;
      }
      box = await Hive.openLazyBox<T>(_boxName(type));
      _boxByType[type] = box;
      return box;
    } finally {
      _boxMutex.release();
    }
  }

  @override
  Future<void> store<T extends ApiData>(T data) async {
    final type = data.apiDataType;
    final mutex = _mutex(type);
    await mutex.acquireWrite();
    try {
      final box = await _lazyBox(type);
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
      final box = await _lazyBox(type);
      return await box.get(id);
    } finally {
      mutex.release();
    }
  }

  @override
  Future<void> clearAll<T extends ApiData>(ApiDataType<T> type) async {
    final mutex = _mutex(type);
    await mutex.acquireWrite();
    try {
      final box = await _lazyBox(type);
      _boxByType.remove(type);
      await box.clear();
      await box.close();
    } finally {
      mutex.release();
    }
  }
}

class _ApiHttpsService implements ApiRemoteService {
  @override
  Future<T> fetch<T extends ApiData>(ApiDataType<T> type, String id) async {
    final client = RetryClient(http.Client());
    final uri = apiUri(_path(type, id));
    try {
      final response = await client.get(uri);
      if (!response.ok) {
        throw Exception('$uri: status ${response.statusCode}');
      }
      return ApiData.fromResponseBodyBytes(type, id, response.bodyBytes);
    } finally {
      client.close();
    }
  }

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
      case ApiDataType.locationImage:
        return '/locations/$id/image.png';

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
