import 'package:camino_nomad/pages/more_pages/contact_page.dart';
import 'package:flutter/material.dart';

import '../../widgets/button_list_tile.dart';
import '../coming_soon_page.dart';
import 'useful_links_page.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: const [
            SizedBox(height: 50),
            ButtonListTile(title: 'Offline Settings', route: ComingSoonPage()),
            ButtonListTile(title: 'Share app', route: ComingSoonPage()),
            ButtonListTile(title: 'Useful links', route: UsefulLinksPage()),
            ButtonListTile(title: 'Updates', route: ComingSoonPage()),
            ButtonListTile(title: 'Contact', route: ContactPage()),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
