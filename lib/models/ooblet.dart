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
  bool operator ==(Object other) =>
      identical(this, other) || (other is Ooblet && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name.toString();
}

enum OobletVariant { common, unusual, gleamy }

enum OobletCaughtStatus { any, caught, missing }

@sealed
@immutable
class OobletWithVariant {
  final Ooblet ooblet;
  final OobletVariant variant;

  const OobletWithVariant(this.ooblet, this.variant);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OobletWithVariant &&
          ooblet == other.ooblet &&
          variant == other.variant);

  @override
  int get hashCode => Object.hash(ooblet, variant);

  @override
  String toString() => '$ooblet (${variant.name})';
}

extension OobletVariantImageType on OobletVariant {
  ApiDataType<ApiImage> get imageType {
    switch (this) {
      case OobletVariant.common:
        return ApiDataType.oobletCommonImage;
      case OobletVariant.unusual:
        return ApiDataType.oobletUnusualImage;
      case OobletVariant.gleamy:
        return ApiDataType.oobletGleamyImage;
    }
  }
}
