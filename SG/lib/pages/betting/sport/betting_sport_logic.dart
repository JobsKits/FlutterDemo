import 'dart:async';
import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/model/sport/sport_bet_model.dart';
import 'package:flutter_bet/model/sport/sport_odds_model.dart';
import 'package:flutter_bet/pages/betting/sport/betting_sport_logic_single_mixin.dart';
import 'package:flutter_bet/pages/sport/sport_detail/model.dart';
import 'package:flutter_bet/pages/betting/sport/widget/sport_slip_odds_changes_mixin.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_controller.dart';
import '../../../constant/app_themes.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../model/sport/sport_bet_info_model.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../routes/routes.dart';
import '../../../services/api/api_service.dart';
import '../../../services/event/event_service.dart';
import '../../../utils/future_util.dart';
import '../../../utils/json_util.dart';
import '../../../utils/num_util.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_button_controller.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../../account/register/register_widget.dart';
import '../../alliance_plan/widget/custom_select_model.dart';
import '../../main/code.dart';
import '../common_helper/betting_biz_helper.dart';
import '../common_model/bet_slip_type_model.dart';
import '../common_model/betting_common_params.dart';
import '../common_model/betting_money_api_model.dart';
import 'betting_sport_logic_duplex_mixin.dart';
import 'betting_sport_state.dart';

