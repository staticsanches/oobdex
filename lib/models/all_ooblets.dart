import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../utils/api.dart';
import 'ooblet.dart';

@sealed
class AllOoblets implements ApiData {
  final List<String> ids;

  AllOoblets.fromJson(List<dynamic> json) : ids = List.unmodifiable(json);

  @override
  ApiDataType<AllOoblets> get apiDataType => ApiDataType.allOoblets;

  @override
  String get id => apiDataType.name;

  Stream<Ooblet> fetchOoblest() => ApiDataType.ooblet.fetchMany(ids);

  @override
  List<String> toJson() => ids;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllOoblets && listEquals(ids, other.ids));

  @override
  int get hashCode => Object.hashAll(ids);

  @override
  String toString() => ids.toString();
}
