import 'package:get/get.dart';
import 'logic.dart';

class VipHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VipHomeLogic());
  }
}

