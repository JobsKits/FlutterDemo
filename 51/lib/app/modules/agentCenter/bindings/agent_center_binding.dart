import 'package:get/get.dart';

import '../controllers/agent_center_controller.dart';
import '../controllers/agent_center_register_controller.dart';
import '../controllers/agent_center_share_controller.dart';
import '../controllers/agent_center_data_controller.dart';
import '../controllers/agent_center_member_controller.dart';

class AgentCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AgentCenterRegisterController());
    Get.put(AgentCenterShareController());
    // Get.put(AgentCenterDataController());
    // Get.put(AgentCenterMemberController());

    Get.lazyPut<AgentCenterController>(
      () => AgentCenterController(),
    );

    Get.lazyPut<AgentCenterDataController>(
      () => AgentCenterDataController(),
    );

    Get.lazyPut<AgentCenterMemberController>(
      () => AgentCenterMemberController(),
    );
  }
}
