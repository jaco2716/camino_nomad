import 'package:camino_nomad/widgets/list_tile_with_icon_sub.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../logic/url_logic.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

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
                  subtitle: 'support@caminonomad.com',
                  icon: const Icon(Icons.email),
                  onTap: () => UrlLogic.launchUrlFunc('mailto:support@caminonomad.com')),
            ],
          ),
        ),
      ),
    );
  }
}
