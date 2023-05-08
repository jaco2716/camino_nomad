import 'package:flutter/material.dart';

class AlbergueInfoListTile extends StatelessWidget {
  const AlbergueInfoListTile(
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
    return show ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title), Text(trailing)]) : const SizedBox.shrink();
  }
}
