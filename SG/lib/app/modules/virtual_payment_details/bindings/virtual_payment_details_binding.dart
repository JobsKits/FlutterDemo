import 'package:get/get.dart';

import '../controllers/virtual_payment_details_controller.dart';

class VirtualPaymentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VirtualPaymentDetailsController>(
      () => VirtualPaymentDetailsController(),
    );
  }
}
