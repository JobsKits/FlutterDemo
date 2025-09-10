import 'package:get/get.dart';

import 'vip_club_logic.dart';

class VipClubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VipClubLogic());
  }
}
