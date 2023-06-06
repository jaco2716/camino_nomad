import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/model/route_info/hotel_price.dart';
import 'package:camino_nomad/widgets/my_alert_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../logic/route_logic.dart';
import 'package:flutter/material.dart';
import '../../model/route_info/hotel.dart';
import '../../model/route_info/route_city.dart';
import '../../widgets/left_aligned_title.dart';
import 'hotel_list_tile.dart';

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
  double filterDistance = 3;
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
    // hotels = filterHotelsWithDistance();
    // hotels.sort((a, b) => a.cityDistance?.compareTo(b.cityDistance ?? filterDistance) ?? 1);
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
    if (sortByValue == sortByList[0]) {
      filterHotels.sort((a, b) => a.cityDistance?.compareTo(b.cityDistance ?? filterDistance) ?? 1);
    } else if (sortByValue == sortByList[1]) {
      filterHotels.sort((a, b) => b.bookingComScore.compareTo(a.bookingComScore));
    } else if (sortByValue == sortByList[2]) {
      filterHotels.sort((a, b) => getLowestPrice(a.prices).compareTo(getLowestPrice(b.prices)));
    } else if (sortByValue == sortByList[3]) {
      filterHotels.sort((a, b) => getLowestPrice(b.prices).compareTo(getLowestPrice(a.prices)));
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
          child: Consumer<AppDataProvider>(builder: (context, value, _) {
            hotels = filterHotelsWithDistance();
            return Padding(
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
                                    // hotels = filterHotelsWithDistance();

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
                                      const LeftAlignedTitle('Sort by', leftPadding: 0),
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
                                        max: 30,
                                        divisions: 30,
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

                            return HotelListTile(hotel: hotels[index]);
                          },
                        ),
                      ),
              ]),
            );
          })),
    );
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
