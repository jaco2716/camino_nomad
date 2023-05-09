import 'package:camino_nomad/extensions/string_extensions.dart';
import 'package:camino_nomad/logic/url_logic.dart';
import 'package:camino_nomad/model/route_info/albergue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/albergue_header_images.dart';
import '../../widgets/booking_com_widgets.dart';
import 'albergue_info_list_tile.dart';

class AlberguePage extends StatelessWidget {
  const AlberguePage({super.key, required this.albergue});
  final Albergue albergue;

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.green;
    String statusText = albergue.status.name.camelToSentence();
    if (albergue.status == AlbergueStatus.unknown) {
      statusColor = Colors.yellow[600]!;
    } else if (albergue.status == AlbergueStatus.closed) {
      statusColor = Colors.red;
    } else if (albergue.status == AlbergueStatus.temporarilyClosed) {
      statusColor = Colors.orange;
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
                            onPressed: () => UrlLogic.openMapApp(albergue.lat, albergue.lon),
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
                                              Icons.check,
                                              // albergueFacilityIconMap[e],
                                              size: 22,
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
                                AlbergueInfoListTile('Check-in:', trailing: albergue.checkInTime, show: albergue.checkInTime.isNotEmpty),
                                AlbergueInfoListTile('Check-out:', trailing: albergue.checkInTime, show: albergue.checkOutTime.isNotEmpty),
                                AlbergueInfoListTile('Close:', trailing: albergue.closeTime, show: albergue.closeTime.isNotEmpty),
                                AlbergueInfoListTile('Beds:', trailing: '${albergue.dormatoryBedAmount}', show: albergue.dormatoryBedAmount > 0),
                                AlbergueInfoListTile('Dormitories:', trailing: '${albergue.dormatoryAmount}', show: albergue.dormatoryAmount > 0),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      BookingAndFacebookRow(albergue: albergue),
                      const SizedBox(height: 12),
                      albergue.website.isNotEmpty
                          ? Center(
                              child: TextButton(
                                  onPressed: () => UrlLogic.launchUrlFunc(albergue.website),
                                  child: Text('Visit Website →',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.amber[800]
                                          // color: Colors.blue,
                                          ))),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 6),
                      Center(
                        child: Column(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: albergue.emails.map((e) => ContactTextButton(name: e, url: 'mailto:$e')).toList()),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: albergue.phones.map((e) => ContactTextButton(name: e, url: 'tel:$e')).toList()),
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
  }
}

class BookingAndFacebookRow extends StatelessWidget {
  const BookingAndFacebookRow({
    super.key,
    required this.albergue,
  });

  final Albergue albergue;

  @override
  Widget build(BuildContext context) {
    List<Widget> tileWidgets = [];
    if (albergue.bookingComUrl.isNotEmpty && albergue.bookingComScore != 0.0) {
      tileWidgets.add(Row(
        children: [
          BookingComLink(url: albergue.bookingComUrl),
          BookingComScore(bookingComScore: albergue.bookingComScore),
        ],
      ));
    } else if (albergue.bookingComUrl.isNotEmpty) {
      tileWidgets.add(BookingComLink(url: albergue.bookingComUrl));
    } else if (albergue.bookingComScore != 0.0) {
      tileWidgets.add(BookingComScore(bookingComScore: albergue.bookingComScore));
    }

    if (albergue.facebook.isNotEmpty) {
      tileWidgets.add(IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => UrlLogic.launchUrlFunc(albergue.facebook),
        iconSize: 55,
        icon: Icon(
          Icons.facebook,
          color: Colors.blue[700],
        ),
      ));
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: tileWidgets);
  }
}

class ContactTextButton extends StatelessWidget {
  const ContactTextButton({
    super.key,
    required this.name,
    required this.url,
  });
  final String name;
  final String url;

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
      child: Text(name),
    );
  }
}
