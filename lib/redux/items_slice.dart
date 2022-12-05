part of 'redux.dart';

@sealed
@immutable
class ItemsSlice {
  final List<Item> items;
  final bool loadingItems;
  final bool hasErrorLoadingItems;

  const ItemsSlice._({
    this.items = const [],
    this.loadingItems = true,
    this.hasErrorLoadingItems = false,
  });

  ItemsSlice _copyWith({
    List<Item>? items,
    bool? loadingItems,
    bool? hasErrorLoadingItems,
  }) =>
      ItemsSlice._(
        items: items ?? this.items,
        loadingItems: loadingItems ?? this.loadingItems,
        hasErrorLoadingItems: hasErrorLoadingItems ?? this.hasErrorLoadingItems,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemsSlice &&
          listEquals(items, other.items) &&
          loadingItems == other.loadingItems &&
          hasErrorLoadingItems == other.hasErrorLoadingItems);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(items),
        loadingItems,
        hasErrorLoadingItems,
      );
}

// Actions - start

Future<void> fetchItemsAction(Store<OobdexState> store) async {
  store.dispatch(const _UpdateItemsSliceAction(
    items: [],
    loadingItems: true,
    hasErrorLoadingItems: false,
  ));
  try {
    final allItems = await ApiManager.instance.fetchAllItems();
    final items = SplayTreeSet<Item>(_compareItems);
    await for (final item in allItems.fetchItems()) {
      items.add(item);
    }
    store.dispatch(_UpdateItemsSliceAction(
      items: List.unmodifiable(items),
      loadingItems: false,
      hasErrorLoadingItems: false,
    ));
  } catch (_) {
    store.dispatch(const _UpdateItemsSliceAction(
      loadingItems: false,
      hasErrorLoadingItems: true,
    ));
  }
}

int _compareItems(Item i1, Item i2) {
  if (i1 == i2) {
    return 0;
  }
  var result = i1.name.toString().compareTo(i2.name.toString());
  if (result == 0) {
    result = i1.id.compareTo(i2.id);
  }
  return result;
}

class _UpdateItemsSliceAction {
  final List<Item>? items;
  final bool? loadingItems;
  final bool? hasErrorLoadingItems;

  const _UpdateItemsSliceAction({
    this.items,
    this.loadingItems,
    this.hasErrorLoadingItems,
  });
}

// Actions - end

// Reducers - start

ItemsSlice _itemsReducer(ItemsSlice state, dynamic action) {
  if (action is _UpdateItemsSliceAction) {
    return state._copyWith(
      items: action.items,
      loadingItems: action.loadingItems,
      hasErrorLoadingItems: action.hasErrorLoadingItems,
    );
  }
  return state;
}

// Reducers - end
