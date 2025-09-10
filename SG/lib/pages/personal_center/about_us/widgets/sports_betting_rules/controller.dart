import 'package:flutter_bet/generated/l10n.dart';
import 'package:get/get.dart';

class SportsBettingRulesController extends GetxController {
  SportsBettingRulesController();

  var title = S.current.sports_betting_rules;
  var title1 = S.current.random_text_580;
  var title2 = S.current.random_text_581;
  var details = '';

  _initData() {
    update(["sports_betting_rules"]);
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
