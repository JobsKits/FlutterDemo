import 'package:get/get.dart';

import '../../../../../utils/route_util.dart';

class OAuthController extends GetxController {
  OAuthController();

  String codeText = '';
  final isCodeError = false.obs;
  final codeErrorText = ''.obs;
  final isButtonEnable = false.obs;
  String passwordText = '';

  _initData() {
    update(["o_auth"]);
  }

  void onTap() {
    RouteUtil.popView();
  }

  Future<void> onInputCode(String value) async {
    codeText = value;
    if (value.isEmpty) {
      isCodeError.value = false;
      codeErrorText.value = '';
      isButtonEnable.value = false;
      return;
    }
  }

  Future<void> onInputPwd(String value) async {
    passwordText = value;
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
