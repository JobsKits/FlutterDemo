import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_select_widget.dart';
import 'package:flutter_bet/pages/betting/sport/betting_sport_logic.dart';
import 'package:flutter_bet/pages/betting/sport/bet_order/sport_single_bet_item.dart';
import 'package:flutter_bet/pages/betting/sport/widget/sport_slip_odds_changes_mixin.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../generated/l10n.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/custom_error_tips_text.dart.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../common_helper/betting_biz_helper.dart';
import '../../common_widget/bet_exchange_select_widget.dart';
import '../../common_widget/bet_slip_bar.dart';
import '../betting_sport_state.dart';
import '../widget/sport_bet_money_widget.dart';

///投注单-单项投注页面
class SportSingleBetView extends BaseView<BettingSportLogic> {
  //BaseView<BettingSportLogic>
  SportSingleBetView({super.key});

  // BettingSportLogic controller = BettingSportLogic.of();

  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final GlobalKey _widgetKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final ScrollController _scrollController = ScrollController();

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  void _startAnimation() {
    _rotatingArrowKey.currentState?.startAnimation();
  }

  @override
  Widget buildBody(BuildContext context) {
    // @override
    // Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          ///切换是否接受赔率变化
          _buildOddsTypeView(context),

          ///投注单列表
          _buildBettingSingleListView(),

          ///下单布局
          _buildBetSubmit(context),
        ],
      ),
    );
  }

  ///为了自定义键盘不遮挡注单项，点击的注单自动滚动到屏幕中间
  void _scrollToItem(int index) {
    _scrollController.animateTo(
      index * 130, // Assuming each item has a height of 50.0
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOutQuart,
    );
  }

  ///提交下注
  Widget _buildBetSubmit(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      width: double.infinity,
      color: ThemeService().colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Visibility(
              visible: logic.checkShowSingleBetMoneyView(),
              child: SportBetMoneyListViewWidget(
                modelList: logic.singleBettingMoneyListObs,
                isCanClick: logic.globalController.bets.isNotEmpty,
                selectedIndex: logic.singleSelectedIndexObs.value,
                onClickItem: (index, model) {
                  logic.onSelectedSingleMoney(index,model);
                },
              ),
            );
          }),
          Row(
            children: [
              CustomText(S.current.bet_pay_all),
              Expanded(child: SizedBox()),
              // CustomText('${controller.state.totalPay}'),
              CustomText(
                BettingBizHelper.dealBetMoneyFormat(
                  controller.state.totalPay.value,
                  decimals: globalController.coinDecimal,
                ),
              ),
              SizedBox(width: 5),
              CustomNetWorkImage(
                width: 14,
                height: 14,
                showErrorMsg: false,
                imageUrl: globalController.coinUrl,
                errorWidget: const CustomAssetIcon(
                  name: 'assets/images/bet_slip/ic_defalut_coin.png',
                  size: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              CustomText(S.current.bet_pay),
              Expanded(child: SizedBox()),
              // CustomText("${controller.state.totalWin}"),
              CustomText(BettingBizHelper.dealBetMoneyFormat(
                controller.state.totalWin.value,
                decimals: globalController.coinDecimal,
              )),
              SizedBox(width: 5),
              CustomNetWorkImage(
                width: 14,
                height: 14,
                imageUrl: globalController.coinUrl,
                errorWidget: const CustomAssetIcon(
                    name: 'assets/images/bet_slip/ic_defalut_coin.png', size: 14),
              ),
            ],
          ),
          SizedBox(height: 8),
          Visibility(
              visible: controller.getErroState(),
              child: DottedBorder(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.defaultMargin, vertical: AppValues.defaultPadding),
                color: ThemeService().colorScheme.error,
                strokeWidth: 2,
                radius: const Radius.circular(20),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomErrorTipsText(
                    text: controller.getErroText(),
                  ),
                ),
              )),
          SizedBox(height: 8),

          ///下单按钮
          _buildSubmitButton(context),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  ///下注之后
  Widget _buildSubmitButton(BuildContext context) {
    ///是否为已下注状态
    if (controller.state.betStateForOrderDone.value == 1) {
      return CustomBigMainButton(
        isSportBet: true,
        title: S.current.check_my_betlist, //查看我的订单
        onTap: (ctr) {
          ///跳转投注明细
          controller.state.chooseType.value = controller.state.sportTypeList[1];

          ///清除列表
          controller.deleteAllBetList();
          controller.state.betStateForOrderDone.value = 0;
        },
      );
    } else {
      if (globalController.isLogin.value) {
        ///是否为可正常下注
        if (controller.state.oddsStates.value == 0) {
          return CustomBigMainButton(
            loading: controller.state.loading.value,
            // loading: true,
            isSportBet: true,
            title: S.current.bet_submit,
            isEnable: controller.state.betStates.value == 0 &&
                controller.state.amountStates.value == 0 &&
                globalController.bets.isNotEmpty,
            onTap: (ctr) {
              controller.doSportToBetting(0, context, ctr);
            },
          );
        } else {
          return CustomBigMainButton(
            isSportBet: true,
            title: S.current.bet_agree_new_odds,
            onTap: (ctr) {
              ///接受新的赔率
              // log("同意新赔率...");
              controller.state.oddsStates.value = 0;
            },
          );
        }
      } else {
        return CustomBigMainButton(
          isSportBet: true,
          title: S.current.random_text_239,
          onTap: (ctr) {
            ///注册弹窗
            // RouteUtil.pushToView(Routes.registerPage);
            controller.openPageToRegisterPage();
          },
        );
      }
    }
  }

  Widget _buildOddsTypeView(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(width: 10),
          _buildAcceptOddsView(context),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              controller.deleteAllBetList();
            },
            child: CustomText(
              S.current.bet_all_clean,
              style: ThemeService().textTheme.bodyMedium,
            ),
          )
        ],
      ),
    );
  }

  ///投注单列表
  _buildBettingSingleListView() {
    return Obx(() {
      return Expanded(
          child: globalController.bets.isNotEmpty
              ? ListView.builder(
              reverse: false,
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 80),
              controller: _scrollController,
              itemCount: globalController.bets.length,
              itemBuilder: (BuildContext context, int index) {
                return SportSingleBetItem(
                  isLogin: globalController.isLogin.value,
                  bean: globalController.bets[index],
                  decimalLength: globalController.currTypeSelected.value.decimal_places ?? 0,
                  deleteBet: () {
                    controller.deleteBetItemFromIndex(index);
                  },
                  onChanged: (String data) {
                    // log("输入回调...data...$data");
                    // globalController.bets[index].amount = num.parse(data);
                    // globalController.bets.refresh();
                    logic.onSportSingleInput(index, data);
                  },
                  onScrollTo: () {
                    // if(index==globalController.bets.length){
                    _scrollToItem(index);
                    // }
                  },
                  onOpenInputText: (amount) => logic.showSingleBetMoneyView(false),
                  onCloseInputText: (amount) => logic.showSingleBetMoneyView(true),
                );
              })
              : _buildNoDataView());
    });
  }

  Widget _buildAcceptOddsView(BuildContext context) {
    if (controller.state.betStateForOrderDone.value == 1) {
      return InkWell(
        onTap: () {
          globalController.bets.forEach((element) {
            element.showState = 0;
          });
          controller.state.betStateForOrderDone.value = 0;
        },
        child: CustomText(
          S.current.bet_again,
          style: ThemeService().textTheme.labelLarge,
        ),
      );
    } else {
      return Obx(() {
        return BetExchangeSelectWidget(

          ///该参数决定当前为娱乐城还是体育的投注模块，后期放到全局公共模块
          selectModel: controller.state.exchangeChooseObs.value,

          ///暂时默认为娱乐城「我的投注」，后期由{modelType}决定
          modelList: controller.state.exchangeSelectList,
          onChange: (chooseBetSlipType) {
            controller.state.exchangeChooseObs.value = chooseBetSlipType;
            //为了兼容老逻辑代码
            controller.chooseAccept(controller.state.exchangeChooseObs.value.label,
                controller.state.exchangeChooseObs.value.data);
          },
        );
      });

      // return CustomSelectWidget(
      //   // width: 125,
      //   borderShow: false,
      //   initSelected: controller.initSelectedObs.value,
      //   scaleAmin: true,
      //   modelList: controller.selectTypeListObs,
      //   // panelRatio: 0.9,
      //   backgroundColor: Colors.white,
      //   selectColor: AppThemes.secondaryColor,
      //   unselectColor: ThemeService().colorScheme.tertiary,
      //   // selectColorFull: AppThemes.secondaryColor,
      //   onSelected: (dataOne, dataTwo) {
      //     // logic.collectParams(type: dataTwo);
      //     // logic.loadNetData(isRefresh: true, isFirst: true);
      //   },
      // );
      return GestureDetector(
        key: _widgetKey,
        onTap: () {
          _startAnimation();
          DialogUtils.showCustomBubbleDialog(context, _viewBubbleChild(), 135,
              widgetKey: _widgetKey,
              height: 125,
              globalKey: _rotatingArrowKey,
              backgroundColor: ThemeService().colorScheme.tertiary);
        },
        child: Row(
          children: [
            Obx(() {
              return CustomText(
                // controller.state.acceptString.value,
                controller.selectList[controller.state.acceptState.value].label,
                // S.current.bet_accept_only_higher_odds,
                style: ThemeService().textTheme.labelLarge,
              );
            }),
            CustomIcon(asset: 'assets/images/bet_slip/ic_casino_down.webp'),
          ],
        ),
      );
      // });
    }
  }

  Widget _viewBubbleChild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        InkWell(
          onTap: () {
            controller.chooseAccept(S.current.bet_accept_any_odds, 0);
            Get.back();
          },
          child: Text(
            S.current.bet_accept_any_odds,
            style: TextStyle(fontSize: 12, color: checkAcceptChoosed(0)),
          ),
        ),
        SizedBox(height: 16),
        InkWell(
          onTap: () {
            Get.back();
            controller.chooseAccept(S.current.bet_accept_only_higher_odds, 1);
          },
          child: Text(
            S.current.bet_accept_only_higher_odds,
            style: TextStyle(fontSize: 12, color: checkAcceptChoosed(1)),
          ),
        ),
        SizedBox(height: 16),
        InkWell(
          onTap: () {
            Get.back();
            controller.chooseAccept(S.current.no_odds_changes_accepted, 2);
          },
          child: Text(
            S.current.no_odds_changes_accepted,
            style: TextStyle(fontSize: 12, color: checkAcceptChoosed(2)),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Color checkAcceptChoosed(int type) {
    return controller.state.acceptState.value == type
        ? AppThemes.secondaryColor
        : AppThemes.widgetColorWhite;
  }

  Widget _buildNoDataView() {
    return Container(
      height: Get.height -
          AppBar().preferredSize.height -
          AppValues.sportHeight_20 -
          AppValues.sportHeight_153,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: AppValues.sportHeight_153),
            Image.asset(
              'assets/images/sport/sport_nodata.webp',
              height: AppValues.sportIconNoData,
              width: AppValues.sportIconNoData,
            ),
            const SizedBox(height: AppValues.sportHeight_16),
            CustomText(
              S.current.random_text_241,
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                color: Color(0xFFB1BAD3),
              ),
            ),
            const SizedBox(height: 5),
            InkWell(
                onTap: () {
                  controller.onChickGotoBetting();
                },
                child: CustomText(S.current.random_text_217)),
          ],
        ),
      ),
    );
  }
}
