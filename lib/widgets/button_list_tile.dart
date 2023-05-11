import 'package:flutter/material.dart';

class ButtonListTile extends StatelessWidget {
  const ButtonListTile({
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
      iconColor: Colors.amber[800],
      title: Text(
        title,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    ));
  }
}
