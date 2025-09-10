import 'package:get/get.dart';

import 'commission_receive_logic.dart';

class CommissionReceiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommissionReceiveLogic());
  }
}
