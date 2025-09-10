import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_detail_controller.dart';
import 'package:get/get.dart';

class RechargeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RechargeDetailController>(
      () => RechargeDetailController(),
    );
  }
}
