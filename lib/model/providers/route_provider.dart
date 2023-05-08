import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../logic/route_logic.dart';
import '../route_info/route_data.dart';

class RouteProvider with ChangeNotifier {
  RouteData? routeData;
  int startIndex;
  int? endIndex;

  List<double>? allDistances;
  List<double>? allEleGain;
  List<double>? allEleLoss;
  List<double>? allMinEle;
  List<double>? allMaxEle;
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

    RouteLogic rl = RouteLogic();
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

  // void setAllEleGain() {
  //   if (routeData == null) return;
  //   // int startCityIndex = routeData!.cities.indexWhere((element) => element.id == startCityId);
  //   // int endCityIndex = routeData!.cities.indexWhere((element) => element.id == endCityId);
  //   // if (startCityIndex > endCityIndex) return;
  //   List<double> tempCityEleGain = [];
  //   List<double> tempCityEleLoss = [];
  //   List<double> tempCityEleMin = [];
  //   List<double> tempCityEleMax = [];
  //   double tempEleGain = 0;
  //   double tempEleLoss = 0;
  //   var cities = routeData!.cities;
  //   var routePoints = routeData!.routePoints;
  //   double tempMin = routePoints.first.ele;
  //   double tempMax = routePoints.first.ele;
  //   int startIndex = 0;
  //   for (var cityi = 0; cityi <= cities.length - 1; cityi++) {
  //     for (var routei = startIndex + 1; routei < routeData!.routePoints.length - 1; routei++) {
  //       if (routePoints[routei + 1].ele > routePoints[routei].ele) {
  //         tempEleGain += (routePoints[routei + 1].ele - routePoints[routei].ele);
  //       } else {
  //         tempEleLoss += (routePoints[routei].ele - routePoints[routei + 1].ele);
  //       }
  //       if (routePoints[routei + 1].ele > tempMax) {
  //         tempMax = routePoints[routei + 1].ele;
  //       } else if (routePoints[routei + 1].ele < tempMin) {
  //         tempMin = routePoints[routei + 1].ele;
  //       }
  //       if (routePoints[routei + 1].id == cities[cityi].routePointId) {
  //         startIndex = routei;
  //         tempCityEleGain.add(tempEleGain);
  //         tempCityEleLoss.add(tempEleLoss);
  //         tempCityEleMin.add(tempMin);
  //         tempCityEleMax.add(tempMax);

  //         tempEleGain = 0;
  //         tempEleLoss = 0;
  //         tempMin = 0;
  //         tempMax = 0;
  //         break;
  //       }
  //     }
  //   }

  //   allEleGain = tempCityEleGain;
  //   allEleLoss = tempCityEleLoss;
  //   allMinEle = tempCityEleMin;
  //   allMaxEle = tempCityEleMax;
  //   return;
  // }

  // List<double> getCityDistances(int startCityIndex, int endCityIndex) {
  //   if (allDistances == null) return [];
  //   var result = allDistances!.getRange(startCityIndex, endCityIndex).toList();
  //   return result;
  // }

  Future<void> getRouteData() async {
    String response = await rootBundle.loadString('assets/route_data/camino_francis_data.json');
    // String response = await rootBundle.loadString('assets/route_data/francis_initial_data.json');

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
