// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppDataSettings _$AppDataSettingsFromJson(Map<String, dynamic> json) =>
    AppDataSettings(
      json['lowDataMode'] as bool,
      (json['offlineDataList'] as List<dynamic>)
          .map((e) => OfflineRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppDataSettingsToJson(AppDataSettings instance) =>
    <String, dynamic>{
      'lowDataMode': instance.lowDataMode,
      'offlineDataList': instance.offlineDataList,
    };

OfflineRoute _$OfflineRouteFromJson(Map<String, dynamic> json) => OfflineRoute(
      json['routeId'] as int,
      json['name'] as String,
      isSaved: json['isSaved'] as bool? ?? false,
      kb: (json['kb'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$OfflineRouteToJson(OfflineRoute instance) =>
    <String, dynamic>{
      'routeId': instance.routeId,
      'name': instance.name,
      'isSaved': instance.isSaved,
      'kb': instance.kb,
    };
