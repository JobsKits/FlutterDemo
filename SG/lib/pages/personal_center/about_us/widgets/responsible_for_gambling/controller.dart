import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:get/get.dart';
import '../../../../../controllers/global_state_controller.dart';

class ResponsibleForGamblingController extends GetxController with GetTickerProviderStateMixin {
  ResponsibleForGamblingController();
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  var title = S.current.responsible_for_gambling;
  var title1 = S.current.random_text_580;
  var title2 = S.current.random_text_581;
  var details = '';
  late TabController tabController;

  _initData() {
    update(["responsible_for_gambling"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 1, initialIndex: 0, vsync: this);
  }

  String getFile() {
    if (globalController.langType.value == 4) {
      return 'assets/html/responsible_for_gambling_vi.html';
    } else if (globalController.langType.value == 5) {
      return 'assets/html/responsible_for_gambling_th.html';
    } else if (globalController.langType.value == 6) {
      return 'assets/html/responsible_for_gambling_hi.html';
    }
    return 'assets/html/responsible_for_gambling.html';
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }
}
