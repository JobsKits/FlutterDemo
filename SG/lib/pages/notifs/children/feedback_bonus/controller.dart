import 'package:flutter_bet/generated/l10n.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/model/notifis/exchange_rate.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_detail/controller.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_home/controller.dart';
import 'package:flutter_bet/pages/personal_center/vault/model/coin_rate_model.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/notifs_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_progress_hud.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';

class FeedbackBonusController extends GetxController {
  FeedbackBonusController();

  /// 币种列表
  List<CurrencyBean> coinInfos = [];
  /// 所选币种
  late CurrencyBean selCoin;

  /// 汇率信息
  late ExchangeRateModel rateTool;
  /// 所选币种汇率
  Decimal selCoinRate = Decimal.parse('0');
  /// 转换后的奖金
  String userCoinBonus = '0';

  late String feedId;
  late String bonus;
  

  _initData() {

    GlobalStateController globalController = Get.find<GlobalStateController>();
    coinInfos = globalController.currTypeLists;
    selCoin   = coinInfos.first;

    reqExchangeRate();
    update(["feedback_bonus"]);
  }


  ///获取 汇率
  Future<void> reqExchangeRate() async {
    await ApiService.instance.exchangeRateList<ExchangeRateModel>(
      success: (data) {
        rateTool = data;
        updateInfo();
      },
      fail: (message) {},
      converter: (json) {
        return ExchangeRateModel.fromJson(json);
      },
    );
  }

  /// 货币类型切换
  void changeCoinType(CurrencyBean bean) {
    selCoin = bean;
    userCoinBonus = "";
    updateInfo();
  }

  /// 确认领取
  void reqReceiveAction(context) {
    CustomProgressHUD.show(context, content: S.current.random_text_4);
    ApiService.instance.feedbackBonusDraw(
        feedId: feedId ?? "",
        coinId: selCoin.cur ?? "",
        success: (data) {
          Future.delayed(const Duration(milliseconds: 250), () async {
            CustomProgressHUD.dismiss(context);
            RouteUtil.popView();

            try{
              final homeController = Get.find<FeedbackHomeController>();
              homeController?.feedbackBonusCallback(S.current.random_text_96);
            }catch(e){}

            try{
            final detailController = Get.find<FeedbackDetailController>();
            detailController?.feedbackBonusCallback(S.current.random_text_96);
            }catch(e){}

            await Future.delayed(const Duration(seconds: 1)); // 延迟一秒
            ///刷新钱包余额
            Get.find<GlobalStateController>().inquireBalance();
          });
        },
        fail: (errorMessage) {
          CustomProgressHUD.dismiss(context);
          CustomSnackBar.showError(errorMessage!, context);
        }
    );
  }
  
  void updateInfo() {
    if(coinInfos.isNotEmpty && rateTool.rates.isNotEmpty) {
      final usdt    = coinInfos.firstWhere((element) => element.name == "USDT");
      selCoinRate   = rateTool.getRate(usdt, selCoin);
      Decimal coinBonus = Decimal.parse(bonus) * selCoinRate;
      userCoinBonus     = coinBonus.toString();
    }
    update(["feedback_bonus"]);
  }


  @override
  void onReady() {
    super.onReady();
    _initData();
  }

}
