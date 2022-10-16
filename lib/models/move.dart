import 'package:meta/meta.dart';

import '../utils/api.dart';
import 'api_image.dart';
import 'i18n_string.dart';

@sealed
class Move implements ApiData {
  @override
  final String id;

  final I18nString name;
  final I18nString description;

  final int cost;

  Move.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = I18nString.fromJson(json['name']),
        description = I18nString.fromJson(json['description']),
        cost = json['cost'];

  @override
  ApiDataType<Move> get apiDataType => ApiDataType.move;

  @nonVirtual
  Future<ApiImage> fetchImage() => ApiDataType.moveImage.fetch(id);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'cost': cost,
      };

  @override
  @nonVirtual
  bool operator ==(Object other) =>
      identical(this, other) || (other is Move && id == other.id);

  @override
  @nonVirtual
  int get hashCode => id.hashCode;

  @override
  String toString() => name.toString();
}
