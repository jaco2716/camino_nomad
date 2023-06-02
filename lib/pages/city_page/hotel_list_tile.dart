import 'package:flutter/material.dart';
import '../../model/route_info/hotel.dart';
import '../../widgets/booking_com_widgets.dart';
import '../hotel_page/hotel_page.dart';

class HotelListTile extends StatelessWidget {
  const HotelListTile({super.key, required this.hotel});

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    // Color statusColor = statusToColor(hotel.status);

    String hotelDist = distToString(hotel.cityDistance);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HotelPage(hotelId: hotel.id))),
        iconColor: Colors.amber[800],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS, add later
            // Padding(
            //   padding: const EdgeInsets.only(top: 4.0),
            //   child: CircleAvatar(radius: 5, backgroundColor: statusColor),
            // ),
            // const SizedBox(width: 5),
            Expanded(child: Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
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
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...hotel.prices.map((e) {
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
                    }).toList(),
                    // Text(
                    //   'B',
                    //   style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w900),
                    // ),
                    hotel.bookingComUrl.isNotEmpty
                        ? SizedBox(width: 12, child: Image.asset('assets/images/custom_icons/bookinglogo.png'))
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              hotel.bookingComScore != 0.0 ? BookingComScore(bookingComScore: hotel.bookingComScore, size: 30) : const SizedBox.shrink(),
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
        //     children: (hotel.hotelFacilities)
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
        //     hotel.bookingComScore != 0.0
        //         ? BookingComScore(bookingComScore: hotel.bookingComScore, size: 30)
        //         : const SizedBox.shrink(),
        //   ],
        // ),
      ),
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

  // Color statusToColor(HotelStatus status) {
  //   if (status == HotelStatus.unknown) {
  //     return Colors.yellow[600]!;
  //   } else if (status == HotelStatus.closed) {
  //     return Colors.red;
  //   } else if (status == HotelStatus.temporarilyClosed) {
  //     return Colors.orange;
  //   } else {
  //     return Colors.green;
  //   }
  // }
}
