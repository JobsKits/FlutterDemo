import 'package:get/get.dart';

import 'logic.dart';

class SportBetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SportBetLogic());
  }
}
