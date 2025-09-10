

import 'package:flutter_bet/pages/personal_center/data_count/data_count_logic.dart';
import 'package:get/get.dart';

class DataCountBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DataCountLogic());
  }

}