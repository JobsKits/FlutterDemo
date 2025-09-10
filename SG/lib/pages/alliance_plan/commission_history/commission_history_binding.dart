import 'package:get/get.dart';

import 'commission_history_logic.dart';

class CommissionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommissionHistoryLogic());
  }
}
