import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/personal_center/wallet/card_bag.dart';
import 'package:flutter_bet/pages/personal_center/wallet/fiat_currency_withdrawal.dart';
import 'package:flutter_bet/pages/personal_center/wallet/set_fund_password.dart';
import 'package:flutter_bet/pages/personal_center/wallet/set_google_auth.dart';
import 'package:flutter_bet/pages/personal_center/wallet/virtual_currency_deposit.dart';
import 'package:flutter_bet/pages/personal_center/wallet/virtual_currency_withdrawal.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/custom_select_coin_widget.dart';
import 'package:flutter_bet/widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tabbar_covered.dart';
import 'package:get/get.dart';
import '../../../app/modules/wallet/views/deposit_view.dart';
import '../../../app/modules/wallet/views/withdraw_view.dart';
import '../../../constant/app_themes.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/vault_util.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'cards/index.dart';
import 'email_auth.dart';
import 'exchange_currency.dart';
import 'fiat_currency_deatils.dart';
import 'fiat_currency_deposit.dart';

double bubbleWidth = 114;
double bubbleWidthWithDrawal = 220;
const ratio = 2.0;

class WalletTabBar extends StatefulWidget {
  const WalletTabBar({super.key});

  @override
  State<WalletTabBar> createState() {
    return _WalletTabBarState();
  }
}

class _WalletTabBarState extends State<WalletTabBar> with SingleTickerProviderStateMixin {
  final GlobalKey _globalKeyContract = GlobalKey();
  final GlobalKey _globalKeyCoin = GlobalKey();

  late GlobalStateController globalController = Get.find<GlobalStateController>();

