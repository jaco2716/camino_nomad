import 'package:json_annotation/json_annotation.dart';

part 'route_point.g.dart';

@JsonSerializable()
class RoutePoint {
  int id;
  double lat;
  double lon;
  double ele;
  RoutePoint(this.id, this.lat, this.lon, this.ele);

  factory RoutePoint.fromJson(Map<String, dynamic> json) => _$RoutePointFromJson(json);
  Map<String, dynamic> toJson() => _$RoutePointToJson(this);

  @override
  String toString() {
    return 'ID: $id, Lat: $lat, Lon: $lon, Ele: $ele';
  }
}
