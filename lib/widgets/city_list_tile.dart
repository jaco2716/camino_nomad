import 'package:flutter/material.dart';
import '../model/route_info/route_city.dart';
import '../pages/city_page.dart';

class CityListTile extends StatelessWidget {
  const CityListTile({
    super.key,
    required this.showBetweenDistance,
    required this.city,
    required this.totalDistance,
    required this.distanceBetween,
    this.onPressed,
  });

  final bool showBetweenDistance;
  final RouteCity city;
  final double totalDistance;
  final double distanceBetween;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: showBetweenDistance ? const EdgeInsets.only(top: 26.0) : const EdgeInsets.only(top: 8.0),
          child: Card(
            margin: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: ListTile(
              onTap: onPressed ??
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CityPage(city: city, totalDistance: totalDistance)));
                  },
              dense: true,
              isThreeLine: true,
              iconColor: Colors.amber[800],
              title: Text(city.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(children: (city.facilities).map((e) => Icon(facilityIconMap[e], size: 20)).toList()),
                  Row(
                    children: [
                      const Icon(Icons.house, size: 20, color: Colors.blue),
                      Text(': ${city.hotels.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              trailing: Text('${totalDistance.toStringAsFixed(1)} km', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              horizontalTitleGap: 5,
              // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
          child: Visibility(
            visible: showBetweenDistance,
            child: Text(
              '${distanceBetween.toStringAsFixed(1)} km',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }
}