  late WalletController controller = Get.find<WalletController>();
  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingContractArrowKey = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  void initState() {
    super.initState();
    // Get.lazyPut(() => WalletController());
    // Get.lazyPut(() => GlobalStateController());
    controller.context = context;
    controller.initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        key: _globalKey,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 24, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: ThemeService().theme.colorScheme.surface, // 设置背景色
            ),
            child: CustomTabBarWithIcon(
              tabController: controller.tabController,
              // 将TabController与TabBar关联
              tabs: controller.tab,
              backgroundColor: ThemeService().theme.colorScheme.tertiary,
              radius: 49,
              height: 54,
              buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
            ),
          ),
          Visibility(
              visible: controller.position.value == 3 ? false : true,
              child: const SizedBox(
                height: 12,
              )),
          Visibility(visible: getState(), child: _coin()),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(), //禁止滑动
              controller: controller.tabController, // 将TabController与TabBarView关联
              children: [
                SingleChildScrollView(child: _detailsView()),
                Visibility(
                    visible: controller.openVerificationAndPayPasswordFrequency.value < 10000,
                    child: SingleChildScrollView(
                        controller: controller.scrollWithdrawalController,
                        child: _withdrawalView())),
                Visibility(
                    visible: controller.openVerificationAndPayPasswordFrequency.value < 10000,
                    child:
                        Flex(direction: Axis.vertical, children: [Expanded(child: _cardView())])),
                if (VaultUtil.isShowExchangeCurrency()) ExchangeCurrency(controller),
              ],
            ),
          ),
        ],
      );
    });
  }

  bool getState() {
    if (controller.position.value == 0) {
      return false;
    }
    if (controller.position.value == 3) {
      return false;
    }
    //https://jira.vgtech.org/browse/STAK-3261
    if (VaultUtil.isEmailCheckStateNotBind()) {
      return false;
    }
    if (VaultUtil.isPayPasswordNotSetting() &&
        (!VaultUtil.isPayPassword() && VaultUtil.isSecretNot())) {
      return false;
    }

    return true;
  }

  Widget _coin() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: controller.position.value > 1
                        ? false
                        : controller.currencySelCurrencyId.value == "706"
                            ? true
                            : false,
                    child: CustomText(
                      S.current.wallet_currency,
                      textColorStyle: CustomTextColorStyle.normal,
                    )),
                Visibility(
                    visible: controller.position.value > 1
                        ? false
                        : controller.currencySelCurrencyId.value == "706"
                            ? true
                            : false,
                    child: const SizedBox(
                      height: 2,
                    )),
                CustomSelectCoinWidget(
                  hintSearchTextual: controller.position.value == 1
                      ? S.current.random_text_452
                      : S.current.wallet_search,
                  globalKeyS: _globalKey,
                  globalKeyWidget: _globalKeyCoin,
                  bubbleWidth: controller.position.value == 0 || controller.position.value == 2
                      ? bubbleWidth
                      : bubbleWidthWithDrawal,
                  ratio: ratio,
                  dataList: controller.position.value == 0
                      ? globalController.dcAvailableData.value
                      : globalController.wcAvailableData.value,
                  contentBuilder: (context, bean) {
                    return controller.position.value == 0 || controller.position.value == 2
                        ? _depositView()
                        : _withDrawalView();
                  },
                  itemBuilder: (context, bean) {
                    return controller.position.value == 0 || controller.position.value == 2
                        ? _coinItem(bean)
                        : _coinWithDrawalItem(bean);
                  },
                ),
              ],
            ),
            const SizedBox(
              width: AppValues.width_12,
            ),
            Obx(() {
              return Visibility(
                  visible: controller.position.value == 2 ||
                          controller.currencyDepositSelectContract.isEmpty ||
                          controller.currencyDepositSelectContract.length == 1
                      ? false
                      : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                          visible: controller.position.value == 3
                              ? false
                              : controller.currencySelCurrencyId.value == "706"
                                  ? true
                                  : false,
                          child: CustomText(
                            S.current.random_text_663,
                            textColorStyle: CustomTextColorStyle.normal,
                          )),
                      Visibility(
                          visible: controller.position.value == 3
                              ? false
                              : controller.currencySelCurrencyId.value == "706"
                                  ? true
                                  : false,
                          child: const SizedBox(
                            height: 2,
                          )),
                      _protocolsWidget(_globalKey, context),
                    ],
                  ));
            })
          ],
        ),
      ],
    );
  }

  _depositView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: AppValues.width_12,
        ),
        CustomNetWorkImage(
          imageUrl: controller.position.value == 0
              ? controller.currencyDepositSelectCoinIc.value
              : controller.currencyWithdrawalSelectCoinIc.value,
          width: 18,
          height: 18,
        ),
        const SizedBox(
          width: AppValues.margin_4,
        ),
        CustomText(
            controller.position.value == 0 || controller.position.value == 2
                ? controller.currencyDepositSelectCoin.value
                : controller.currencyWithdrawalSelectCoinAndAmount.value,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(
          width: AppValues.margin_4,
        ),
      ],
    );
  }

  _withDrawalView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: AppValues.width_12,
        ),
        CustomText(
            // controller.position.value == 0
            //     ? controller.currencyDepositSelectCoin.value
            //     : controller.currencyWithdrawalSelectCoinAndAmount.value,
            controller.position.value == 0
                ? controller.currencyDepositSelectCoin.value
                : controller.currencyAmount.value,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(
          width: AppValues.margin_4,
        ),
        CustomNetWorkImage(
          imageUrl: controller.position.value == 0
              ? controller.currencyDepositSelectCoinIc.value
              : controller.currencyWithdrawalSelectCoinIc.value,
          width: 18,
          height: 18,
        ),
        const SizedBox(
          width: 4,
        ),
      ],
    );
  }

  //协议
  Widget _protocolsWidget(GlobalKey globalKeyS, BuildContext context) {
    return InkWell(
      onTap: () {
        controller.scale.value = 0.9;
        Future.delayed(const Duration(milliseconds: 100), () {
          controller.scale.value = 1.0;
        });
        _startAnimation(_rotatingContractArrowKey);
        DialogUtils.showCustomBubbleDialog(
            context, _selectContractType(context, globalKeyS), bubbleWidth,
            widgetKey: _globalKeyContract,
            backgroundColor: AppThemes.widgetColorWhite,
            globalKey: _rotatingContractArrowKey, onDismissCallback: () {
          controller.scale.value = 0.9;
          Future.delayed(const Duration(milliseconds: 100), () {
            controller.scale.value = 1.0;
          });
        });
      },
      child: Row(
        key: _globalKeyContract,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: AppValues.defaultPadding, bottom: AppValues.defaultPadding),
            decoration: BoxDecoration(
                color: ThemeService().colorScheme.surface,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(2), bottomLeft: Radius.circular(2))),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.bounceIn, // 使用弹性曲线
              transform: Matrix4.identity()..scale(controller.scale.value),
              child: Row(
                children: [
                  const SizedBox(
                    width: AppValues.width_12,
                  ),
                  CustomText(controller.currencyDepSelContract.value,
                      style: ThemeService()
                          .theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(
                    width: 4,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  RotatingArrow(
                    key: _rotatingContractArrowKey,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _selectContractType(BuildContext context, GlobalKey globalKeyS) {
    return Container(
      constraints: BoxConstraints(maxHeight: _getWalletHeight(ratio)),
      child: SingleChildScrollView(
        child: Column(
          children: controller.currencyDepositSelectContract.map((contract) {
            return InkWell(
                onTap: () {
                  for (int i = 0; i < controller.currencyDepositSelectContract.length; i++) {
                    controller.currencyDepositSelectContract[i]['isSelect'] = false;
                  }
                  var isSelect = contract["isSelect"] ?? false;
                  contract["isSelect"] = isSelect ? false : true;
                  controller.currencyDepSelContract.value = contract['label'];
                  controller.currencySelContractId.value = contract['id'];
                  controller.coinPayChannelList();
                  controller.getWalletList();
                  Get.back();
                },
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: CustomText(
                      contract['label'],
                      style: TextStyle(
                          color: contract['isSelect'] == true
                              ? Colors.blue
                              : ThemeService().colorScheme.surface),
                    )));
          }).toList(),
        ),
      ),
    );
  }

  Widget _coinItem(CurrencyBean bean) {
    return GestureDetector(
      onTap: () {
        Get.back();
        controller.withdrawal(bean);
        controller.saveSelected(bean);
      },
      child: Container(
        // color: controller.isSelectedItem(bean)
        //     ? ThemeService().colorScheme.primary
        //     : Colors.transparent,
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: AppValues.margin_6, bottom: AppValues.margin_6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: bubbleWidth / 2 - 31,
            ),
            CustomNetWorkImage(
              width: 18,
              height: 18,
              imageUrl: bean.coinIc ?? "",
            ),
            const SizedBox(
              width: 8,
            ),
            CustomText(
              bean.name ?? "",
              style: ThemeService()
                  .theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ThemeService().colorScheme.tertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coinWithDrawalItem(CurrencyBean bean) {
    return GestureDetector(
      onTap: () {
        Get.back();
        controller.withdrawal(bean);
        controller.saveSelected(bean);
      },
      child: Container(
        // color: controller.isSelectedItem(bean)
        //     ? ThemeService().colorScheme.primary
        //     : Colors.transparent,
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: AppValues.margin_6, bottom: AppValues.margin_6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                CustomText(
                  // "${bean.symbol}${controller.truncateText(bean.amount ?? "", 13)}",
                  "${controller.truncateText(bean.amount ?? "", 13)}",
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: ThemeService().colorScheme.tertiary),
                ),
              ],
            ),
            SizedBox(
              width: 76,
              child: Row(
                children: [
                  CustomNetWorkImage(
                    imageUrl: bean.coinIc ?? "",
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  CustomText(
                    bean.name ?? " ",
                    style: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: ThemeService().colorScheme.tertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailsView() {
    return _getDepositView();
  }

  Widget _withdrawalView() {
    return getStateView();
  }

  Widget _cardView() {
    return getStateCardView();
  }

  Widget _getDepositView() {
    return controller.currencyDepositSelectContract.isEmpty
        ? FiatCurrencyDeposit(controller: controller, globalKeyS: _globalKey)
        : VirtualCurrencyDeposit(controller: controller, globalKeyS: _globalKey);
  }

  Widget _getWithdrawalView() {
    return controller.currencyWithdrawalSelectContract.isEmpty
        ? FiatCurrencyWithdrawal(
            walletController: controller,
          )
        : VirtualCurrencyWithdrawal(walletController: controller, globalKeyS: _globalKey);
  }

  Widget getStateView() {
    return getShowView(_getWithdrawalView());
  }

  Widget getStateCardView() {
    return getShowView(const CardsPage());
  }

  Widget getShowView(Widget view) {
    // return view;
    if (VaultUtil.isEmailCheckStateNotBind()) {
      return EmailAuth(
        tips: S.current.wallet_email_hint_auth,
      );
    } else {
      if (VaultUtil.isPayPasswordNotSetting()) {
        if (VaultUtil.isSecret()) {
          return view;
        } else {
          return FundPassword();
        }
      } else {
        if (!VaultUtil.isPayPassword() && VaultUtil.isSecretNot()) {
          return GoogleAuth();
        } else {
          return view;
        }
      }
    }
  }

  double _getWalletHeight(double ratio) {
    double? totalHeight;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = _globalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    totalHeight = size.height;
    return totalHeight / ratio;
  }
}
