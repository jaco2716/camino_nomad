import 'package:flutter/material.dart';

class RouteListTile extends StatefulWidget {
  const RouteListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget route;

  @override
  State<RouteListTile> createState() => _RouteListTileState();
}

class _RouteListTileState extends State<RouteListTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => widget.route));
        },
        dense: true,
        iconColor: Colors.amber[800],
        leading: SizedBox(
          height: double.infinity,
          child: Icon(widget.icon),
        ),
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(widget.subtitle, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios),
        horizontalTitleGap: 0,
      ),
    );
  }
}
