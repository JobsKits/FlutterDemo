import 'package:get/get.dart';
import 'logic.dart';

class VipFanshuiLingQuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VipLingQuFanshuiLogic());
  }
}
