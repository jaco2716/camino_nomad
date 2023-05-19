// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteCity _$RouteCityFromJson(Map<String, dynamic> json) => RouteCity(
      id: json['id'] as int,
      routeIds:
          (json['routeIds'] as List<dynamic>).map((e) => e as int).toList(),
      name: json['name'] as String,
      facilities: (json['facilities'] as List<dynamic>)
          .map((e) => $enumDecode(_$FacilityEnumMap, e))
          .toList(),
      albergues: (json['albergues'] as List<dynamic>)
          .map((e) => Albergue.fromJson(e as Map<String, dynamic>))
          .toList(),
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      routePointId: json['routePointId'] as int,
    );

Map<String, dynamic> _$RouteCityToJson(RouteCity instance) => <String, dynamic>{
      'id': instance.id,
      'routeIds': instance.routeIds,
      'name': instance.name,
      'facilities':
          instance.facilities.map((e) => _$FacilityEnumMap[e]!).toList(),
      'albergues': instance.albergues,
      'lat': instance.lat,
      'lon': instance.lon,
      'routePointId': instance.routePointId,
    };

const _$FacilityEnumMap = {
  Facility.atm: 'atm',
  Facility.barCafe: 'barCafe',
  Facility.restaurant: 'restaurant',
  Facility.shop: 'shop',
  Facility.medClinic: 'medClinic',
  Facility.pharmacy: 'pharmacy',
  Facility.fountain: 'fountain',
  Facility.postOffice: 'postOffice',
  Facility.busStation: 'busStation',
  Facility.trainStation: 'trainStation',
  Facility.airport: 'airport',
  Facility.tobaccoStore: 'tobaccoStore',
};
