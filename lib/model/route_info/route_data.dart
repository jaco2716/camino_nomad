import 'route_point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_data.g.dart';

@JsonSerializable()
class RouteData {
  int id;
  String name;
  List<RoutePoint> routePoints;

  RouteData({
    required this.id,
    required this.name,
    required this.routePoints,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) => _$RouteDataFromJson(json);
  Map<String, dynamic> toJson() => _$RouteDataToJson(this);

  @override
  String toString() {
    return 'id: $id, name: $name, routePoints length: ${routePoints.length}.';
  }
}
