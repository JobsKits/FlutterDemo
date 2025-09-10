import 'package:get/get.dart';
import 'logic.dart';

class AllianceDtailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllianceDtailsLogic());
  }
}
