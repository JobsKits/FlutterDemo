import 'package:get/get.dart';

import 'logic.dart';

class AllianceProgramBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllianceProgramLogic());
  }
}
