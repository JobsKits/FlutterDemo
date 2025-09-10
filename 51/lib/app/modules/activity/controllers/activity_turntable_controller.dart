import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_info.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/action_cfg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/activity_turntable_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/wheel_config.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/turntable_records_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/turntable_win_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

enum TirntbaleEnum {
  silver, // 银
  gold, // 金
  diamond, // 钻
}

class ActivityTurntableController extends GetxController {
  late Rx<ActivityTurntableDetailModel> model =
      ActivityTurntableDetailModel().obs;
  late final ActionCfg actionCfg;
  late final Rx<WheelConfig> wheelConfig = WheelConfig().obs;
  late final Rx<WheelConfig> wheelConfig2 = WheelConfig().obs;
  late final Rx<WheelConfig> wheelConfig3 = WheelConfig().obs;
  late final RxList<dynamic> wheelSwitch = <dynamic>[].obs;
  Rx<ActivityTurntableDetailInfo> info = ActivityTurntableDetailInfo().obs;
  Rx<TirntbaleEnum> type = TirntbaleEnum.silver.obs;
  final NewHomeController hcController = Get.find();
  var wheelType = 1;

  @override
  void onInit() async {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>;

    model.value = arguments['model'];
    actionCfg = model.value.actionCfg as ActionCfg;
    final List<WheelConfig> configs = actionCfg.wheelConfigs ?? [];

    if (configs.length >= 1) {
      wheelConfig.value = configs.first;
    }
    if (configs.length >= 2) {
      wheelConfig2.value = configs[1];
    }
    if (configs.length >= 3) {
      wheelConfig3.value = configs[2];
    }

    wheelSwitch.value = actionCfg.wheelSwitch ?? <dynamic>[];

    wheelType = wheelSwitch.first;
    updateTypeBasedOnWheelSwitch();

    // if (LoginManager.instance.isLogin.value) {
    reqActivityTurntableDetail();
    // }
  }

  void updateTypeBasedOnWheelSwitch() {
    if (wheelSwitch.isNotEmpty) {
      final firstValue = wheelSwitch[0];

      switch (firstValue) {
        case 1:
          type.value = TirntbaleEnum.silver;
          break;
        case 2:
          type.value = TirntbaleEnum.gold;
          break;
        case 3:
          type.value = TirntbaleEnum.diamond;
          break;
        default:
          type.value = TirntbaleEnum.silver;
      }
    }
  }

  num get maxAmount {
    late List wheelGrids = [];
    if (type.value == TirntbaleEnum.silver) {
      wheelGrids = wheelConfig.value.wheelGrids ?? [];
      wheelType = wheelConfig.value.wheelType ?? 1;
    } else if (type.value == TirntbaleEnum.gold) {
      wheelGrids = wheelConfig2.value.wheelGrids ?? [];
      wheelType = wheelConfig2.value.wheelType ?? 1;
    } else if (type.value == TirntbaleEnum.diamond) {
      wheelGrids = wheelConfig3.value.wheelGrids ?? [];
      wheelType = wheelConfig3.value.wheelType ?? 1;
    }

    if (wheelGrids.isEmpty) return 0;

    final maxReward = wheelGrids.fold<int>(
        0,
        (max, item) =>
            (max > (item.rewordAmount ?? 0)) ? max : (item.rewordAmount ?? 0));
    return maxReward;
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
      amount = (amount * 100).truncate() / 100;

      Get.dialog(
        TurntableWinDialog(price: amount),
        barrierDismissible: false,
      );
      reqActivityTurntableDetail();
      callback(response.data['t']['rewordAmount']); //4是未中奖
    } else if (response.type == NetworkService.networkTypeError) {
      displayTips('您的积分不足\n请获取积分后再参与');
      callback(0); //4是未中奖
    } else {
      callback(0);
    }
  }

  /// 领取红包
  Future<void> reqActivityTurntableRecords() async {
    Get.dialog(TurntableRecordsDialog(
        arguments: {'id': model.value.id ?? 0, 'wheelType': wheelType}));
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

  Future<void> reqActivityTaskIntegral(TaskConfigs taskConfig) async {
    print({'object ========== '});
    final response = await ActivityApi.reqActivityTaskIntegral(
        model.value.id ?? 0, taskConfig.taskId ?? 0);
    print({'object ==============${response.type}'});
    print({'object ==============${response.data}'});
    if (response.type == NetworkService.networkTypeSuccess) {
      EasyLoading.showToast('领取成功');

      Future.delayed(Duration(milliseconds: 500), () {
        reqActivityTurntableDetail();
      });
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
