import 'dart:async';
import 'dart:convert';
import 'package:camino_nomad/constants/env_config.dart' as config;
import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/logic/file_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../logic/route_logic.dart';
import '../route_info/route_data.dart';
import '../shared_pref_names.dart';

class RouteProvider with ChangeNotifier {
  RouteData? routeData;
  int startIndex;
  int? endIndex;

  List<double>? allDistances;
  List<double>? allEleGain;
  List<double>? allEleLoss;
  List<double>? allMinEle;
  List<double>? allMaxEle;
  bool? offlineMode;
  bool? lowDataMode;
  double? kbSaved;

  RouteProvider({
    this.routeData,
    this.startIndex = 0,
  });
  late SharedPreferences prefs;
  late FileManagement fm;

  Future<void> initValues() async {
    prefs = await SharedPreferences.getInstance();
    fm = FileManagement();
    offlineMode = prefs.getBool(SharedPrefNames.offlineMode.name);
    lowDataMode = prefs.getBool(SharedPrefNames.lowDataMode.name);
  }

  void setAllDistances() {
    if (routeData == null) return;
    final RouteLogic rl = RouteLogic();

    var cities = routeData!.cities;
    var routePoints = routeData!.routePoints;

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
      for (var routei = startIndex + 1; routei < routeData!.routePoints.length - 1; routei++) {
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
          if (routePoints.length > routei + 3) tempMin = routePoints[routei + 2].ele;
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
    String response = '';
    if (offlineMode ?? false) {
      //Change to route ID instead og 0
      response = await fm.readFile(config.allRutes[0].localFileName);
      kbSaved = response.toKb();
    } else {
      response = await rootBundle.loadString('assets/route_data/camino_francis_data.json');
      // response = await rootBundle.loadString('assets/route_data/francis_initial_data.json');
    }

    Map<String, dynamic> jsonData = json.decode(response);
    RouteData data = RouteData.fromJson(jsonData);
    routeData = data;
    return;
  }

  void setStartIndex(int value) {
    startIndex = value;
    notifyListeners();
  }

  void setEndIndex(int? value) {
    endIndex = value;
    notifyListeners();
  }

  void setOfflineMode(bool value) {
    offlineMode = value;
    prefs.setBool(SharedPrefNames.offlineMode.name, value);
    notifyListeners();
  }

  void setLowDataMode(bool value) {
    lowDataMode = value;
    prefs.setBool(SharedPrefNames.lowDataMode.name, value);
    notifyListeners();
  }

  void saveDataToFile(int routeId) async {
    int index = config.allRutes.indexWhere((element) => element.id == routeId);
    if (index != -1) {
      String json = jsonEncode(routeData);
      await fm.writeFile(config.allRutes[index].localFileName, json);
      kbSaved = json.toKb();
    }
    notifyListeners();
  }
}
