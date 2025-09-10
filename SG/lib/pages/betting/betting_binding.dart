import 'package:flutter_bet/pages/betting/sport/betting_sport_logic.dart';
import 'package:get/get.dart';

import 'casino/betting_casino_logic.dart';
import 'betting_logic.dart';

///首页菜单 没有使用路由 ，所以会有 没有初始化的隐患
class BettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BettingLogic());
    Get.lazyPut(() => BettingCasinoLogic());
    Get.lazyPut(() => BettingSportLogic());
  }
}
