import 'package:get/get.dart';

import 'expansion_logic.dart';

class ExpansionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExpansionLogic());
  }
}
