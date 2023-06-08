import 'package:flutter/material.dart';
import '../../constants/styles_config.dart' as styles;

class ListTileWithIconSub extends StatelessWidget {
  const ListTileWithIconSub({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
  });

  final String title;
  final String subtitle;
  final Widget icon;
  final void Function() onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: backgroundColor,
      child: ListTile(
        onTap: onTap,
        dense: true,
        iconColor: backgroundColor == null ? styles.primaryColor : Colors.white,
        leading: SizedBox(width: 30, child: Center(child: icon)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: backgroundColor == null ? Colors.black : Colors.white)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: backgroundColor == null ? const Color(0x90000000) : const Color(0xDDFFFFFF),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        horizontalTitleGap: 0,
      ),
    );
  }
}
