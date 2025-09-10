//为了适配国际化语言， 做长度适配
// mixin BettingListWidthConfig{
//   double width;
//   List<int> expends;
//
// }

import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';

class AllianceWidthConfig {
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

  AllianceWidthConfig.myCommission()
      // : width = GlobalStateController.of().isChinese() ? Get.width * 2.0 : Get.width * 2.4,
      //   expends = GlobalStateController.of().isChinese() ? [3, 3, 3, 2, 3, 1] : [2, 3, 2, 3, 2, 2];
      : width = _getWidth(
          zh: Get.width * 2.0,
          en: Get.width * 2.25,
          vi: Get.width * 2.4,
          pt: Get.width * 2.45,
          th: Get.width * 2.1,
          hi: Get.width * 2.1,
        ),
        expends = _getExpends(
          zh: [130, 100, 85, 60, 85, 50],
          en: [110, 100, 90, 110, 90, 50],
          vi: [135, 100, 90, 90, 90, 50],
          pt: [130, 100, 90, 110, 90, 50],
          th: [100, 100, 85, 80, 90, 60],
          hi: [100, 100, 85, 110, 90, 50],
        );

  ///我的业绩
  AllianceWidthConfig.myPerformance()
      // : width = GlobalStateController.of().isChinese() ? Get.width * 1.7 : Get.width * 2.2,
      //   expends = GlobalStateController.of().isChinese() ? [2, 2, 1, 2, 2] : [2, 1, 2, 2, 2];
      : width = _getWidth(
          zh: Get.width * 1.8,
          en: Get.width * 2.25,
          vi: Get.width * 2.4,
          pt: Get.width * 2.4,
          th: Get.width * 1.9,
          hi: Get.width * 1.9,
        ),
        expends = _getExpends(
          zh: [140, 100, 75, 100, 100],
          en: [100, 90, 110, 90, 110],
          vi: [120, 80, 130, 80, 95],
          pt: [115, 80, 110, 80, 110],
          th: [90, 90, 70, 85, 100],
          hi: [95, 90, 90, 85, 85],
        );

  ///所有数据
  AllianceWidthConfig.allData()
      // : width = GlobalStateController.of().isChinese() ? Get.width * 1.7 : Get.width * 2.0,
      //   expends = GlobalStateController.of().isChinese() ? [1, 1, 1, 1, 1] : [3, 2, 3, 3, 5];
      : width = _getWidth(
          zh: Get.width * 1.8,
          en: Get.width * 1.9,
          pt: Get.width * 2.0,
          vi: Get.width * 2.15,
        ),
        expends = _getExpends(
          zh: [120, 110, 90, 90, 90],
          en: [120, 110, 100, 100, 100],
          pt: [110, 90, 90, 90, 130],
          vi: [100, 90, 85, 95, 135],
        );

  AllianceWidthConfig.directFinance()
      // : width = GlobalStateController.of().isChinese() ? Get.width * 2.0 : Get.width * 2.3,
      //   expends = GlobalStateController.of().isChinese() ? [2, 3, 3, 3, 3, 3] : [3, 2, 4, 3, 4, 3];
      : width = _getWidth(
          zh: Get.width * 2.05,
          en: Get.width * 2.1,
          vi: Get.width * 2.3,
          pt: Get.width * 2.3,
          th: Get.width * 2.0,
          hi: Get.width * 2.0,
        ),
        expends = _getExpends(
          zh: [95, 110, 90, 90, 90, 90],
          en: [75, 110, 100, 100, 100, 100],
          vi: [110, 110, 100, 100, 100, 100],
          pt: [105, 110, 100, 100, 100, 100],
          th: [75, 110, 100, 100, 100, 100],
          hi: [75, 110, 100, 100, 100, 100],
        );

  ///直属投注
  AllianceWidthConfig.directBetting()
      // : width = GlobalStateController.of().isChinese() ? Get.width * 1.3 : Get.width * 1.8,
      //   expends = GlobalStateController.of().isChinese() ? [2, 3, 3, 3] : [2, 2, 2, 4];
      : width = _getWidth(
          zh: Get.width * 1.4,
          en: Get.width * 1.35,
          vi: Get.width * 1.8,
          pt: Get.width * 1.8,
          th: Get.width * 1.3,
          hi: Get.width * 1.3,
        ),
        expends = _getExpends(
          zh: [100, 100, 100, 100],
          en: [80, 100, 100, 120],
          vi: [105, 100, 100, 120],
          pt: [100, 100, 100, 150],
          th: [75, 100, 100, 120],
          hi: [75, 100, 100, 120],
        );

  ///直属用户
  AllianceWidthConfig.directUser()
      : width = _getWidth(
          zh: Get.width * 1.6,
          en: Get.width * 2.0,
          vi: Get.width * 2.3,
        ),
        expends = _getExpends(
          zh: [120, 100, 66, 126, 66],
          en: [90, 80, 90, 90, 66],
          vi: [80, 80, 110, 85, 75],
        );

  AllianceWidthConfig.directReceive()
      : width = _getWidth(
          zh: Get.width * 1.4,
          en: Get.width * 2.0,
        ),
        expends = _getExpends(
          zh: [1, 1, 1, 1, 1],
          en: [3, 2, 3, 2, 3],
        );

  AllianceWidthConfig.history()
      // : width = GlobalStateController.of().isChinese() ? Get.width * 1.6 : Get.width * 1.8,
      //   expends = GlobalStateController.of().isChinese() ? [80, 90, 120, 140] : [120, 90, 120, 120];
      : width = _getWidth(
          zh: Get.width * 1.5,
          en: Get.width * 1.8,
          vi: Get.width * 1.8,
          pt: Get.width * 1.9,
          th: Get.width * 1.8,
          hi: Get.width * 1.65,
        ),
        expends = _getExpends(
          zh: [80, 90, 120, 145],
          en: [130, 80, 110, 125],
          vi: [130, 80, 110, 125],
          pt: [155, 80, 110, 125],
          th: [130, 80, 110, 125],
          hi: [110, 80, 110, 125],
        );
}
