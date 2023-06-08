import 'package:camino_nomad/constants/env_config.dart' as config;
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/styles_config.dart' as styles;

class ChooseRoutePage extends StatefulWidget {
  const ChooseRoutePage({super.key});

  @override
  State<ChooseRoutePage> createState() => _ChooseRoutePageState();
}

class _ChooseRoutePageState extends State<ChooseRoutePage> {
  // static const List<Map<String, dynamic>> dataList = [
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextFormField(
            //   decoration: const InputDecoration(
            //     filled: true,
            //     fillColor: Colors.white,
            //     prefixIcon: Icon(Icons.search),
            //     isDense: true,
            //     hintText: 'Search...',
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: config.allRoutes.length,
                itemBuilder: (context, index) {
                  return Theme(
                    data: Theme.of(context).copyWith(textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 13, color: Colors.grey))),
                    child: Card(
                        child: InkWell(
                      onTap: () async {
                        var appDataP = context.read<AppDataProvider>();
                        appDataP.setRouteId(config.allRoutes[index].id);
                        // appDataP.appDataSettings.routeId = config.allRoutes[index].id;
                        // await appDataP.getRouteData();

                        if (mounted) Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    config.allRoutes[index].name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ),
                                Text(
                                  ' ${config.allRoutes[index].distance} km',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: styles.primaryColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Elevation min/max:'),
                                Text('${config.allRoutes[index].eleMin.round()} m / ${config.allRoutes[index].eleMax.round()} m')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Elevation gain/loss:'),
                                Text('${config.allRoutes[index].eleGain.round()} m / -${config.allRoutes[index].eleLoss.round()} m')
                              ],
                            ),
                            // Row(
                            //   children: const [
                            //     // Spacer(),
                            //     CircleAvatar(
                            //       radius: 8,
                            //       backgroundColor: styles.secoundaryColor,
                            //       child: Icon(
                            //         Icons.download,
                            //         color: Colors.white,
                            //         size: 11,
                            //       ),
                            //     ),
                            //     SizedBox(width: 6),
                            //     Text('Downloaded'),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    )),
                  );
                },
              ),
            ),
            const Expanded(child: Text('More routes coming soon...'))
          ],
        ),
      )),
    );
  }
}
