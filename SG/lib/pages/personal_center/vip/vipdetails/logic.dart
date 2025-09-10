import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/viplevel/viplevel_lingqu_model.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:flutter_bet/pages/personal_center/vip/logic.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/vip_api_service.dart';
import 'package:get/get.dart';

class VipLingQuLogic extends BaseController {
  List<VipLevelLingQuModel> dataList = [];
  List<String> dateList = [
    S.current.date_past_today,
    S.current.random_text_621,
    S.current.random_text_622,
    S.current.random_text_623,
  ];
  List<String> typeList = [
    S.current.sport_all,
    S.current.random_text_403,
    S.current.random_text_1121,
    S.current.random_text_603,
    S.current.random_text_604,
    S.current.random_text_605,
  ];
  List<String> paramsTypeList = ["", "814", "818", "819", "820", "821"];
  int currentSelectedIndex = 0;
  int currentTypeSelectedIndex = 0;

  String totalAmount = "0";
  bool isLoading = false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.find<VipHomeLogic>().shouldDayilyBonusVisibility("819") == false) {
      typeList = [
        S.current.sport_all,
        S.current.random_text_403,
        S.current.random_text_1121,
        S.current.random_text_604,
        S.current.random_text_605,
      ];
      paramsTypeList = ["", "814", "818", "820", "821"];
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    initData(getStartTimeStamp());
  }

  initData(startTime) async {
    if (globalController.isLogin.value == false) {
      return;
    }
    isLoading = true;
    update(['vip_record']);
    await ApiService.instance.chakanLingQuJiLu(
      cash_type: paramsTypeList[currentTypeSelectedIndex],
      page: 1,
      start_time: startTime,
      end_time: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      success: (data) {
        dataList.clear();
        dataList.addAll(data.content);
        totalAmount = data.totalAmount!;
        if (totalAmount == "") {
          totalAmount = "0";
        }
        Future.delayed(Duration(seconds: 1), () {
          isLoading = false;
          update(['vip_record']);
        });
      },
      fail: (message) {
        isLoading = false;

        print(message);
      },
    );
  }

  changeTimeType(index) {
    currentSelectedIndex = index;
    if (currentSelectedIndex == 0) {
      initData(getStartTimeStamp());
    } else if (index == 1) {
      initData(getStartTimeStamp() - 3600 * 24 * 6);
    } else if (index == 2) {
      initData(getStartTimeStamp() - 3600 * 24 * 29);
    } else {
      initData(getStartTimeStamp() - 3600 * 24 * 89);
    }
  }

  changeTypeType(index) {
    currentTypeSelectedIndex = index;
    if (currentSelectedIndex == 0) {
      initData(getStartTimeStamp());
    } else if (index == 1) {
      initData(getStartTimeStamp() - 3600 * 24 * 6);
    } else if (index == 2) {
      initData(getStartTimeStamp() - 3600 * 24 * 29);
    } else {
      initData(getStartTimeStamp() - 3600 * 24 * 89);
    }
  }

  loadMore() {}
  int getStartTimeStamp() {
    DateTime now = DateTime.now();
    // 获取今天 00:00:00 的时间
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    int todayStartTimestamp = todayStart.millisecondsSinceEpoch;
    return todayStartTimestamp ~/ 1000;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
