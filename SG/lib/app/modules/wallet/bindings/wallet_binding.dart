import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:get/get.dart';


class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(
      () => WalletController(),
    );
  }
}
