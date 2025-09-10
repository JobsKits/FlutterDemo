import 'package:flutter/material.dart';

class FundingTypePopWidget {
  // 私有构造函数，防止外部实例化
  FundingTypePopWidget._internal();

  // 提供一个静态的实例，通过类名调用
  static final FundingTypePopWidget instance = FundingTypePopWidget._internal();

  OverlayEntry? _overlayEntry;

  // 显示 Overlay
  void show(BuildContext context, Widget child,
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    if (_overlayEntry != null) return; // 如果已经显示，则不重复显示

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: top,
        left: left,
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  // 隐藏 Overlay
  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // 判断是否显示
  bool isShowing() => _overlayEntry != null;
}
