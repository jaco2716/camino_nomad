import 'package:flutter/material.dart';
import '../model/route_info/route_city.dart';
import '../pages/city_page/city_page.dart';
import '../../constants/styles_config.dart' as styles;

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
          padding: showBetweenDistance ? const EdgeInsets.only(top: 26.0) : const EdgeInsets.only(top: 4.0, bottom: 4),
          child: Card(
            margin: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: ListTile(
              onTap: onPressed ??
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CityPage(city: city, totalDistance: totalDistance)));
                  },
              dense: true,
              // isThreeLine: true,
              iconColor: styles.primaryColor,
              title: Text(city.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(children: (city.facilities).map((e) => Icon(facilityIconMap[e], size: 18)).toList()),
                  // Row(
                  //   children: [
                  //     const Icon(Icons.house, size: 20, color: Colors.blue),
                  //     Text(
                  //       // ': ${city.hotels.length}',
                  //       'TODO',
                  //       style: const TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              trailing: Text('${totalDistance.toStringAsFixed(1)} km', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              // horizontalTitleGap: 5,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
