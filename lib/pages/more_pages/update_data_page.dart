import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

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
      body: SafeArea(
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
                const Text(
                  'v2',
                  style: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _checkForUpdates,
                  child: const Text('Check for updates'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkForUpdates() async {
    String version = await _getAppDataVersion();

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return MyInfoDialog(
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
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const MyInfoDialog(child: Text('Advanced Settings Disabled'));
                        },
                      );
                    },
                    child: const Text('Update'))
              ],
            ),
            child: Text(' $version'),
          );
        },
      );
    }
  }

  Future<String> _getAppDataVersion() async {
    var response = await http.get(Uri.parse('https://caminonomad.com/wp-content/uploads/app_data/data_version.txt'));
    if (response.body.length < 16) return '';
    print(response.body.substring(0, 16));
    if (response.body.substring(0, 16) == 'Appdata Version:') {
      String version = response.body.substring(16);
      return version;
    } else {
      return '';
    }
  }
}
