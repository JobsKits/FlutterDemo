import '../../../model/wallet/CurrencyBean.dart';
import 'activity_common_params.dart';

///推广界面 开宝箱item model
class PromotionProcessItemModel {
  String imgUrl;
  String content;
  String contentUnit;
  bool insideMoney; //是否是内部显示
  String money;
  String coinUrl;
  CurrencyBean? coinBean;
  ActivityAwardState state; //类型状态
  ActivityReceiveState? receiveState; //领取状态

  PromotionProcessItemModel({
    required this.imgUrl,
    required this.content,
    required this.contentUnit,
    required this.state,
    this.insideMoney = false,
    this.money = "",
    this.coinUrl = "",
    this.coinBean,
    this.receiveState,
  });

  void nextState() {
    if (state.nextState != null) {
      state = insideMoney ? state.nextStateInside! : state.nextState!;
    }
  }

  @override
  String toString() {
    return 'PromotionProcessItemModel{imgUrl: $imgUrl, content: $content, contentUnit: $contentUnit, insideMoney: $insideMoney, money: $money, state: $state}';
  }
}
