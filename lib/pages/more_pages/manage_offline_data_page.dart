import 'package:camino_nomad/logic/route_logic.dart';
import 'package:camino_nomad/model/providers/route_provider.dart';
import 'package:camino_nomad/widgets/left_aligned_title.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../logic/file_management.dart';
import '../../widgets/list_tile_with_icon_sub.dart';

class ManageOfflineDataPage extends StatefulWidget {
  const ManageOfflineDataPage({super.key});

  @override
  State<ManageOfflineDataPage> createState() => _ManageOfflineDataPageState();
}

class _ManageOfflineDataPageState extends State<ManageOfflineDataPage> {
  final rl = RouteLogic();
  final fm = FileManagement();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Settings'),
      ),
      body: SafeArea(
        child: Consumer<RouteProvider>(builder: (context, value, _) {
          bool offlineMode = value.offlineMode ?? false;
          bool lowDataMode = value.lowDataMode ?? false;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTileWithIconSub(
                    title: 'Offline Mode',
                    subtitle: offlineMode ? 'Offline Mode On' : 'Offline Mode Off',
                    icon: FaIcon(FontAwesomeIcons.powerOff, color: offlineMode ? Colors.green : Colors.grey),
                    onTap: () => value.setOfflineMode(!offlineMode)),
                const LeftAlignedTitle('In Low Data Mode hotel images will not loaded.', color: Colors.grey, fontWeight: FontWeight.normal, size: 12),
                const SizedBox(height: 10),
                ListTileWithIconSub(
                    title: 'Download Camino Frances',
                    subtitle: '${value.kbSaved ?? 0} kb saved.',
                    icon: const FaIcon(FontAwesomeIcons.download),
                    onTap: () => value.saveDataToFile(0)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
