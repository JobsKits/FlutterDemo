import 'package:get/get.dart';

import 'logic.dart';

class SportDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SportDetailLogic());
  }
}
