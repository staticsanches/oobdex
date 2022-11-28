part of 'api_data.dart';

@sealed
@immutable
class ItemList {
  final List<ItemListElement> elements;

  ItemList._fromJson(List<dynamic> jsonList)
      : elements = List.unmodifiable(
          jsonList.map((json) => ItemListElement._fromJson(json)),
        );

  List<ItemListElement> toJson() => elements;

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

  ItemListElement._fromJson(Map<String, dynamic> json)
      : itemID = json['item'],
        quantity = json['quantity'];

  Future<Item> fetchItem() => ApiDataType.item.fetch(itemID);

  Map<String, dynamic> toJson() => {
        'item': itemID,
        'quantity': quantity,
      };

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
