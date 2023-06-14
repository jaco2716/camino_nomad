// import 'dart:math';
// import 'package:camino_nomad/model/providers/app_data_provider.dart';
// import 'package:camino_nomad/model/route_info/route_data.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../../../constants/styles_config.dart' as styles;
// import 'package:provider/provider.dart';

// import '../../logic/route_logic.dart';
// import '../../model/route_info/route_point.dart';

// class ElevationChartPage extends StatefulWidget {
//   const ElevationChartPage({super.key});

//   @override
//   State<ElevationChartPage> createState() => _ElevationChartPageState();
// }

// class _ElevationChartPageState extends State<ElevationChartPage> {
//   final rl = RouteLogic();
//   bool isPortraitMode = true;
//   late AppDataProvider appDataP;
//   late RouteData routeData;
//   List<RoutePoint> routePoints = [];
//   List<int> cityRPIds = [];
//   int startEleIndex = 0;
//   int endEleIndex = 0;
//   Iterable<double>? eleMaxList = [];
//   Iterable<double>? eleMinList = [];
//   double eleMax = 0;
//   double eleMin = 0;

//   List<double> yAxisValues = [];

//   @override
//   void initState() {
//     super.initState();
//     appDataP = context.read<AppDataProvider>();
//     routeData = appDataP.routeData[appDataP.routeIndex];
//     // cityRPIds = appDataP.cities.map((e) => e.routePointId).toList();
//     cityRPIds = appDataP.cities.map((e) => e.id).toList();
//     // startEleIndex = routeData.routePoints.indexWhere((element) => element.id == cityRPIds[appDataP.appDataSettings.startIndex]);
//     // endEleIndex = routeData.routePoints.indexWhere((element) => element.id == cityRPIds[appDataP.appDataSettings.endIndex!]);
//     // routePoints = reduceRoutePointsToAverage(routeData.routePoints);

//     // startEleIndex = routePoints.indexWhere((element) => element.cityId == cityRPIds[appDataP.appDataSettings.startIndex]);
//     // endEleIndex = routePoints.indexWhere((element) => element.cityId == cityRPIds[appDataP.appDataSettings.endIndex!]);
//     startEleIndex = routeData.routePoints.indexWhere((element) => element.cityId == cityRPIds[appDataP.appDataSettings.startIndex ?? 0]);
//     endEleIndex = routeData.routePoints.indexWhere((element) => element.cityId == cityRPIds[appDataP.appDataSettings.endIndex!]);
//     eleMaxList = appDataP.allMaxEle.getRange((appDataP.appDataSettings.startIndex ?? 0) + 1, appDataP.appDataSettings.endIndex! + 1);
//     eleMinList = appDataP.allMinEle.getRange((appDataP.appDataSettings.startIndex ?? 0) + 1, appDataP.appDataSettings.endIndex! + 1);
//     eleMax = eleMaxList?.reduce(max) ?? 0;
//     eleMin = eleMinList?.reduce(min) ?? 0;

//     if (eleMax < 1400) eleMax = 1400;
//     if (eleMin > 0) eleMin = 0;
//     eleMax += 100;
//     eleMin -= 100;

//     // for (var i = ((eleMax + eleMin) / 100).ceil(); i > (eleMin / 100).floor(); i--) {
//     //   yAxisValues.add(i * 100);
//     // }
//   }

//   // List<RoutePoint> reduceRoutePointsToAverage(List<RoutePoint> rps) {
//   //   List<RoutePoint> newRoutePoints = [];
//   //   int j = 0;
//   //   for (var i = 0; i < rps.length; i++) {
//   //     if (rps[i].cityId != null) {
//   //       newRoutePoints.add(RoutePoint(i, rps[i].lat, rps[i].lon, rps[i].ele, cityId: rps[i].cityId));
//   //     } else if (j >= 5) {
//   //       double avgEle = (rps[i].ele + rps[i - 1].ele + rps[i - 2].ele + rps[i - 3].ele + rps[i - 4].ele) / 5;
//   //       newRoutePoints.add(RoutePoint(i, rps[i].lat, rps[i].lon, avgEle, cityId: null));
//   //       j++;
//   //     }
//   //   }
//   //   print('after: ${newRoutePoints.first.cityId}');
//   //   return newRoutePoints;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Elevation'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 isPortraitMode = !isPortraitMode;
//               });
//             },
//             icon: const Icon(Icons.screen_rotation_rounded),
//           )
//         ],
//       ),
//       body: FutureBuilder<int?>(
//           // future: getYourLocationRPIndex(),
//           builder: (context, snapshot) {
//         // if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
//         // int? currentPosIndex = snapshot.data;
//         int? currentPosIndex = null;

