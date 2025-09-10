import 'package:get/get.dart';

import '../controllers/cs_home_controller.dart';

class CsHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CsHomeController>(
      () => CsHomeController(),
    );
  }
}