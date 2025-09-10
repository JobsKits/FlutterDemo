import 'package:get/get.dart';

import '../controllers/fiat_payment_details_controller.dart';

class FiatPaymentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FiatPaymentDetailsController>(
      () => FiatPaymentDetailsController(),
    );
  }
}
