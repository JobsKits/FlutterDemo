import 'package:flutter/material.dart';

class DotIndicator extends Decoration {
  final double radius;
  final Color color;

  const DotIndicator({this.radius = 2.6, this.color = Colors.white});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(radius, color);
  }
}

class _DotPainter extends BoxPainter {
  final double radius;
  final Color color;

  _DotPainter(this.radius, this.color);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double x = offset.dx + config.size!.width / 2;
    final double y = offset.dy + config.size!.height + 4;

    canvas.drawCircle(Offset(x, y), radius, paint);
  }
}
