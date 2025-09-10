import 'package:get/get.dart';

import '../controllers/red_packet_controller.dart';

class RedPacketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RedPacketController>(
      () => RedPacketController(),
    );
  }
}
