import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../generated/l10n.dart';
import 'common_model/bet_slip_type_model.dart';
import 'common_model/betting_common_params.dart';

class BettingState {
  ///当前投注页类型 0:娱乐城投注单 1:体育投注单 默认为娱乐城类型
  late RxInt bettingPageTypeObs;

  ///缩放比例
  final scale = 1.0.obs;

  BettingState() {
    bettingPageTypeObs = 1.obs;
  }
}
