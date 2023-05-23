import 'package:camino_nomad/model/providers/app_data_provider.dart';
import 'package:camino_nomad/pages/popup_picture_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/route_info/hotel.dart';

class HotelHeaderImages extends StatelessWidget {
  const HotelHeaderImages({
    super.key,
    required this.hotel,
  });

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    if (hotel.imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }
    if (context.read<AppDataProvider>().appDataSettings?.lowDataMode ?? false) {
      return const Text('Turn off Low Data Mode to see images.');
    }
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PopupPicturePage(imageUrls: hotel.imageUrls)));
      },
      child: AspectRatio(
        aspectRatio: 2,
        child: hotel.imageUrls.length == 1
            ? Image.asset(
                'assets/images/hotel/${hotel.imageUrls[0]}',
                fit: BoxFit.cover,
              )
            : Row(
                children: [
                  AspectRatio(
                    aspectRatio: hotel.imageUrls.length > 1 ? 1.3 : 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Image.asset(
                        'assets/images/hotel/${hotel.imageUrls[0]}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 0.7,
                    child: hotel.imageUrls.length == 2
                        ? Image.asset(
                            'assets/images/hotel/${hotel.imageUrls[1]}',
                            fit: BoxFit.cover,
                          )
                        : Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 1.2,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Image.asset(
                                    'assets/images/hotel/${hotel.imageUrls[1]}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.68,
                                    child: Image.asset(
                                      'assets/images/hotel/${hotel.imageUrls[2]}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  hotel.imageUrls.length > 3
                                      ? AspectRatio(
                                          aspectRatio: 1.68,
                                          child: Container(
                                            color: const Color(0x90202020),
                                            child: Center(
                                              child: Text('+${hotel.imageUrls.length - 2}',
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
