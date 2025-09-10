import 'package:get/get.dart';

import 'tabbar_logic.dart';

class TabbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabbarLogic());
  }
}
