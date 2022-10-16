import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../utils/api.dart';
import 'location.dart';

@sealed
class AllLocations implements ApiData {
  final List<String> ids;

  AllLocations.fromJson(List<dynamic> json) : ids = List.unmodifiable(json);

  @override
  ApiDataType<AllLocations> get apiDataType => ApiDataType.allLocations;

  @override
  String get id => apiDataType.name;

  Stream<Location> fetchLocations() => ApiDataType.location.fetchMany(ids);

  @override
  List<String> toJson() => ids;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllLocations && listEquals(ids, other.ids));

  @override
  int get hashCode => Object.hashAll(ids);

  @override
  String toString() => ids.toString();
}
