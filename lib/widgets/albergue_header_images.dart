import 'package:camino_nomad/pages/popup_picture_page.dart';
import 'package:flutter/material.dart';

import '../model/route_info/albergue.dart';

class AlbergueHeaderImages extends StatelessWidget {
  const AlbergueHeaderImages({
    super.key,
    required this.albergue,
  });

  final Albergue albergue;

  @override
  Widget build(BuildContext context) {
    if (albergue.imageUrls.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PopupPicturePage(imageUrls: albergue.imageUrls)));
        },
        child: AspectRatio(
          aspectRatio: 2,
          child: albergue.imageUrls.length == 1
              ? Image.asset(
                  'assets/images/albergue/${albergue.imageUrls[0]}',
                  fit: BoxFit.cover,
                )
              : Row(
                  children: [
                    AspectRatio(
                      aspectRatio: albergue.imageUrls.length > 1 ? 1.3 : 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Image.asset(
                          'assets/images/albergue/${albergue.imageUrls[0]}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 0.7,
                      child: albergue.imageUrls.length == 2
                          ? Image.asset(
                              'assets/images/albergue/${albergue.imageUrls[1]}',
                              fit: BoxFit.cover,
                            )
                          : Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: Image.asset(
                                      'assets/images/albergue/${albergue.imageUrls[1]}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1.68,
                                      child: Image.asset(
                                        'assets/images/albergue/${albergue.imageUrls[2]}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    albergue.imageUrls.length > 3
                                        ? AspectRatio(
                                            aspectRatio: 1.68,
                                            child: Container(
                                              color: const Color(0x90202020),
                                              child: Center(
                                                child: Text('+${albergue.imageUrls.length - 2}',
                                                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500)),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink()
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
        ),
      );
    }
  }
}
