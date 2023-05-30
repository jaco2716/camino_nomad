import 'dart:math';

import 'package:camino_nomad/logic/data_generation.dart';
import 'package:camino_nomad/model/route_info/route_data.dart';
import 'package:camino_nomad/pages/elevation_chart_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../model/providers/app_data_provider.dart';
import '../widgets/city_list_tile.dart';
import '../widgets/left_aligned_title.dart';
import '../widgets/list_tile_with_icon_sub.dart';
import 'choose_route_page.dart';
import 'choose_start_end_page.dart';

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
                  ElevatedButton(onPressed: () => dg.generateHotels(0), child: const Text('get hotels')),
                  ElevatedButton(onPressed: () => dg.createAllCities(appDataP.routeData[appDataP.routeIndex]), child: const Text('get cities')),
                  const SizedBox(height: 16),
                  SizedBox(height: 90, child: Image.asset('assets/images/nomad-transparent.png')),
                  const SizedBox(height: 16),
                  const LeftAlignedTitle('Start Your Journey'),
                  Consumer<AppDataProvider>(builder: (context, value, _) {
                    String routeSub = value.routeData[value.routeIndex].name;

                    String startSub = value.cities.isNotEmpty ? value.cities[value.appDataSettings.startIndex].name : 'No Cities';
                    String endSub = value.appDataSettings.endIndex != null
                        ? value.cities.isNotEmpty
                            ? value.cities[value.appDataSettings.endIndex!].name
                            : 'No Cities'
                        : 'Choose your end city...';

                    return Column(
                      children: [
                        ListTileWithIconSub(
                            title: 'Route',
                            subtitle: routeSub,
                            icon: const FaIcon(FontAwesomeIcons.route),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChooseRoutePage()))),
                        ListTileWithIconSub(
                            title: 'Start here today!',
                            subtitle: startSub,
                            icon: const FaIcon(FontAwesomeIcons.mapPin),
                            onTap: () => Navigator.push(
                                context, MaterialPageRoute(builder: (context) => const ChooseStartEndPage(isStart: true, startIndex: 0)))),
                        ListTileWithIconSub(
                            title: 'End here today!',
                            subtitle: endSub,
                            icon: const FaIcon(FontAwesomeIcons.locationCrosshairs),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChooseStartEndPage(isStart: false, startIndex: value.appDataSettings.startIndex + 1)))),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  const LeftAlignedTitle('Current route'),
                  Theme(
                    data: Theme.of(context).copyWith(textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white))),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () {
                          if (appDataP.appDataSettings.endIndex != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ElevationChartPage()));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Consumer<AppDataProvider>(builder: (context, value, _) {
                            double? distSum;
                            double? eleGainSum;
                            double? eleLossSum;
                            double? eleMin;
                            double? eleMax;
                            if (value.appDataSettings.endIndex != null && value.cities.isNotEmpty) {
                              var distanceList =
                                  value.allDistances.getRange(value.appDataSettings.startIndex + 1, value.appDataSettings.endIndex! + 1);
                              var eleGainList = value.allEleGain.getRange(value.appDataSettings.startIndex + 1, value.appDataSettings.endIndex! + 1);
                              var eleLossList = value.allEleLoss.getRange(value.appDataSettings.startIndex + 1, value.appDataSettings.endIndex! + 1);
                              var eleMinList = value.allMinEle.getRange(value.appDataSettings.startIndex + 1, value.appDataSettings.endIndex! + 1);
                              var eleMaxList = value.allMaxEle.getRange(value.appDataSettings.startIndex + 1, value.appDataSettings.endIndex! + 1);

                              distSum = distanceList.reduce((a, b) => a + b);
                              eleGainSum = eleGainList.reduce((a, b) => a + b);
                              eleLossSum = eleLossList.reduce((a, b) => a + b);
                              eleMin = eleMinList.reduce(min);
                              eleMax = eleMaxList.reduce(max);
                            }
                            double totalDistance = value.allDistances.isNotEmpty ? value.allDistances.reduce((a, b) => a + b) : 0;

                            return Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [const Text('Todays Distance:'), Text('${distSum?.toStringAsFixed(2) ?? '?'} km')],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [const Text('Total Distance:'), Text('${totalDistance.toStringAsFixed(2)} km')],
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Elevation min/max:'),
                                  Text('${eleMin?.toStringAsFixed(0) ?? '?'} m / ${eleMax?.toStringAsFixed(0) ?? '?'} m')
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Elevation gain/loss:'),
                                  Text('${eleGainSum?.toStringAsFixed(0) ?? '?'} m / -${eleLossSum?.toStringAsFixed(0) ?? '?'} m')
                                ],
                              ),
                            ]);
                          }),
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
                  int cityIndex = index + value.appDataSettings.startIndex;
                  double totalDistance = 0;
                  for (var i = 1; i <= index; i++) {
                    totalDistance += value.allDistances[i + (value.appDataSettings.startIndex)];
                  }
                  return CityListTile(
                      showBetweenDistance: index != 0,
                      city: value.cities[cityIndex],
                      totalDistance: totalDistance,
                      distanceBetween: value.allDistances[cityIndex]);
                },
                childCount: ((value.appDataSettings.endIndex ?? -1) - (value.appDataSettings.startIndex) + 1),
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
