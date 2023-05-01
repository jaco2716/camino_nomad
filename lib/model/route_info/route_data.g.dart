// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteData _$RouteDataFromJson(Map<String, dynamic> json) => RouteData(
      id: json['id'] as int,
      name: json['name'] as String,
      cities: (json['cities'] as List<dynamic>)
          .map((e) => RouteCity.fromJson(e as Map<String, dynamic>))
          .toList(),
      routePoints: (json['routePoints'] as List<dynamic>)
          .map((e) => RoutePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RouteDataToJson(RouteData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cities': instance.cities,
      'routePoints': instance.routePoints,
    };
