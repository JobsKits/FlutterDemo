import 'package:get/get.dart';

import 'logic.dart';

class TestSnackBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TestSnackBarLogic());
  }
}
