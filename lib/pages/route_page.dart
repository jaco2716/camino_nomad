import 'dart:math';
import 'package:camino_nomad/logic/data_generation.dart';
import 'package:camino_nomad/pages/elevation_chart_page.dart';
import 'package:camino_nomad/widgets/my_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../model/providers/app_data_provider.dart';
import '../widgets/city_list_tile.dart';
import '../widgets/left_aligned_title.dart';
import '../widgets/list_tile_with_icon_sub.dart';
import 'choose_route_page.dart';
import 'choose_start_end_page.dart';
import '../../constants/styles_config.dart' as styles;

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> with AutomaticKeepAliveClientMixin {
  late AppDataProvider appDataP;
  final dg = DataGeneration();

  @override
  void initState() {
    super.initState();

    appDataP = context.read<AppDataProvider>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  // ElevatedButton(onPressed: () => dg.generateHotels(appDataP.hotels), child: const Text('get hotels')),
                  // ElevatedButton(
                  //     onPressed: () => dg.addCityIdtoRoutePoints(appDataP.routeData[appDataP.routeIndex], appDataP.allCities),
                  //     child: const Text('addCityToPR')),
                  // ElevatedButton(onPressed: () => dg.generateRoutePoints(), child: const Text('get routepoints')),
                  // ElevatedButton(
                  //     onPressed: () => dg.createAllCities(appDataP.routeData[appDataP.routeIndex], appDataP.allCities),
                  //     child: const Text('get cities')),
                  const SizedBox(height: 16),
                  // SizedBox(height: 90, child: Image.asset('assets/images/nomad-transparent.png')),
                  SizedBox(height: 90, child: Image.asset('assets/icon/icon-circle.png')),
                  const SizedBox(height: 16),
                  const LeftAlignedTitle('Start Your Journey', color: styles.primaryColor),
                  Consumer<AppDataProvider>(builder: (context, value, _) {
                    String routeSub = value.routeData[value.routeIndex].name;

                    String startSub =
                        value.appDataSettings.startIndex != null ? value.cities[value.appDataSettings.startIndex!].name : 'Choose your city';
                    String endSub = value.appDataSettings.endIndex != null ? value.cities[value.appDataSettings.endIndex!].name : 'Choose your city';

                    return Column(
                      children: [
                        ListTileWithIconSub(
                            // backgroundColor: styles.primaryColor,
                            backgroundColor: styles.secoundaryColor,
                            title: 'Route',
                            subtitle: routeSub,
                            icon: const FaIcon(FontAwesomeIcons.route),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChooseRoutePage()))),
                        ListTileWithIconSub(
                            backgroundColor: styles.primaryColor,
                            title: 'Starting here today',
                            subtitle: startSub,
                            icon: const FaIcon(FontAwesomeIcons.mapPin),
                            onTap: () => Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const ChooseStartEndPage(isStart: true, startIndex: 0)))),
                        ListTileWithIconSub(
                            backgroundColor: styles.primaryColor,
                            title: 'Walking here today',
                            subtitle: endSub,
                            icon: const FaIcon(FontAwesomeIcons.locationCrosshairs),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChooseStartEndPage(isStart: false, startIndex: (value.appDataSettings.startIndex ?? 0) + 1)))),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  const LeftAlignedTitle("Today's Stage", color: styles.primaryColor),
                  Theme(
                    data: Theme.of(context).copyWith(
                        textTheme: const TextTheme(
                      bodyMedium: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                    child: Card(
                      // color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      color: styles.secoundaryColor,
                      child: InkWell(
                        onTap: () {
                          if (appDataP.appDataSettings.endIndex != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ElevationChartPage()));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const MyInfoDialog(child: Text('Choose start and end point to view Elevation Map'));
                              },
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                                // padding: const EdgeInsets.all(0),
                                child: Ink(
                                  // margin: const EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
                                  decoration: BoxDecoration(
                                    // color: Colors.blue[600],
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 0, 140, 255),
                                          Color.fromARGB(255, 51, 163, 255),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.35, 0.35]),
                                  ),
                                  // clipBehavior: Clip.hardEdge,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Consumer<AppDataProvider>(builder: (context, value, _) {
                                      double? distSum;
                                      double? eleGainSum;
                                      double? eleLossSum;
                                      double? eleMin;
                                      double? eleMax;
                                      if (value.appDataSettings.endIndex != null && value.cities.isNotEmpty) {
                                        var distanceList = value.allDistances
                                            .getRange((value.appDataSettings.startIndex ?? 0) + 1, value.appDataSettings.endIndex! + 1);
                                        var eleGainList = value.allEleGain
                                            .getRange((value.appDataSettings.startIndex ?? 0) + 1, value.appDataSettings.endIndex! + 1);
                                        var eleLossList = value.allEleLoss
                                            .getRange((value.appDataSettings.startIndex ?? 0) + 1, value.appDataSettings.endIndex! + 1);
                                        var eleMinList = value.allMinEle
                                            .getRange((value.appDataSettings.startIndex ?? 0) + 1, value.appDataSettings.endIndex! + 1);
                                        var eleMaxList = value.allMaxEle
                                            .getRange((value.appDataSettings.startIndex ?? 0) + 1, value.appDataSettings.endIndex! + 1);

                                        distSum = distanceList.reduce((a, b) => a + b);
                                        eleGainSum = eleGainList.reduce((a, b) => a + b);
                                        eleLossSum = eleLossList.reduce((a, b) => a + b);
                                        eleMin = eleMinList.reduce(min);
                                        eleMax = eleMaxList.reduce(max);
                                      }
                                      // double totalDistance = value.allDistances.isNotEmpty ? value.allDistances.reduce((a, b) => a + b) : 0;

                                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [const Text('Todays Distance:'), Text('${distSum?.toStringAsFixed(2) ?? '?'} km')],
                                        ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [const Text('Total Distance:'), Text('${totalDistance.toStringAsFixed(2)} km')],
                                        // ),
                                        const Divider(color: Colors.transparent),
                                        const Text(
                                          'Elevation',
                                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Min / Max:'),
                                            Text('${eleMin?.toStringAsFixed(0) ?? '?'} m / ${eleMax?.toStringAsFixed(0) ?? '?'} m')
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Gain / Loss:'),
                                            Text('${eleGainSum?.toStringAsFixed(0) ?? '?'} m / -${eleLossSum?.toStringAsFixed(0) ?? '?'} m')
                                          ],
                                        ),
                                      ]);
                                    }),
                                  ),
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Colors.white),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<AppDataProvider>(builder: (context, value, _) {
                    if (value.appDataSettings.endIndex == null) return const SizedBox.shrink();
                    return const LeftAlignedTitle('Cities on route');
                  }),
                ],
              ),
            ),
          ),
          Consumer<AppDataProvider>(builder: (context, value, _) {
            if (value.appDataSettings.endIndex == null) return const SliverToBoxAdapter(child: SizedBox.shrink());
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  int cityIndex = index + (value.appDataSettings.startIndex ?? 0);
                  double totalDistance = 0;
                  for (var i = 1; i <= index; i++) {
                    totalDistance += value.allDistances[i + (value.appDataSettings.startIndex ?? 0)];
                  }
                  return CityListTile(
                      showBetweenDistance: index != 0,
                      city: value.cities[cityIndex],
                      totalDistance: totalDistance,
                      distanceBetween: value.allDistances[cityIndex]);
                },
                childCount: ((value.appDataSettings.endIndex ?? -1) - (value.appDataSettings.startIndex ?? 0) + 1),
              ),
            );
          }),
          const SliverToBoxAdapter(child: SizedBox(height: 30))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
