
import 'package:flutter_bet/pages/account/register/logic.dart';
import 'package:get/get.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => RegisterLogic());
  }


}