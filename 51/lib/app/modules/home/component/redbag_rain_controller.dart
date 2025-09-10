import 'dart:convert';

import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/t.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_component_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/models/RedBagData.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/redbag_revice_dialog.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/dialog_manager.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RedbagRainController extends GetxController {
  final ActivitysComponentController acController =
      Get.put(ActivitysComponentController());

  RxInt preGameCountdown = 0.obs;
  RxInt countdown = 10.obs;
  RxBool gameStarted = false.obs;
  RxBool showRewardModal = false.obs;

  /// 红包雨显示
  final redbagRainStatus = false.obs;
  final redBagStart = false.obs;
  final redBagReward = false.obs;
  final rewardAmount = ''.obs;
  final isClick = false.obs;

  RxList<RedBagData> redBags = <RedBagData>[].obs;

  Map<String, dynamic> jsonData = {};

  RxBool isPushed = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 领取红包
  Future<void> reqRedbagRainActivity(int id, Function(bool) callback) async {
    final response = await ActivityApi.reqReviceRain(id);
    print({'object ==============${response.type}'});
    print({'object ==============${response.data}'});
    if (response.type == NetworkService.networkTypeSuccess &&
        response.data['amount'] > 0) {
      var amount = response.data['amount'] / 1000;
      amount = double.parse(amount.truncateToFixed(2));
      callback(true);
      Get.dialog(
        RadbagReviceDialog(price: amount),
        barrierDismissible: false,
      );
    } else {
      callback(false);
      displayTips(response.data.toString());
    }
  }

  void displayTips(String tips) {
    DialogManager.showDialogWithQueue(
        dialog: TipsDialog(
          tips: tips,
          // desc: desc,
          comfirmText: '知道了',
          contentF1Size: 42,
          contentF2Size: 35,
          type: 'redbag',
          confirmAction: () {
            Get.back();
            Get.back();
            if (tips == '请绑定手机号') {
              isPushed.value = true;
              Get.toNamed(Routes.USER_INFO,
                  arguments: {"isShowSendCode": true});
            }
          },
        ),
        priority: 99);
  }

  void saveRainIds(String saveName, int id) async {
    List<String>? existingIds = await loadLoaclData(saveName);
    existingIds ??= [];

    String idStr = id.toString();
    if (existingIds.contains(idStr)) {
      existingIds.remove(idStr);
    } else {
      existingIds.add(idStr);
    }
    await SpUtil.saveStringList(saveName, existingIds);
  }

  Future<List<String>?> loadLoaclData(String key) async {
    return await SpUtil.getStringList(key);
  }
}
