import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:oobdex/models/api_data.dart';
import 'package:oobdex/utils/api.dart';

void main() {
  final tempDir = Directory.systemTemp.createTempSync();
  Hive.registerAdapter(ApiDataTypeAdapter());
  Hive.init(tempDir.path);
  registerApiGetItTypes();

  setUp(() async {
    await ApiManager.instance.clearAll();
  });

  test('Check api call for CookedFood', () async {
    final fetcher =
        ApiManager.instance.fetcher(ApiDataType.item, 'soggy_bread');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final item = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(item.runtimeType, CookedFood);
    expect(item.type, ItemType.cookedFood);
    expect(identical(item, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(item, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(item, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      await item.fetchImage(),
      predicate((ApiImage image) => image.id == item.id),
    );
  });

  test('Check api call for Forageable', () async {
    final fetcher = ApiManager.instance.fetcher(ApiDataType.item, 'rainplop');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final item = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(item.runtimeType, Forageable);
    expect(item.type, ItemType.forageable);
    expect(identical(item, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(item, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(item, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      await item.fetchImage(),
      predicate((ApiImage image) => image.id == item.id),
    );
  });

  test('Check api call for Ingredient', () async {
    final fetcher = ApiManager.instance.fetcher(ApiDataType.item, 'muz_flour');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final item = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(item.runtimeType, Ingredient);
    expect(item.type, ItemType.ingredient);
    expect(identical(item, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(item, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(item, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      await item.fetchImage(),
      predicate((ApiImage image) => image.id == item.id),
    );
  });

  test('Check api call for RawCrop', () async {
    final fetcher =
        ApiManager.instance.fetcher(ApiDataType.item, 'sweetiebeetie');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final item = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(item.runtimeType, RawCrop);
    expect(item.type, ItemType.rawCrop);
    expect(identical(item, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(item, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(item, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      await item.fetchImage(),
      predicate((ApiImage image) => image.id == item.id),
    );
  });

  test('Check api call for AllItems', () async {
    final fetcher = ApiManager.instance.allItemsFetcher();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final allItems = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(allItems.runtimeType, AllItems);
    expect(identical(allItems, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(allItems, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(allItems, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      allItems.fetchItems(),
      emitsInOrder(
        allItems.ids.map((id) => predicate((Item item) => item.id == id)),
      ),
    );
  });

  test('Check api call for itemImage', () async {
    final fetcher =
        ApiManager.instance.fetcher(ApiDataType.itemImage, 'muz_flour');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final image = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(image.runtimeType, ApiImage);
    expect(image.apiDataType, ApiDataType.itemImage);
    expect(identical(image, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(image, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(image, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);
  });

  test('Check api call for Location', () async {
    final fetcher =
        ApiManager.instance.fetcher(ApiDataType.location, 'badgetown');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final location = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(location.runtimeType, Location);
    expect(identical(location, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(location, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(location, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      await location.fetchImage(),
      predicate((ApiImage image) => image.id == location.id),
    );

    expect(
      location.fetchOoblets(),
      emitsInOrder(
        location.oobletsIDs
            .map((id) => predicate((Ooblet ooblet) => ooblet.id == id)),
      ),
    );

    expect(
      location.fetchItems(),
      emitsInOrder(
        location.itemsIDs.map((id) => predicate((Item item) => item.id == id)),
      ),
    );
  });

  test('Check api call for AllLocations', () async {
    final fetcher = ApiManager.instance.allLocationsFetcher();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final allLocations = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(allLocations.runtimeType, AllLocations);
    expect(identical(allLocations, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(allLocations, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(allLocations, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      allLocations.fetchLocations(),
      emitsInOrder(
        allLocations.ids
            .map((id) => predicate((Location location) => location.id == id)),
      ),
    );
  });

  test('Check api call for locationImage', () async {
    final fetcher =
        ApiManager.instance.fetcher(ApiDataType.locationImage, 'badgetown');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final image = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(image.runtimeType, ApiImage);
    expect(image.apiDataType, ApiDataType.locationImage);
    expect(identical(image, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(image, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(image, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);
  });

  test('Check api call for Ooblet', () async {
    final fetcher = ApiManager.instance.fetcher(ApiDataType.ooblet, 'bibbin');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final ooblet = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(ooblet.runtimeType, Ooblet);
    expect(identical(ooblet, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(ooblet, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(ooblet, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      await ooblet.fetchCommonImage(),
      predicate((ApiImage image) => image.id == ooblet.id),
    );
    expect(
      await ooblet.fetchGleamyImage(),
      predicate((ApiImage image) => image.id == ooblet.id),
    );
    expect(
      await ooblet.fetchUnusualImage(),
      predicate((ApiImage image) => image.id == ooblet.id),
    );
  });

  test('Check api call for oobletCommonImage', () async {
    final fetcher =
        ApiManager.instance.fetcher(ApiDataType.oobletCommonImage, 'bibbin');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final image = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(image.runtimeType, ApiImage);
    expect(image.apiDataType, ApiDataType.oobletCommonImage);
    expect(identical(image, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(image, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(image, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);
  });

  test('Check api call for oobletGleamyImage', () async {
    final fetcher =
        ApiManager.instance.fetcher(ApiDataType.oobletGleamyImage, 'bibbin');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final image = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(image.runtimeType, ApiImage);
    expect(image.apiDataType, ApiDataType.oobletGleamyImage);
    expect(identical(image, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(image, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(image, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);
  });

  test('Check api call for oobletUnusualImage', () async {
    final fetcher =
        ApiManager.instance.fetcher(ApiDataType.oobletUnusualImage, 'bibbin');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final image = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(image.runtimeType, ApiImage);
    expect(image.apiDataType, ApiDataType.oobletUnusualImage);
    expect(identical(image, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(image, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(image, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);
  });

  test('Check api call for AllOoblets', () async {
    final fetcher = ApiManager.instance.allOobletsFetcher();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final allOoblets = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(allOoblets.runtimeType, AllOoblets);
    expect(identical(allOoblets, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(allOoblets, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(allOoblets, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      allOoblets.fetchOoblets(),
      emitsInOrder(
        allOoblets.ids
            .map((id) => predicate((Ooblet ooblet) => ooblet.id == id)),
      ),
    );
  });

  test('Check api call for Move', () async {
    final fetcher =
        ApiManager.instance.fetcher(ApiDataType.move, 'drizzle_drop');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final move = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(move.runtimeType, Move);
    expect(identical(move, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(move, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(move, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      await move.fetchImage(),
      predicate((ApiImage image) => image.id == move.id),
    );
  });

  test('Check api call for AllMoves', () async {
    final fetcher = ApiManager.instance.allMovesFetcher();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final allMoves = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(allMoves.runtimeType, AllMoves);
    expect(identical(allMoves, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(allMoves, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(allMoves, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(
      allMoves.fetchMoves(),
      emitsInOrder(
        allMoves.ids.map((id) => predicate((Move move) => move.id == id)),
      ),
    );
  });

  test('Check api call for moveImage', () async {
    final fetcher =
        ApiManager.instance.fetcher(ApiDataType.moveImage, 'flora_flip');
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    final image = await fetcher.fetch();
    expect(fetcher.status, ApiFetcherStatus.loadedFromRemote);
    expect(image.runtimeType, ApiImage);
    expect(image.apiDataType, ApiDataType.moveImage);
    expect(identical(image, await fetcher.fetch()), true);

    fetcher.reset();
    expect(fetcher.status, ApiFetcherStatus.notLoaded);

    expect(identical(image, await fetcher.fetch()), false);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(image, await fetcher.fetch());
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);

    expect(identical(await fetcher.fetch(), await fetcher.fetch()), true);
    expect(fetcher.status, ApiFetcherStatus.loadedFromCache);
  });

  tempDir.deleteSync();
}
