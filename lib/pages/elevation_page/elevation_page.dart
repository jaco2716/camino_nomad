import 'dart:math' as math;
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/model/route_info/route_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../constants/styles_config.dart' as styles;
import 'package:provider/provider.dart';

import '../../logic/route_logic.dart';
import '../../model/route_info/route_point.dart';
import 'chart_widgets.dart';

class ElevationPage extends StatefulWidget {
  const ElevationPage({super.key});

  @override
  State<ElevationPage> createState() => _ElevationPageState();
}

class _ElevationPageState extends State<ElevationPage> {
  final rl = RouteLogic();
  double chartPadding = 40.0;
  // final double xAxisMultiplier = 20.0;
  final double xAxisMultiplier = 70.0;
  late double chartHeight;
  List<ChartDataPoint> chartData = [];
  List<Map<String, dynamic>> cityList = [];
  int? currentDistanceIndex;

  late AppDataProvider appDataP;
  late RouteData routeData;
  List<int> cityRPIds = [];
  int startEleIndex = 0;
  int endEleIndex = 0;
  double eleMax = 0.0;
  double eleMin = 0.0;
  double chartMax = 0.0;

  Stream<Position> checkPositionStream() async* {
    yield await _determinePosition();

    yield* Stream.periodic(const Duration(seconds: 4), (_) {
      return _determinePosition();
    }).asyncMap((event) async {
      return await event;
    });
  }

  @override
  void initState() {
    super.initState();

    changeOrientation(Orientation.landscape);

    appDataP = context.read<AppDataProvider>();
    routeData = appDataP.routeData[appDataP.routeIndex];
    cityRPIds = appDataP.cities.map((e) => e.id).toList();
    startEleIndex = routeData.routePoints.indexWhere((element) => element.cityId == cityRPIds[appDataP.appDataSettings.startIndex ?? 0]);
    endEleIndex = routeData.routePoints.indexWhere((element) => element.cityId == cityRPIds[appDataP.appDataSettings.endIndex!]);
    Iterable<double> eleMaxList = appDataP.allMaxEle.getRange((appDataP.appDataSettings.startIndex ?? 0) + 1, appDataP.appDataSettings.endIndex! + 1);
    Iterable<double> eleMinList = appDataP.allMinEle.getRange((appDataP.appDataSettings.startIndex ?? 0) + 1, appDataP.appDataSettings.endIndex! + 1);
    eleMax = eleMaxList.reduce(math.max);
    eleMin = eleMinList.reduce(math.min);

    if (eleMax < 1300) eleMax = 1300;
    if (eleMin > 200) eleMin = 200;
    eleMax += 100;
    eleMin -= 100;
    chartMax = eleMax - eleMin;
  }

  @override
  void dispose() {
    changeOrientation(Orientation.portrait);
    super.dispose();
  }

