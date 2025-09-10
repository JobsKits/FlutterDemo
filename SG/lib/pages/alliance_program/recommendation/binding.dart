import 'package:get/get.dart';

import 'logic.dart';

class RecommendationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecommendationLogic());
  }
}
