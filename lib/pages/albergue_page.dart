import 'dart:io';

import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/model/route_info/albergue.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/albergue_header_images.dart';

class AlberguePage extends StatelessWidget {
  const AlberguePage({super.key, required this.albergue});
  final Albergue albergue;

  static Future<void> openMap(double latitude, double longitude) async {
    // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&travelmode=walking';
    var url = '';
    var urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$latitude,$longitude';
      url = "comgooglemaps://?saddr=&daddr=$latitude,$longitude&directionsmode=walking";
    }

    Uri uri = Uri.parse(url);
    bool result = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!result) {
      Uri uriapple = Uri.parse(urlAppleMaps);
      result = await launchUrl(uriapple, mode: LaunchMode.externalApplication);
      if (!result) {
        Uri uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
        await launchUrl(uri);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.green;
    String statusText = '${albergue.status.name[0].toUpperCase()}${albergue.status.name.substring(1)}';
    if (albergue.status == AlbergueStatus.unknown) {
      statusColor = Colors.yellow[600]!;
    } else if (albergue.status == AlbergueStatus.closed) {
      statusColor = Colors.red;
    } else if (albergue.status == AlbergueStatus.temporarilyClosed) {
      statusColor = Colors.orange;
      statusText = 'Temporarily Closed';
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(backgroundColor: statusColor.withAlpha(80), radius: 10, child: CircleAvatar(backgroundColor: statusColor, radius: 7)),
            const SizedBox(width: 8),
            Text(statusText),
            const SizedBox(width: 18),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              AlbergueHeaderImages(albergue: albergue),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(albergue.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text('${albergue.address},\n${albergue.postalCode} ${albergue.cityName}, ${albergue.country}',
                                style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
                          ),
                          IconButton(
                            onPressed: () => openMap(albergue.lat, albergue.lon),
                            icon: const Icon(Icons.directions),
                            color: Colors.amber[800],
                            iconSize: 40,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Facilities:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                const SizedBox(height: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: albergue.albergueFacilities
                                      .map((e) => Row(children: [
                                            Icon(
                                              albergueFacilityIconMap[e],
                                              size: 25,
                                              color: Colors.amber[800],
                                            ),
                                            const SizedBox(width: 6),
                                            Text(e.name.camelToSentence())
                                          ]))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 135,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Info:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Check-in:'),
                                        const Text('Check-out:'),
                                        const Text('Doors Close:'),
                                        albergue.dormatoryBedAmount > 0 ? const Text('Beds:') : const SizedBox.shrink(),
                                        albergue.dormatoryAmount > 0 ? const Text('Dormitories:') : const SizedBox.shrink(),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(albergue.checkInTime),
                                        Text(albergue.checkOutTime),
                                        Text(albergue.closeTime),
                                        albergue.dormatoryBedAmount > 0 ? Text('${albergue.dormatoryBedAmount}') : const SizedBox.shrink(),
                                        albergue.dormatoryAmount > 0 ? Text('${albergue.dormatoryAmount}') : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Booking.com',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19, color: Colors.blue, letterSpacing: -1),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: Colors.blue[800],
                            ),
                            child: Text(
                              albergue.bookingComScore != 0.0 ? '${albergue.bookingComScore}' : '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      // Material(
                      //   borderRadius: BorderRadius.circular(6),
                      //   clipBehavior: Clip.hardEdge,
                      //   color: Colors.blue,
                      //   child: InkWell(
                      //     onTap: () => _launchUrl('https://www.booking.com/'),
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      //       child: Text(
                      //         albergue.bookingComScore != 0.0 ? '${albergue.bookingComScore} Booking.com' : ' --  Booking.com',
                      //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Text(albergue.bookingComUrl),
                      Text(albergue.facebook),
                      Text(albergue.website),
                      Text(albergue.bookingComScore.toString()),
                      Text(albergue.emails.toString()),
                      Text(albergue.phones.toString()),
                      Text(albergue.prices.toString()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _launchUrl(url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
