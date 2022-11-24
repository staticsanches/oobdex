part of 'api_data.dart';

@sealed
class Location implements ApiData {
  @override
  final String id;

  final I18nString name;
  final I18nString description;

  final List<String> oobletsIDs;

  final List<String> itemsIDs;

  Location._fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = I18nString.fromJson(json['name']),
        description = I18nString.fromJson(json['description']),
        oobletsIDs = List.unmodifiable(json['ooblets']),
        itemsIDs = List.unmodifiable(json['items']);

  @override
  ApiDataType<Location> get apiDataType => ApiDataType.location;

  Future<ApiImage> fetchImage() => ApiDataType.locationImage.fetch(id);

  Stream<Ooblet> fetchOoblets() => ApiDataType.ooblet.fetchMany(oobletsIDs);

  Stream<Item> fetchItems() => ApiDataType.item.fetchMany(itemsIDs);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'ooblets': oobletsIDs,
        'items': itemsIDs,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Location && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name.toString();
}

mixin WithLocation {
  String get locationID;

  @nonVirtual
  Future<Location> fetchLocation() => ApiDataType.location.fetch(locationID);
}
