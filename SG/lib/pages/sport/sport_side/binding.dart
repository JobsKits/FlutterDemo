import 'package:get/get.dart';

import 'logic.dart';

class SportSideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SportSideLogic());
  }
}
