import 'package:flutter_bet/pages/setup/index/logic.dart';
import 'package:get/get.dart';

class SetupBinding extends Bindings {


  @override
  void dependencies() {
    Get.lazyPut(() => SetupLogic());
  }
}