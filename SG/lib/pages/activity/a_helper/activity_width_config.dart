//为了适配国际化语言， 做长度适配
// mixin BettingListWidthConfig{
//   double width;
//   List<int> expends;
//
// }

import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';

class ActivityWidthConfig {
  double width;
  List<int> expends;

  ActivityWidthConfig.invite()
      : width = GlobalStateController.of().isChinese() ? Get.width *1.0 : Get.width * 1.1,
        expends = GlobalStateController.of().isChinese() ? [90,130,50] : [10,20,8];


}
