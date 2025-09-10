import 'package:get/get.dart';

import 'logic.dart';

class ActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivityLogic());
  }
}
