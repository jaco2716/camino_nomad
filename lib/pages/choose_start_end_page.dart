import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/providers/route_provider.dart';
import '../widgets/city_list_tile.dart';

class ChooseStartEndPage extends StatelessWidget {
  const ChooseStartEndPage({super.key, required this.isStart, required this.startIndex});

  final bool isStart;
  final int startIndex;

  // static const List<String> dataList = [
  //   'Saint Jean Piet de Port',
  //   'Honto (Napoleon Route)',
  //   'Orisson (Napoleon Route)',
  //   'Roncesvalles',
  //   'Burguete',
  //   'Espinal',
  // ];

  @override
  Widget build(BuildContext context) {
    var routeProvider = Provider.of<RouteProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(isStart ? 'Start Position' : 'End Position'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
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
                itemCount: (routeProvider.routeData?.cities.length ?? 0) - startIndex,
                itemBuilder: (context, index) {
                  if (isStart) {
                    return Card(
                        child: InkWell(
                      onTap: () {
                        if (isStart) {
                          routeProvider.setStartIndex(index + startIndex);
                          routeProvider.setEndIndex(null);
                        } else {
                          routeProvider.setEndIndex(index + startIndex);
                        }
                        Navigator.pop(context);
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            routeProvider.routeData?.cities[index + startIndex].name ?? '',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          )),
                    ));
                  } else {
                    int cityIndex = index + startIndex;
                    double totalDistance = 0;
                    for (var i = 1; i <= index; i++) {
                      totalDistance += routeProvider.allDistances?[i + (routeProvider.startIndex)] ?? 0;
                    }
                    return CityListTile(
                      showBetweenDistance: false,
                      city: routeProvider.routeData!.cities[cityIndex],
                      totalDistance: totalDistance,
                      distanceBetween: index == 0 ? 0 : routeProvider.allDistances![cityIndex],
                      onPressed: () {
                        routeProvider.setEndIndex(index + startIndex);
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
}
