import 'dart:math';

import 'package:camino_nomad/model/providers/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ElevationChartPage extends StatelessWidget {
  const ElevationChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    var routeProvider = context.read<RouteProvider>();
    var routeData = routeProvider.currentRouteData!;
    var cityRPIds = routeData.cities.map((e) => e.routePointId).toList();
    int startEleIndex = routeData.routePoints.indexWhere((element) => element.id == cityRPIds[routeProvider.startCityIndex]);
    int endEleIndex = routeData.routePoints.indexWhere((element) => element.id == cityRPIds[routeProvider.endCityIndex!]);
    var eleMaxList = routeProvider.allMaxEle?.getRange(routeProvider.startCityIndex + 1, routeProvider.endCityIndex! + 1);
    double eleMax = eleMaxList?.reduce(max) ?? 0;
    if (eleMax < 1500) eleMax = 1500;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elevation'),
      ),
      body: SafeArea(
        // bottom: false,
        child: LayoutBuilder(builder: (context, constraints) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            scrollDirection: Axis.horizontal,
            itemCount: endEleIndex - startEleIndex + 1,
            itemBuilder: (context, index) {
              int rpIndex = index + startEleIndex;
              double chartHeight = routeData.routePoints[rpIndex].ele / eleMax * constraints.maxHeight;

              if (cityRPIds.contains(routeData.routePoints[rpIndex].id)) {
                var cityIndex = cityRPIds.indexOf(routeData.routePoints[rpIndex].id);
                double totalDistance = 0;
                for (var i = 1; i <= cityIndex; i++) {
                  totalDistance += routeProvider.allDistances?[i + (routeProvider.startCityIndex)] ?? 0;
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
                            ' ${routeData.cities[cityIndex].name} - ${totalDistance.toStringAsFixed(2)} km',
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
                  width: 2,
                  height: chartHeight,
                  color: Colors.blue,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
