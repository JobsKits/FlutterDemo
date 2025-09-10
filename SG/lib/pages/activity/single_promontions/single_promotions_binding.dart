import 'package:get/get.dart';

import 'single_promotions_logic.dart';

class SinglePromotionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SinglePromotionsLogic());
  }
}
