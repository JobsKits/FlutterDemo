import 'package:get/get.dart';

import 'logic.dart';

class CapitalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CapitalLogic());
  }
}
