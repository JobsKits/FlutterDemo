import 'package:get/get.dart';
import 'logic.dart';

class YulechengGongPingXingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YulechengGongPingXingController());
  }
}
