import 'package:get/get.dart';

import 'logic.dart';

class TestColorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TestColorLogic());
  }
}
