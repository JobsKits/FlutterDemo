import 'package:flutter_bet/generated/l10n.dart';
import 'package:get/get.dart';

class FairnessController extends GetxController {
  FairnessController();

  var title = S.current.fairness;
  var title1 = S.current.random_text_580;
  var title2 = S.current.random_text_581;
  var details = '';

  _initData() {
    update(["fairness"]);
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
