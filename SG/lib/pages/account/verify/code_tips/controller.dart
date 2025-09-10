import 'package:get/get.dart';

import '../../../../utils/route_util.dart';
import '../verify_code/controller.dart';

class CodeTipsController extends GetxController {
  CodeTipsController();

  final isButtonEnable = true.obs;
  var fromPage = 0;

  _initData() {
    update(["code_tips"]);
  }

  void onTap() {
    if (fromPage == 1) {

    } else if (fromPage == 2) {
      VerifyCodeController verifyCode = Get.find<VerifyCodeController>();
      verifyCode.hidden.value = false;
    }
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
