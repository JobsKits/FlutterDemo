import 'package:get/get.dart';

import 'controller.dart';

class ResponsibleForGamblingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResponsibleForGamblingController>(() => ResponsibleForGamblingController());
  }
}
