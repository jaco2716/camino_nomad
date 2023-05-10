
import 'package:flutter/material.dart';

class ListTileWithIconSub extends StatelessWidget {
  const ListTileWithIconSub({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        dense: true,
        iconColor: Colors.amber[800],
        leading: SizedBox(width: 30, child: Center(child: icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios),
        horizontalTitleGap: 0,
      ),
    );
  }
}
