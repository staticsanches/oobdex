part of 'api_data.dart';

@sealed
class AllItems implements ApiData {
  final List<String> ids;

  AllItems._fromJson(List<dynamic> json) : ids = List.unmodifiable(json);

  @override
  ApiDataType<AllItems> get apiDataType => ApiDataType.allItems;

  @override
  String get id => apiDataType.name;

  Stream<Item> fetchItems() => ApiDataType.item.fetchMany(ids);

  @override
  List<String> toJson() => ids;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllItems && listEquals(ids, other.ids));

  @override
  int get hashCode => Object.hashAll(ids);

  @override
  String toString() => ids.toString();
}
