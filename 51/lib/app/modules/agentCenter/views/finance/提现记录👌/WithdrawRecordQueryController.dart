import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WithdrawRecordQueryController extends GetxController {
  // —— 真正挂在 TextField 的 controller —— //
  final TextEditingController memberCtrl = TextEditingController();

  // —— 对外暴露的响应式值（Obx 用它） —— //
  final RxString memberId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // TextField → Rx 同步
    memberCtrl.addListener(() {
      memberId.value = memberCtrl.text.trim();
    });
  }

  @override
  void onClose() {
    memberCtrl.dispose();
    super.onClose();
  }
}
