import 'package:meta/meta.dart';

import '../utils/api.dart';
import 'api_image.dart';
import 'i18n_string.dart';
import 'item_list.dart';
import 'location.dart';

enum ItemType {
  cookedFood('cooked_food'),
  forageable('forageable'),
  ingredient('ingredient'),
  rawCrop('raw_crop'),
  ;

  final String _id;
  const ItemType(this._id);

  factory ItemType._fromJson(String id) =>
      values.firstWhere((type) => type._id == id);

  String toJson() => _id;
}

abstract class Item implements ApiData {
  @override
  final String id;

  final I18nString name;
  final I18nString description;

  Item._fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = I18nString.fromJson(json['name']),
        description = I18nString.fromJson(json['description']);

  factory Item.fromJson(Map<String, dynamic> json) {
    final type = ItemType._fromJson(json['type']);
    switch (type) {
      case ItemType.cookedFood:
        return CookedFood._fromJson(json);
      case ItemType.forageable:
        return Forageable._fromJson(json);
      case ItemType.ingredient:
        return Ingredient._fromJson(json);
      case ItemType.rawCrop:
        return RawCrop._fromJson(json);
    }
  }

  ItemType get type;

  @override
  @nonVirtual
  ApiDataType<Item> get apiDataType => ApiDataType.item;

  @nonVirtual
  Future<ApiImage> fetchImage() => ApiDataType.itemImage.fetch(id);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'name': name,
        'description': description,
      };

  @override
  @nonVirtual
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item && id == other.id && type == other.type);

  @override
  @nonVirtual
  int get hashCode => Object.hash(id, type);

  @override
  String toString() => name.toString();
}

@sealed
class CookedFood extends Item {
  final ItemList recipe;

  CookedFood._fromJson(Map<String, dynamic> json)
      : recipe = ItemList.fromJson(json['recipe']),
        super._fromJson(json);

  @override
  ItemType get type => ItemType.cookedFood;

  @override
  Map<String, dynamic> toJson() => super.toJson()..['recipe'] = recipe;
}

@sealed
class Forageable extends Item with WithLocation {
  @override
  final String locationID;

  Forageable._fromJson(Map<String, dynamic> json)
      : locationID = json['location'],
        super._fromJson(json);

  @override
  ItemType get type => ItemType.forageable;

  @override
  Map<String, dynamic> toJson() => super.toJson()..['location'] = locationID;
}

@sealed
class Ingredient extends Item {
  final ItemList recipe;

  Ingredient._fromJson(Map<String, dynamic> json)
      : recipe = ItemList.fromJson(json['recipe']),
        super._fromJson(json);

  @override
  ItemType get type => ItemType.ingredient;

  @override
  Map<String, dynamic> toJson() => super.toJson()..['recipe'] = recipe;
}

@sealed
class RawCrop extends Item with WithLocation {
  @override
  final String locationID;

  RawCrop._fromJson(Map<String, dynamic> json)
      : locationID = json['location'],
        super._fromJson(json);

  @override
  ItemType get type => ItemType.rawCrop;

  @override
  Map<String, dynamic> toJson() => super.toJson()..['location'] = locationID;
}
