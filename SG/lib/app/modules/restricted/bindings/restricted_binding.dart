import 'package:get/get.dart';

import '../controllers/restricted_controller.dart';

class RestrictedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestrictedController>(
      () => RestrictedController(),
    );
  }
}
