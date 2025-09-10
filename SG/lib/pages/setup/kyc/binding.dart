import 'package:get/get.dart';

import 'logic.dart';

class SetupKYCBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetupKYCLogic());
  }
}