//         return SafeArea(
//           child: LayoutBuilder(builder: (context, constraints) {
//             return RotatedBox(
//               quarterTurns: isPortraitMode ? 0 : 1,
//               child: Stack(
//                 children: [
//                   ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 0),
//                     scrollDirection: Axis.horizontal,
//                     itemCount: endEleIndex - startEleIndex + 1,
//                     itemBuilder: (context, index) {
//                       int rpIndex = index + startEleIndex;

//                       // double chartHeight = (routePoints[rpIndex].ele + (eleMin * -1)) / eleMax * constraints.maxHeight;
//                       // if (!isPortraitMode) {
//                       //   chartHeight = (routePoints[rpIndex].ele + (eleMin * -1)) / eleMax * constraints.maxWidth;
//                       // }
//                       double chartHeight = (routeData.routePoints[rpIndex].ele + (eleMin * -1)) / eleMax * constraints.maxHeight;
//                       if (!isPortraitMode) {
//                         chartHeight = (routeData.routePoints[rpIndex].ele + (eleMin * -1)) / eleMax * constraints.maxWidth;
//                       }

//                       // if (cityRPIds.contains(routeData.routePoints[rpIndex].id)) {
//                       if (cityRPIds.contains(routeData.routePoints[rpIndex].cityId)) {
//                         // if (cityRPIds.contains(routePoints[rpIndex].cityId)) {
//                         // var cityIndex = cityRPIds.indexOf(routeData.routePoints[rpIndex].id);
//                         var cityIndex = cityRPIds.indexOf(routeData.routePoints[rpIndex].cityId ?? -1);
//                         // var cityIndex = cityRPIds.indexOf(routePoints[rpIndex].cityId ?? -1);
//                         double totalDistance = getTotalDistanceToPoints(cityIndex, appDataP.allDistances);
//                         // print(rpIndex);
//                         return ChartColumnWithCity(
//                           chartHeight: chartHeight,
//                           appDataP: appDataP,
//                           cityIndex: cityIndex,
//                           totalDistance: totalDistance,
//                           isCurrentLocation: rpIndex == currentPosIndex,
//                         );
//                       }

//                       return ChartColumnWithHeight(
//                         isPortraitMode: isPortraitMode,
//                         chartHeight: chartHeight,
//                         isCurrentLocation: rpIndex == currentPosIndex, //currentPosIndex,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           }),
//         );
//       }),
//     );
//   }

//   double getTotalDistanceToPoints(int pointIndex, List<double> allDistances) {
//     double totalDistance = 0;

//     for (var i = (appDataP.appDataSettings.startIndex ?? 0) + 1; i <= pointIndex; i++) {
//       totalDistance += allDistances[i];
//     }
//     return totalDistance;
//   }

//   // Future<int?> getYourLocationRPIndex() async {
//   //   Position currentPos = await _determinePosition();
//   //   int? lowestIndex;
//   //   double minValue = 9999;
//   //   List<double> routeDistances = [];
//   //   for (var i = 0; i < endEleIndex; i++) {
//   //     var distance = rl.calculateDistance(routeData.routePoints[i].lat, routeData.routePoints[i].lon, currentPos.latitude, currentPos.longitude);
//   //     routeDistances.add(rl.calculateDistance(
//   //       routeData.routePoints[i].lat,
//   //       routeData.routePoints[i].lon,
//   //       routeData.routePoints[i + 1].lat,
//   //       routeData.routePoints[i + 1].lon,
//   //     ));
//   //     if (distance < minValue) {
//   //       minValue = distance;
//   //       //Only set index if distance less than 5km
//   //       if (minValue < 5) {
//   //         lowestIndex = i;
//   //       }
//   //     }
//   //   }
//   //   // lowestIndex = 300;
//   //   print(lowestIndex);
//   //   if (lowestIndex != null) {
//   //     routeDistances = routeDistances.getRange(0, lowestIndex!).toList();
//   //     double currentDistance = routeDistances.reduce((a, b) => a + b);
//   //     print('current d: $currentDistance');
//   //   }
//   //   return lowestIndex;
//   // }

