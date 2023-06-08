import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/logic/url_logic.dart';
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/model/route_info/hotel.dart';
import 'package:camino_nomad/pages/hotel_page/edit_hotel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../widgets/hotel_header_images.dart';
import '../../widgets/booking_com_widgets.dart';
import 'hotel_info_list_tile.dart';
import '../../constants/styles_config.dart' as styles;

class HotelPage extends StatefulWidget {
  const HotelPage({super.key, required this.hotelId});
  final int hotelId;

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  late Hotel hotel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Color statusColor = Colors.green;
    // String statusText = hotel.status.name.camelToSentence();
    // if (hotel.status == HotelStatus.unknown) {
    //   statusColor = Colors.yellow[600]!;
    // } else if (hotel.status == HotelStatus.closed) {
    //   statusColor = Colors.red;
    // } else if (hotel.status == HotelStatus.temporarilyClosed) {
    //   statusColor = Colors.orange;
    // }

    return Consumer<AppDataProvider>(builder: (context, value, _) {
      hotel = value.hotels.firstWhere(
        (element) => element.id == widget.hotelId,
        orElse: () => Hotel(id: -1, name: 'Null', lat: 0, lon: 0),
      );

      List<dynamic> highlightedFacilityImagePaths = [];
      if (hotel.bookingComUrl.isNotEmpty) {
        highlightedFacilityImagePaths.add({'image': 'assets/images/custom_icons/bookinglogo.png', 'title': 'Book with Booking.com'});
      }
      if (hotel.hotelFacilities.contains(HotelFacility.kitchen)) {
        highlightedFacilityImagePaths.add({'image': 'assets/images/custom_icons/kitchen.png', 'title': 'Kitchen availabe'});
      }
      if (hotel.hotelFacilities.contains(HotelFacility.vegan) || hotel.hotelFacilities.contains(HotelFacility.vegetarian)) {
        highlightedFacilityImagePaths.add({'image': 'assets/images/custom_icons/vegan.png', 'title': 'Vegetarian options'});
      }
      if (hotel.hotelFacilities.contains(HotelFacility.communityDinner)) {
        highlightedFacilityImagePaths.add({'image': 'assets/images/custom_icons/dinner.png', 'title': 'Community dinner'});
      }
      if (highlightedFacilityImagePaths.isNotEmpty) {
        highlightedFacilityImagePaths.add({'image': const Icon(FontAwesomeIcons.solidCircleQuestion, size: 10, color: Colors.grey), 'title': 'info'});
      }

      return Scaffold(
        appBar: AppBar(
          // title: Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     CircleAvatar(backgroundColor: statusColor.withAlpha(80), radius: 10, child: CircleAvatar(backgroundColor: statusColor, radius: 7)),
          //     const SizedBox(width: 8),
          //     Text(statusText),
          //     const SizedBox(width: 18),
          //   ],
          // ),
          actions: value.appDataSettings.showAdvancedSettings
              ? [
                  IconButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditHotelPage(hotel: hotel),
                            ));
                        setState(() {});
                      },
                      icon: const Icon(Icons.edit))
                ]
              : null,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                HotelHeaderImages(hotel: hotel),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: styles.secoundaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text('${hotel.address},\n${hotel.postalCode} ${hotel.cityName}, ${hotel.country}',
                                  style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
                            ),
                            IconButton(
                              onPressed: () => UrlLogic.openMapApp(hotel.lat, hotel.lon),
                              icon: const Icon(Icons.directions),
                              color: styles.primaryColor,
                              iconSize: 40,
                            ),
                          ],
                        ),
                        // const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Info:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              const SizedBox(height: 6),
                              Column(
                                  children: hotel.prices.map((e) {
                                String priceString = '';
                                if (e.fromPrice != null && e.toPrice != null) {
                                  priceString = '${e.fromPrice!.round()}-${e.toPrice!.round()}€';
                                } else if (e.fromPrice != null) {
                                  priceString = '${e.fromPrice!.round()}€ +';
                                } else {
                                  priceString = '${e.toPrice!.round()}€';
                                }
                                return Container(
                                  height: 24,
                                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        child: Image.asset(
                                          hotelTypeIconMap[e.type]!,
                                          color: styles.primaryColor,
                                          // size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(e.type.name.camelToSentence()),
                                      const Spacer(),
                                      Text(priceString),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                );
                              }).toList()),
                              // const SizedBox(height: 10),
                              HotelInfoListTile('Check-in:', trailing: hotel.checkInTime, show: hotel.checkInTime.isNotEmpty),
                              HotelInfoListTile('Check-out:', trailing: hotel.checkOutTime, show: hotel.checkOutTime.isNotEmpty),
                              HotelInfoListTile('Close:', trailing: hotel.closeTime, show: hotel.closeTime.isNotEmpty),
                              HotelInfoListTile('Beds:', trailing: '${hotel.dormatoryBedAmount}', show: hotel.dormatoryBedAmount > 0),
                              HotelInfoListTile('Dormitories:', trailing: '${hotel.dormatoryAmount}', show: hotel.dormatoryAmount > 0),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            hotel.hotelFacilities.isNotEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 24.0, bottom: 6, top: 12),
                                    child: Text('Facilities:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                  )
                                : const SizedBox.shrink(),
                            GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              childAspectRatio: 8,
                              children: hotel.hotelFacilities
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6),
                                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                                          const Icon(
                                            Icons.check,
                                            // hotelFacilityIconMap[e],
                                            size: 15,
                                            color: styles.primaryColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(e.name.camelToSentence())
                                        ]),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 16),
                        BookingAndFacebookRow(hotel: hotel),
                        // const SizedBox(height: 16),
                        hotel.website.isNotEmpty
                            ? Center(
                                child: TextButton(
                                    onPressed: () => UrlLogic.launchUrlFunc(hotel.website),
                                    child: const Text('Visit Website →',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: styles.primaryColor
                                            // color: styles.secoundaryColor,
                                            ))),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 6),
                        Center(
                          child: Column(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: hotel.emails.map((e) => ContactTextButton(name: e, url: 'mailto:$e')).toList()),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: hotel.phones.map((e) {
                                    String number = e.split('whatsapp')[0];
                                    return ContactTextButton(
                                        name: number,
                                        icon: e.contains('whatsapp') ? const Icon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 18) : null,
                                        url: 'tel:$number');
                                  }).toList()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class BookingAndFacebookRow extends StatelessWidget {
  const BookingAndFacebookRow({
    super.key,
    required this.hotel,
  });

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    List<Widget> tileWidgets = [];
    if (hotel.bookingComUrl.isNotEmpty && hotel.bookingComScore != 0.0) {
      tileWidgets.add(Row(
        children: [
          BookingComLink(url: hotel.bookingComUrl),
          BookingComScore(bookingComScore: hotel.bookingComScore),
        ],
      ));
    } else if (hotel.bookingComUrl.isNotEmpty) {
      tileWidgets.add(BookingComLink(url: hotel.bookingComUrl));
    } else if (hotel.bookingComScore != 0.0) {
      tileWidgets.add(BookingComScore(bookingComScore: hotel.bookingComScore));
    }

    if (hotel.facebook.isNotEmpty) {
      tileWidgets.add(IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => UrlLogic.launchUrlFunc(hotel.facebook),
        iconSize: 55,
        icon: Icon(
          Icons.facebook,
          color: Colors.blue[700],
        ),
      ));
    }
    if (tileWidgets.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: tileWidgets),
    );
  }
}

