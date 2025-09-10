//为了适配国际化语言， 做长度适配
// mixin BettingListWidthConfig{
//   double width;
//   List<int> expends;
//
// }

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';

class SportWidthConfig {
  double width;
  List<int> expends;

  ///活动不同语言 宽度
  static double _getWidth({
    required double zh,
    required double en,
    double? pt,
    double? vi,
    double? th,
    double? hi,
  }) {
    if (GlobalStateController.of().isChinese()) {
      return zh;
    } else if (GlobalStateController.of().isPt()) {
      //不为空 默认使用英文模式
      return pt ?? en;
    } else if (GlobalStateController.of().isVi()) {
      //不为空 默认使用英文模式
      return vi ?? en;
    } else if (GlobalStateController.of().isThai()) {
      return th ?? en;
    } else if (GlobalStateController.of().isHi()) {
      return hi ?? en;
    } else {
      return en;
    }
  }

  ///活动不同语言 比例
  static List<int> _getExpends({
    required List<int> zh,
    required List<int> en,
    List<int>? pt,
    List<int>? vi,
    List<int>? th,
    List<int>? hi,
  }) {
    if (GlobalStateController.of().isChinese()) {
      return zh;
    } else if (GlobalStateController.of().isPt()) {
      //不为空 默认使用英文模式
      return pt ?? en;
    } else if (GlobalStateController.of().isVi()) {
      //不为空 默认使用英文模式
      return vi ?? en;
    } else if (GlobalStateController.of().isThai()) {
      return th ?? en;
    } else if (GlobalStateController.of().isHi()) {
      return hi ?? en;
    } else {
      return en;
    }
  }

  ///体育盘口
  SportWidthConfig.handicap()
      // : width = GlobalStateController.of().isChinese() ? Get.width * 2.0 : Get.width * 2.4,
      //   expends = GlobalStateController.of().isChinese() ? [3, 3, 3, 2, 3, 1] : [2, 3, 2, 3, 2, 2];
      : width = _getWidth(
          zh: 100.w,
          en: 110.w,
          pt: 120.w,
          vi: 170.w,
          th: 110.w,
          hi: 100.w,
        ),
        expends = _getExpends(
          zh: [1],
          en: [1],
        );
}
