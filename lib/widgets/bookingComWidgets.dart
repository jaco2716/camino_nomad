import 'package:flutter/material.dart';
import '../logic/url_logic.dart';

class BookingComLink extends StatelessWidget {
  const BookingComLink({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: TextButton(
        onPressed: () => UrlLogic.launchUrlFunc(url),
        child: const Text('Booking.com', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19, color: Colors.blue, letterSpacing: -1)),
      ),
    );
  }
}

class BookingComScore extends StatelessWidget {
  const BookingComScore({
    super.key,
    required this.bookingComScore,
    this.size = 40,
  });

  final double bookingComScore;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(size / 5), topRight: Radius.circular(size / 5), bottomRight: Radius.circular(size / 5)),
        color: Colors.blue[800],
      ),
      child: Text(
        '$bookingComScore',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size / 2.2, color: Colors.white),
      ),
    );
  }
}
