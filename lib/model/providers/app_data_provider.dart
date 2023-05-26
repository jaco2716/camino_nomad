import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:camino_nomad/constants/env_config.dart' as config;
import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/logic/file_management.dart';
import 'package:camino_nomad/model/route_info/hotel.dart';
import 'package:camino_nomad/model/route_info/route_city.dart';
import 'package:camino_nomad/model/settings/app_data_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../logic/route_logic.dart';
import '../route_info/route_data.dart';
import '../settings/shared_pref_names.dart';

class AppDataProvider with ChangeNotifier {
  late List<RouteData> routeData;
  late List<RouteCity> cities;
  late List<Hotel> hotels;
  late AppDataSettings appDataSettings;
  late int routeIndex;

  late List<double> allDistances;
  late List<double> allEleGain;
  late List<double> allEleLoss;
  late List<double> allMinEle;
  late List<double> allMaxEle;
  // double? kbSaved;

  late SharedPreferences prefs;
  late FileManagement fm;

  AppDataProvider();

  Future<void> initValues() async {
    prefs = await SharedPreferences.getInstance();
    fm = FileManagement();
    String appDataString = prefs.getString(SharedPrefNames.appDataSettings.name) ?? '';
    if (appDataString.isEmpty) {
      appDataSettings = AppDataSettings(false, 0, 0);
    } else {
      Map<String, dynamic> appDataJson = jsonDecode(appDataString);
      appDataSettings = AppDataSettings.fromJson(appDataJson);
    }
  }

  void setAllDistances() {
    final RouteLogic rl = RouteLogic();
    var routePoints = routeData[routeIndex].routePoints;

    //Distance
    List<double> tempCityDistances = [];
    double tempDistance = 0;

    //Elevation
    List<double> tempCityEleGain = [];
    List<double> tempCityEleLoss = [];
    List<double> tempCityEleMin = [];
    List<double> tempCityEleMax = [];
    double tempEleGain = 0;
    double tempEleLoss = 0;
    double tempMin = routePoints.first.ele;
    double tempMax = routePoints.first.ele;

    int startIndex = 0;
    for (var cityi = 0; cityi <= cities.length - 1; cityi++) {
      for (var routei = startIndex + 1; routei < routePoints.length - 1; routei++) {
        //Distance
        tempDistance +=
            rl.calculateDistance(routePoints[routei].lat, routePoints[routei].lon, routePoints[routei + 1].lat, routePoints[routei + 1].lon);

        //Elevation
        if (routePoints[routei + 1].ele > routePoints[routei].ele) {
          tempEleGain += (routePoints[routei + 1].ele - routePoints[routei].ele);
        } else {
          tempEleLoss += (routePoints[routei].ele - routePoints[routei + 1].ele);
        }
        if (routePoints[routei + 1].ele > tempMax) {
          tempMax = routePoints[routei + 1].ele;
        } else if (routePoints[routei + 1].ele < tempMin) {
          tempMin = routePoints[routei + 1].ele;
        }

        if (routePoints[routei + 1].id == cities[cityi].routePointId) {
          startIndex = routei;
          //Distance
          tempCityDistances.add(tempDistance);
          tempDistance = 0;

          //Elevation
          tempCityEleGain.add(tempEleGain);
          tempCityEleLoss.add(tempEleLoss);
          tempCityEleMin.add(tempMin);
          tempCityEleMax.add(tempMax);

          tempEleGain = 0;
          tempEleLoss = 0;
          //TODO check if min is correct.
          // if (routePoints.length > routei + 3) tempMin = routePoints[routei + 2].ele;
          tempMin = routePoints[routei + 1].ele;
          tempMax = 0;
          break;
        }
      }
    }

    allDistances = tempCityDistances;
    allEleGain = tempCityEleGain;
    allEleLoss = tempCityEleLoss;
    allMinEle = tempCityEleMin;
    allMaxEle = tempCityEleMax;
    return;
  }

  Future<void> getRouteData() async {
    await initValues();
    // response = await rootBundle.loadString('assets/route_database/route_data/route_file_${appDataSettings.routeId}.json');
    // String response = await rootBundle.loadString('assets/route_database/route_data/route_data.json');
    // List<Map<String, dynamic>> jsonData = jsonDecode(response);
    // routeData = jsonData.map((e) => RouteData.fromJson(e)).toList();
    hotels = await getListFromFile<Hotel>('assets/route_database/hotels/route_hotels.json', (p0) => Hotel.fromJson(p0));
    routeData = await getListFromFile<RouteData>('assets/route_database/route_data/route_data.json', (p0) => RouteData.fromJson(p0));
    routeIndex = routeData.indexWhere((element) => element.id == appDataSettings.routeId);
    var allCities = await getListFromFile<RouteCity>('assets/route_database/cities/route_cities.json', (p0) => RouteCity.fromJson(p0));
    cities = sortCities(allCities);

    setAllDistances();
    notifyListeners();
    return;
  }

  Future<List<T>> getListFromFile<T>(String path, T Function(Map<String, dynamic>) fromJson) async {
    try {
      String response = await rootBundle.loadString(path);
      List<dynamic> json = jsonDecode(response);
      return json.map<T>((e) => fromJson(e)).toList();
    } catch (e) {
      log('Cant load file: $path', error: e);
      return [];
    }
  }

  List<RouteCity> sortCities(List<RouteCity> allCities) {
    var rps = routeData[routeIndex].routePoints;
    List<RouteCity> newCities = [];

    for (var i = 0; i < allCities.length - 1; i++) {
      if (rps.indexWhere((element) => element.id == allCities[i].routePointId) != -1) newCities.add(allCities[i]);
    }
    newCities.sort(
        (a, b) => rps.indexWhere((element) => element.id == a.routePointId).compareTo(rps.indexWhere((element) => element.id == b.routePointId)));

    return newCities;
  }

  void setStartIndex(int value) async {
    // startCityIndex = value;
    appDataSettings.startIndex = value;
    await prefs.setString(SharedPrefNames.appDataSettings.name, jsonEncode(appDataSettings));
    notifyListeners();
  }

  void setEndIndex(int? value) async {
    // endCityIndex = value;
    appDataSettings.endIndex = value;
    await prefs.setString(SharedPrefNames.appDataSettings.name, jsonEncode(appDataSettings));
    notifyListeners();
  }

  void setLowDataMode(bool value) async {
    appDataSettings.lowDataMode = value;
    await prefs.setString(SharedPrefNames.appDataSettings.name, jsonEncode(appDataSettings));
    notifyListeners();
  }

  void setRouteId(int id) async {
    appDataSettings.routeId = id;
    await prefs.setString(SharedPrefNames.appDataSettings.name, jsonEncode(appDataSettings));
    notifyListeners();
  }

  // void saveRouteToFile(int id) async {
  //   int index = config.allRoutes.indexWhere((element) => element.id == id);
  //   if (index != -1) {
  //     String json = jsonEncode(routeData);
  //     await fm.writeFile('${config.routeFilePrefix}$id', json);
  //     kbSaved = json.toKb();
  //   }
  //   notifyListeners();
  // }
}
