import 'package:flutter_bet/app/modules/binding_bank_card/controllers/binding_bank_card_controller.dart';
import 'package:get/get.dart';


class BindingBankCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BindingBankCardController>(
      () => BindingBankCardController(),
    );
  }
}
