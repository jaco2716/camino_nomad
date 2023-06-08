import 'package:flutter/material.dart';
import '../../constants/styles_config.dart' as styles;

class HotelInfoListTile extends StatelessWidget {
  const HotelInfoListTile(
    this.title, {
    super.key,
    required this.trailing,
    required this.show,
  });
  final String title;
  final String trailing;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return show
        ? Container(
            height: 24,
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
            child: Row(children: [
              const SizedBox(width: 20, child: Icon(Icons.horizontal_rule_rounded, color: styles.primaryColor, size: 12)),
              const SizedBox(width: 10),
              Text(title),
              const Spacer(),
              Text(trailing),
              const SizedBox(width: 12),
            ]),
          )
        : const SizedBox.shrink();
  }
}
