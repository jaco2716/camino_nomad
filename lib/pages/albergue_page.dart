import 'dart:io';

import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/logic/url_logic.dart';
import 'package:camino_nomad/model/route_info/albergue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/albergue_header_images.dart';

class AlberguePage extends StatelessWidget {
  AlberguePage({super.key, required this.albergue});
  final Albergue albergue;
  final ul = UrlLogic();

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
                            width: 170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Info:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                const SizedBox(height: 6),
                                Column(
                                    children: albergue.prices.map((e) {
                                  String priceString = '';
                                  if (e.fromPrice != null && e.toPrice != null) {
                                    priceString = '${e.fromPrice!.round()}-${e.toPrice!.round()}€';
                                  } else if (e.fromPrice != null) {
                                    priceString = '${e.fromPrice!.round()}€ +';
                                  } else {
                                    priceString = '${e.toPrice!.round()}€';
                                  }
                                  return Row(
                                    children: [
                                      Icon(
                                        albergueTypeIconMap[e.type],
                                        color: Colors.amber[800],
                                        size: 18,
                                      ),
                                      Text(e.type.name.camelToSentence()),
                                      const Spacer(),
                                      Text(priceString)
                                    ],
                                  );
                                }).toList()),
                                albergue.checkInTime.isNotEmpty
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [const Text('Check-in:'), Text(albergue.checkInTime)])
                                    : const SizedBox.shrink(),
                                albergue.checkOutTime.isNotEmpty
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [const Text('Check-out:'), Text(albergue.checkOutTime)])
                                    : const SizedBox.shrink(),
                                albergue.closeTime.isNotEmpty
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Close:'), Text(albergue.closeTime)])
                                    : const SizedBox.shrink(),
                                albergue.dormatoryBedAmount > 0
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [const Text('Beds:'), Text('${albergue.dormatoryBedAmount}')])
                                    : const SizedBox.shrink(),
                                albergue.dormatoryAmount > 0
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [const Text('Dormitories:'), Text('${albergue.dormatoryAmount}')])
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          albergue.bookingComUrl.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: TextButton(
                                    onPressed: () => ul.launchUrlFunc(albergue.bookingComUrl),
                                    child: const Text('Booking.com',
                                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19, color: Colors.blue, letterSpacing: -1)),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          albergue.bookingComScore != 0.0
                              ? Container(
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
                                    color: Colors.blue[800],
                                  ),
                                  child: Text(
                                    '${albergue.bookingComScore}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const Spacer(),
                          albergue.facebook.isNotEmpty
                              ? IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => ul.launchUrlFunc(albergue.facebook),
                                  iconSize: 55,
                                  icon: Icon(
                                    Icons.facebook,
                                    color: Colors.blue[700],
                                  ),
                                )
                              : const SizedBox.shrink(),
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
                      albergue.website.isNotEmpty
                          ? Center(
                              child: TextButton(
                                  onPressed: () => ul.launchUrlFunc(albergue.website),
                                  child: Text('Visit Website →',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.amber[800]
                                          // color: Colors.blue,
                                          ))),
                            )
                          : const SizedBox.shrink(),

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Text('Contact:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: albergue.emails.map((e) => ContactTextButton(name: e, url: 'mailto:$e')).toList()),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: albergue.phones.map((e) => ContactTextButton(name: e, url: 'tel:$e')).toList()),
                            ],
                          ),
                        ),
                      ),
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
}

class ContactTextButton extends StatelessWidget {
  ContactTextButton({
    super.key,
    required this.name,
    required this.url,
  });
  final String name;
  final String url;

  final ul = UrlLogic();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: name)).then((value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Copied to clipboard"),
              duration: Duration(seconds: 1),
            )));
      },
      onPressed: () => ul.launchUrlFunc(url),
      child: Text(name),
    );
  }
}
