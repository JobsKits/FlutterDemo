import 'package:get/get.dart';

import '../../../../../utils/route_util.dart';
import '../../logic.dart';

class UserAgreeController extends GetxController {
  UserAgreeController();

  RegisterLogic register = Get.find<RegisterLogic>();

  _initData() {
    update(["user_agree"]);
  }

  void onTap() {
    register.hidden.value = false;
    RouteUtil.popView();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
