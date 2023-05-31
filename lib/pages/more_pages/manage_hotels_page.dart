import 'package:camino_nomad/constants/env_config.dart' as config;
import 'package:camino_nomad/logic/file_management.dart';
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/model/route_info/hotel.dart';
import 'package:camino_nomad/pages/hotel_page/edit_hotel_page.dart';
import 'package:camino_nomad/pages/more_pages/contact_page.dart';
import 'package:camino_nomad/widgets/my_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/booking_com_widgets.dart';
import '../../widgets/button_list_tile.dart';
import '../city_page/hotel_list_tile.dart';
import '../hotel_page/hotel_page.dart';
import 'useful_links_page.dart';
import 'package:share_plus/share_plus.dart';

class ManageHotelsPage extends StatefulWidget {
  const ManageHotelsPage({super.key});

  @override
  State<ManageHotelsPage> createState() => _ManageHotelsPageState();
}

class _ManageHotelsPageState extends State<ManageHotelsPage> {
  final fm = FileManagement();
  List<Hotel> hotels = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Hotels')),
      body: SafeArea(
        child: Consumer<AppDataProvider>(builder: (context, value, _) {
          hotels = value.hotels.reversed.toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ButtonListTile(
                  title: 'Add Hotel',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditHotelPage())),
                ),
                ButtonListTile(
                  title: 'Export Hotels Data',
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const Dialog(elevation: 0, backgroundColor: Colors.transparent, child: Center(child: CircularProgressIndicator())),
                    );

                    await fm.exportFile(config.hotelsFileName);
                    if (mounted) {
                      Navigator.maybePop(context);
                    }
                  },
                ),
                const Divider(),
                Text('Sorted by Latest added. Total: ${hotels.length} hotels'),
                Expanded(
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
              ],
            ),
          );
        }),
      ),
    );
  }
}
