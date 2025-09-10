
import 'package:flutter/material.dart';

/// 三角角标
class TrianglePainter extends CustomPainter {

  final Color color;
  final bool isUpward;

  TrianglePainter({
    this.color    = Colors.white,
    this.isUpward = true
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint() // 创建绘制画笔
      ..color = color // 设置画笔颜色
      ..strokeWidth = 2 // 设置画笔宽度
      ..style = PaintingStyle.fill; // 设置画笔风格为填充

    Path path = Path(); // 创建路径

    if (isUpward) {
      // 绘制朝上的三角形
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      // 绘制朝下的三角形
      path.moveTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    }

    // 绘制闭合路径
    path.close();

    // 绘制路径
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // 因为这个绘制器不会更改，所以我们始终返回false
  }
}