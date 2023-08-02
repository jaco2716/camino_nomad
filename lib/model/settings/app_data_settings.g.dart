// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppDataSettings _$AppDataSettingsFromJson(Map<String, dynamic> json) =>
    AppDataSettings(
      json['lowDataMode'] as bool,
      json['routeId'] as int,
      json['startIndex'] as int?,
      endIndex: json['endIndex'] as int?,
      showAdvancedSettings: json['showAdvancedSettings'] as bool? ?? false,
      appDataVersion: json['appDataVersion'] as String? ?? 'v1',
    );

Map<String, dynamic> _$AppDataSettingsToJson(AppDataSettings instance) =>
    <String, dynamic>{
      'lowDataMode': instance.lowDataMode,
      'routeId': instance.routeId,
      'startIndex': instance.startIndex,
      'endIndex': instance.endIndex,
      'showAdvancedSettings': instance.showAdvancedSettings,
      'appDataVersion': instance.appDataVersion,
    };
