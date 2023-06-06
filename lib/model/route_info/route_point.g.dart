// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutePoint _$RoutePointFromJson(Map<String, dynamic> json) => RoutePoint(
      json['id'] as int,
      (json['lat'] as num).toDouble(),
      (json['lon'] as num).toDouble(),
      (json['ele'] as num).toDouble(),
      cityId: json['cityId'] as int?,
    );

Map<String, dynamic> _$RoutePointToJson(RoutePoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cityId': instance.cityId,
      'lat': instance.lat,
      'lon': instance.lon,
      'ele': instance.ele,
    };
