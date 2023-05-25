// import 'dart:convert';
// import 'package:camino_nomad/logic/data_generation.dart';
// import 'package:camino_nomad/model/providers/app_data_provider.dart';
// import 'package:camino_nomad/widgets/left_aligned_title.dart';
// import 'package:camino_nomad/widgets/my_switch_list_tile.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import '../../logic/file_management.dart';
// import '../../widgets/list_tile_with_icon_sub.dart';
// import 'manage_offline_data_page.dart';

// class OfflineSettingsPage extends StatefulWidget {
//   const OfflineSettingsPage({super.key});

//   @override
//   State<OfflineSettingsPage> createState() => _OfflineSettingsPageState();
// }

// class _OfflineSettingsPageState extends State<OfflineSettingsPage> {
//   final dg = DataGeneration();
//   final fm = FileManagement();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Offline Settings'),
//       ),
//       body: SafeArea(
//         child: Consumer<AppDataProvider>(builder: (context, value, _) {
//           bool lowDataMode = value.appDataSettings?.lowDataMode ?? false;

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 50),
//                 ListTileWithIconSub(
//                     title: 'Low Data Mode',
//                     subtitle: lowDataMode ? 'Low Data Mode On' : 'Low Data Mode Off',
//                     icon: FaIcon(FontAwesomeIcons.powerOff, color: lowDataMode ? Colors.green : Colors.grey),
//                     onTap: () => value.setLowDataMode(!lowDataMode)),
//                 MySwitchListTile(title: 'Low Data Mode', onTap: () {}),
//                 const LeftAlignedTitle('In Low Data Mode hotel images will not loaded.', color: Colors.grey, fontWeight: FontWeight.normal, size: 12),
//                 // Text(
//                 //   'In Low Data Mode images will not be loaded for hotels',
//                 //   textAlign: TextAlign.left,
//                 //   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 // ),
//                 const SizedBox(height: 10),
//                 ListTileWithIconSub(
//                     title: 'Offline Data',
//                     subtitle: '${value.kbSaved ?? 0} kb saved.',
//                     icon: const FaIcon(FontAwesomeIcons.download),
//                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageOfflineDataPage()))),
//                 ListTileWithIconSub(
//                     title: 'Download Camino Frances',
//                     subtitle: '${value.kbSaved ?? 0} kb saved.',
//                     icon: const FaIcon(FontAwesomeIcons.download),
//                     onTap: () => value.saveRouteToFile(0)),
//                 ListTileWithIconSub(
//                     title: 'Print route data',
//                     subtitle: 'json',
//                     icon: const FaIcon(FontAwesomeIcons.print),
//                     onTap: () async {
//                       dg.printMore(jsonEncode(value.routeData));
//                     }),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
