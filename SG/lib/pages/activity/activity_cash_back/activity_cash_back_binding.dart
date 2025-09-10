import 'package:get/get.dart';

import 'activity_cash_back_logic.dart';

class ActivityCashBackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivityCashBackLogic());
  }
}
