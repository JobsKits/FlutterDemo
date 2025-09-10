
import 'package:get/get.dart';

import 'alliance_plan_logic.dart';

class AlliancePlanBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AlliancePlanLogic());
  }

}