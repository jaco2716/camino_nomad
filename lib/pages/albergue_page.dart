import 'dart:io';

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
                      const SizedBox(height: 6),
                      Text(albergue.bookingUrl),
                      Text(albergue.checkInTime),
                      Text(albergue.checkOutTime),
                      Text(albergue.cityName),
                      Text(albergue.closeTime),
                      Text(albergue.country),
                      Text(albergue.facebook),
                      Text(albergue.website),
                      Text(albergue.postalCode),
                      Text('${albergue.albergueFacilities}'),
                      Text('${albergue.albergueFacilities}'),
                      Text(albergue.bookingComScore.toString()),
                      Text(albergue.dormatoryAmount.toString()),
                      Text(albergue.dormatoryBedAmount.toString()),
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
}
