import 'package:get/get.dart';
import 'controller.dart';

class YulechengcategorypageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YulechengcategorypageController());
  }
}
