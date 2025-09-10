import 'package:get/get.dart';

import '../controllers/commission_wallet_controller.dart';

class CommissionWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommissionWalletController>(
      () => CommissionWalletController(),
    );
  }
}
