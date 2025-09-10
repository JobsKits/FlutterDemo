import 'package:get/get.dart';

import 'betting_both_logic.dart';

class BettingBothBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BettingBothLogic());
  }
}
