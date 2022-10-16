part of 'api_data.dart';

@sealed
class AllMoves implements ApiData {
  final List<String> ids;

  AllMoves._fromJson(List<dynamic> json) : ids = List.unmodifiable(json);

  @override
  ApiDataType<AllMoves> get apiDataType => ApiDataType.allMoves;

  @override
  String get id => apiDataType.name;

  Stream<Move> fetchMoves() => ApiDataType.move.fetchMany(ids);

  @override
  List<String> toJson() => ids;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllMoves && listEquals(ids, other.ids));

  @override
  int get hashCode => Object.hashAll(ids);

  @override
  String toString() => ids.toString();
}
