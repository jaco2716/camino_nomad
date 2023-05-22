import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/providers/route_provider.dart';
import '../widgets/city_list_tile.dart';
import 'package:diacritic/diacritic.dart';

class ChooseStartEndPage extends StatefulWidget {
  const ChooseStartEndPage({super.key, required this.isStart, required this.startIndex});

  final bool isStart;
  final int startIndex;

  @override
  State<ChooseStartEndPage> createState() => _ChooseStartEndPageState();
}

class _ChooseStartEndPageState extends State<ChooseStartEndPage> {
  final _searchController = TextEditingController();

  late RouteProvider routeProvider;
  late List<bool> showCities;

  @override
  void initState() {
    super.initState();
    routeProvider = Provider.of<RouteProvider>(context, listen: false);
    showCities = List.generate(routeProvider.currentRouteData?.cities.length ?? 0, (index) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isStart ? 'Start Position' : 'End Position'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              onChanged: searchCities,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                isDense: true,
                hintText: 'Search...',
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: (routeProvider.currentRouteData?.cities.length ?? 0) - widget.startIndex,
                itemBuilder: (context, index) {
                  if (!showCities[index + widget.startIndex]) return const SizedBox.shrink();
                  if (widget.isStart) {
                    return Card(
                        child: InkWell(
                      onTap: () {
                        if (widget.isStart) {
                          routeProvider.setStartIndex(index + widget.startIndex);
                          routeProvider.setEndIndex(null);
                        } else {
                          routeProvider.setEndIndex(index + widget.startIndex);
                        }
                        Navigator.pop(context);
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            routeProvider.currentRouteData?.cities[index + widget.startIndex].name ?? '',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          )),
                    ));
                  } else {
                    int cityIndex = index + widget.startIndex;
                    double totalDistance = 0;
                    for (var i = 1; i <= index + 1; i++) {
                      totalDistance += routeProvider.allDistances?[i + (routeProvider.startCityIndex)] ?? 0;
                    }
                    return CityListTile(
                      showBetweenDistance: false,
                      city: routeProvider.currentRouteData!.cities[cityIndex],
                      totalDistance: totalDistance,
                      distanceBetween: index == 0 ? 0 : routeProvider.allDistances![cityIndex],
                      onPressed: () {
                        routeProvider.setEndIndex(index + widget.startIndex);
                        Navigator.pop(context);
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      )),
    );
  }

  searchCities(String value) {
    if (routeProvider.currentRouteData != null) {
      final input = removeDiacritics(value).replaceAll(RegExp('[^A-Za-z0-9]'), '').toLowerCase();
      final tempShowCities = routeProvider.currentRouteData!.cities
          .map((e) => removeDiacritics(e.name).replaceAll(RegExp('[^A-Za-z0-9]'), '').toLowerCase().contains(input))
          .toList();
      setState(() => showCities = tempShowCities);
    }
  }
}
