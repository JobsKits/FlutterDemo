import 'package:flutter/material.dart';
import 'package:flutter_bet/model/sport/sport_bet_info_model.dart';
import 'package:flutter_bet/model/sport/sport_bet_model.dart';
import 'package:flutter_bet/pages/betting/common_model/betting_common_params.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../generated/l10n.dart';
import '../../../model/sport/sport_bet_list_model.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_icon.dart';
import '../../alliance_plan/widget/custom_select_model.dart';
import '../betting_state.dart';
import '../common_model/bet_slip_type_model.dart';

class BettingSportState {
  final loading = false.obs;//单项下注 动画按钮
  final loadingDuplex = false.obs; //复式下注 动画按钮

  ///当前已选择投注单类型
  late Rx<BetSlipTypeModel> chooseType;

  ///体育投注单分类
  late RxList<BetSlipTypeModel> sportTypeList;
  late RxList<Tab> tabs;

  ///投注数据
  late RxList<SportBetBean> sportBetList;

  ///1.从globalController中取得List<M>数据添加进注单列表
  ///2.根据注单列表数据来请求【索取投注信息】接口，并更新注单列表数据
  ///3.下注时向接口发送注单列表数据
  late Rx<SportBetModel> sportBetModel = SportBetModel(ao: 0, bl: [], cur: '').obs;

  ///单项投注赔率信息
  late Rx<SportBetInfoModel> singleSportInfoModel = SportBetInfoModel(ic: 0, bi: [], cur: '').obs;

  ///复式投注赔率信息
  late Rx<SportBetInfoModel> duplexSportInfoModel = SportBetInfoModel(ic: 1, bi: [], cur: '').obs;

  ///0:不接受任何赔率变化 1:接受更高赔率 2:接受任何赔率
  late RxInt ao = 0.obs;

  ///复式投注总赔率
  late RxString duplexTotalOdds = '1.0'.obs;

  ///复式总支付金额，用户输入金额
  late RxString duplexInputPay = '0.0'.obs;

  // ///复式预支付金额
  // late RxDouble duplexWin = 0.00.obs;

  ///串关类型
  late RxInt ptType = 0.obs;

  ///复式投注最小金额
  late RxDouble duplexMinAmount = 0.0.obs;

  ///复式投注最大金额
  late RxDouble duplexMaxAmount = 0.0.obs;

  ///总支付金额
  late RxDouble totalPay = 0.00.obs;

  ///预支付金额
  late RxDouble totalWin = 0.00.obs;

  ///预支付金额
  late RxInt totalNum = 0.obs;

  ///注单状态
  ///0.正常 1.赛事暂停 2.赛事关闭 3.同场赛事不能多个投注 4.获取投注信息失败 5.不支持复式投注
  late RxInt betStates = 0.obs;

  ///0.正常 1.余额不足 2.下注不在注单限额内
  late RxInt amountStates = 0.obs;

  ///0.正常 1.不接受赔率变动，赔率已变更 2.不接受赔率下降，赔率变更
  late RxInt oddsStates = 0.obs;

  ///0.正常 1.展示已下注列表
  late RxInt betStateForOrderDone = 0.obs;

  ///复式注单状态（跟单项投注一样）
  ///2、串关的情况下如果有多个错误提示同时满足，则按优先级提示：
  // <1>、该场馆暂不支持您所选的币种；
  // <2>、同一场赛事的多个投注项不能组合为复式投注；
  // <3>、您有暂停的投注项；
  // <4>、您有不支持复式投注的投注项；
  // <5>、赔率小于1.10的投注项不能组合为复式投注
  // <6>、同时最多只能添加10个投注项；
  // <7>、赔率已变更，您需先接受赔率更改方可进行投注；
  // <8>、您的账户余额不足；
  // <9>、不支持小数位超过两位的投注金额；
  // <10>、只支持10的整数倍的投注金额；
  // <11>、不支持小数位超过5位的投注金额；
  // <12>、获取投注信息失败；
  ///0.正常 1.赛事暂停 2.赛事关闭 3.同场赛事不能多个投注 4.获取投注信息失败 5.不支持复式投注 6.赔率小于1.10的投注项不能组合为复式投注
  late RxInt doubleBetState = 0.obs;

  ///复式投注提示文本
  late RxString doubleBetTips = ''.obs;

  ///复式投注是否显示提示文本
  late RxBool doubleBetShowTips = false.obs;

  ///复式投注金额状态判断（跟单项投注一样amountStates）
  ///0.正常 1.余额不足 2.下注不在注单限额内
  late RxInt doubleAmountState = 0.obs;

  ///选中是否接受赔率 0.接受任何赔率 1.只接受更高赔率 2.不接受任何赔率更改
  late RxInt acceptState = 2.obs;
  late RxString acceptString = S.current.no_odds_changes_accepted.obs;

  ///0.正常 1.不支持该货币
  late RxInt coinStates = 0.obs;

  ///0.正常 1.同时最多只能添加10个投注项
  late RxInt numStates = 0.obs;

  ///代表接受的小数点位数 0.正常 3:不支援的币种 4:只接受两位小数 5:要10的倍数 6:只接受小数点后5位
  late RxInt dlStates = 0.obs;

  ///投注活跃数据
  late RxList<SportBetBean> sportBetActivityList;

