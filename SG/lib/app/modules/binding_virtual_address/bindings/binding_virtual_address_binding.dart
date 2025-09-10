import 'package:flutter_bet/pages/personal_center/wallet/binding_bank_card_controller.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:get/get.dart';

import '../controllers/binding_virtual_address_controller.dart';


class BindingVirtualAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BindingVirtualAddressController>(
      () => BindingVirtualAddressController(),
    );
  }
}
