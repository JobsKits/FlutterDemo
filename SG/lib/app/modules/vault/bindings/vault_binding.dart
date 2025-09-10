import 'package:flutter_bet/pages/personal_center/vault/vault_controller.dart';
import 'package:get/get.dart';

class VaultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaultController>(
      () => VaultController(),
    );
  }
}
