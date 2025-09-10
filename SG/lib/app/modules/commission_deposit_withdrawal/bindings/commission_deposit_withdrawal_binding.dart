import 'package:get/get.dart';

import '../controllers/commission_deposit_withdrawal_controller.dart';

class CommissionDepositWithdrawalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommissionDepositWithdrawalController>(
      () => CommissionDepositWithdrawalController(),
    );
  }
}
