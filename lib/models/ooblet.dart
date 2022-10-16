part of 'api_data.dart';

@sealed
class Ooblet with WithLocation implements ApiData {
  @override
  final String id;

  final I18nString name;
  final I18nString quote;

  @override
  final String locationID;

  final ItemList items;

  final SignatureMoveList signatureMoves;

  Ooblet._fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = I18nString.fromJson(json['name']),
        quote = I18nString.fromJson(json['quote']),
        locationID = json['location'],
        items = ItemList._fromJson(json['items']),
        signatureMoves = SignatureMoveList._fromJson(json['signatureMoves']);

  @override
  ApiDataType<Ooblet> get apiDataType => ApiDataType.ooblet;

  Future<ApiImage> fetchCommonImage() =>
      ApiDataType.oobletCommonImage.fetch(id);

  Future<ApiImage> fetchGleamyImage() =>
      ApiDataType.oobletGleamyImage.fetch(id);

  Future<ApiImage> fetchUnusualImage() =>
      ApiDataType.oobletUnusualImage.fetch(id);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quote': quote,
        'location': locationID,
        'items': items,
        'signatureMoves': signatureMoves,
      };

  @override
  @nonVirtual
  bool operator ==(Object other) =>
      identical(this, other) || (other is Ooblet && id == other.id);

  @override
  @nonVirtual
  int get hashCode => id.hashCode;

  @override
  String toString() => name.toString();
}
