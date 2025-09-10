import 'package:get/get.dart';
import 'logic.dart';

class AllianceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllianceLogic());
  }
}
