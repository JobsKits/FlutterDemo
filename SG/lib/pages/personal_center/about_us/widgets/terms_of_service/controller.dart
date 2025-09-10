import 'package:flutter_bet/generated/l10n.dart';
import 'package:get/get.dart';

class TermsOfServiceController extends GetxController {
  TermsOfServiceController();

  var title = S.current.terms_of_service_text;
  var title1 = S.current.random_text_580;
  var title2 = S.current.random_text_581;
  var details = '';

  _initData() {
    update(["terms_of_service"]);
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
