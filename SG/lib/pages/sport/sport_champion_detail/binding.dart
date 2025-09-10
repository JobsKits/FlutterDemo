import 'package:get/get.dart';

import 'logic.dart';

class Sport_champion_detailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Sport_champion_detailLogic());
  }
}
