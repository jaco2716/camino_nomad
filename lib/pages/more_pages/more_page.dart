import 'package:camino_nomad/logic/file_management.dart';
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/pages/more_pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/button_list_tile.dart';
import 'manage_hotels_page.dart';
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
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) =>
                      const Dialog(elevation: 0, backgroundColor: Colors.transparent, child: Center(child: CircularProgressIndicator())),
                );
                await Share.shareWithResult('Download Camino Nomad for iOS and Android: https://caminonomad.com');
                if (mounted) {
                  Navigator.maybePop(context);
                }
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

            Consumer<AppDataProvider>(builder: (context, value, _) {
              return value.appDataSettings.showAdvancedSettings
                  ? Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: ButtonListTile(
                        title: 'Manage Hotels',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageHotelsPage())),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
