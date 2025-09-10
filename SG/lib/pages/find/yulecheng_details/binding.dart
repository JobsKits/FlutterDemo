import 'package:get/get.dart';
import 'logic.dart';

class YuLeChengDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YulechenggamedetailsController());
  }
}
