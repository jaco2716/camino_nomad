import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLogic {
  static launchUrlFunc(url) async {
    final uri = Uri.parse(url);

    try {
      var mode = Platform.isAndroid ? LaunchMode.externalApplication : LaunchMode.platformDefault;
      await launchUrl(uri, mode: mode);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  static Future<void> openMapApp(double latitude, double longitude) async {
    try {
      // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&travelmode=walking';
      var url = '';
      var urlAppleMaps = '';
      if (Platform.isAndroid) {
        url = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&travelmode=walking";
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
          Uri uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&travelmode=walking");
          await launchUrl(uri);
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
