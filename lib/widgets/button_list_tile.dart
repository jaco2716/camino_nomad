import 'package:flutter/material.dart';
import '../../constants/styles_config.dart' as styles;

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
      iconColor: styles.primaryColor,
      title: Text(
        title,
        style: const TextStyle(color: styles.secoundaryColor, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    ));
  }
}
