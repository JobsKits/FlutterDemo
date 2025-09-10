import 'package:get/get.dart';

import '../controllers/commission_conversion_controller.dart';

class CommissionConversionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommissionConversionController>(
      () => CommissionConversionController(),
    );
  }
}
