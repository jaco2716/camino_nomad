import 'package:flutter/material.dart';

import '../pages/coming_soon_page.dart';

class ButtonListTile extends StatelessWidget {
  const ButtonListTile({
    super.key,
    required this.title,
    required this.route,
  });

  final Widget route;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
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
