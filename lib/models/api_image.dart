part of 'api_data.dart';

@sealed
class ApiImage implements ApiData {
  @override
  final ApiDataType<ApiImage> apiDataType;
  @override
  final String id;
  final UnmodifiableUint8ListView content;

  const ApiImage._(this.apiDataType, this.id, this.content);

  @override
  UnmodifiableUint8ListView toJson() => content;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApiImage && apiDataType == other.apiDataType && id == other.id);

  @override
  int get hashCode => Object.hash(apiDataType, id);

  @override
  String toString() => '${apiDataType.name}: $id';
}
