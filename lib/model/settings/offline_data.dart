class AppConfigSettings {
  bool lowDataMode;
  List<OfflineData> offlineDataList;

  AppConfigSettings(
    this.lowDataMode,
    this.offlineDataList,
  );
}

class OfflineData {
  int routeId;
  String name;
  bool isSaved;
  double kb;

  OfflineData(this.routeId, this.name, {this.isSaved = false, this.kb = 0});
}
