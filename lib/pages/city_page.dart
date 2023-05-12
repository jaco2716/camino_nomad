import 'dart:convert';
import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/widgets/my_alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../logic/route_logic.dart';
import '../pages/albergue_page/albergue_page.dart';
import '../widgets/booking_com_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  List<Widget> facilityRow = [];

  @override
  void initState() {
    super.initState();
    generateFacilityIcons();
  }

  generateFacilityIcons() {
    if (widget.city.facilities.isNotEmpty) {
      facilityRow = (widget.city.facilities)
          .map((e) => Icon(
                facilityIconMap[e],
                size: 20,
                color: Colors.amber[800],
              ))
          .toList();

      facilityRow.add(const Icon(FontAwesomeIcons.solidCircleQuestion, size: 10, color: Colors.grey));
    }
  }

  Future<dynamic> loadFile() async {
    final String response = await rootBundle.loadString('assets/route_data/test.json');
    final Map<String, dynamic> routeData = await json.decode(response);

    // List<dynamic> routePoints = routeData['route_points'];
    int cityindex = (routeData['cities'] as List<dynamic>).indexWhere((element) => element['name'] == widget.city.name);
    // dynamic cityfile = routeData['cities'][cityindex];
    return routeData['cities'][cityindex];
    // print(cityfile);
  }

  generateAlbergues() async {
    dynamic cityfile = await loadFile();

    final rl = RouteLogic();
    List<dynamic> alberguesF = cityfile['albergues'];
    int startID = widget.city.albergues.length;
    rl.generateAlbergues(startID, alberguesF);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city.name),
      ),
      body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return MyInfoDialog(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: (widget.city.facilities)
                                      .map((e) => Row(
                                            children: [
                                              Icon(facilityIconMap[e], size: 20, color: Colors.amber[800]),
                                              const SizedBox(width: 10),
                                              Text(e.name.camelToSentence()),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Wrap(children: facilityRow),
                        ),
                      ),
                    ),
                    const Icon(Icons.location_on, size: 18, color: Colors.blue),
                    Text('${widget.totalDistance.toStringAsFixed(1)} km', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const LeftAlignedTitle('Accomodations'),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.city.albergues.length,
                  itemBuilder: (BuildContext context, int index) {
                    List<String> highlightedFacilityImagePaths = [];
                    if (widget.city.albergues[index].bookingComUrl.isNotEmpty) {
                      highlightedFacilityImagePaths.add('assets/images/custom_icons/bookinglogo.png');
                    }
                    if (widget.city.albergues[index].albergueFacilities.contains(AlbergueFacility.kitchen)) {
                      highlightedFacilityImagePaths.add('assets/images/custom_icons/kitchen.png');
                    }
                    if (widget.city.albergues[index].albergueFacilities.contains(AlbergueFacility.vegan) ||
                        widget.city.albergues[index].albergueFacilities.contains(AlbergueFacility.vegetarian)) {
                      highlightedFacilityImagePaths.add('assets/images/custom_icons/vegan.png');
                    }
                    if (widget.city.albergues[index].albergueFacilities.contains(AlbergueFacility.communityDinner)) {
                      highlightedFacilityImagePaths.add('assets/images/custom_icons/dinner.png');
                    }
                    Color statusColor = Colors.green;

                    if (widget.city.albergues[index].status == AlbergueStatus.unknown) {
                      statusColor = Colors.yellow[600]!;
                    } else if (widget.city.albergues[index].status == AlbergueStatus.closed) {
                      statusColor = Colors.red;
                    } else if (widget.city.albergues[index].status == AlbergueStatus.temporarilyClosed) {
                      statusColor = Colors.orange;
                    }
                    return Card(
                      child: ListTile(
                        onTap: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AlberguePage(albergue: widget.city.albergues[index]))),
                        iconColor: Colors.amber[800],
                        title: Row(
                          children: [
                            CircleAvatar(radius: 5, backgroundColor: statusColor),
                            const SizedBox(width: 5),
                            Expanded(
                                child: Text(widget.city.albergues[index].name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                              child: Wrap(
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
                                    SizedBox(
                                        height: 20,
                                        child: Image.asset(
                                          albergueTypeIconMap[e.type]!,
                                          color: Colors.amber[800],
                                        )),
                                    Text(priceString),
                                    const SizedBox(width: 6),
                                  ],
                                );
                              }).toList()),
                            ),
                            Wrap(
                                children: highlightedFacilityImagePaths
                                    .map((e) => SizedBox(
                                        height: 20,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Image.asset(
                                            e,
                                            color: e.contains('bookinglogo') ? null : Colors.blue,
                                          ),
                                        )))
                                    .toList()),
                          ],
                        ),
                        // Wrap(
                        //     children: (widget.city.albergues[index].albergueFacilities)
                        //         .map((e) => Icon(
                        //               albergueFacilityIconMap[e],
                        //               size: 20,
                        //               color: Colors.amber[800],
                        //             ))
                        //         .toList()),
                        // visualDensity: const VisualDensity(vertical: VisualDensity.maximumDensity),
                        trailing: BookingComScore(bookingComScore: widget.city.albergues[index].bookingComScore, size: 30),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAlberguePage()));
                    // int id = city.albergues.length;
                    // newAlbergues.add(Albergue(id: id, name: name, lat: lat, lon: lon))
                    generateAlbergues();
                  },
                  child: const Text('Add'))
            ]),
          )),
    );
  }
}