class BettingSportLogic extends BaseController
    with
        GetTickerProviderStateMixin,
        SportSlipOddsChangesMixin,
        BettingSportLogicSingleMixin,
        BettingSportLogicDuplexMixin {
  final BettingSportState state = BettingSportState();
  TabController? tabController;

  static BettingSportLogic of() {
    return Get.find<BettingSportLogic>();
  }

  final initSelectedObs = 1.obs;

  ///默认选择2
  final selectTypeListObs = <CustomSelectModel>[
    CustomSelectModel(S.current.tab_bar_orders, type: 0),
    CustomSelectModel(S.current.sport_tabbar_mybet, type: 1),
    CustomSelectModel(S.current.sport_tabbar_mybet, type: 2),
  ].obs;

  final GlobalStateController globalController = Get.find<GlobalStateController>();
  Timer? myTimer;
  int lenght = 0;
  int totalCount = 0;
  num totalMoney = 0;

  @override
  void showOddsChangesAnimation(BuildContext context, Offset startOffset, Size size, String type) {
    super.showOddsChangesAnimation(context, startOffset, size, type);
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();

    ///初始化注单信息
    initBetInfo();
    initObsEvent();

    ///获取索取投注信息请求参数并请求
    // loadSingleSportInfo();
    // loadDuplexSportInfo();
    myTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      // loadSingleSportInfo();
      // loadDuplexSportInfo();
      // initBetInfo();
      reLoadSportBetInfo();
    });
  }

  ///重新加载 注单信息
  void reLoadSportBetInfo() {
    if (globalController.bets.isNotEmpty) {
      /// 异步的同时执行tasks中的Future
      /// 有任何一个Future返回false，则直接返回false
      /// 等待所有的Future返回true，则返回true
      FutureUtil.executeTasksAsync([
        loadSingleSportInfo(),
        loadDuplexSportInfo(),
      ]).then((isFinish) {
        //状态判断
        // log("等待所有的Future...$isFinish");
        initBetInfo();
      });
    }
  }

  late CurrencyBean currCoinBean;

  bool needUpdateMinBet = false; //是否需要跟新最小投注

  ///监听obs 事件的变变化
  initObsEvent() {
    //初始化
    currCoinBean = globalController.currTypeSelected.value;
    //监听货币切换， 切换时更新最小投注
    ever(globalController.currTypeSelected, (coinBean) {
      if (currCoinBean != coinBean) {
        currCoinBean = coinBean;
        needUpdateMinBet = true;
      }
    });

    //监听投注单
    ever(globalController.bets, (callback) async {
      if (globalController.bets.isNotEmpty) {
        state.oddsStates.value = 0;
        state.doubleBetState.value = 0;
        onSingleBettingSizeChang(isNotEmpty: true);
        onDuplexBettingSizeChang(isNotEmpty: true);
      } else {
        resetDuplexBetState();
        onSingleBettingSizeChang(isNotEmpty: false);
        onDuplexBettingSizeChang(isNotEmpty: false);
      }
      // log("initObsEvent...数量发生变化...${lenght}...${globalController.bets.length}");
      // log("initObsEvent...数量发生变化...${JsonUtil.encodeObj(globalController.bets)}");
      if (lenght != globalController.bets.length) {
        if (globalController.bets.isNotEmpty) {
          state.chooseType.value = state.sportTypeList[0];
        }
        await loadSingleSportInfo(minBet: true);
        await loadDuplexSportInfo();
        lenght = globalController.bets.length;
        if (lenght > 10) {
          state.numStates.value = 1;
        } else {
          state.numStates.value = 0;
        }
        // if(state.chooseType.value.typeId!=state.sportTypeList[0].typeId){
        //   ///我的投注，查看注单，然后点击体育，选择任意盘口，回到“投注单”页，还是显示“我的投注”
        //   state.chooseType.value = state.sportTypeList[0];
        // }
      }
      initBetInfo();
    });

    ///监听
    // state.decimalLength  = globalController.currTypeSelected.value.decimal_places;
    ever(globalController.currTypeSelected, (CurrencyBean bean) {
      // state.decimalLength = bean.decimal_places;
      loadSingleSportInfo();
      loadDuplexSportInfo();
      initBetInfo();
    });

    ///监听 是否是登陆状态， 未登录"我的投注" 不可点击并置灰
    settingMyBetEnable(globalController.isLogin.value);
    ever(globalController.isLogin, (isLogin) {
      //体育的投注
      settingMyBetEnable(isLogin);
    });

    ///需求：
    ///【体育】未登录状态下，从 “体育” 切换到 “投注单”，stake是直接弹出注册页，我们需要点击下方的“注册进行投注”
    ever(globalController.buttonSelectIndex, (index) {
      if (!globalController.isLogin.value &&
          globalController.menuSelectType.value == 1 &&
          index == 2) {
        openPageToRegisterPage();
      }
    });

    /// 监听 语言切换
    ever(globalController.langType, (callback) => globalController.bets.clear());
  }

  void settingMyBetEnable(bool isEnable) {
    if (state.sportTypeList.isNotEmpty && state.sportTypeList.length > 1) {
      //置灰色
      state.sportTypeList[1].isEnable = isEnable;
      //并选第一个
      state.chooseType.value = state.sportTypeList[0];
    }
  }

  @override
  void onClose() {
    tabController?.dispose();

    myTimer?.cancel();
    super.onClose();
  }

  ///初始化投注单信息, 什么时候被调用
  ///onReady
  ///globalController.bets 监听变化
  ///globalController.currTypeSelected 监听变化
  void initBetInfo() {
    // log('更新注单列表状态-start：${JsonUtil.encodeObj(globalController.bets)}');
    state.totalNum.value = globalController.bets.length;

    ///计算总支付金额
    state.totalPay.value = Decimal.parse(
            '${globalController.bets.fold(Decimal.zero, (Decimal previousValue, M object) => previousValue + Decimal.parse('${object.amount!}'))}')
        .toDouble();

    ///单项投注注单状态
    if (globalController.bets.any((element) => element.os == 0 || element.es == 2)) {
      ///注单列表包含未开盘注单
      state.betStates.value = 2;
    } else {
      if (globalController.bets.any((element) => element.rbts == 3)) {
        ///注单列表包含暂停注单
        state.betStates.value = 1;
      } else {
        state.betStates.value = 0;
      }
    }

    ///单项投注金额状态
    if (globalController.bets.any((element) => element.amount == 0.00)) {
      state.amountStates.value = 3;
    } else {
      if (state.totalPay.value >
          num.parse(globalController.currTypeSelected.value.amount ?? '0.0')) {
        ///余额不足
        state.amountStates.value = 1;
      } else {
        if (globalController.bets.every((element) =>
            element.amount! >= (element.min ?? 0) &&
            element.amount! <= (element.max ?? 1000000000))) {
          state.amountStates.value = 0;
        } else {
          state.amountStates.value = 2;
        }
      }
    }
    if (globalController.bets.any((element) => element.showState != 0)) {
      state.betStateForOrderDone.value = 1;
    } else {
      state.betStateForOrderDone.value = 0;
    }

    if (state.betStateForOrderDone.value == 0) {
      // bool hasDuplicateAge = globalController.bets.any((element) {
      //   return globalController.bets.any((element1) {
      //     return element != element1 && element.ci == element1.ci;
      //   });
      // });

      if (checkSameCi(globalController.bets)) {
        // print('是否包含同场赛事$hasDuplicateAge');

        ///包含同场赛事
        state.doubleBetState.value = 3;
      } else {
        ///复式投注注单状态
        if (globalController.bets.any((element) => element.os == 0)) {
          ///注单列表包含未开盘注单 2.赛事关闭
          state.doubleBetState.value = 2;
        } else if (globalController.bets.any((element) => element.os == 2 || element.ic != 1)) {
          ///5.不支持复式投注
          state.doubleBetState.value = 5;
        } else if (globalController.bets.any((element) =>
            element.osDuplex == 3 &&
            double.parse(element.ov ?? '0') < BettingCommonConfig.unSupportDuplexOv)) {
          ///6.赔率小于1.10的投注项不能组合为复式投注
          state.doubleBetState.value = 6;
        } else {
          if (globalController.bets.any((element) => element.rbts == 3)) {
            ///注单列表包含暂停注单
            state.doubleBetState.value = 1;
          } else {
            state.doubleBetState.value = 0;
          }
        }
      }
    } else {
      state.doubleBetState.value = 0;
    }

    log('是否包含同场赛事${state.doubleBetState.value}');

    ///复式投注金额状态判断
    ///金额累积计算
    state.totalWin.value = globalController.bets.fold(
      0.00,
      (double previousValue, M object) {
        //todo: 防止精度丢失；
        double money = previousValue +
            NumUtil.multiplyDec(object.amount!, double.tryParse(object.ov ?? '0.00')!).toDouble();
        // log("预支付金额：object.amount:${object.amount!}, object.ov:${object.ov},计算：${BettingBizHelper.toDouble(object.amount) * double.parse(object.ov!)},money:$money");
        //预支付金额：object.amount:3.0, object.ov:5.60,计算：16.799999999999997,money:16.799999999999997
        //预支付金额：object.amount:3, object.ov:3.05,计算：9.149999999999999,money:9.15 【可以了】
        return money;
      },
    );
    checkDoubleAmountState(); //检查输入金额
    state.doubleBetShowTips.value = getDoubleErroState();
    state.doubleBetTips.value = getDoubleErroText();
    // log('更新注单列表状态-end：${JsonUtil.encodeObj(globalController.bets)}');
  }

  //当复式 输入关闭时
  void onDuplexKeyboardClose() {
    checkDoubleAmountInput();
    checkDoubleAmountState();
  }

  @override
  void onSelectedDuplexMoney(BettingMoneyApiModel? model) {
    super.onSelectedDuplexMoney(model);
    if (model != null) {
      state.duplexInputPay.value = "${model.betMoney}";
    } else {
      state.duplexInputPay.value = "0";
    }
    onDuplexKeyboardClose();
  }

  ///复式投注，对输入金额进行处理
  void checkDoubleAmountInput() {
    //如果是空
    if (state.duplexInputPay.value.isEmpty) {
      state.duplexInputPay.value = "0";
    } else if (state.duplexInputPay.value.endsWith('.')) {
      //如果最后只是一个小数点'.', 去掉
      state.duplexInputPay.value =
          state.duplexInputPay.value.substring(0, state.duplexInputPay.value.length - 1);
      // log("复式投注...键盘...${ state.duplexInputPay.value}");
    }
  }

  ///复式投注，对金额 进行状态判断
  void checkDoubleAmountState() {
    if (num.parse(state.duplexInputPay.value) == 0) {
      //todo: 3 改为 2
      state.doubleAmountState.value = 2;
    } else {
      //
      if (num.parse(state.duplexInputPay.value) >
          num.parse(globalController.currTypeSelected.value.amount!)) {
        ///余额不足
        state.doubleAmountState.value = 3;
      } else {
        if (num.parse(state.duplexInputPay.value) >= state.duplexMinAmount.value &&
            num.parse(state.duplexInputPay.value) <= state.duplexMaxAmount.value) {
          state.doubleAmountState.value = 0;
        } else {
          state.doubleAmountState.value = 1;
        }
      }
    }
  }

  ///复式投注，投注信息 重置
  void resetDoubleBetInfo() {
    state.duplexTotalOdds.value = "1.0";
    state.duplexInputPay.value = "0.0";
  }

  ///检查是否有相同的， 同场赛事
  bool checkSameCi(List<M> list) {
    Set<String> uniqueCis = Set<String>();
    for (M m in list) {
      if (!uniqueCis.add(m.ei!)) {
        return true;
      }
    }
    return false;
  }

  final selectList = [
    CustomSelectModel(S.current.bet_accept_any_odds, type: 0),
    CustomSelectModel(S.current.bet_accept_only_higher_odds, type: 1),
    CustomSelectModel(S.current.no_odds_changes_accepted, type: 2),
  ].obs;

  chooseAccept(String acceptString, int acceptState) {
    state.acceptState.value = acceptState;
    state.acceptString.value = acceptString;
  }

  ///押下投注 方法
  ///"ic": 1, //0:非串关 1:串关  ,是单项 还是复式
  void doSportToBetting(int ic, BuildContext context, CustomButtonController btnCtr) {
    SportBetModel sportBetModel = SportBetModel(ao: 0, bl: [], cur: '');
    totalCount = 0;
    totalMoney = 0;
    if (ic == 0) {
      sportBetModel.ao = state.ao.value;
      sportBetModel.cur = globalController.currTypeSelected.value.cur ?? '';
      for (var i = 0; i < globalController.bets.length; i++) {
        List<M> biList = [globalController.bets[i]];
        sportBetModel.bl.clear();
        sportBetModel.bl.add(Bl(pt: 0, a: globalController.bets[i].amount!, bi: biList));

        ///一个对一个请求网络投注
        // submitBet(sportBetModel, ic, context, btnCtr, i == globalController.bets.length - 1, i);
        syncBet(sportBetModel, ic, btnCtr, i == globalController.bets.length - 1, i,
            globalController.bets.length);
      }
    } else {
      sportBetModel.ao = state.ao.value;
      sportBetModel.cur = globalController.currTypeSelected.value.cur ?? '';
      sportBetModel.bl.add(Bl(
          pt: state.ptType.value,
          a: num.parse(state.duplexInputPay.value),
          bi: globalController.bets));

      ///投注
      // submitBet(sportBetModel, ic, context, btnCtr, true, 0);
      syncBet(sportBetModel, ic, btnCtr, true, 0, globalController.bets.length);
    }
  }

  ///单项投注
  ///返回表示执行完成
  Future<bool> loadSingleSportInfo({bool minBet = false}) async {
    SportBetInfoModel data = state.singleSportInfoModel.value;
    data.ic = 0;
    data.cur = globalController.currTypeSelected.value.cur ?? '';
    data.bi.clear();
    data.bi.addAll(globalController.bets);
    // if (!data.bi[0].new_wid!.isNotEmpty) {
    //   data.bi[0].new_wid = data.bi[0].wid;
    // }
    return loadSportBetInfoData(data, ic: 0, minBet: minBet);
  }

  ///复式投注
  Future<bool> loadDuplexSportInfo({bool minBet = false}) async {
    //基本模型
    SportBetInfoModel data = state.duplexSportInfoModel.value;
    data.ic = 1;
    data.cur = globalController.currTypeSelected.value.cur ?? '';
    data.bi.clear();
    //追加 最新全部投注信息
    data.bi.addAll(globalController.bets);
    // if (!data.bi[0].new_wid!.isNotEmpty) {
    //   data.bi[0].new_wid = data.bi[0].wid;
    // }
    ///有同场赛事时不请求复式赔率
    if (state.doubleBetState.value != 3) {
      await loadSportBetInfoData(data, ic: 1);
    }
    return true;
  }

  ///删除投注列表 item
  void deleteBetItemFromIndex(int index) {
    // log('删除了$index');
    globalController.bets.remove(globalController.bets[index]);
    // state.sportBetList.remove(state.sportBetList[index]);
    //如果清0了， 重置一下
    if (globalController.bets.isEmpty) {
      resetBottomStateTip();
    }
    update();
  }

  ///点击全部删除按钮
  void deleteAllBetList() {
    globalController.bets.clear();
    resetDuplexBetState();
    // state.sportBetList.clear();
    //todo:0116 同时清除提示状态。
    resetBottomStateTip();
    update();
  }

  ///重置复式投注的投注金额状态
  void resetDuplexBetState() {
    state.duplexInputPay.value = '0';
    state.duplexTotalOdds.value = '1.0';
    state.duplexMinAmount.value = 0.0;
    state.duplexMaxAmount.value = 0.0;
  }

  ///重置底部信息， 比如总支付金额、预支付金额、赔率变换
  void resetBottomStateTip() {
    state.betStates.value = 0;
    state.doubleBetState.value = 0;
    //接受新的赔率
    state.oddsStates.value = 0;
  }

  /// 索取注信息
  /// 什么时候请求该接口
  /// 投注前，需要先呼叫索取投注信息 place/betinfo
  /// 并且每10秒呼叫⼀次 投注项增加或减少时，都重新呼叫place/betinfo
  Future<bool> loadSportBetInfoData(SportBetInfoModel sportBetInfoModel,
      {required int ic, bool minBet = false}) async {
    await ApiService.instance.getSportOddsApiBetInfo(
      requestData: sportBetInfoModel,
      success: (betModel) {
        //todo:更新注单列表赔率
        updateAndMargeData(betModel, ic: ic, minBet: minBet);

        //todo:逻辑处理
        if (betModel.status == 3) {
          state.coinStates.value = 1;
        } else {
          state.coinStates.value = 0;
        }
        if (ic == 1) {
          ///给总赔率赋值
          state.duplexTotalOdds.value = betModel.bi?[0].ov ?? '';
          state.ptType.value = betModel.bi?[0].pt ?? 0;
          if (betModel.bi![0].mia != null && betModel.bi![0].maa != Null) {
            state.duplexMinAmount.value = betModel.bi![0].mia.toDouble();
            state.duplexMaxAmount.value = betModel.bi![0].maa.toDouble();
          }
        }

        //快捷投注金额 处理
        if (betModel.qck != null) {
          var tempMoneys = <BettingMoneyApiModel>[];
          for (var money in betModel.qck!) {
            tempMoneys.add(BettingMoneyApiModel(betMoney: money));
          }
          if (ic == 0) singleBettingMoneyListObs.assignAll(tempMoneys);
          if (ic == 1) duplexBettingMoneyListObs.assignAll(tempMoneys);
        }
      },
      fail: (message) {
        if (ic == 1) {
          state.doubleBetState.value = 4;
        }
      },
    );
    //表示执行完成
    return true;
  }

  /// 下注
  Future<ResultBean> submitBet(SportBetModel sportBetModel, int ic, CustomButtonController btnCtr,
      bool showSnack, int index) async {
    btnCtr.showAnimation();
    // state.loading.value = true;
    showBettingBtnLoading(ic, true);
    Completer<ResultBean> completer = Completer<ResultBean>();
    await ApiService.instance.submitApiBet(
      requestData: sportBetModel,
      success: (data) {
        log("投注成功...${JsonUtil.encodeObj(data)}");
        //成功返回的数据{"status":true,"data":{"status":1}}
        btnCtr.hideAnimation();
        // state.loading.value = false;
        showBettingBtnLoading(ic, false);
        completer.complete(ResultBean(
            betNum: "${++totalCount}", betAmount: "${totalMoney += sportBetModel.bl[0].a}"));
      },
      fail: (message) {
        log("投注失败...${message}");
        if (showSnack) {
          totalCount = 0;
          totalMoney = 0;
        }

        ///投注失败状态
        if (ic == 0) {
          globalController.bets[index].showState = 2;
        } else {
          for (int i = 0; i < globalController.bets.length; i++) {
            globalController.bets[i].showState = 2;
          }
        }
        state.betStateForOrderDone.value = 1;
        btnCtr.hideAnimation();
        // state.loading.value = false;
        showBettingBtnLoading(ic, false);
        CustomSnackBar.showError(message!, Get.overlayContext!);
      },
    );
    return completer.future;
  }

  ///ic 单项 或者 复式
  Future<void> syncBet(SportBetModel sportBetModel, int ic, CustomButtonController btnCtr,
      bool showSnack, int index, int betSize) async {
    ///请求网络
    ResultBean resultBean = await submitBet(sportBetModel, ic, btnCtr, showSnack, index);
    log("neco 下注单数： ${resultBean.betNum}");

    ///当是复式投注时， betSize 可以时多个投注项， 但resultBean.betNum 永远只有一个，因为提交一次请求
    ///做这个的判断的目的时， 如果是单项投注，多个一起，到最后一个才提示信息，结果处理。
    //多个单项 投注
    if (ic == 0 && int.parse(resultBean.betNum ?? "0") == betSize) {
      ///投注成功状态
      globalController.bets[index].showState = 1;
      state.betStateForOrderDone.value = 1;
      globalController.bets.refresh();
      showSnackBar(ic, sportBetModel, resultBean);
    }
    // 复式投注
    if (ic == 1) {
      for (int i = 0; i < globalController.bets.length; i++) {
        globalController.bets[i].showState = 1;
      }
      state.betStateForOrderDone.value = 1;
      globalController.bets.refresh();
      showSnackBar(ic, sportBetModel, resultBean);
    }
    //todo: 1213 xiaoan 旧代码有问题, 改成上面的
    // if (int.parse(resultBean.betNum ?? "0") == betSize) {
    //   showSnackBar(ic, sportBetModel, resultBean, context);
    //   if (ic == 0) {
    //     ///投注成功状态
    //     globalController.bets[index].showState = 1;
    //   } else {
    //     for (int i = 0; i < globalController.bets.length; i++) {
    //       globalController.bets[i].showState = 1;
    //     }
    //   }
    //   state.betStateForOrderDone.value = 1;
    //   globalController.bets.refresh();
    // }
  }

  void showSnackBar(int ic, SportBetModel sportBetModel, ResultBean resultBean) {
    //单项
    if (ic == 0) {
      CustomSnackBar.show(
          title: S.current.single_bet,
          subContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                S.current.submit_bet_result,
                textColorStyle: CustomTextColorStyle.secondary,
              ),
              Row(
                children: [
                  CustomText(
                    S.current.submit_bet_result_amount(resultBean.betAmount ?? ""),
                    textColorStyle: CustomTextColorStyle.secondary,
                  ),
                  SizedBox(width: 3),
                  CustomNetWorkImage(
                    width: 14,
                    height: 14,
                    imageUrl: globalController.currTypeSelected.value.coinIc ?? "",
                    errorWidget: const CustomAssetIcon(
                      name: 'assets/images/bet_slip/ic_defalut_coin.png',
                      size: 14,
                    ),
                  ),
                  if(!LangUtil().isViVn())
                  Container(
                      padding: const EdgeInsets.only(left: 3),
                    child: CustomText(
                      '${S.current.random_text_244}${S.current.single_bet}!',
                      textColorStyle: CustomTextColorStyle.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          '',
          Get.overlayContext!,
          preIcon: CustomSnackBarIcons.submitBetResult);
    }
    //复式
    else {
      //只有一个显示单项，否则复式投注
      var betCount = sportBetModel.bl[0].bi.length;
      CustomSnackBar.show(
          title: betCount == 1 ? S.current.single_bet : S.current.multiple_bet,
          subContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                S.current.submit_bet_result,
                textColorStyle: CustomTextColorStyle.secondary,
              ),
              Row(
                children: [
                  CustomText(
                    S.current.submit_bet_result_amount(state.duplexInputPay.value),
                    textColorStyle: CustomTextColorStyle.secondary,
                  ),
                  SizedBox(width: 3),
                  CustomNetWorkImage(
                    width: 14,
                    height: 14,
                    imageUrl: globalController.currTypeSelected.value.coinIc ?? "",
                    errorWidget: CustomAssetIcon(
                      name: 'assets/images/bet_slip/ic_defalut_coin.png',
                      size: 14,
                    ),
                  ),
                  SizedBox(width: 3),
                  CustomText(
                    '${S.current.random_text_244}${betCount == 1 ? S.current.single_bet : S.current.multiple_bet}!',
                    textColorStyle: CustomTextColorStyle.secondary,
                  ),
                ],
              ),
            ],
          ),
          '',
          Get.overlayContext!,
          preIcon: CustomSnackBarIcons.submitBetResult);
    }
  }

  ///更新注单列表赔率
  ///【注意：】单项注单 和 复式注单， 都会走改方法
  void updateAndMargeData(SportOddsModel data, {required int ic, bool minBet = false}) {
    List<Wsi> wsiList = data.wsi!;
    for (var wsiData in wsiList) {
      String? latestWid = wsiData.wid;
      String? latestOv = wsiData.ov;
      // 查找原始列表中是否存在对应的wid
      M? originalItem = globalController.bets.firstWhereOrNull((item) => item.wid == latestWid);
      if (originalItem != null) {
        // log('原值：$latestWid 旧值：${originalItem.new_wid} 新值：${wsiData.new_wid}');
        originalItem.new_wid = wsiData.new_wid;

        ///为new_wid赋值
        // 更新原始列表中对应wid的赔率信息
        String? originalOv = originalItem.ov;
        originalItem.ov = latestOv;
        //todo: 有可能 单项注单 os = 2，复式注单os = 3
        originalItem.os = wsiData.os;
        //是复式请求才给赋值
        if (ic == 1) {
          originalItem.osDuplex = wsiData.os;
        }
        // 计算赔率变化
        if (originalOv != null) {
          double originalOvValue = double.tryParse(originalOv) ?? 0.0;
          double latestOvValue = double.tryParse(latestOv) ?? 0.0;

          if (latestOvValue > originalOvValue) {
            log('赔率变大了');
            originalItem.isUp = 1;
            if (state.acceptState.value == 2) {
              state.oddsStates.value = 1;
            }
          } else if (latestOvValue < originalOvValue) {
            log('赔率变小了');
            originalItem.isUp = 0;
            if (state.acceptState.value == 2 || state.acceptState.value == 1) {
              state.oddsStates.value = 1;
            }
          } else {
            originalItem.isUp = 0;
          }
        }
      }
    }
    if (ic == 0) {
      List<Bi> biList = data.bi!;
      for (var biData in biList) {
        String? latestWid = biData.wid;
        num? mia = biData.mia;
        num? maa = biData.maa;
        M? originalItem = globalController.bets.firstWhereOrNull((item) => item.wid == latestWid);
        if (originalItem != null) {
          originalItem.min = mia;
          originalItem.max = maa;
          //todo：【0528】第一次投注 需要默认最小投注
          if (needUpdateMinBet) {
            originalItem.amount = mia;
          } else {
            if (minBet) {
              originalItem.amount = mia;
            }
          }
        }
        //更新一下
        if (needUpdateMinBet) {
          needUpdateMinBet = false;
        }
      }
    }
    // globalController.bets.any((element) => false);
    // globalController.bets.refresh();
    // update();
  }

  bool getErroState() {
    if (state.oddsStates.value != 0) {
      return true;
    }
    if (state.coinStates.value != 0) {
      return true;
    }
    if (state.betStates.value != 0) {
      return true;
    }
    if (state.numStates.value != 0) {
      return true;
    }
    if (state.amountStates.value == 1) {
      return true;
    }
    return false;
  }

  String getErroText() {
    ///赔率有变化
    if (state.oddsStates.value == 1) {
      return S.current.bet_submit_tips_two;
    }

    if (state.coinStates.value == 1) {
      return S.current.random_text_245;
    }

    ///来自同一赛事的多重投注项不能结合成复式投注
    if (state.betStates.value == 3) {
      return S.current.bet_tips_three;
    }
    if (state.betStates.value == 1) {
      return S.current.random_text_246;
    }
    if (state.numStates.value == 1) {
      return S.current.random_text_247;
    }
    if (state.betStates.value == 2) {
      return S.current.random_text_248;
    }
    if (state.amountStates.value == 1) {
      //todo:[0531]投注单-投注额不够时的提示语不对
      // return S.current.random_text_249;
      return S.current.random_text_1222;
    }
    if (state.betStates.value == 4) {
      return S.current.random_text_250;
    }
    if (state.betStates.value == 5) {
      return S.current.random_text_251;
    }
    return '';
  }

  bool getDoubleErroState() {
    if (state.oddsStates.value != 0) {
      return true;
    }
    if (state.coinStates.value != 0) {
      return true;
    }
    if (state.doubleBetState.value != 0) {
      return true;
    }
    if (state.numStates.value != 0) {
      return true;
    }
    if (state.doubleAmountState.value == 1) {
      return true;
    }
    return false;
  }

  String getDoubleErroText() {
    log('是否包含同场赛事${state.doubleBetState.value}');

    ///赔率有变化
    if (state.oddsStates.value == 1) {
      return S.current.bet_submit_tips_two;
    }

    if (state.coinStates.value == 1) {
      return S.current.random_text_245;
    }

    ///来自同一赛事的多重投注项不能结合成复式投注
    if (state.doubleBetState.value == 3) {
      return S.current.random_text_252;
    }
    if (state.doubleBetState.value == 1) {
      return S.current.random_text_246;
    }
    if (state.doubleBetState.value == 2) {
      return S.current.random_text_248;
    }
    if (state.numStates.value == 1) {
      return S.current.random_text_247;
    }
    if (state.doubleAmountState.value == 1) {
      //todo:[0531]投注单-投注额不够时的提示语不对
      // return S.current.random_text_249;
      return S.current.random_text_1222;
    }
    if (state.doubleBetState.value == 4) {
      return S.current.random_text_250;
    }
    if (state.doubleBetState.value == 5) {
      return S.current.random_text_251;
    }
    if (state.doubleBetState.value == 6) {
      return '${S.current.random_text_558}${BettingCommonConfig.unSupportDuplexOv}${S.current.random_text_559}';
    }
    return '';
  }

  void showOddsChange(BuildContext context, Offset startOffset, Size size, String type) {
    showOddsChangesAnimation(context, startOffset, size, type);
  }

  void onChickGotoBetting() {
    EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.MSG);
  }

  ///"ic": 1, //0:非串关 1:串关  ,是单项 还是复式
  void showBettingBtnLoading(int ic, bool amin) {
    //单项投注
    if (ic == 0) {
      state.loading.value = amin;
    }
    //复式投注
    else {
      state.loadingDuplex.value = amin;
    }
  }

  ///需求：未登录状态下，从 “体育” 切换到 “投注单”，直接弹出注册页
  void openPageToRegisterPage() {
    ///注册弹窗
    // RouteUtil.pushToView(Routes.registerPage);
    showCustomRegisterWidget();
  }

  void onTabChanged(int index) {
    if (state.betStateForOrderDone.value == 1) deleteAllBetList();
  }
}
