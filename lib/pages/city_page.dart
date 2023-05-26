import 'dart:convert';
import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/model/route_info/hotel_price.dart';
import 'package:camino_nomad/widgets/my_alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
  // List<Hotel> newHotels = [];
  final rl = RouteLogic();
  List<Widget> facilityRow = [];

  List<Hotel> hotels = [];
  late AppDataProvider appDataP;
  double filterDistance = 5;
  static const List<String> sortByList = <String>[
    'Distance to city center',
    'Rating',
    'Price: Low - High',
    'Price: High - Low',
  ];
  String sortByValue = sortByList.first;

  @override
  void initState() {
    super.initState();
    appDataP = context.read<AppDataProvider>();
    // for (var hotel in appDataP.hotels) {
    //   double distance = rl.calculateDistance(hotel.lat, hotel.lon, widget.city.lat, widget.city.lon);
    //   if (distance < filterDistance) {
    //     hotel.cityDistance = distance;
    //     hotels.add(hotel);
    //   }
    // }
    hotels = filterHotelsWithDistance();
    hotels.sort((a, b) => a.cityDistance?.compareTo(b.cityDistance ?? filterDistance) ?? 1);
    // hotels = appDataP.hotels.where((hotel) {
    //   double distance = rl.calculateDistance(hotel.lat, hotel.lon, widget.city.lat, widget.city.lon);
    //   return distance < filterDistance;
    // }).toList();
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

  List<Hotel> filterHotelsWithDistance() {
    List<Hotel> filterHotels = [];
    for (var hotel in appDataP.hotels) {
      double distance = rl.calculateDistance(hotel.lat, hotel.lon, widget.city.lat, widget.city.lon);
      if (distance < filterDistance) {
        hotel.cityDistance = distance;
        filterHotels.add(hotel);
      }
    }
    return filterHotels;
  }

  // generateHotels() async {
  //   final rl = RouteLogic();
  //   int startID = hotels.length;

  //   rl.generateHotels(startID, widget.city);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city.name),
        // actions: [],
      ),
      body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              //   child: Row(
              //     children: [
              //       const Icon(Icons.location_on, size: 18, color: Colors.blue),
              //       Text('${widget.totalDistance.toStringAsFixed(1)} km', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
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
              Row(
                children: [
                  const Expanded(child: LeftAlignedTitle('Accomodations')),
                  TextButton.icon(
                      onPressed: () {
                        double currentSliderValue = filterDistance;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return MyInfoDialog(
                              action: TextButton(
                                child: const Text('Search'),
                                onPressed: () {
                                  filterDistance = currentSliderValue;
                                  hotels = filterHotelsWithDistance();
                                  if (sortByValue == sortByList[0]) {
                                    hotels.sort((a, b) => a.cityDistance?.compareTo(b.cityDistance ?? filterDistance) ?? 1);
                                  } else if (sortByValue == sortByList[1]) {
                                    hotels.sort((a, b) => b.bookingComScore.compareTo(a.bookingComScore));
                                  } else if (sortByValue == sortByList[2]) {
                                    hotels.sort((a, b) => getLowestPrice(a.prices).compareTo(getLowestPrice(b.prices)));
                                  } else if (sortByValue == sortByList[3]) {
                                    hotels.sort((a, b) => getLowestPrice(b.prices).compareTo(getLowestPrice(a.prices)));
                                  }
                                  setState(() {});
                                  Navigator.maybePop(context);
                                },
                              ),
                              child: StatefulBuilder(builder: (context, modalState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Filter',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Divider(),
                                    const SizedBox(height: 20),
                                    LeftAlignedTitle('Sort by', leftPadding: 0),
                                    const SizedBox(height: 10),
                                    Container(
                                      // margin: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey[400]!),
                                      ),
                                      // width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: sortByValue,
                                          icon: const Icon(Icons.arrow_drop_down_rounded),
                                          elevation: 16,
                                          onChanged: (String? value) {
                                            // This is called when the user selects an item.
                                            modalState(() {
                                              sortByValue = value!;
                                            });
                                          },
                                          dropdownColor: Colors.white,
                                          underline: const SizedBox.shrink(),
                                          items: sortByList.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    LeftAlignedTitle('Distance:  ${currentSliderValue.round()} km', leftPadding: 0),
                                    Slider(
                                      min: 1,
                                      value: currentSliderValue,
                                      max: 50,
                                      divisions: 50,
                                      label: currentSliderValue.round().toString(),
                                      onChanged: (double value) {
                                        modalState(() => currentSliderValue = value.roundToDouble());
                                      },
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                        );
                      },
                      icon: const Icon(FontAwesomeIcons.arrowDownWideShort),
                      label: const Text('')),
                ],
              ),
              hotels.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.0),
                      child: Text('No Accomodations'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: hotels.length,
                        itemBuilder: (BuildContext context, int index) {
                          // List<String> highlightedFacilityImagePaths = [];
                          // if (hotels[index].bookingComUrl.isNotEmpty) {
                          //   highlightedFacilityImagePaths.add('assets/images/custom_icons/bookinglogo.png');
                          // }
                          // if (hotels[index].hotelFacilities.contains(HotelFacility.kitchen)) {
                          //   highlightedFacilityImagePaths.add('assets/images/custom_icons/kitchen.png');
                          // }
                          // if (hotels[index].hotelFacilities.contains(HotelFacility.vegan) ||
                          //     hotels[index].hotelFacilities.contains(HotelFacility.vegetarian)) {
                          //   highlightedFacilityImagePaths.add('assets/images/custom_icons/vegan.png');
                          // }
                          // if (hotels[index].hotelFacilities.contains(HotelFacility.communityDinner)) {
                          //   highlightedFacilityImagePaths.add('assets/images/custom_icons/dinner.png');
                          // }
                          Color statusColor = statusToColor(hotels[index].status);

                          String hotelDist = distToString(hotels[index].cityDistance);

                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HotelPage(hotel: hotels[index]))),
                              iconColor: Colors.amber[800],
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: CircleAvatar(radius: 5, backgroundColor: statusColor),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(child: Text(hotels[index].name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(hotelDist, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue)),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                          children: hotels[index].prices.map((e) {
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
                                    hotels[index].bookingComScore != 0.0
                                        ? BookingComScore(bookingComScore: hotels[index].bookingComScore, size: 30)
                                        : const SizedBox.shrink(),
                                    // Wrap(
                                    //     children: highlightedFacilityImagePaths
                                    //         .map((e) => SizedBox(
                                    //             height: 20,
                                    //             child: Padding(
                                    //               padding: const EdgeInsets.only(right: 8.0),
                                    //               child: Image.asset(
                                    //                 e,
                                    //                 color: e.contains('bookinglogo') ? null : Colors.blue,
                                    //               ),
                                    //             )))
                                    //         .toList()),
                                  ],
                                ),
                              ),
                              // Wrap(
                              //     children: (hotels[index].hotelFacilities)
                              //         .map((e) => Icon(
                              //               hotelFacilityIconMap[e],
                              //               size: 20,
                              //               color: Colors.amber[800],
                              //             ))
                              //         .toList()),
                              // visualDensity: const VisualDensity(vertical: VisualDensity.maximumDensity),
                              // trailing: Column(
                              //   children: [
                              //     Text(hotelDist, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
                              //     hotels[index].bookingComScore != 0.0
                              //         ? BookingComScore(bookingComScore: hotels[index].bookingComScore, size: 30)
                              //         : const SizedBox.shrink(),
                              //   ],
                              // ),
                            ),
                          );
                        },
                      ),
                    ),
            ]),
          )),
    );
  }

  String distToString(double? dist) {
    if (dist == null) {
      return '- km';
    } else if (dist < 1) {
      return '${(dist * 1000).round()} m';
    } else {
      return '${(dist.toStringAsFixed(2))} km';
    }
  }

  Color statusToColor(HotelStatus status) {
    if (status == HotelStatus.unknown) {
      return Colors.yellow[600]!;
    } else if (status == HotelStatus.closed) {
      return Colors.red;
    } else if (status == HotelStatus.temporarilyClosed) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  double getLowestPrice(List<HotelPrice> prices) {
    return prices.fold<double>(999, (min, e) {
      if (e.fromPrice != null) {
        return e.fromPrice! < min ? e.fromPrice! : min;
      } else if (e.toPrice != null) {
        return e.toPrice! < min ? e.toPrice! : min;
      }
      return min;
    });
  }
}
