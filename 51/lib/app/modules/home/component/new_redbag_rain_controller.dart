import 'dart:convert';

import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/t.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_component_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/models/RedBagData.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/redbag_revice_dialog.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NewRedbagRainController extends GetxController {
  final ActivitysComponentController acController =
      Get.put(ActivitysComponentController());

  RxInt reviceNum = 0.obs;

  RxList<RedBagData> redBags = <RedBagData>[].obs;
  late Rx<T> model = T().obs;

  Map<String, dynamic> jsonData = {};

  @override
  void onInit() async {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>;
    if (arguments['model'] != null) {
      model.value = arguments['model'];
      String? jsonString = model.value.actionCfg;
      // 解析 JSON 字符串
      jsonData = json.decode(jsonString ?? '');
    } else {
      String? jsonString = acController.model.value.actionCfg;
      // 解析 JSON 字符串
      jsonData = json.decode(jsonString ?? '');
    }

    if (LoginManager.instance.isLogin == true) {
      reqRedbagRainRemainingNumbers(model.value.id ?? 0);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 领取红包
  Future<void> reqRedbagRainRemainingNumbers(int id) async {
    final response = await ActivityApi.reqRedbagRainRemainingNumbers(id);
    if (response.data > 0) {
      reviceNum.value = response.data;
    }
  }
}
