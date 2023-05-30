import 'dart:math';
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/model/route_info/route_data.dart';
import 'package:flutter/material.dart';
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
  List<int> cityRPIds = [];
  int startEleIndex = 0;
  int endEleIndex = 0;
  Iterable<double>? eleMaxList = [];
  double eleMax = 0;

  @override
  void initState() {
    super.initState();
    appDataP = context.read<AppDataProvider>();
    routeData = appDataP.routeData[appDataP.routeIndex];
    cityRPIds = appDataP.cities.map((e) => e.routePointId).toList();
    startEleIndex = routeData.routePoints.indexWhere((element) => element.id == cityRPIds[appDataP.appDataSettings.startIndex]);
    endEleIndex = routeData.routePoints.indexWhere((element) => element.id == cityRPIds[appDataP.appDataSettings.endIndex!]);
    eleMaxList = appDataP.allMaxEle.getRange(appDataP.appDataSettings.startIndex + 1, appDataP.appDataSettings.endIndex! + 1);
    eleMax = eleMaxList?.reduce(max) ?? 0;

    if (eleMax < 1500) eleMax = 1500;
  }

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
    eleMax = 1500;
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              scrollDirection: Axis.horizontal,
              itemCount: endEleIndex - startEleIndex + 1,
              itemBuilder: (context, index) {
                int rpIndex = index + startEleIndex;

                double chartHeight = routeData.routePoints[rpIndex].ele / eleMax * constraints.maxHeight;
                if (!isPortraitMode) {
                  chartHeight = routeData.routePoints[rpIndex].ele / eleMax * constraints.maxWidth;
                }

                if (cityRPIds.contains(routeData.routePoints[rpIndex].id)) {
                  var cityIndex = cityRPIds.indexOf(routeData.routePoints[rpIndex].id);
                  double totalDistance = 0;

                  for (var i = appDataP.appDataSettings.startIndex + 1; i <= cityIndex; i++) {
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
                    color: Colors.blue,
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
