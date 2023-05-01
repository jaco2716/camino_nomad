import 'package:flutter/material.dart';

import 'coming_soon_page.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});
  static const List<String> title = [
    'Offline Settings',
    'Share app',
    'Useful links',
    'Updates',
    'Contact',
  ];

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
          children: [
            const SizedBox(height: 50),
            MoreListTile(title: MorePage.title[0]),
            MoreListTile(title: MorePage.title[1]),
            MoreListTile(title: MorePage.title[2]),
            MoreListTile(title: MorePage.title[3]),
            MoreListTile(title: MorePage.title[4]),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MoreListTile extends StatelessWidget {
  const MoreListTile({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ComingSoonPage()));
      },
      iconColor: Colors.amber[800],
      title: Text(
        title,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    ));
  }
}
