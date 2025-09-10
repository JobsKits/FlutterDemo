import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';
import '../common_model/betting_money_api_model.dart';

/// 体育复式投注， 部分逻辑
mixin BettingSportLogicDuplexMixin {
  final GlobalStateController globalController = GlobalStateController.of();

  //是否显示 金额面板
  final _duplexShowSelectMoneyObs = true.obs;

  //投注快捷金额
  final duplexBettingMoneyListObs = <BettingMoneyApiModel>[].obs;

  //todo： 保存 金额面板 选中索引。历史原因，投注单页面回被重建，所以组件即使有状态也会被重建 覆盖点，所以需要 外部保留
  final duplexSelectedIndexObs = Rxn<int>();

  ///当输入金额发生变化时
  void onSportDuplexInput(int index, String data) {
    globalController.bets[index].amount = num.parse(data);
    globalController.bets.refresh();
  }

  void onSelectedDuplexMoney(BettingMoneyApiModel? model) {}

  ///显示控制
  void showDuplexBetMoneyView(bool isShow) {
    _duplexShowSelectMoneyObs.value = isShow;
  }

  ///检查是否要显示
  bool checkShowDuplexBetMoneyView() {
    return _duplexShowSelectMoneyObs.value && duplexBettingMoneyListObs.isNotEmpty;
  }

  ///重置选中的
  void resetDuplexSelected() {
    duplexSelectedIndexObs.value = null;
  }

  //当没有投注
  void onDuplexBettingSizeChang({required bool isNotEmpty}) {
    showDuplexBetMoneyView(isNotEmpty);
    //当空 时处理 选中
    if (!isNotEmpty) resetDuplexSelected();
  }
}
