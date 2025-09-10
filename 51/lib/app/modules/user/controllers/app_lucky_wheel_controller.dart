import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/lucky_wheel_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/lucky_wheel_success_or_failed_dialog.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

import '../widget/lucky_wheel_dialog.dart';

class AppLuckyWheelController extends GetxController {
  final ValueNotifier<int> result = ValueNotifier<int>(0);
  StreamController<int> selected = StreamController<int>();
  Rx<LuckyWheelBean?> luckyWheelBean = LuckyWheelBean().obs; //大转盘列表的数据
  Rx<LuckyPointsBean?> luckyPointsBean = LuckyPointsBean().obs; //积分
  LuckyBigWheelSys? currentLuckyBigWheelSys;
  RxList<LuckyBigWheeDetails> wheelItems = <LuckyBigWheeDetails>[].obs;
  RxInt currentSelectIndex = 0.obs;
  LuckySelectBean? luckySelectBean;
  @override
  void onClose() {
    selected.close();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    luckyWheelBean.value = await UserApi().reqWheelData();
    initWheelList();
    luckyPointsBean.value = await UserApi().checkWheelPoints();
  }

  void initWheelList() {
    currentLuckyBigWheelSys =
        luckyWheelBean.value!.luckyBigWheelSys![0]; //默认等于0
    for (int i = 0; i < luckyWheelBean.value!.luckyBigWheelSys!.length; i++) {
      if (i == 0) {
        wheelItems.value =
            luckyWheelBean.value!.luckyBigWheelSys![i].luckyBigWheeDetails!;
      }
    }
  }

  //显示抽奖完成后的弹窗，可能是没中奖，也可能是中奖,通过接口返回的值是否为0，判断是否中奖
  void showFinishDialog() {
    String tempStr = "${(luckySelectBean?.prize ?? 0) / 1000}";
    Get.dialog(LuckyWheelSuccessOrFailedDialog(
      isSuccess: luckySelectBean?.prize != 0,
      successMoney: tempStr,
    ));
  }

  void startWheel() async {
    if (!LoginManager.instance.isLogin.value) {
      //如果没有登录，弹出登录弹窗，不执行后续逻辑
      Get.dialog(
          const LuckyWheelDialog(
            unLoginOrPointNotEnough: false,
          ),
          barrierDismissible: false);
      return;
    }
    if (currentLuckyBigWheelSys!.integral! < luckyPointsBean.value!.usable!) {
      //如果选中的积分，小于当前总积分，才执行里面的逻辑，否则，弹出弹窗
      luckySelectBean =
          await UserApi().startWheel(currentLuckyBigWheelSys!.sysId!);
      if (luckySelectBean != null) {
        //接口请求不为空，转盘开始转动并停止到接口指定位置
        int tempIndex = wheelItems.indexWhere(
            (wheelItem) => wheelItem.prize == luckySelectBean!.prize);
        selected.add(tempIndex);
      }
    } else {
      //弹出积分不足
      Get.dialog(
          const LuckyWheelDialog(
            unLoginOrPointNotEnough: true,
          ),
          barrierDismissible: false);
    }
  }

  void changeSelectIndex(int index) {
    currentLuckyBigWheelSys = luckyWheelBean.value!.luckyBigWheelSys![index];
    wheelItems.value =
        luckyWheelBean.value!.luckyBigWheelSys![index].luckyBigWheeDetails!;
    currentSelectIndex.value = index;
  }
}
