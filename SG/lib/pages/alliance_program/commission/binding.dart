import 'package:get/get.dart';

import 'logic.dart';

class CommissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommissionLogic());
  }
}
