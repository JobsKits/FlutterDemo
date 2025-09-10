import 'package:flutter_bet/pages/personal_center/wallet/binding_bank_card_controller.dart';
import 'package:get/get.dart';

import '../controllers/binding_pix_controller.dart';

class BindingPixBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BindingPixController>(
      () => BindingPixController(),
    );
  }
}
