import 'package:get/get.dart';

import 'logic.dart';

class ChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatRoomLogic());
  }
}
