import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:get/get.dart';

class OffersController extends BaseController {
  OffersController();

  String offerCode = '';
  String redeemBonusDropCode = '';

  /// 新用户优惠 / 空投优惠 Code内容输入变化
  void offerCodeChange(String? text) {
    offerCode = text ?? '';
    print(text);
  }
  void redeemBonusDropCodeChange(String text) {
    redeemBonusDropCode = text ?? '';
    print(text);
  }

  /// 新用户优惠 / 空投优惠 提交
  void offerCodeSubmit(btnController) {
    print(offerCode);
  }
  void redeemBonusDropCodeSubmit(btnController) {
    print(redeemBonusDropCode);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
