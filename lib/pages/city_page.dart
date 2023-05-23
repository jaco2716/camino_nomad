import 'dart:convert';
import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/widgets/my_alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../logic/route_logic.dart';
import '../pages/hotel_page/hotel_page.dart';
import '../widgets/booking_com_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/route_info/hotel.dart';
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
  List<Hotel> newHotels = [];

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

  generateHotels() async {
    dynamic cityfile = await loadFile();

    final rl = RouteLogic();
    List<dynamic> hotelsF = cityfile['hotels'];
    int startID = widget.city.hotels.length;
    rl.generateHotels(startID, hotelsF, widget.city.id);
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
              widget.city.hotels.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.0),
                      child: Text('No Accomodations'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: widget.city.hotels.length,
                        itemBuilder: (BuildContext context, int index) {
                          List<String> highlightedFacilityImagePaths = [];
                          if (widget.city.hotels[index].bookingComUrl.isNotEmpty) {
                            highlightedFacilityImagePaths.add('assets/images/custom_icons/bookinglogo.png');
                          }
                          if (widget.city.hotels[index].hotelFacilities.contains(HotelFacility.kitchen)) {
                            highlightedFacilityImagePaths.add('assets/images/custom_icons/kitchen.png');
                          }
                          if (widget.city.hotels[index].hotelFacilities.contains(HotelFacility.vegan) ||
                              widget.city.hotels[index].hotelFacilities.contains(HotelFacility.vegetarian)) {
                            highlightedFacilityImagePaths.add('assets/images/custom_icons/vegan.png');
                          }
                          if (widget.city.hotels[index].hotelFacilities.contains(HotelFacility.communityDinner)) {
                            highlightedFacilityImagePaths.add('assets/images/custom_icons/dinner.png');
                          }
                          Color statusColor = Colors.green;

                          if (widget.city.hotels[index].status == HotelStatus.unknown) {
                            statusColor = Colors.yellow[600]!;
                          } else if (widget.city.hotels[index].status == HotelStatus.closed) {
                            statusColor = Colors.red;
                          } else if (widget.city.hotels[index].status == HotelStatus.temporarilyClosed) {
                            statusColor = Colors.orange;
                          }
                          return Card(
                            child: ListTile(
                              onTap: () =>
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HotelPage(hotel: widget.city.hotels[index]))),
                              iconColor: Colors.amber[800],
                              title: Row(
                                children: [
                                  CircleAvatar(radius: 5, backgroundColor: statusColor),
                                  const SizedBox(width: 5),
                                  Expanded(
                                      child: Text(widget.city.hotels[index].name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                                    child: Wrap(
                                        children: widget.city.hotels[index].prices.map((e) {
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
                                                hotelTypeIconMap[e.type]!,
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
                              //     children: (widget.city.hotels[index].hotelFacilities)
                              //         .map((e) => Icon(
                              //               hotelFacilityIconMap[e],
                              //               size: 20,
                              //               color: Colors.amber[800],
                              //             ))
                              //         .toList()),
                              // visualDensity: const VisualDensity(vertical: VisualDensity.maximumDensity),
                              trailing: widget.city.hotels[index].bookingComScore != 0.0
                                  ? BookingComScore(bookingComScore: widget.city.hotels[index].bookingComScore, size: 30)
                                  : const SizedBox.shrink(),
                            ),
                          );
                        },
                      ),
                    ),
              // ElevatedButton(
              //     onPressed: () {
              //       // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddHotelPage()));
              //       // int id = city.hotels.length;
              //       // newHotels.add(Hotel(id: id, name: name, lat: lat, lon: lon))
              //       generateHotels();
              //     },
              //     child: const Text('Add'))
            ]),
          )),
    );
  }
}
