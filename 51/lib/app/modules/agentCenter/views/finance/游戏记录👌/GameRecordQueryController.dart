import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GameRecordQueryController extends GetxController {
  // —— 真正挂在 TextField 的 controller —— //
  final TextEditingController memberCtrl = TextEditingController();
  final TextEditingController categoryCtrl = TextEditingController();

  // —— 对外暴露的响应式值（Obx 用它） —— //
  final RxString memberId = ''.obs;
  final RxString category = '选择游戏类别'.obs; // 默认值

  @override
  void onInit() {
    super.onInit();
    // TextField → Rx 同步
    memberCtrl.addListener(() {
      memberId.value = memberCtrl.text.trim();
    });
    // Rx → TextField 同步（用于“只读分类框”的显示）
    ever<String>(category, (v) => categoryCtrl.text = v);
  }

  @override
  void onClose() {
    memberCtrl.dispose();
    categoryCtrl.dispose();
    super.onClose();
  }

  /// 生成网络请求需要的 Query（空值用 ""）
  RecordQuery buildQuery() {
    final m = memberId.value.isEmpty ? "" : memberId.value;
    final c = (category.value.isEmpty || category.value == '选择游戏类别')
        ? ""
        : category.value;
    return RecordQuery(memberId: m, gameCategory: c);
  }
}
