import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/betting/sport/betting_sport_logic.dart';
import 'package:flutter_bet/pages/betting/sport/bet_order/sport_duplex_bet_item.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../constant/app_themes.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../generated/l10n.dart';
import '../../../../routes/routes.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_error_tips_text.dart.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_number_keyboard.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../account/register/register_widget.dart';
import '../../common_helper/betting_biz_helper.dart';
import '../../common_widget/bet_exchange_select_widget.dart';
import '../widget/sport_bet_money_widget.dart';

///投注单-复式投注页面
class SportDuplexBetView extends BaseView<BettingSportLogic> {
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final GlobalKey _widgetKeyTwo = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingArrowKeyTwo = GlobalKey<RotatingArrowState>();

  SportDuplexBetView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  void _startAnimation() {
    _rotatingArrowKeyTwo.currentState?.startAnimation();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //接收赔率 行view
          _buildOddsTypeRowView(context),

          ///投注单列表
          _buildBettingDuplexListView(),

          ///下单布局
          _buildBetSubmitInfoView(context)
        ],
      ),
    );
  }

  ///接收赔率 行view
  Widget _buildOddsTypeRowView(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(width: 10),
          _buildAcceptOddsView(context),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              controller.deleteAllBetList();
              controller.resetDuplexSelected();
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
  _buildBettingDuplexListView() {
    return Obx(() {
      return Expanded(
          child: globalController.bets.isNotEmpty
              ? ListView.builder(
              itemCount: globalController.bets.length,
              itemBuilder: (BuildContext context, int index) {
                return SportDuplexBetItem(
                  bean: globalController.bets[index],
                  deleteBet: () {
                    controller.deleteBetItemFromIndex(index);
                  },
                );
              })
              : _buildNoDataView());
    });
  }

  ///投注信息
  Widget _buildBetSubmitInfoView(BuildContext context) {
    var toast_text =
        '${S.current.binding_bank_card_please_enter}${controller.state.duplexMinAmount
        .value}-${controller.state.duplexMaxAmount.value}${S.current.random_text_243}';
    if (LangUtil().isTh()) {
      toast_text =
      '${S.current.binding_bank_card_please_enter}${S.current.random_text_243} ${controller.state
          .duplexMinAmount.value}-${controller.state.duplexMaxAmount.value}';
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.defaultMargin, vertical: AppValues.fontBodyMediumSize),
      width: double.infinity,
      color: ThemeService().colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Visibility(
              visible: logic.checkShowDuplexBetMoneyView(),
              child: SportBetMoneyListViewWidget(
                selectedIndex: logic.duplexSelectedIndexObs.value,
                modelList: logic.duplexBettingMoneyListObs,
                isCanClick: logic.globalController.bets.isNotEmpty,
                onClickItem: (index, model) {
                  logic.duplexSelectedIndexObs.value = index;
                  logic.onSelectedDuplexMoney(model);
                },
              ),
            );
          }),

          ///输入框
          Visibility(
              visible: controller.state.betStateForOrderDone.value == 0,
              child: _buildTextField(context)),

          ///是否显示错误提示
          Visibility(
              visible: checkAmount(),
              child: Padding(
                padding: const EdgeInsets.only(top: AppValues.smallPadding),
                child: CustomErrorTipsText(text: toast_text),
              )),
          const SizedBox(height: 11),

          ///总赔率
          Row(
            children: [
              CustomText(S.current.bet_total_odds),
              const Expanded(child: SizedBox()),
              // Image.asset('assets/images/bet_slip/ic_odds_up.webp'),
              const SizedBox(width: 5),
              CustomText(controller.state.duplexTotalOdds.value,
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: ThemeService().colorScheme.secondary)),
              SizedBox(width: 5),
            ],
          ),
          SizedBox(height: 5),

          ///预支付金额
          Row(
            children: [
              CustomText(S.current.bet_pay),
              Expanded(child: SizedBox()),
              // CustomText(controller.state.duplexInputPay.value),
              CustomText(
                BettingBizHelper.dealBetMoneyFormat(
                  controller.state.duplexInputPay.value,
                  decimals: globalController.coinDecimal,
                ),
              ),
              // CustomText(
              //     BettingBizHelper.dealBetMoneyFormat(controller.state.duplexInputPay.value)),
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
              visible: controller.state.doubleBetShowTips.value,
              child: DottedBorder(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.defaultMargin, vertical: AppValues.defaultPadding),
                color: AppThemes.errorColor,
                strokeWidth: 2,
                radius: const Radius.circular(20),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomErrorTipsText(
                    text: controller.state.doubleBetTips.value,
                  ),
                ),
              )),
          SizedBox(height: 8),
          //下注按钮
          _buildSubmitButton(context),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildAcceptOddsView(BuildContext context) {
    if (controller.state.betStateForOrderDone.value == 1) {
      return GestureDetector(
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
      return GestureDetector(
        key: _widgetKeyTwo,
        onTap: () {
          _startAnimation();
          DialogUtils.showCustomBubbleDialog(context, _viewBubbleChild(), 135,
              widgetKey: _widgetKeyTwo,
              height: 125,
              globalKey: _rotatingArrowKeyTwo,
              backgroundColor: ThemeService().colorScheme.tertiary);
        },
        child: Row(
          children: [
            CustomText(
              controller.state.acceptString.value,
              style: ThemeService().textTheme.labelLarge,
            ),
            CustomIcon(asset: 'assets/images/bet_slip/ic_casino_down.webp'),
          ],
        ),
      );
    }
  }

  ///投注额输入框
  Widget _buildTextField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //todo: 有点问题， betStates 改为 doubleBetState
        // globalController.bets.isNotEmpty && controller.state.betStates.value == 0
        if (globalController.bets.isNotEmpty && controller.state.doubleBetState.value == 0) {
          showModalBottomSheet<bool>(
            context: context,
            barrierColor: Colors.transparent,
            isDismissible: true,
            builder: (BuildContext context) {
              return CustomNumberKeyboard(
                margin: EdgeInsets.only(bottom: AppValues.barBottomHeight - 2),
                onKeyPressed: (string) {
                  handleKeyboardInput(string, context);
                },
              );
            },
          ).then((value) {
            //关闭回调，应该调用一下计算方法
            // log("复式投注...键盘...$value");
            //检查输入金额
            // log("复式投注...键盘...${ controller.state.duplexInputPay.value}");
            // controller.checkDoubleAmountInput();
            // controller.checkDoubleAmountState();
            controller.onDuplexKeyboardClose();
          });
        } else {}
      },
      child: Container(
        height: 40,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: ThemeService().theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: checkAmount() ? Colors.red : AppThemes.secondaryIconColor, width: 2.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 12, right: 5),
                child: CustomText(controller.state.duplexInputPay.value),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 12),
              child: CustomNetWorkImage(
                width: 14,
                height: 14,
                imageUrl: globalController.currTypeSelected.value.coinIc ?? "",
                errorWidget: CustomAssetIcon(
                  name: 'assets/images/bet_slip/ic_defalut_coin.png',
                  size: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///下注按钮
  Widget _buildSubmitButton(BuildContext context) {
    if (controller.state.betStateForOrderDone.value == 1) {
      return CustomBigMainButton(
        title: S.current.check_my_betlist,
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
        if (controller.state.oddsStates.value == 0) {
          //"押下复式投注"
          return CustomBigMainButton(
            isSportBet: true,
            loading: controller.state.loadingDuplex.value,
            //需求：复式投注-只下注一个投注项 ，显示"押下单项投注"
            title:
            globalController.bets.length == 1 ? S.current.bet_submit : S.current.bet_submit_two,
            // isEnable:true,
            isEnable: controller.state.doubleBetState.value == 0 &&
                controller.state.doubleAmountState.value == 0 &&
                globalController.bets.isNotEmpty,
            onTap: (ctr) {
              // log("复式投注...doubleBetState...${controller.state.doubleBetState.value}");
              // log("复式投注...doubleAmountState...${controller.state.doubleAmountState.value}");
              // controller.loadSportBetInfo(0, context, ctr);
              controller.doSportToBetting(1, context, ctr);
            },
          );
        } else {
          return CustomBigMainButton(
            title: S.current.bet_agree_new_odds,
            onTap: (ctr) {
              ///接受新的赔率
              controller.state.oddsStates.value = 0;
            },
          );
        }
      } else {
        return CustomBigMainButton(
          title: S.current.random_text_239,
          onTap: (ctr) {
            ///注册弹窗
            // RouteUtil.pushToView(Routes.registerPage);
            showCustomRegisterWidget();
          },
        );
      }
    }
  }

  Widget _viewBubbleChild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16,
        ),
        InkWell(
          onTap: () {
            Get.back();
            controller.chooseAccept(S.current.bet_accept_any_odds, 0);
          },
          child: Text(
            S.current.bet_accept_any_odds,
            style: TextStyle(fontSize: 12, color: checkAcceptChoosed(0)),
          ),
        ),
        SizedBox(
          height: 16,
        ),
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
        SizedBox(
          height: 16,
        ),
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
        SizedBox(
          height: 16,
        ),
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

  void handleKeyboardInput(String key, BuildContext context) {
    if (key == 'delete') {
      // 处理删除逻辑
      if (controller.state.duplexInputPay.value.isNotEmpty &&
          controller.state.duplexInputPay.value != '0') {
        final text = controller.state.duplexInputPay.value;
        controller.state.duplexInputPay.value = text.substring(0, text.length - 1);
      } else {
        controller.state.duplexInputPay.value = '0';
      }
    } else if (key == 'OK') {
      Navigator.of(context).pop();
    } else if (key == '.') {
      if (!controller.state.duplexInputPay.value.contains('.')) {
        controller.state.duplexInputPay.value += key;
      }
    } else {
      if (controller.state.duplexInputPay.value == '0') {
        controller.state.duplexInputPay.value = key;
      } else {
        // 处理其他数字输入
        controller.state.duplexInputPay.value += key;
      }
    }

    log("复式投注...输入金额...${controller.state.duplexInputPay.value}");
  }

  bool checkAmount() {
    log('${S.current.random_text_557}${controller.state.duplexInputPay.value} ${controller.state
        .duplexMinAmount.value} ${controller.state.duplexMaxAmount.value}');
    if (controller.state.duplexInputPay.isNotEmpty) {
      if (num.parse(controller.state.duplexInputPay.value) != 0.00) {
        return num.parse(controller.state.duplexInputPay.value) <
            (controller.state.duplexMinAmount.value) ||
            num.parse(controller.state.duplexInputPay.value) >
                (controller.state.duplexMaxAmount.value);
      }
    }
    return false;
  }
}