  void changeOrientation(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.paddingOf(context);
    chartPadding = (math.max(padding.left, padding.right) + 40) * 2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Elevation'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: padding.top),
        child: StreamBuilder<Position>(
          stream: checkPositionStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active) {
              Position? currentPos = snapshot.data;
              bool locationEnabled = snapshot.hasError ? false : true;

              return LayoutBuilder(
                builder: (context, constraints) {
                  chartHeight = constraints.maxHeight;
                  chartData = createChartData(routeData.routePoints.getRange(startEleIndex, endEleIndex + 1).toList(), chartMax, eleMin, currentPos);
                  Alignment currentLocationAlignment = currentLocationBoxAlignment();

                  return Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width + (chartPadding / 2)),
                          child: Stack(
                            children: [
                              CustomPaint(
                                  size: Size((chartData[chartData.length - 1].x * xAxisMultiplier) + chartPadding, chartHeight),
                                  painter: PathPainter(
                                    path: drawPath(false, chartPadding),
                                    fillPath: drawPath(true, chartPadding),
                                  )),
                              ...cityList.map((e) {
                                int cityIndex = appDataP.cities.indexWhere((element) => element.id == e['id']);
                                String cityTitle = '';
                                if (cityIndex != -1) {
                                  cityTitle = '${appDataP.cities[cityIndex].name} - ${(e['x'] as double).toStringAsFixed(2)} km';
                                }
                                return Positioned(
                                    left: e['x'] * xAxisMultiplier + chartPadding / 2,
                                    bottom: 0,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: chartHeight,
                                          width: 1,
                                          color: styles.primaryColor,
                                        ),
                                        Container(
                                            color: styles.primaryColor,
                                            child: RotatedBox(
                                                quarterTurns: -1,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                                  child: Text(
                                                    cityTitle,
                                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: -1),
                                                  ),
                                                ))),
                                      ],
                                    ));
                              }).toList(),
                              currentDistanceIndex != null
                                  ? AnimatedPositioned(
                                      duration: const Duration(milliseconds: 200),
                                      left: chartData[currentDistanceIndex!].x * xAxisMultiplier + chartPadding / 2,
                                      bottom: (chartData[currentDistanceIndex!].y * chartHeight) - 10,
                                      child: SizedBox(
                                        width: 1,
                                        height: 50,
                                        child: OverflowBox(
                                          maxWidth: 250,
                                          maxHeight: 150,
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: currentLocationAlignment,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(
                                                          color: Colors.grey[300]!,
                                                        )),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                          'Distance: ${(chartData[currentDistanceIndex!].x).toStringAsFixed(2)} km\nAltitude: ${(chartData[currentDistanceIndex!].y * (eleMax - eleMin) + eleMin).toStringAsFixed(0)} m'),
                                                    )),
                                              ),
                                              const Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(FontAwesomeIcons.personHiking, color: styles.primaryColor)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 35.0),
                          child: locationEnabled
                              ? currentDistanceIndex == null
                                  ? const Text(
                                      'Your location was not found on route',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : const SizedBox.shrink()
                              : const Text(
                                  ' Location Disabled ',
                                  style: TextStyle(color: Colors.red),
                                ),
                        ),
                      ),
                      //Chart Y-axis Labels
                      // Align(alignment: Alignment.topRight, child: YaxisLabels(chartHeight: chartHeight, minY: eleMin, maxY: eleMax)),
                    ],
                  );
                },
              );
            } else {
              return const Center(child: Text('Something went wrong, please reload page'));
            }
          },
        ),
      ),
    );
  }

  List<ChartDataPoint> createChartData(List<RoutePoint> routePoints, double chartMax, double chartMin, Position? currentPos) {
    final normalizedList = <ChartDataPoint>[];
    double? myLat = currentPos?.latitude;
    double? myLon = currentPos?.longitude; //"lat":42.748311,"lon":-1.722681
    double minDistance = 9999;
    int? myDinstanceIndex;
    double prevDistance = 0;

    for (var i = 0; i < routePoints.length; i++) {
      if (myLat != null && myLon != null) {
        final myDistance = rl.calculateDistance(myLat, myLon, routePoints[i].lat, routePoints[i].lon);
        //Finding closest point if distnace is below 2 km.
        if (minDistance > myDistance && myDistance < 2) {
          minDistance = myDistance;
          myDinstanceIndex = i;
        }
      }

      final double xdistance =
          i != 0 ? rl.calculateDistance(routePoints[i - 1].lat, routePoints[i - 1].lon, routePoints[i].lat, routePoints[i].lon) + prevDistance : 0.0;

      if (routePoints[i].cityId != null) {
        cityList.add({'x': xdistance, 'y': (routePoints[i].ele - chartMin) / chartMax, 'id': routePoints[i].cityId});
      }
      normalizedList.add(ChartDataPoint(x: xdistance, y: (routePoints[i].ele - chartMin) / chartMax));
      prevDistance = xdistance;
    }
    currentDistanceIndex = myDinstanceIndex;
    return normalizedList;
  }

  Path drawPath(bool closePath, double padding) {
    final height = chartHeight;
    final path = Path();

    path.moveTo(0, height - chartData[0].y * height);
    path.lineTo(padding / 2, height - chartData[0].y * height);
    for (var i = 0; i < chartData.length - 1; i++) {
      final x = chartData[i].x * xAxisMultiplier + padding / 2;
      final y = height - (chartData[i].y * height);
      path.lineTo(x, y);
    }

    path.lineTo(chartData[chartData.length - 1].x * xAxisMultiplier + padding, height - chartData[chartData.length - 1].y * height);
    if (closePath) {
      path.lineTo(chartData[chartData.length - 1].x * xAxisMultiplier + padding, height);
      path.lineTo(0, height);
    }

    return path;
  }

  Alignment currentLocationBoxAlignment() {
    if (currentDistanceIndex == null) return Alignment.topCenter;
    if ((chartData[currentDistanceIndex!].x * xAxisMultiplier) < 60) {
      if (chartData[currentDistanceIndex!].y > 0.8) {
        return Alignment.bottomRight;
      } else {
        return Alignment.topRight;
      }
    } else if (((chartData[chartData.length - 1].x - chartData[currentDistanceIndex!].x) * xAxisMultiplier) < 60) {
      if (chartData[currentDistanceIndex!].y > 0.8) {
        return Alignment.bottomLeft;
      } else {
        return Alignment.topLeft;
      }
    } else if (chartData[currentDistanceIndex!].y > 0.8) {
      return Alignment.bottomCenter;
    }
    return Alignment.topCenter;
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 5));
  }
}

