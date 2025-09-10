import 'package:get/get.dart';

import 'logic.dart';

class TestKeyboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TestKeyboardLogic());
  }
}
