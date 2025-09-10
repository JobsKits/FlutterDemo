import 'package:get/get.dart';

import 'activity_red_packet_logic.dart';

class ActivityRedPacketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivityRedPacketLogic());
  }
}
