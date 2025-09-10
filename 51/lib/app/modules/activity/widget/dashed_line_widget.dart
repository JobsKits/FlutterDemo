import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashedLineWidget extends StatelessWidget {
  const DashedLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1), // 高度为1，宽度自适应
      painter: DashedLinePainter(),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDDEAEC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    path.moveTo(0, size.height / 2); // 起点
    path.lineTo(size.width, size.height / 2); // 终点

    drawDashedLine(canvas, path, paint, dashWidth: 24.w, dashSpace: 8.w);
  }

  void drawDashedLine(Canvas canvas, Path path, Paint paint,
      {double dashWidth = 5, double dashSpace = 3}) {
    // 根据路径的长度计算虚线的绘制
    double distance = 0.0;

    // 获取路径的测量信息
    final PathMetrics pathMetrics = path.computeMetrics();

    for (final PathMetric pathMetric in pathMetrics) {
      final double segmentLength = pathMetric.length;
      for (double i = 0; i < segmentLength; i += dashWidth + dashSpace) {
        final double start = i;
        final double end = (i + dashWidth).clamp(0, segmentLength);
        final Path extractedPath = pathMetric.extractPath(start, end);
        canvas.drawPath(extractedPath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
