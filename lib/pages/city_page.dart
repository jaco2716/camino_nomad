import 'dart:convert';
import 'package:camino_nomad/logic/route_logic.dart';
import 'package:camino_nomad/pages/albergue_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/route_info/albergue.dart';
import '../model/route_info/route_city.dart';
import '../widgets/left_aligned_title.dart';

class CityPage extends StatefulWidget {
  const CityPage({super.key, required this.city, required this.totalDistance});
  final RouteCity city;
  final double totalDistance;

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  List<Albergue> newAlbergues = [];
  dynamic cityfile;

  @override
  void initState() {
    super.initState();
    loadFile();
  }

  loadFile() async {
    final String response = await rootBundle.loadString('assets/route_data/test.json');
    final Map<String, dynamic> routeData = await json.decode(response);

    // List<dynamic> routePoints = routeData['route_points'];
    int cityindex = (routeData['cities'] as List<dynamic>).indexWhere((element) => element['name'] == widget.city.name);
    cityfile = routeData['cities'][cityindex];
    // print(cityfile);
  }

  generateAlbergues() {
    final rl = RouteLogic();
    List<dynamic> alberguesF = cityfile['albergues'];
    int startID = widget.city.albergues.length;
    rl.generateAlbergues(startID, alberguesF);
    // for (var i = 0; i < alberguesF.length; i++) {
    // for (var i = 0; i < 2; i++) {
    //   // print('${alberguesF[i]['address']}, ${alberguesF[i]['postal_code']}');

    //   // String checkintime = alberguesF[i]['checkin_time'] ?? '';
    //   // print(checkintime);
    //   var newItem = Albergue(
    //     id: i + startID,
    //     name: alberguesF[i]['name'],
    //     lat: alberguesF[i]['latitude'],
    //     lon: alberguesF[i]['longitude'],
    //     address: '${alberguesF[i]['address']}, ${alberguesF[i]['postal_code']}, ${alberguesF[i]['city_name']}, ${alberguesF[i]['country']}',
    //     postalCode: '${alberguesF[i]['postal_code']}',
    //     // albergueFacilities: alberguesF[i]['longitude'],
    //     bookingComScore: alberguesF[i]['g_rating'],
    //     bookingUrl: alberguesF[i]['Booking_com_url'],
    //     website: alberguesF[i]['web'],
    //     facebook: alberguesF[i]['facebook_url'],
    //     checkInTime: alberguesF[i]['checkin_time'],
    //     checkOutTime: alberguesF[i]['checkout_time'],
    //     closeTime: alberguesF[i]['close_time'],
    //     prices: alberguesF[i]['longitude'],
    //     status: alberguesF[i]['longitude'],
    //   );

    //   if (alberguesF[i]['emails'] != null) {
    //     for (var j = 0; j < alberguesF[i]['emails'].length; j++) {
    //       newItem.emails.add(alberguesF[j]['emails'][j]);
    //     }
    //   }
    //   if (alberguesF[i]['phones'] != null) {
    //     for (var j = 0; j < alberguesF[i]['phones'].length; j++) {
    //       newItem.emails.add(alberguesF[j]['phones'][j]);
    //     }
    //   }

    //   if (alberguesF[i]['has_kitchen'] == '1') newItem.albergueFacilities.add(AlbergueFacilities.kitchen);
    //   if (alberguesF[i]['has_cooktops'] == '1') newItem.albergueFacilities.add(AlbergueFacilities.cooktops);
    //   if (alberguesF[i]['has_microwave'] == '1') newItem.albergueFacilities.add(AlbergueFacilities.microwave);
    //   if (alberguesF[i]['has_water_boiler'] == '1') newItem.albergueFacilities.add(AlbergueFacilities.waterBoiler);
    //   if (alberguesF[i]['has_plates_utensils'] == '1') newItem.albergueFacilities.add(AlbergueFacilities.platesUtensils);
    //   if (alberguesF[i]['has_cooking_pots'] == '1') newItem.albergueFacilities.add(AlbergueFacilities.cookingPots);
    //   if (alberguesF[i]['has_breakfast'] == '1') newItem.albergueFacilities.add(AlbergueFacilities.breakfast);
    //   if (alberguesF[i]['is_breakfast_included'] == '1') newItem.albergueFacilities.add(AlbergueFacilities.breakfastIncluded);
    //   if (alberguesF[i]['has_clothes_line'] == '1') newItem.albergueFacilities.add(AlbergueFacilities.clothesLine);
    //   if (alberguesF[i]['has_wifi'] == '1') newItem.albergueFacilities.add(AlbergueFacilities.wifi);

    //   newAlbergues.add(newItem);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // city.facilities.add(Facility.airport);
    // city.facilities.add(Facility.airport);
    // city.facilities.add(Facility.airport);
    // city.facilities.add(Facility.airport);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city.name),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                      children: (widget.city.facilities)
                          .map((e) => Icon(
                                facilityIconMap[e],
                                size: 20,
                                color: Colors.amber[800],
                              ))
                          .toList()),
                ),
                const Icon(Icons.location_on, size: 18, color: Colors.blue),
                Text('${widget.totalDistance.toStringAsFixed(1)} km', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // ListTile(
          //   dense: true,
          //   iconColor: Colors.amber[800],
          //   title: Row(children: (data['icons'] as List<IconData>).map((e) => Icon(e, size: 20)).toList()),
          //   trailing: Text('${data['distance']} km', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          // ),
          const LeftAlignedTitle('Accomodations'),
          Expanded(
            child: ListView.builder(
              // shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.city.albergues.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AlberguePage(albergue: widget.city.albergues[index]))),
                    dense: true,
                    isThreeLine: true,
                    iconColor: Colors.amber[800],
                    title: Text(widget.city.albergues[index].name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                            children: widget.city.albergues[index].prices.map((e) {
                          String priceString = '';
                          if (e.fromPrice != null && e.toPrice != null) {
                            priceString = '${e.fromPrice!.round()}-${e.toPrice!.round()}€';
                          } else if (e.fromPrice != null) {
                            priceString = '${e.fromPrice!.round()}€ +';
                          } else {
                            priceString = '${e.toPrice!.round()}€';
                          }
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                albergueTypeIconMap[e.type],
                                // size: 10,
                                // color: Colors.red,
                              ),
                              Text(priceString)
                            ],
                          );
                        }).toList()
                            //  [
                            //   const Icon(Icons.bedroom_child),
                            //   Text('${city.albergues[index].prices.length}€+', style: TextStyle(color: Colors.amber[800])),
                            //   const SizedBox(width: 16),
                            //   const Icon(Icons.bedroom_parent),
                            // ]
                            ),
                        Wrap(
                            children: (widget.city.albergues[index].albergueFacilities)
                                .map((e) => Icon(
                                      albergueFacilityIconMap[e],
                                      size: 20,
                                      color: Colors.amber[800],
                                    ))
                                .toList()),
                      ],
                    ),
                    trailing: Material(
                      borderRadius: BorderRadius.circular(6),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () => _launchUrl('https://www.booking.com/'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            '${widget.city.albergues[index].bookingComScore} Booking',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ElevatedButton(
          //     onPressed: () {
          //       // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAlberguePage()));
          //       // int id = city.albergues.length;
          //       // newAlbergues.add(Albergue(id: id, name: name, lat: lat, lon: lon))
          //       generateAlbergues();
          //     },
          //     child: const Text('Add'))
        ]),
      )),
    );
  }

  // Future<void> _launchUrl(url) async {
  _launchUrl(url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
