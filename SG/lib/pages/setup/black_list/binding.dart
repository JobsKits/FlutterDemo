import 'package:get/get.dart';

import 'logic.dart';

class BlackListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BlackListLogic());
  }
}
