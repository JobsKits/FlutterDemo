import 'package:get/get.dart';

import 'activity_promotion_logic.dart';

class ActivityPromotionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivityPromotionLogic());
  }
}
