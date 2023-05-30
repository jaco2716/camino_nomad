import 'package:camino_nomad/constants/env_config.dart' as config;
import 'package:camino_nomad/logic/file_management.dart';
import 'package:camino_nomad/pages/hotel_page/edit_hotel_page.dart';
import 'package:camino_nomad/pages/more_pages/contact_page.dart';
import 'package:flutter/material.dart';
import '../../widgets/button_list_tile.dart';
import 'useful_links_page.dart';
import 'package:share_plus/share_plus.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> with AutomaticKeepAliveClientMixin {
  final fm = FileManagement();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            // ButtonListTile(
            //   title: 'Offline Settings',
            //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OfflineSettingsPage())),
            // ),
            // ButtonListTile(
            //   title: 'Updates',
            //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ComingSoonPage())),
            // ),
            ButtonListTile(
              title: 'Share app',
              onTap: () {
                Share.share('Download Camino Nomad for iOS and Android: https://caminonomad.com');
              },
            ),
            ButtonListTile(
              title: 'Useful links',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UsefulLinksPage())),
            ),
            ButtonListTile(
              title: 'Contact',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactPage())),
            ),
            ButtonListTile(
              title: 'Add Hotel',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditHotelPage())),
            ),
            ButtonListTile(
              title: 'Export Hotels Data',
              onTap: () => fm.exportFile(config.hotelsFileName),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
