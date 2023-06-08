import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:camino_nomad/constants/env_config.dart' as config;

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
  late List<RouteCity> allCities;
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
      for (var routei = startIndex; routei < routePoints.length - 1; routei++) {
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

        // if (routePoints[routei + 1].id == cities[cityi].routePointId) {
        if (routePoints[routei + 1].cityId == cities[cityi].id || (routei == 0 && routePoints[routei].cityId == cities[cityi].id)) {
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
  }

  Future<void> getRouteData() async {
    await initValues();
    // response = await rootBundle.loadString('assets/route_database/route_data/route_file_${appDataSettings.routeId}.json');
    // String response = await rootBundle.loadString('assets/route_database/route_data/route_data.json');
    // List<Map<String, dynamic>> jsonData = jsonDecode(response);
    // routeData = jsonData.map((e) => RouteData.fromJson(e)).toList();
    String hotelsResponse = await fm.readFile(config.hotelsFileName);
    if (hotelsResponse == '') {
      hotels = await getListFromFile<Hotel>('assets/route_database/hotels/route_hotels.json', (p0) => Hotel.fromJson(p0));
    } else {
      List<dynamic> hotelJson = jsonDecode(hotelsResponse);
      hotels = hotelJson.map<Hotel>((e) => Hotel.fromJson(e)).toList();
    }
    routeData = await getListFromFile<RouteData>('assets/route_database/route_data/route_data.json', (p0) => RouteData.fromJson(p0));
    routeIndex = routeData.indexWhere((element) => element.id == appDataSettings.routeId);
    allCities = await getListFromFile<RouteCity>('assets/route_database/cities/route_cities.json', (p0) => RouteCity.fromJson(p0));
    sortCities(allCities);

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

  void sortCities(List<RouteCity> allCitiesToSort) {
    var rps = routeData[routeIndex].routePoints;
    List<RouteCity> newCities = [];
    for (var i = 0; i < allCitiesToSort.length - 1; i++) {
      if (rps.indexWhere((element) => element.cityId == allCitiesToSort[i].id) != -1) {
        newCities.add(allCitiesToSort[i]);
      }
      // if (rps.indexWhere((element) => element.id == allCitiesToSort[i].routePointId) != -1) newCities.add(allCitiesToSort[i]);
    }
    newCities.sort((a, b) => rps.indexWhere((element) => element.cityId == a.id).compareTo(rps.indexWhere((element) => element.cityId == b.id)));
    // (a, b) => rps.indexWhere((element) => element.id == a.routePointId).compareTo(rps.indexWhere((element) => element.id == b.routePointId)));
    cities = newCities;
    setAllDistances();
    // return newCities;
  }

  void setStartIndex(int? value) async {
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
    routeIndex = routeData.indexWhere((element) => element.id == id);
    appDataSettings.startIndex = null;
    appDataSettings.endIndex = null;
    sortCities(allCities);
    await prefs.setString(SharedPrefNames.appDataSettings.name, jsonEncode(appDataSettings));
    notifyListeners();
  }

  void saveHotelsLocal(Hotel hotel) async {
    int hotelIndex = hotels.indexWhere((element) => element.id == hotel.id);
    // await fm.writeFile(config.hotelsFileName, '');
    // return;
    if (hotelIndex == -1) {
      hotel.id = hotels.length;
      hotels.add(hotel);
    } else {
      hotels[hotelIndex] = hotel;
    }

    String json = jsonEncode(hotels);
    await fm.writeFile(config.hotelsFileName, json);
    notifyListeners();
  }

  void deleteHotel(Hotel hotel) async {
    int hotelIndex = hotels.indexWhere((element) => element.id == hotel.id);
    if (hotelIndex != -1) {
      hotels.removeAt(hotelIndex);
    }

    String json = jsonEncode(hotels);
    await fm.writeFile(config.hotelsFileName, json);
    notifyListeners();
  }

  void setAdvancedSettings(bool value) async {
    appDataSettings.showAdvancedSettings = value;
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
