import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';

//显示什么内容自己传递
class AppCommonDropMenu {
  // 私有构造函数，防止外部实例化
  AppCommonDropMenu._internal();

  // 提供一个静态的实例，通过类名调用
  static final AppCommonDropMenu instance = AppCommonDropMenu._internal();

  OverlayEntry? _overlayEntry;

  void show(BuildContext context, GlobalKey targetKey, Widget child,
      {double? width, double? height}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (targetKey.currentContext == null) {
        debugPrint("Error: targetKey.currentContext is null.");
        return;
      }

      final overlay = Overlay.of(context);
      if (overlay == null) {
        debugPrint("Error: Overlay not found.");
        return;
      }

      final RenderBox renderBox =
          targetKey.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);

      // 使用控件宽度作为默认宽度
      double defaultWidth = width ?? renderBox.size.width;

      _overlayEntry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            InkWell(
              onTap: hide,
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: position.dx,
              top: position.dy + renderBox.size.height,
              width: defaultWidth,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: height ?? 300,
                    minWidth: defaultWidth,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      );

      overlay.insert(_overlayEntry!);
    });
  }

  /// 隐藏弹出框
  void hide() {
    AppManager.instance.tapVibrate();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 判断弹出框是否显示中
  bool isShowing() => _overlayEntry != null;
}
