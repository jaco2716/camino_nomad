import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../logic/route_logic.dart';
import '../route_info/route_data.dart';

class RouteProvider with ChangeNotifier {
  RouteData? routeData;
  int startIndex;
  int? endIndex;

  List<double>? allDistances;
  // double? totalDistance;
  RouteProvider({
    this.routeData,
    this.startIndex = 0,
  });

  // double getRouteDistance(int startPointId, int endPointId) {
  //   if (routeData == null) return 0;
  //   int startIndex = routeData!.routePoints.indexWhere((element) => element.id == startPointId);
  //   int endIndex = routeData!.routePoints.indexWhere((element) => element.id == endPointId);
  //   if (startIndex == -1 || endIndex == -1) return 0;
  //   RouteLogic rl = RouteLogic();
  //   double tempTotal = 0;
  //   var data = routeData!.routePoints;
  //   for (var i = startIndex; i < endIndex; i++) {
  //     tempTotal += rl.calculateDistance(data[i].lat, data[i].lon, data[i + 1].lat, data[i + 1].lon);
  //   }
  //   return tempTotal;
  // }

  void setAllDistances() {
    if (routeData == null) return;
    // int startCityIndex = routeData!.cities.indexWhere((element) => element.id == startCityId);
    // int endCityIndex = routeData!.cities.indexWhere((element) => element.id == endCityId);
    // if (startCityIndex > endCityIndex) return;
    RouteLogic rl = RouteLogic();
    List<double> tempCityDistances = [];
    double tempDistance = 0;
    // double temoTotalDistance = 0;
    var cities = routeData!.cities;
    var routePoints = routeData!.routePoints;
    int startIndex = 0;
    for (var cityi = 0; cityi <= cities.length - 1; cityi++) {
      for (var routei = startIndex + 1; routei < routeData!.routePoints.length - 1; routei++) {
        tempDistance +=
            rl.calculateDistance(routePoints[routei].lat, routePoints[routei].lon, routePoints[routei + 1].lat, routePoints[routei + 1].lon);
        if (routePoints[routei + 1].id == cities[cityi].routePointId) {
          // temoTotalDistance += tempDistance;
          startIndex = routei;
          tempCityDistances.add(tempDistance);
          // print('city: ${cities[cityi].name}, distance: $tempDistance');
          tempDistance = 0;
          break;
        }
      }
    }

    allDistances = tempCityDistances;
    return;
  }

  // List<double> getCityDistances(int startCityIndex, int endCityIndex) {
  //   if (allDistances == null) return [];
  //   var result = allDistances!.getRange(startCityIndex, endCityIndex).toList();
  //   return result;
  // }

  Future<void> getRouteData() async {
    String response = await rootBundle.loadString('assets/route_data/camino_francis_data.json');
    // print(response);
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
}
