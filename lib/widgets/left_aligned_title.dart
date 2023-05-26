import 'package:flutter/material.dart';

class LeftAlignedTitle extends StatelessWidget {
  const LeftAlignedTitle(
    this.title, {
    super.key,
    this.color = Colors.blue,
    this.size = 14,
    this.fontWeight = FontWeight.bold,
    this.leftPadding = 20,
  });
  final String title;
  final Color color;
  final double size;
  final FontWeight fontWeight;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: leftPadding),
        child: Text(
          title,
          style: TextStyle(fontWeight: fontWeight, color: color, fontSize: size),
        ));
  }
}