class ContactTextButton extends StatelessWidget {
  const ContactTextButton({
    super.key,
    required this.name,
    required this.url,
    this.icon,
  });
  final String name;
  final String url;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: name)).then((value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Copied to clipboard"),
              duration: Duration(seconds: 1, milliseconds: 400),
            )));
      },
      onPressed: () => UrlLogic.launchUrlFunc(url),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name),
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: icon,
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}



// // Highlighted Facilities
                      // InkWell(
                      //   borderRadius: BorderRadius.circular(10),
                      //   onTap: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return MyInfoDialog(
                      //           child: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: highlightedFacilityImagePaths
                      //                 .map((e) => e['title'] == 'info'
                      //                     ? const SizedBox.shrink()
                      //                     : SizedBox(
                      //                         height: 35,
                      //                         child: Row(
                      //                           children: [
                      //                             Padding(
                      //                               padding: const EdgeInsets.all(6.0),
                      //                               child: Image.asset(
                      //                                 e['image'],
                      //                                 color: e['image'].contains('bookinglogo') ? null : styles.secoundaryColor,
                      //                               ),
                      //                             ),
                      //                             Text(e['title']),
                      //                           ],
                      //                         )))
                      //                 .toList(),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                      //     child: Wrap(
                      //         children: highlightedFacilityImagePaths
                      //             .map((e) => e['title'] == 'info'
                      //                 ? (e['image'] as Widget)
                      //                 : SizedBox(
                      //                     height: 30,
                      //                     child: Padding(
                      //                       padding: const EdgeInsets.only(right: 8.0),
                      //                       child: Image.asset(
                      //                         e['image'],
                      //                         color: e['image'].contains('bookinglogo') ? null : styles.secoundaryColor,
                      //                       ),
                      //                     )))
                      //             .toList()),
                      //   ),
                      // ),