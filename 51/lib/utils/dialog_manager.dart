import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogManager {
  static final List<_DialogItem> _dialogList = [];
  static bool _isDialogShowing = false;
  static bool _isFirstCall = true;
  static bool _isFirstWaiting = true;

  static void showDialogWithQueue({
    required Widget dialog,
    bool barrierDismissible = true,
    int priority = 0,
  }) {
    _dialogList.add(_DialogItem(
      dialog: dialog,
      barrierDismissible: barrierDismissible,
      priority: priority,
    ));

    // 按优先级排序（降序排列，优先级高的先展示）
    _dialogList.sort((a, b) => b.priority.compareTo(a.priority));

    if (_isFirstCall) {
      _isFirstCall = false;
      Future.delayed(const Duration(seconds: 2), () {
        _isFirstWaiting = false;
        _tryShowNextDialog();
      });
    } else {
      if (!_isFirstWaiting) {
        _tryShowNextDialog();
      }
    }
  }

  static void _tryShowNextDialog() {
    if (_isDialogShowing || _dialogList.isEmpty) return;

    _isDialogShowing = true;
    final nextDialog = _dialogList.removeAt(0);

    Get.dialog(
      nextDialog.dialog,
      barrierDismissible: nextDialog.barrierDismissible,
    ).then((_) {
      // 弹窗关闭后，标记为空闲状态，并尝试显示下一个
      _isDialogShowing = false;
      _tryShowNextDialog();
    });
  }
}

class _DialogItem {
  final Widget dialog;
  final bool barrierDismissible;
  final int priority;
  _DialogItem({
    required this.dialog,
    required this.barrierDismissible,
    required this.priority,
  });
}
