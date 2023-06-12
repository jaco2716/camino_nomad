import 'dart:async';
import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/widgets/list_tile_with_icon_sub.dart';
import 'package:camino_nomad/widgets/my_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../logic/url_logic.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int tapCounter = 0;
  Timer? _timer;

  void hiddenTapped() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      tapCounter = 0;
    });
    if (_timer?.isActive ?? false) tapCounter++;

    if (tapCounter > 10) {
      var controller = TextEditingController();
      showDialog(
        context: context,
        builder: (context) {
          return MyInfoDialog(
            title: 'Access Advanced Settings',
            action: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                    child: const Text('Activate'),
                    onPressed: () {
                      if (controller.text == 'JK1406') {
                        Navigator.pop(context);
                        context.read<AppDataProvider>().setAdvancedSettings(true);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const MyInfoDialog(child: Text('Advanced Settings activated'));
                          },
                        );
                      }
                    }),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
        actions: [
          GestureDetector(
            onTap: hiddenTapped,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.transparent,
            ),
          )
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              ListTileWithIconSub(
                  title: 'Website',
                  subtitle: 'caminonomad.com',
                  icon: const Icon(Icons.public),
                  onTap: () => UrlLogic.launchUrlFunc('https://www.caminonomad.com')),
              ListTileWithIconSub(
                  title: 'Instagram',
                  subtitle: '@caminonomad',
                  icon: const FaIcon(FontAwesomeIcons.instagram),
                  onTap: () => UrlLogic.launchUrlFunc('https://www.instagram.com/caminonomad/')),
              ListTileWithIconSub(
                  title: 'Facebook',
                  subtitle: '@caminonomad',
                  icon: const Icon(Icons.facebook),
                  onTap: () => UrlLogic.launchUrlFunc('https://www.facebook.com/caminonomad')),
              ListTileWithIconSub(
                  title: 'E-mail',
                  subtitle: 'jonas@caminonomad.com',
                  icon: const Icon(Icons.email),
                  onTap: () => UrlLogic.launchUrlFunc('mailto:jonas@caminonomad.com')),
            ],
          ),
        ),
      ),
    );
  }
}
