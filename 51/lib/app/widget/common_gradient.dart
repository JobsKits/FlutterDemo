import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity_detail_view.dart';
import 'package:get/get.dart';

import '../../theme/theme.service.dart';

class CommonGradient {
  /// 渐变常量配置
  static final Map<int, List<Color>> _gradientColorList = {
    0: [
      const Color(0xFF00d7bd), // 渐变的开始颜色
      const Color(0xFF02b19d), // 渐变的结束颜色
    ],
    1: [
      const Color(0xFFf47306),
      const Color(0xFFd12d15),
    ],
    2: [
      const Color(0xFFa546f1),
      const Color(0xFF792bb9),
    ],
    3: [
      const Color(0xFFf7a300),
      const Color(0xFFd76001),
    ],
    4: [
      const Color(0xFF07bcff),
      const Color(0xFF1461c8),
    ],
    5: [
      const Color(0xFF1fb341),
      const Color(0xFF09631f),
    ],
    6: [
      const Color(0xFFff3daa),
      const Color(0xFFe51e76),
    ],
  };

  /// 右下角渐变
  static getRadialGradient({
    required int index,
    AlignmentGeometry? center,
  }) {
    int max = 7;
    int currentIndex = index % max;

    if (_gradientColorList[currentIndex] != null) {
      return RadialGradient(
        colors: _gradientColorList[currentIndex] as List<Color>,
        stops: const [0.2, 1.2], // 渐变的停止位置
        radius: 1.5, // 渐变半径
        center: center ?? const Alignment(0.7, 0.8), // 渐变中心
      );
    }
    return null;
  }

  /// 充值按钮的背景色
  static LinearGradient getButtonLinearGradient({bool disabled = false}) {
    return LinearGradient(
      begin: Alignment.centerLeft, // 渐变开始位置
      end: Alignment.centerRight, // 渐变结束位置
      colors: disabled
          ? (ThemeService.to.currentTheme.value?.model == "blackGold"
              ? [
                  Get.context?.theme.primaryColor ?? const Color(0xFFE5E5E5),
                  Get.context?.theme.primaryColor ?? const Color(0xFFE5E5E5),
                ]
              : [
                  const Color(0xFFE5E5E5),
                  const Color(0xFFE5E5E5),
                ])
          : [
              Get.context?.theme.primaryColor ?? Colors.white, // 渐变的起始颜色
              Get.context?.theme.primaryColor ?? Colors.white, // 渐变的结束颜色
            ],
    );
  }
}
