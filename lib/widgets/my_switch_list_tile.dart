import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MySwitchListTile extends StatelessWidget {
  const MySwitchListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        dense: true,
        iconColor: Colors.amber[800],
        leading: const SizedBox(width: 30, child: Center(child: Icon(FontAwesomeIcons.powerOff))),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: const Text('On', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
        horizontalTitleGap: 0,
        trailing: Switch(
          value: true,
          onChanged: (value) {},
        ),
      ),
      // child: SwitchListTile(
      //   title: const Text('SwitchListTile with red background'),
      //   value: true,
      //   onChanged: (bool? value) {},
      // ),
    );
  }
}
