import 'route_city.dart';
import 'route_point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_data.g.dart';

@JsonSerializable()
class RouteData {
  int id;
  String name;
  List<RouteCity> cities;
  List<RoutePoint> routePoints;

  RouteData({
    required this.id,
    required this.name,
    required this.cities,
    required this.routePoints,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) => _$RouteDataFromJson(json);
  Map<String, dynamic> toJson() => _$RouteDataToJson(this);

  @override
  String toString() {
    return 'id: $id, name: $name, cities length: ${cities.length}, routePoints length: ${routePoints.length}.';
  }
}
