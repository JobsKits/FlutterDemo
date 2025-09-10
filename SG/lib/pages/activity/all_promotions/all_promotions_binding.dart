
import 'package:get/get.dart';

import 'all_promotions_logic.dart';

class AllPromotionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllPromotionsLogic());
  }
}
