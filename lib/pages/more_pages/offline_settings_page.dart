import 'dart:convert';

import 'package:camino_nomad/logic/route_logic.dart';
import 'package:camino_nomad/model/providers/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/env_config.dart' as config;
import '../../logic/file_management.dart';
import '../../logic/url_logic.dart';
import '../../widgets/list_tile_with_icon_sub.dart';

class OfflineSettingsPage extends StatefulWidget {
  const OfflineSettingsPage({super.key});

  @override
  State<OfflineSettingsPage> createState() => _OfflineSettingsPageState();
}

class _OfflineSettingsPageState extends State<OfflineSettingsPage> {
  late SharedPreferences sp;

  Future<bool> getOfflineMode() async {
    sp = await SharedPreferences.getInstance();
    return sp.getBool('offlineMode') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              FutureBuilder(
                  future: getOfflineMode(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.data ?? false) {
                      return ListTileWithIconSub(
                          title: 'stop Camino Frances offline',
                          subtitle: 'Offline Mode On',
                          icon: const FaIcon(FontAwesomeIcons.powerOff),
                          onTap: () async {
                            setState(() {
                              sp.setBool('offlineMode', false);
                            });
                          });
                    }
                    return ListTileWithIconSub(
                        title: 'Save Camino Frances offline',
                        subtitle: 'Offline Mode Off',
                        icon: const FaIcon(FontAwesomeIcons.powerOff, color: Colors.grey),
                        onTap: () async {
                          setState(() {
                            sp.setBool('offlineMode', true);
                          });
                        });
                  }),
              ListTileWithIconSub(
                  title: 'Download Camino Frances',
                  subtitle: 'See data offline',
                  icon: const FaIcon(FontAwesomeIcons.download),
                  onTap: () async {
                    var rp = context.read<RouteProvider>();
                    String json = jsonEncode(rp.routeData);
                    final fm = FileManagement();
                    await fm.writeFile(config.allRutes[0]['localFileName'], json);
                  }),
              ListTileWithIconSub(
                  title: 'Print route data',
                  subtitle: 'json',
                  icon: const FaIcon(FontAwesomeIcons.powerOff),
                  onTap: () async {
                    final rl = RouteLogic();
                    var rp = context.read<RouteProvider>();
                    String json = jsonEncode(rp.routeData);
                    rl.printMore(json);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
