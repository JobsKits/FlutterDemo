import 'package:flutter_bet/generated/l10n.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  PrivacyPolicyController();

  var title = S.current.privacy_policy;
  var details = '';

  _initData() {
    update(["privacy_policy"]);
  }

  void onTap() {}

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
