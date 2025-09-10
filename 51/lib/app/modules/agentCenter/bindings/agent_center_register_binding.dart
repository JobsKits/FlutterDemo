import '../controllers/agent_center_register_controller.dart';
import 'package:get/get.dart';

class AgentCenterRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentCenterRegisterController>(
      () => AgentCenterRegisterController(),
    );
  }
}
