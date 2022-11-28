part of 'api_data.dart';

@sealed
@immutable
class SignatureMoveList {
  final List<SignatureMove> elements;

  SignatureMoveList._fromJson(List<dynamic> jsonList)
      : elements = List.unmodifiable(
          jsonList
              .map((json) => SignatureMove._fromJson(json))
              .toList(growable: false)
            ..sort((m1, m2) => m1.level - m2.level),
        );

  List<SignatureMove> toJson() => elements;

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      (other is SignatureMoveList && listEquals(elements, other.elements));

  @override
  int get hashCode => Object.hashAll(elements);

  @override
  String toString() => elements.join('\n');
}

@sealed
@immutable
class SignatureMove {
  final String moveID;
  final int level;

  SignatureMove._fromJson(Map<String, dynamic> json)
      : moveID = json['move'],
        level = json['level'];

  Future<Move> fetchMove() => ApiDataType.move.fetch(moveID);

  Map<String, dynamic> toJson() => {
        'move': moveID,
        'level': level,
      };

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      (other is SignatureMove &&
          moveID == other.moveID &&
          level == other.level);

  @override
  int get hashCode => Object.hash(moveID, level);

  @override
  String toString() => '- $level: $moveID';
}
