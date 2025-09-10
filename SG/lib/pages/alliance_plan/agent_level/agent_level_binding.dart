import 'package:get/get.dart';

import 'agent_level_logic.dart';

class AgentLevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AgentLevelLogic());
  }
}
