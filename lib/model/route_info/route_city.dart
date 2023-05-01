import 'package:flutter/material.dart';

import 'albergue.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_city.g.dart';

@JsonSerializable()
class RouteCity {
  int id;
  String name;
  List<Facility> facilities;
  List<Albergue> albergues;
  double lat;
  double lon;
  int routePointId;

  RouteCity({
    required this.id,
    required this.name,
    required this.facilities,
    required this.albergues,
    required this.lat,
    required this.lon,
    required this.routePointId,
  });
  //country
  //region
  //province
  //city slug
  //km
  //etape_city
  //route_point_id
  //share_url
  factory RouteCity.fromJson(Map<String, dynamic> json) => _$RouteCityFromJson(json);
  Map<String, dynamic> toJson() => _$RouteCityToJson(this);

  @override
  String toString() {
    return 'id: $id, name: $name, lat: $lat, lon: $lon, routePointID: $routePointId';
  }
}

enum Facility {
  atm,
  barCafe,
  restaurant,
  shop,
  medClinic,
  pharmacy,
  fountain,
  postOffice,
  busStation,
  trainStation,
  airport,
  tobaccoStore,
}

Map<Facility, IconData> facilityIconMap = {
  Facility.atm: Icons.attach_money,
  Facility.barCafe: Icons.local_cafe,
  Facility.restaurant: Icons.dining,
  Facility.shop: Icons.shopping_cart,
  Facility.medClinic: Icons.local_hospital,
  Facility.pharmacy: Icons.local_pharmacy,
  Facility.fountain: Icons.water_drop,
  Facility.postOffice: Icons.local_post_office,
  Facility.busStation: Icons.directions_bus,
  Facility.trainStation: Icons.train,
  Facility.airport: Icons.local_airport,
  Facility.tobaccoStore: Icons.eco,
};
