import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/personal_center/wallet/card_bag.dart';
import 'package:flutter_bet/pages/personal_center/wallet/fiat_currency_withdrawal.dart';
import 'package:flutter_bet/pages/personal_center/wallet/virtual_currency_deposit.dart';
import 'package:flutter_bet/pages/personal_center/wallet/virtual_currency_withdrawal.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:flutter_bet/utils/vault_util.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../pages/personal_center/wallet/email_auth.dart';
import '../../../../pages/personal_center/wallet/exchange_currency.dart';
import '../../../../pages/personal_center/wallet/fiat_currency_deposit.dart';
import '../../../../pages/personal_center/wallet/widget/custom_currency_component.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/tab_bar/custom_tab_bar_with_icon.dart';

double bubbleWidth = 114;
double bubbleWidthWithDrawal = 220;
const ratio = 1.3;

@Deprecated("")
class WalletTabBar extends StatefulWidget {
  const WalletTabBar({super.key});

  @override
  State<WalletTabBar> createState() {
    return _WalletTabBarState();
  }
}

class _WalletTabBarState extends State<WalletTabBar> with SingleTickerProviderStateMixin {
  final GlobalKey _globalKey = GlobalKey();

  late WalletController controller = Get.find<WalletController>();

  @override
  void initState() {
    super.initState();
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
              radius: 30,
              height: 54,
              buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(), //禁止滑动
              controller: controller.tabController, // 将TabController与TabBarView关联
              children: [
                SingleChildScrollView(
                    child: Column(
                      children: [
                        Visibility(
                          visible: controller.globalController.currTypeLists.isNotEmpty,
                          child: CustomCurrencyComponent(
                            dataList: controller.globalController.currTypeLists,
                            itemBuilder: (context, bean) {
                              return _coinItem(bean);
                            },
                          ),
                        ),
                        _detailsView(),
                      ],
                    )),
                SingleChildScrollView(child: _withdrawalView()),
                // Text("卡包")
                Container(
                    color: Colors.transparent,
                    child: CardBag(
                      controller: controller,
                    )),
                ExchangeCurrency(controller),
                Text("data"),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _coinItem(CurrencyBean bean) {
    return GestureDetector(
      onTap: () {
        log("neco  点击了");
        controller.withdrawal(bean);
        controller.saveSelected(bean);
        //暂时注释
        // for (int i = controller.globalController.dcAvailableData.length - 1; i >= 0; i--) {
        //   if (controller.isSelectedItem(controller.globalController.dcAvailableData[i])) {
        //     var selectedItem = controller.globalController.dcAvailableData[i];
        //     controller.globalController.dcAvailableData.removeAt(i);
        //     controller.globalController.dcAvailableData.insert(0, selectedItem);
        //     controller.globalController.dcAvailableData.refresh();
        //     break;
        //   }
        // }
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomNetWorkImage(
              width: 20,
              height: 20,
              imageUrl: bean.coinIc ?? "",
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              padding: const EdgeInsets.only(left: 4, right: 4),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: controller.isSelectedItem(bean)
                          ? ThemeService().colorScheme.primary
                          : Colors.transparent,
                      width: 1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  )),
              child: CustomText(
                bean.name ?? "",
                style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                    color: controller.isSelectedItem(bean)
                        ? ThemeService().colorScheme.primary
                        : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailsView() {
    return VaultUtil.isEmailCheckStateNotBind()
        ? EmailAuth(
      tips: S.current.random_text_770,
    )
        : _getDepositView();
  }

  Widget _withdrawalView() {
    return VaultUtil.isEmailCheckStateNotBind()
        ? EmailAuth(
      tips: S.current.wallet_email_hint_auth,
    )
        : _getWithdrawalView();
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
}
