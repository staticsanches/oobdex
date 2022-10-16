import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../utils/api.dart';
import 'item.dart';

@sealed
@immutable
class ItemList {
  final List<ItemListElement> elements;

  ItemList.fromJson(Map<String, dynamic> json)
      : elements = List.unmodifiable(
          json.entries
              .map((entry) => ItemListElement._(entry.key, entry.value)),
        );

  Map<String, int> toJson() => {for (final e in elements) e.itemID: e.quantity};

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemList && listEquals(elements, other.elements));

  @override
  int get hashCode => Object.hashAll(elements);

  @override
  String toString() => elements.join('\n');
}

@sealed
@immutable
class ItemListElement {
  final String itemID;
  final int quantity;

  const ItemListElement._(this.itemID, this.quantity);

  Future<Item> fetchItem() => ApiDataType.item.fetch(itemID);

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemListElement &&
          itemID == other.itemID &&
          quantity == other.quantity);

  @override
  int get hashCode => Object.hash(itemID, quantity);

  @override
  String toString() => '- $itemID x $quantity';
}
