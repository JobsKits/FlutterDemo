import 'package:get/get.dart';

import '../controllers/rotary_controller.dart';

class RotaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RotaryController>(
      () => RotaryController(),
    );
  }
}