//   // /// Determine the current position of the device.
//   // ///
//   // /// When the location services are not enabled or permissions
//   // /// are denied the `Future` will return an error.
//   // Future<Position> _determinePosition() async {
//   //   bool serviceEnabled;
//   //   LocationPermission permission;

//   //   // Test if location services are enabled.
//   //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   if (!serviceEnabled) {
//   //     // Location services are not enabled don't continue
//   //     // accessing the position and request users of the
//   //     // App to enable the location services.
//   //     return Future.error('Location services are disabled.');
//   //   }

//   //   permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //     if (permission == LocationPermission.denied) {
//   //       // Permissions are denied, next time you could try
//   //       // requesting permissions again (this is also where
//   //       // Android's shouldShowRequestPermissionRationale
//   //       // returned true. According to Android guidelines
//   //       // your App should show an explanatory UI now.
//   //       return Future.error('Location permissions are denied');
//   //     }
//   //   }

//   //   if (permission == LocationPermission.deniedForever) {
//   //     // Permissions are denied forever, handle appropriately.
//   //     return Future.error('Location permissions are permanently denied, we cannot request permissions.');
//   //   }

//   //   // When we reach here, permissions are granted and we can
//   //   // continue accessing the position of the device.
//   //   return await Geolocator.getCurrentPosition();
//   // }
// }

// class ChartColumnWithCity extends StatelessWidget {
//   const ChartColumnWithCity({
//     super.key,
//     required this.chartHeight,
//     required this.appDataP,
//     required this.cityIndex,
//     required this.totalDistance,
//     required this.isCurrentLocation,
//   });

//   final double chartHeight;
//   final AppDataProvider appDataP;
//   final int cityIndex;
//   final double totalDistance;
//   final bool isCurrentLocation;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CurrentLocationIcon(isCurrentLocation: isCurrentLocation),
//           ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight: chartHeight,
//             ),
//             child: Container(
//               color: isCurrentLocation ? styles.primaryColor : styles.secoundaryColor,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
//                 child: RotatedBox(
//                   quarterTurns: -1,
//                   child: Text(
//                     ' ${appDataP.cities[cityIndex].name} - ${totalDistance.toStringAsFixed(2)} km',
//                     style: const TextStyle(
//                       height: 1,
//                       // fontSize: 14,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChartColumnWithHeight extends StatelessWidget {
//   const ChartColumnWithHeight({
//     super.key,
//     required this.isPortraitMode,
//     required this.chartHeight,
//     required this.isCurrentLocation,
//   });

//   final bool isPortraitMode;
//   final double chartHeight;
//   final bool isCurrentLocation;

//   @override
//   Widget build(BuildContext context) {
//     double widthMultiplier = isCurrentLocation ? 5 : 1;
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CurrentLocationIcon(isCurrentLocation: isCurrentLocation),
//           Container(
//             width: isPortraitMode ? (2 * widthMultiplier) : (1 * widthMultiplier),
//             height: chartHeight,
//             color: isCurrentLocation ? styles.primaryColor : styles.secoundaryColor.withOpacity(0.8),
//             child: isCurrentLocation
//                 ? const RotatedBox(
//                     quarterTurns: -1,
//                     child: Center(
//                       child: Text(
//                         '120 km',
//                         style: TextStyle(fontSize: 8, height: 1.1, color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ))
//                 : const SizedBox.shrink(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CurrentLocationIcon extends StatelessWidget {
//   const CurrentLocationIcon({super.key, required this.isCurrentLocation});
//   final bool isCurrentLocation;

//   @override
//   Widget build(BuildContext context) {
//     return isCurrentLocation
//         ? Container(
//             width: 12,
//             height: 20,
//             padding: const EdgeInsets.only(bottom: 20),
//             child: const OverflowBox(
//               maxWidth: 50,
//               maxHeight: 50,

//               // width: isPortraitMode ? 2 : 1,
//               child: Icon(FontAwesomeIcons.personHiking, color: styles.primaryColor),
//             ),
//           )
//         : const SizedBox.shrink();
//   }
// }
