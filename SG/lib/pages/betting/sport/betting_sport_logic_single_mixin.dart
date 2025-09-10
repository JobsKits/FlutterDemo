import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';
import '../common_model/betting_money_api_model.dart';
import 'betting_sport_logic.dart';

/// 体育单项投注， 部分逻辑
mixin BettingSportLogicSingleMixin {
  final GlobalStateController globalController = GlobalStateController.of();

  //是否显示 金额面板 总开关
  final _singleShowSelectedMoneyObs = true.obs;

  //投注快捷金额
  final singleBettingMoneyListObs = <BettingMoneyApiModel>[].obs;

  //todo： 保存 金额面板 选中索引。历史原因，投注单页面回被重建，所以组件即使有状态也会被重建 覆盖点，所以需要 外部保留
  final singleSelectedIndexObs = Rxn<int>();

  ///当输入金额发生变化时
  void onSportSingleInput(int index, String data) {
    globalController.bets[index].amount = num.parse(data);
    globalController.bets.refresh();
  }

  ///当点击 投注快捷金额时
  void onSelectedSingleMoney(int? index, BettingMoneyApiModel? model) {
    singleSelectedIndexObs.value = index;
    if (model != null) {
      for (var bet in globalController.bets) {
        bet.amount = model.betMoney;
      }
      globalController.bets.refresh();
    } else {
      for (var bet in globalController.bets) {
        bet.amount = 0;
        // bet.amount = bet.min ?? 0;
      }
      globalController.bets.refresh();
    }
  }

  ///显示控制
  void showSingleBetMoneyView(bool isShow) {
    _singleShowSelectedMoneyObs.value = isShow;
  }

  ///检查是否要显示
  bool checkShowSingleBetMoneyView() {
    return _singleShowSelectedMoneyObs.value && singleBettingMoneyListObs.isNotEmpty;
  }

  ///重置选中的
  void resetSingleSelected() {
    singleSelectedIndexObs.value = null;
  }

  //当没有投注
  void onSingleBettingSizeChang({required bool isNotEmpty}) {
    showSingleBetMoneyView(isNotEmpty);
    //当空 时处理 选中
    if (!isNotEmpty) resetSingleSelected();
  }
}
