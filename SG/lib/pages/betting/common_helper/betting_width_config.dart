import 'package:get/get.dart';

import '../../../services/lang_service.dart';

///投注模块，配置
class BettingWidthConfig {
  double width;
  List<int> expends;

  ///竞赛排行版
  BettingWidthConfig.race()
      : width = LangService().isChinese ? Get.width * 1.0 -24: Get.width * 1.05,
        expends = LangService().isChinese ? const [15, 30, 40, 20] : const [15, 30, 40, 30];
}
