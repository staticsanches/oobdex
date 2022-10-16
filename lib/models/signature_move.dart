part of 'api_data.dart';

@sealed
@immutable
class SignatureMoveList {
  final List<SignatureMove> elements;

  SignatureMoveList._fromJson(Map<String, dynamic> json)
      : elements = List.unmodifiable(
          json.entries
              .map((entry) => SignatureMove._(entry.key, entry.value))
              .toList(growable: false)
            ..sort((m1, m2) => m1.level - m2.level),
        );

  Map<String, int> toJson() => {for (final e in elements) e.moveID: e.level};

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

  const SignatureMove._(this.moveID, this.level);

  Future<Move> fetchMove() => ApiDataType.move.fetch(moveID);

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