  ///金额输入默认小数位
  ///需求：未登录状态下，待投注项金额输入框内的提示金额显示样式我们统一显示0.00...，
  ///小数的位数根据币种保留的金额小数位数来显示（用暗色的字体颜色）
  late int decimalLength;

  BettingSportState() {
    sportTypeList = [
      BetSlipTypeModel(
          type: BettingTypeEnum.betBill,
          title: S.current.tab_bar_orders,
          icon: 'assets/images/bet_slip/ic_casino_my_bet.webp',
          count: '4'),
      BetSlipTypeModel(
          type: BettingTypeEnum.myBet,
          title: S.current.sport_tabbar_mybet,
          icon: 'assets/images/bet_slip/ic_casino_bet_order.webp'),
    ].obs;
    chooseType = BetSlipTypeModel(
            type: BettingTypeEnum.betBill,
            title: S.current.tab_bar_orders,
            icon: 'assets/images/bet_slip/ic_casino_my_bet.webp')
        .obs;
    sportBetActivityList = [
      SportBetBean(
          isRollingBall: true,
          betTitle: S.current.random_text_253,
          wayToWin: S.current.random_text_254,
          teamName: S.current.random_text_255,
          orderStatus: 0,
          money: '0.0000000',
          needPay: '0.0000000',
          odds: 1.23),
      SportBetBean(
          isRollingBall: true,
          betTitle: S.current.random_text_253,
          wayToWin: S.current.random_text_254,
          teamName: S.current.random_text_255,
          orderStatus: 0,
          money: '0.0000000',
          needPay: '0.0000000',
          odds: 3.23),
    ].obs;
    sportBetList = [
      SportBetBean(
          isRollingBall: true,
          betTitle: S.current.random_text_253,
          wayToWin: S.current.random_text_256,
          teamName: S.current.random_text_255,
          orderStatus: 0,
          money: '0.0000000',
          needPay: '0.0000000',
          odds: 10.23),
      SportBetBean(
          isRollingBall: true,
          betTitle: S.current.random_text_253,
          wayToWin: S.current.random_text_256,
          teamName: S.current.random_text_255,
          orderStatus: 0,
          money: '0.0000000',
          needPay: '0.0000000',
          odds: 2.34),
      SportBetBean(
          isRollingBall: false,
          betTitle: S.current.random_text_253,
          wayToWin: S.current.random_text_256,
          teamName: S.current.random_text_255,
          orderStatus: 2,
          money: '0.0000000',
          needPay: '0.0000000',
          odds: 0.45),
      SportBetBean(
          isRollingBall: true,
          betTitle: S.current.random_text_253,
          wayToWin: S.current.random_text_256,
          teamName: S.current.random_text_255,
          orderStatus: 0,
          money: '0.0000000',
          needPay: '0.0000000',
          odds: 1.89),
    ].obs;
  }

  late RxList<CustomSelectModel> exchangeSelectList;
  final Rx<CustomSelectModel> exchangeChooseObs =
      CustomSelectModel(S.current.tab_bar_orders, data: 1).obs;

  buildData() {
    //  ///选中是否接受赔率 0.接受任何赔率 1.只接受更高赔率 2.不接受任何赔率更改
    exchangeSelectList = [
      CustomSelectModel(S.current.random_text_1223, data: 0),
      CustomSelectModel(S.current.bet_accept_only_higher_odds, data: 1),
      CustomSelectModel(S.current.no_odds_changes_accepted, data: 2),
    ].obs;
    exchangeChooseObs.value = exchangeSelectList[2];
    sportTypeList = [
      BetSlipTypeModel(
          type: BettingTypeEnum.betBill,
          title: S.current.tab_bar_orders,
          icon: 'assets/images/bet_slip/ic_casino_my_bet.webp',
          count: '4'),
      BetSlipTypeModel(
          type: BettingTypeEnum.myBet,
          title: S.current.sport_tabbar_mybet,
          icon: 'assets/images/bet_slip/ic_casino_bet_order.webp'),
    ].obs;
    for (var element in sportTypeList) {
      if (chooseType.value.type == element.type) {
        chooseType.value = element;
      }
    }
    tabs = [
      Tab(
        icon: const CustomIcon(
          asset: 'assets/images/bet_slip/ic_bet_sigle.webp',
        ),
        child: Text(S.current.single_bet,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
      Tab(
        icon: const CustomIcon(
          asset: 'assets/images/bet_slip/ic_bet_together.webp',
        ),
        child: Text(S.current.multiple_bet,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
    ].obs;
  }
}

///体育投注单-临时数据
class SportBetBean {
  bool? isRollingBall; //是否滚球
  String? betTitle; //标题
  String? wayToWin; //获胜方式
  String? teamName; //下注队伍
  int? orderStatus; //订单状态0:正常 1:暂停 2:已结算 3:已关闭
  String? money; //下注金额
  String? needPay; //预支付金额
  String? payType; //支付币种
  double? odds; //当前赔率

  SportBetBean({
    this.isRollingBall,
    this.betTitle,
    this.wayToWin,
    this.teamName,
    this.orderStatus,
    this.money,
    this.needPay,
    this.payType,
    this.odds,
  });
}

class ResultBean {
  String? betNum; //下注单数
  String? betAmount; //下注金额

  ResultBean({
    this.betNum,
    this.betAmount,
  });
}
