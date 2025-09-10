import 'package:get/get.dart';

import 'logic.dart';

class SportFavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SportFavoriteLogic());
  }
}
