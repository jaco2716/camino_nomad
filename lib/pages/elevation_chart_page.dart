import 'dart:math';
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/model/route_info/route_data.dart';
import 'package:flutter/material.dart';
import '../../constants/styles_config.dart' as styles;
import 'package:provider/provider.dart';

class ElevationChartPage extends StatefulWidget {
  const ElevationChartPage({super.key});

  @override
  State<ElevationChartPage> createState() => _ElevationChartPageState();
}

class _ElevationChartPageState extends State<ElevationChartPage> {
  bool isPortraitMode = true;
  late AppDataProvider appDataP;
  late RouteData routeData;
  // List<RoutePoint> routePoints = [];
  List<int> cityRPIds = [];
  int startEleIndex = 0;
  int endEleIndex = 0;
  Iterable<double>? eleMaxList = [];
  Iterable<double>? eleMinList = [];
  double eleMax = 0;
  double eleMin = 0;

  List<double> yAxisValues = [];

  @override
  void initState() {
    super.initState();
    appDataP = context.read<AppDataProvider>();
    routeData = appDataP.routeData[appDataP.routeIndex];
    // cityRPIds = appDataP.cities.map((e) => e.routePointId).toList();
    cityRPIds = appDataP.cities.map((e) => e.id).toList();
    // startEleIndex = routeData.routePoints.indexWhere((element) => element.id == cityRPIds[appDataP.appDataSettings.startIndex]);
    // endEleIndex = routeData.routePoints.indexWhere((element) => element.id == cityRPIds[appDataP.appDataSettings.endIndex!]);
    // routePoints = reduceRoutePointsToAverage(routeData.routePoints);

    // startEleIndex = routePoints.indexWhere((element) => element.cityId == cityRPIds[appDataP.appDataSettings.startIndex]);
    // endEleIndex = routePoints.indexWhere((element) => element.cityId == cityRPIds[appDataP.appDataSettings.endIndex!]);
    startEleIndex = routeData.routePoints.indexWhere((element) => element.cityId == cityRPIds[appDataP.appDataSettings.startIndex ?? 0]);
    endEleIndex = routeData.routePoints.indexWhere((element) => element.cityId == cityRPIds[appDataP.appDataSettings.endIndex!]);
    eleMaxList = appDataP.allMaxEle.getRange((appDataP.appDataSettings.startIndex ?? 0) + 1, appDataP.appDataSettings.endIndex! + 1);
    eleMinList = appDataP.allMinEle.getRange((appDataP.appDataSettings.startIndex ?? 0) + 1, appDataP.appDataSettings.endIndex! + 1);
    eleMax = eleMaxList?.reduce(max) ?? 0;
    eleMin = eleMinList?.reduce(min) ?? 0;

    if (eleMax < 1400) eleMax = 1400;
    if (eleMin > 0) eleMin = 0;
    eleMax += 100;
    eleMin -= 100;

    // for (var i = ((eleMax + eleMin) / 100).ceil(); i > (eleMin / 100).floor(); i--) {
    //   yAxisValues.add(i * 100);
    // }
  }

  // List<RoutePoint> reduceRoutePointsToAverage(List<RoutePoint> rps) {
  //   List<RoutePoint> newRoutePoints = [];
  //   for (var i = 0; i < rps.length - 3; i += 3) {
  //     newRoutePoints.add(
  //       RoutePoint(
  //         i,
  //         0,
  //         0,
  //         (rps[i].ele + rps[i + 1].ele + rps[i + 2].ele) / 3,
  //         cityId: rps[i].cityId ?? rps[i + 1].cityId ?? rps[i + 2].cityId,
  //       ),
  //     );
  //   }
  //   print('after: ${newRoutePoints.first.cityId}');
  //   return newRoutePoints;
  // }

  @override
  Widget build(BuildContext context) {
    // var appDataP = context.read<AppDataProvider>();
    // var routeData = appDataP.currentRouteData!;
    // var cityRPIds = routeData.cities.map((e) => e.routePointId).toList();
    // int startEleIndex = routeData.routePoints.indexWhere((element) => element.id == cityRPIds[appDataP.startCityIndex]);
    // int endEleIndex = routeData.routePoints.indexWhere((element) => element.id == cityRPIds[appDataP.endCityIndex!]);
    // var eleMaxList = appDataP.allMaxEle?.getRange(appDataP.startCityIndex + 1, appDataP.endCityIndex! + 1);
    // double eleMax = eleMaxList?.reduce(max) ?? 0;
    // if (eleMax < 1500) eleMax = 1500;

    // appDataP.allDistances?.forEach((element) {
    //   print(element);
    // });
    // var distSum = appDataP.allDistances?.reduce((a, b) => a + b);
    // print(distSum);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elevation'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isPortraitMode = !isPortraitMode;
              });
            },
            icon: const Icon(Icons.screen_rotation_rounded),
          )
        ],
      ),
      body: SafeArea(
        // bottom: false,
        child: LayoutBuilder(builder: (context, constraints) {
          return RotatedBox(
            quarterTurns: isPortraitMode ? 0 : 1,
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  scrollDirection: Axis.horizontal,
                  itemCount: endEleIndex - startEleIndex + 1,
                  itemBuilder: (context, index) {
                    int rpIndex = index + startEleIndex;

                    // double chartHeight = (routePoints[rpIndex].ele + (eleMin * -1)) / eleMax * constraints.maxHeight;
                    // if (!isPortraitMode) {
                    //   chartHeight = (routePoints[rpIndex].ele + (eleMin * -1)) / eleMax * constraints.maxWidth;
                    // }
                    double chartHeight = (routeData.routePoints[rpIndex].ele + (eleMin * -1)) / eleMax * constraints.maxHeight;
                    if (!isPortraitMode) {
                      chartHeight = (routeData.routePoints[rpIndex].ele + (eleMin * -1)) / eleMax * constraints.maxWidth;
                    }

                    // if (cityRPIds.contains(routeData.routePoints[rpIndex].id)) {
                    if (cityRPIds.contains(routeData.routePoints[rpIndex].cityId)) {
                      // if (cityRPIds.contains(routePoints[rpIndex].cityId)) {
                      // var cityIndex = cityRPIds.indexOf(routeData.routePoints[rpIndex].id);
                      var cityIndex = cityRPIds.indexOf(routeData.routePoints[rpIndex].cityId ?? -1);
                      // var cityIndex = cityRPIds.indexOf(routePoints[rpIndex].cityId ?? -1);
                      double totalDistance = 0;

                      for (var i = (appDataP.appDataSettings.startIndex ?? 0) + 1; i <= cityIndex; i++) {
                        totalDistance += appDataP.allDistances[i];
                      }

                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: chartHeight,
                          ),
                          child: Container(
                            color: Colors.blue[600],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Text(
                                  ' ${appDataP.cities[cityIndex].name} - ${totalDistance.toStringAsFixed(2)} km',
                                  style: const TextStyle(
                                    height: 1,
                                    // fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: isPortraitMode ? 2 : 1,
                        height: chartHeight,
                        color: styles.secoundaryColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
