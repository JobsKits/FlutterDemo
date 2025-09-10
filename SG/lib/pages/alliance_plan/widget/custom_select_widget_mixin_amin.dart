import 'package:flutter/material.dart';

///选择框动画 mixin
mixin CustomSelectWidgetMixinAmin<T extends StatefulWidget> on State<T> {
  //缩放比例
  var scale = 1.0;

  ///执行动画
  void doScaleAmin(bool? scaleAmin) {
    //没开启就不执行动画
    if (scaleAmin == null || scaleAmin == false) {
      return;
    }
    setState(() {
      scale = 0.9;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        scale = 1.0;
      });
    });
  }
}
