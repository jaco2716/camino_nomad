import 'package:json_annotation/json_annotation.dart';

part 'app_data_settings.g.dart';

@JsonSerializable()
class AppDataSettings {
  bool lowDataMode;
  int routeId;
  int? startIndex;
  int? endIndex;
  bool showAdvancedSettings;

  AppDataSettings(
    this.lowDataMode,
    this.routeId,
    this.startIndex, {
    this.endIndex,
    this.showAdvancedSettings = false,
  });

  factory AppDataSettings.fromJson(Map<String, dynamic> json) => _$AppDataSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppDataSettingsToJson(this);
}

// @JsonSerializable()
// class OfflineRoute {
//   int routeId;
//   String name;
//   bool isSaved;
//   double kb;

//   OfflineRoute(this.routeId, this.name, {this.isSaved = false, this.kb = 0});

//   factory OfflineRoute.fromJson(Map<String, dynamic> json) => _$OfflineRouteFromJson(json);
//   Map<String, dynamic> toJson() => _$OfflineRouteToJson(this);
// }
