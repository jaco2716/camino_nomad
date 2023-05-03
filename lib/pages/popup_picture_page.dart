import 'package:flutter/material.dart';

class PopupPicturePage extends StatelessWidget {
  const PopupPicturePage({super.key, required this.imageUrls});
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
      ),
      body: ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Image.asset('assets/images/albergue/${imageUrls[index]}'),
          );
        },
      ),
    );
  }
}
