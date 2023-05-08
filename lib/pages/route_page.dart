import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/providers/route_provider.dart';
import '../widgets/city_list_tile.dart';
import '../widgets/left_aligned_title.dart';
import '../widgets/route_list_tile.dart';
import 'choose_route_page.dart';
import 'choose_start_end_page.dart';
import 'coming_soon_page.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> with AutomaticKeepAliveClientMixin {
  late RouteProvider routeProvider;

  @override
  void initState() {
    super.initState();

    routeProvider = context.read<RouteProvider>();
    routeProvider.setAllDistances();
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
                  const SizedBox(height: 16),
                  SizedBox(height: 90, child: Image.asset('assets/images/nomad-transparent.png')),
                  const SizedBox(height: 16),
                  const LeftAlignedTitle('Start Your Journey'),
                  Consumer<RouteProvider>(builder: (context, value, _) {
                    String routeSub = value.routeData?.name ?? 'Choose your route...';

                    String startSub = (value.routeData != null) ? value.routeData!.cities[value.startIndex].name : 'Choose your start city...';
                    String endSub = (value.endIndex != null && value.routeData != null)
                        ? value.routeData!.cities[value.endIndex!].name
                        : 'Choose your end city...';

                    return Column(
                      children: [
                        RouteListTile(title: 'Route', subtitle: routeSub, icon: Icons.route, route: const ChooseRoutePage()),
                        RouteListTile(
                            title: 'Start here today!',
                            subtitle: startSub,
                            icon: Icons.pin_drop_outlined,
                            route: const ChooseStartEndPage(isStart: true, startIndex: 0)),
                        RouteListTile(
                            title: 'End here today!',
                            subtitle: endSub,
                            icon: Icons.pin_drop_outlined,
                            route: ChooseStartEndPage(isStart: false, startIndex: value.startIndex + 1)),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ComingSoonPage()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Consumer<RouteProvider>(builder: (context, value, _) {
                            double? sum;
                            if (value.endIndex != null) {
                              var distanceList = value.allDistances?.getRange(value.startIndex + 1, value.endIndex! + 1);
                              sum = distanceList?.reduce((a, b) => a + b);
                            }
                            double? totalDistance = value.allDistances?.reduce((a, b) => a + b);

                            return Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [const Text('Todays Distance:'), Text('${sum?.toStringAsFixed(2) ?? '?'} km')],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [const Text('Total Distance:'), Text('${totalDistance?.toStringAsFixed(2) ?? '?'} km')],
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [Text('Elevation min/max:'), Text('? m / ? m')],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [Text('Elevation gain/loss:'), Text('? m / ? m')],
                              ),
                            ]);
                          }),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<RouteProvider>(builder: (context, value, _) {
                    if (value.endIndex == null) return const SizedBox.shrink();
                    return const LeftAlignedTitle('Cities on route');
                  }),
                ],
              ),
            ),
          ),
          Consumer<RouteProvider>(builder: (context, value, _) {
            if (value.endIndex == null) return const SliverToBoxAdapter(child: SizedBox.shrink());

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  int cityIndex = index + value.startIndex;
                  double totalDistance = 0;
                  for (var i = 1; i <= index; i++) {
                    totalDistance += value.allDistances?[i + (value.startIndex)] ?? 0;
                  }
                  return CityListTile(
                      showBetweenDistance: index != 0,
                      city: value.routeData!.cities[cityIndex],
                      totalDistance: totalDistance,
                      distanceBetween: value.allDistances![cityIndex]);
                },
                childCount: ((value.endIndex ?? -1) - (value.startIndex) + 1),
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
