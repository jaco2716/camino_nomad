import 'package:camino_nomad/widgets/list_tile_with_icon_sub.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../logic/url_logic.dart';

class UsefulLinksPage extends StatelessWidget {
  const UsefulLinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              ListTileWithIconSub(
                  title: 'Packing List Inspiration',
                  subtitle: 'caminonomad.com/packinglist',
                  icon: const FaIcon(FontAwesomeIcons.personWalkingLuggage),
                  onTap: () => UrlLogic.launchUrlFunc('https://www.caminonomad.com/packinglist')),
              ListTileWithIconSub(
                  title: 'Send Luggage to Santiago',
                  subtitle: 'elcaminoconcorreos.com',
                  icon: const FaIcon(FontAwesomeIcons.cartFlatbedSuitcase),
                  onTap: () => UrlLogic.launchUrlFunc('https://www.elcaminoconcorreos.com/en/transfer-luggage')),
            ],
          ),
        ),
      ),
    );
  }
}
