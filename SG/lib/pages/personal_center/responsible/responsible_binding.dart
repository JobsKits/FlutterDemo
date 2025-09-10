

import 'package:flutter_bet/pages/personal_center/responsible/responsible_logic.dart';
import 'package:get/get.dart';

class ResponsibleBinding extends Bindings{
  @override
  void dependencies() {
   Get.put(ResponsibleLogic());
  }

}