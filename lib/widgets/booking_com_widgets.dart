import 'package:flutter/material.dart';
import '../logic/url_logic.dart';
import '../../constants/styles_config.dart' as styles;

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
        onPressed: () => UrlLogic.launchUrlFunc(convertUrlToAfilliate(url)),
        child: const Text('Booking.com →',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19, color: styles.secoundaryColor, letterSpacing: -1)),
      ),
    );
  }

  String convertUrlToAfilliate(String value) {
    return '${value.split('.html')[0]}.html?aid=8029725';
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
    return Row(
      children: [
        const Icon(
          Icons.star,
          size: 14,
          color: styles.primaryColor,
        ),
        Text(
          '$bookingComScore',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: size / 2.2, color: styles.primaryColor),
        ),
      ],
    );
  }
}
