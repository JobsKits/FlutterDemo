import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_turntable_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_info.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/activity_turntable_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/wheel_config.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/turntable_records_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/turntable_win_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ActivityTurntableDialogController extends GetxController {
  late Rx<ActivityTurntableDetailModel> model =
      ActivityTurntableDetailModel().obs;
  Rx<ActivityTurntableDetailInfo> info = ActivityTurntableDetailInfo().obs;
  late dynamic actionCfg;
  late Rx<WheelConfig> wheelConfig = WheelConfig().obs;
  late Rx<WheelConfig> wheelConfig2 = WheelConfig().obs;
  late Rx<WheelConfig> wheelConfig3 = WheelConfig().obs;
  Rx<TirntbaleEnum> type = TirntbaleEnum.silver.obs;
  var wheelType = 1;
  RxInt index = 0.obs;

  List<Map<String, dynamic>> functionsList = [
    {"title": "白银转盘", "value": ""},
    {"title": "黄金转盘", "value": ""},
    {"title": "钻石转盘", "value": ""},
  ];

  final List<Tab> tabs = <Tab>[const Tab(text: '规则'), const Tab(text: '记录')];

  RxList<TurntableRecordItem> models = RxList();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 领取红包
  Future<void> reqActivityTurntable(Function(int) callback) async {
    final response = await ActivityApi.reqActivityTurntableWin(
        model.value.id ?? 0, wheelType);
    print({'object ==============${response.data}'});
    if (response.type == NetworkService.networkTypeSuccess &&
        response.data['response_code'] == '9999') {
      var amount = response.data['t']['rewordAmount'] / 1000;
      amount = double.parse(amount.truncateToFixed(2));

      Get.dialog(
        TurntableWinDialog(price: amount),
        barrierDismissible: false,
      );
      reqActivityTurntableDetail();
      reqActivityTurntableRecords();
      callback(response.data['t']['rewordAmount']); //4是未中奖
    } else if (response.type == NetworkService.networkTypeError) {
      displayTips('您的积分不足\n请获取积分后再参与');
      callback(0); //4是未中奖
    } else {
      callback(0);
    }
  }

  /// 领取红包
  Future<void> reqActivityTurntableDetail() async {
    print({'object ========== '});
    final response = await ActivityApi.reqActivityTurntableDetail(
        model.value.id ?? 0, wheelType);
    if (response.type == NetworkService.networkTypeSuccess) {
      if (response.data['response_code'] == '9999') {
        print({'object ========== ${response.data['t']}'});
        info.value = ActivityTurntableDetailInfo.fromJson(response.data['t']);
        print({'object ========== ${info.value}'});
      }
    }
  }

  Future<void> reqActivityTurntableRecords() async {
    final response = await ActivityApi.reqActivityTurntableRecords(
        model.value.id.toString(), '0');
    if (response.type == NetworkService.networkTypeSuccess) {
      final datas = (response.data['t'] as List?)?.map((item) {
            return TurntableRecordItem.fromJson(item as Map<String, dynamic>);
          }).toList() ??
          [];
      models.value = datas;
    }
  }

  void displayTips(String tips) {
    Get.dialog(
      TipsDialog(
        tips: tips,
        // desc: desc,
        comfirmText: '确认',
        contentF1Size: 42,
        contentF2Size: 35,
        type: 'redbag',
        confirmAction: () {},
      ),
      barrierDismissible: false,
    );
  }
}
