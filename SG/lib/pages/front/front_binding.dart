import 'package:get/get.dart';

import 'front_logic.dart';

class FrontBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrontLogic());
  }
}
