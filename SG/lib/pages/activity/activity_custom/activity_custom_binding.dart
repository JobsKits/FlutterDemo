import 'package:get/get.dart';

import 'activity_custom_logic.dart';

class ActivityCustomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivityCustomLogic());
  }
}
