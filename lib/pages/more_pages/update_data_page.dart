import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/my_alert_dialog.dart';

class UpdateDataPage extends StatefulWidget {
  const UpdateDataPage({super.key});

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data'),
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, value, child) {
          return SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Current data version:',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    Text(
                      value.appDataSettings.appDataVersion,
                      style: const TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _checkForUpdates(value),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Check for updates'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _checkForUpdates(AppDataProvider appDataP) async {
    String? version = await appDataP.getAppDataVersion();
    if (mounted) {
      if (version == null) {
        showDialog(
          context: context,
          builder: (context) {
            return const MyInfoDialog(
              child: Text('Could not check for updates.\nMake sure your app is up to date or try again later.'),
            );
          },
        );
      } else if (version == appDataP.appDataSettings.appDataVersion) {
        showDialog(
          context: context,
          builder: (context) {
            return const MyInfoDialog(
              child: Text('Your data is up to date.'),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return MyInfoDialog(
              title: 'New version available',
              action: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        _updateHotelData(version);
                      },
                      child: const Text('Update'))
                ],
              ),
              child: Text('New version: $version'),
            );
          },
        );
      }
    }
  }

  void _updateHotelData(String version) async {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => const Dialog(elevation: 0, backgroundColor: Colors.transparent, child: Center(child: CircularProgressIndicator())),
    );
    var result = await context.read<AppDataProvider>().updateHotelsWithHttp(version);
    if (mounted) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) {
          return MyInfoDialog(child: Text(result ? 'Data has been updated!' : 'Could not update data.\nTry again later.'));
        },
      );
    }
  }
}
