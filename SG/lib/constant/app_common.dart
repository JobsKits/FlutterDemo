import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

///旋转常量
///联盟计划-推广教程- 的流程组件 及其 枚举常量
enum ProcessRotate {
  rotate_0(value: pi * 0),
  rotate_90(value: pi / 2),
  rotate_180(value: pi * 1),
  rotate_270(value: pi * 1.5),
  rotate_360(value: pi * 2);

  final double value;

  const ProcessRotate({required this.value});
}

class GlobalState {
  // 私有构造函数。只是提醒私有，外部还是可以被调用的。
  GlobalState._();
  // 单例对象
  // 单例对象要被重置为null，要求_instance不能被final修饰，因为不能直接赋值null
  static GlobalState? _instance;
  // 获取单例对象的方法
  static GlobalState get instance {
    _instance ??= GlobalState._();
    return _instance!;
  }
  // 销毁单例对象的方法
  static void destroyInstance() {
    _instance = null;
    debugPrint("该单例对象已经被销毁");
  }

  bool myGlobalVariable = true;
  /// 第一次灌入数据，不管有没有数据，都不能编辑
  bool isEdit = false;
  int index = 0;
  /// 是否转了轮盘
  // final isClickLuckyWheel = false.obs;
}