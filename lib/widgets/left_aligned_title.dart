import 'package:flutter/material.dart';

class LeftAlignedTitle extends StatelessWidget {
  const LeftAlignedTitle(
    this.title, {
    super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ));
  }
}
