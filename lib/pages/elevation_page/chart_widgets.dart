import 'package:flutter/material.dart';
import '../../../constants/styles_config.dart' as styles;

class PathPainter extends CustomPainter {
  Path path;
  Path fillPath;
  PathPainter({required this.path, required this.fillPath});

  @override
  void paint(Canvas canvas, Size size) {
    // paint the line
    final paint = Paint()
          ..color = styles.secoundaryColor.withOpacity(0.8)
          ..style = PaintingStyle.fill
        // ..strokeJoin = StrokeJoin.bevel
        // ..strokeWidth = 10.0
        ;
    // canvas.drawPath(path, paint);
    // paint the gradient fill
    // paint.style = PaintingStyle.fill;
    // paint.shader = ui.Gradient.linear(
    //   Offset.zero,
    //   Offset(0.0, size.height),
    //   [
    //     Colors.blue.withOpacity(0.2),
    //     Colors.blue.withOpacity(0.85),
    //   ],
    // );
    canvas.drawPath(fillPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ChartDataPoint {
  double x;
  double y;
  ChartDataPoint({required this.x, required this.y});
}
