import 'dart:async';
import 'package:get/get.dart';

import '../../../../../../utils/route_util.dart';

class RegisterPhoneVerifyController extends GetxController {
  RegisterPhoneVerifyController();

  String codeText = '';
  final isCodeError = false.obs;
  final codeErrorText = ''.obs;
  final isButtonEnable = false.obs;
  String passwordText = '';

  late Timer timer;
  final seconds = 59.obs;

  _initData() {
    update(["phone_verify"]);
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

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (seconds < 1) {
        timer.cancel();
      } else {
        seconds.value--;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    if (timer.isActive) {
      timer.cancel();
    }
  }
}
