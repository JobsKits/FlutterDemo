import 'package:get/get.dart';

import 'bet_list_logic.dart';

class BetListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>  BetListLogicTwo());
  }
}
