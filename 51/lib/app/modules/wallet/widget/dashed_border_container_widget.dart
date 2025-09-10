import 'package:flutter/material.dart';

///虚线边框的容器
class DashedBorderContainerWidget extends StatelessWidget {
  const DashedBorderContainerWidget({
    super.key,
    required this.child,
    this.strokeWidth = 2.0,
    this.color = Colors.black,
    this.dashWidth = 5.0,
    this.dashGap = 3.0,
    this.borderRadius = 8.0,
  });

  final Widget child;
  final double strokeWidth;
  final Color color;
  final double dashWidth;
  final double dashGap;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        strokeWidth: strokeWidth,
        color: color,
        dashWidth: dashWidth,
        dashGap: dashGap,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double dashWidth;
  final double dashGap;
  final double borderRadius;

  DashedBorderPainter({
    required this.strokeWidth,
    required this.color,
    required this.dashWidth,
    required this.dashGap,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(outerRect);
    final dashPath = Path();

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        dashPath.addPath(
          metric.extractPath(distance, nextDistance),
          Offset.zero,
        );
        distance = nextDistance + dashGap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
