import 'package:get/get.dart';

import '../controllers/vault_descriptions_controller.dart';

class VaultDescriptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaultDescriptionsController>(
      () => VaultDescriptionsController(),
    );
  }
}