class CurrentLocationIcon extends StatelessWidget {
  const CurrentLocationIcon({super.key, required this.isCurrentLocation});
  final bool isCurrentLocation;

  @override
  Widget build(BuildContext context) {
    return isCurrentLocation
        ? Container(
            width: 12,
            height: 20,
            padding: const EdgeInsets.only(bottom: 20),
            child: const OverflowBox(
              maxWidth: 50,
              maxHeight: 50,

              // width: isPortraitMode ? 2 : 1,
              child: Icon(FontAwesomeIcons.personHiking, color: styles.primaryColor),
            ),
          )
        : const SizedBox.shrink();
  }
}

class YaxisLabels extends StatelessWidget {
  const YaxisLabels({super.key, required this.maxY, required this.minY, required this.chartHeight});
  final double maxY;
  final double minY;
  final double chartHeight;

  // (routePoints[i].ele - chartMin) / chartMax
  // chartData[currentDistanceIndex!].y * chartHeight

  // List<double> createLabels(int count, double padding, double chartMax) {
  //   List<double> labels = [];
  //   for (var i = 0; i < count; i++) {
  //     print(i * maxY / (count - 1));
  //     // labels.add(maxY + minY + padding - (i * maxY / (count - 1)));
  //     labels.add((i * (chartMax) / (count - 1)) / chartMax);
  //     // labels.add((i * (chartMax) / (count - 1)) / chartMax + padding);
  //   }
  //   print(labels);
  //   return labels;
  // }

  List<double> createLabels(bool isBig) {
    List<double> labels = [];
    double value = ((minY / 100).floor() * 100);
    if (!isBig) value += 50;
    while (value < maxY - 100) {
      value += 100;
      labels.add(value);
    }
    return labels;
  }

  // Offset labelOffset(int length, double i) {
  //   final segment = 1 / (length - 1);
  //   final offsetValue = (i - ((length - 1) / 2)) * segment;
  //   return Offset(0, offsetValue);
  // }

  @override
  Widget build(BuildContext context) {
    double chartMax = maxY - minY;
    List<double> labels = createLabels(true);
    List<double> smallLabels = createLabels(false);

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: chartHeight,
        child: Stack(children: [
          ...labels.map((e) => YaxisLabelWidget(bottom: (e - minY) / chartMax * chartHeight, value: e)).toList(),
          ...smallLabels.map((e) => YaxisLabelWidget(bottom: (e - minY) / chartMax * chartHeight, value: e, isBig: false)).toList(),
        ]),
      ),
    );
  }
}

class YaxisLabelWidget extends StatelessWidget {
  const YaxisLabelWidget({super.key, required this.bottom, required this.value, this.isBig = true});

  final double bottom;
  final double value;
  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      height: 1,
      width: MediaQuery.of(context).size.width,
      child: OverflowBox(
        maxHeight: 20,
        child: Row(
          children: [
            SizedBox(
                child: Text(
              isBig ? ' ${value.toInt()}' : '',
              style: TextStyle(color: const Color(0xEECCCCCC), fontSize: isBig ? 10 : 8),
            )),
            Expanded(
              child: Container(
                height: 1,
                color: isBig ? const Color(0x4ECCCCCC) : const Color(0x20CCCCCC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
