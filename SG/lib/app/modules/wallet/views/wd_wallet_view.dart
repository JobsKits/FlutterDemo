import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/withdraw_ctrl.dart';
import 'package:flutter_bet/app/modules/wallet/views/unbound_withdraw_info.dart';
import 'package:flutter_bet/app/modules/wallet/views/wd_fiatcurr_amt.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/wallet/BankcardBean.dart';
import '../../../../pages/personal_center/wallet/auth_widget.dart';
import '../../../../pages/personal_center/wallet/delete_address.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../utils/vault_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/input/custom_main_text_field.dart';

class WdWalletView extends GetView<WithDrawCtrl> {
  @override
  Widget build(BuildContext context) {
    return _rootView(context);
  }

  var _context;
  var wallet;
  final GlobalKey _globalKeyInput = GlobalKey();
  final GlobalKey _globalKeyAccount = GlobalKey();

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<RotatingArrowState> _rotatingArrowKeyAccount = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  Widget _rootView(BuildContext context) {
    _context = context;
    wallet = controller.wallet;
    if (wallet.isNotEmpty) {
      controller.bnkNameBean.value = wallet[0];
      controller.bnkPos.value = 0;
      controller.saveBnk(wallet[0]['accountInfo'][0], wallet);
    }
    return wallet.isEmpty ? UnboundWithdrawInfo() : fiat(context);
  }

  Widget fiat(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            CustomAsterisksTipsText(
              text: S.current.random_text_1318,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ).marginOnly(top: 16),
            Obx(() {
              return _selectWallet(S.current.fiat_currency_select_the_payment_bank, context);
            }).marginOnly(top: 5),
            CustomAsterisksTipsText(
              text: S.current.random_text_1125,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ).marginOnly(top: 16),
            Obx(() {
              return _selectBankIno(S.current.fiat_currency_select_the_payment_bank, context);
            }).marginOnly(top: 5),
            // PayoutOptionsView(),
            // _payoutView(),
            // WdBnkView(),
            WdFiatCurrAmt(),
            // PassWordView(),
            CustomBigMainButton(
              colorStyle: CustomButtonColorStyle.tertiary,
              onTap: (buttonCtr) {
                controller.onClickWd(context);
              },
              title: S.current.random_text_1316,
              fontWeight: FontWeight.w600,
            ).marginOnly(top: 16, bottom: 16),
          ],
        ).marginOnly(left: 16, right: 6),
        Visibility(
            visible: VaultUtil.isSecretNot() && !VaultUtil.isEmailCheckStateNotBind(),
            child: const AuthWidget())
      ],
    );
  }

  Widget _selectWallet(String hintStr, BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (controller.previousBottomInset > 0) {
              FocusScope.of(Get.context!).requestFocus(FocusNode());
            } else {
              _startAnimation(_rotatingArrowKey);
              DialogUtils.showCustomBubbleDialog(
                context, _selectWalletType(), _getInputWidth(),
                widgetKey: _globalKeyInput,
                backgroundColor: AppThemes.widgetColorWhite,
                bubbleArrowHeight: 6,
                bubbleArrowWidth: 10,
                globalKey: _rotatingArrowKey,
                // arrowBasisOffset: -120.0
              );
            }
          },
          child: Column(
            children: [
              CustomMainTextField(
                errorText: controller.getMergerSelId(controller.fiatCurrTabSel.value) == "702"
                    ? S.current.random_text_1188
                    : S.current.random_text_1189,
                showError: controller.curSelBnkShowErr.value,
                text: "\t\t\t\t\t${controller.bnkNameBean['bankName'] ?? ""}",
                enabled: false,
                key: _globalKeyInput,
              ),
            ],
          ),
        ),
        Positioned(
            left: 10,
            child: SizedBox(
              height: AppValues.defaultTextHeight,
              child: CustomNetWorkImage(
                  fit: BoxFit.fitWidth,
                  placeholder: CustomAssetIcon(
                    name: controller.defCoin,
                  ),
                  errorWidget: CustomAssetIcon(
                    name: controller.defCoin,
                  ),
                  width: 18,
                  height: 18,
                  imageUrl:
                  "${controller.globalController.bnkDomain}${controller.bnkSelBean.value
                      .bank_id}${controller.coinIcExtensionName}"),
            )),
        Positioned(
            right: 0,
            child: Container(
              height: AppValues.defaultTextHeight,
              margin: const EdgeInsets.only(right: 9),
              child: RotatingArrow(
                key: _rotatingArrowKey,
              ),
            ))
      ],
    );
  }

  Widget _selectBankIno(String hintStr, BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (controller.previousBottomInset > 0) {
              FocusScope.of(Get.context!).requestFocus(FocusNode());
            } else {
              _startAnimation(_rotatingArrowKeyAccount);
              DialogUtils.showCustomBubbleDialog(
                context, _selectWalletInfo(), _getInputWidth(),
                widgetKey: _globalKeyAccount,
                backgroundColor: AppThemes.widgetColorWhite,
                bubbleArrowHeight: 6,
                bubbleArrowWidth: 10,
                globalKey: _rotatingArrowKeyAccount,
                // arrowBasisOffset: -120.0
              );
            }
          },
          child: Column(
            children: [
              CustomMainTextField(
                contentPadding: const EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  left: AppValues.defaultPadding,
                  right: 30,
                ),
                errorText: controller.getMergerSelId(controller.wdFiatCurrTabSel.value) == "702"
                    ? S.current.wallet_pleaseSelectPIXAccount
                    : S.current.fiat_currency_select_the_payment_bank,
                showError: controller.curSelBnkAccountShowErr.value,
                text:
                // "\t\t\t\t\t${controller.bnkSelBean.value.bankName} ${controller.bnkSelBean.value.bankAccount}",
                "${controller.bnkSelBean.value.bankAccount}",
                enabled: false,
                key: _globalKeyAccount,
              ),
            ],
          ),
        ),
        Positioned(
            right: 0,
            child: Container(
              height: AppValues.defaultTextHeight,
              margin: const EdgeInsets.only(right: 9),
              child: RotatingArrow(
                key: _rotatingArrowKeyAccount,
              ),
            ))
      ],
    );
  }

  Widget _selectWalletType() {
    return Column(
      children: [
        if (wallet.isNotEmpty)
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: wallet.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _walletItem(wallet[index], index),
              );
            },
          )
        else
          SizedBox(
            height: 60,
            child: Center(
              child: CustomText(
                S.current.random_text_657,
                textColorStyle: CustomTextColorStyle.dark,
              ),
            ),
          ),
      ],
    );
  }

  Widget _walletItem(dynamic bankcardBean, int pos) {
    return GestureDetector(
      onTap: () {
        RouteUtil.popView();
        controller.saveBnkName(bankcardBean, pos, wallet);
      },
      child: Opacity(
        opacity: 1,
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              CustomNetWorkImage(
                  fit: BoxFit.fitWidth,
                  placeholder: CustomAssetIcon(
                    name: controller.defCoin,
                  ),
                  errorWidget: CustomAssetIcon(
                    name: controller.defCoin,
                  ),
                  width: 18,
                  height: 18,
                  imageUrl:
                  "${controller.globalController.bnkDomain}${bankcardBean['bankId']}${controller
                      .coinIcExtensionName}"),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                "${bankcardBean['bankName']}",
                textColorStyle: CustomTextColorStyle.dark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectWalletInfo() {
    return Column(
      children: [
        if (wallet[controller.bnkPos.value]['accountInfo'].isNotEmpty)
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: wallet[controller.bnkPos.value]['accountInfo'].length + 1,
            itemBuilder: (context, index) {
              if (index < (wallet[controller.bnkPos.value]['accountInfo'].length)) {
                return _walletInfo(wallet[controller.bnkPos.value]['accountInfo'][index]);
              } else {
                return InkWell(
                  onTap: () => controller.saveWithdrawInfo(),
                  child: controller.bnkCurrCards.value >= controller.cardMaxNum
                      ? const SizedBox().marginOnly(bottom: 16)
                      : CustomText(
                    S.current.random_text_1142,
                    textColorStyle: CustomTextColorStyle.blue,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ).marginOnly(top: 16, bottom: 16),
                );
              }
            },
          )
        else
          SizedBox(
            height: 60,
            child: Center(
              child: CustomText(
                S.current.random_text_657,
                textColorStyle: CustomTextColorStyle.dark,
              ),
            ),
          ),
      ],
    );
  }

  Widget _walletInfo(BankcardBean bankcardBean) {
    return GestureDetector(
      onTap: () {
        RouteUtil.popView();
        controller.saveBnk(bankcardBean, wallet);
      },
      child: Container(
        // color: bankcardBean.isSelect == true ? ThemeService().colorScheme.primary : Colors
        //     .transparent,
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment:
          (bankcardBean.uid ?? "").isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 4,
              child: Opacity(
                opacity: bankcardBean.state == 2 ? 0.5 : 1,
                child: CustomText(
                    textColorStyle: bankcardBean.isSelect ?? false
                        ? CustomTextColorStyle.blue
                        : CustomTextColorStyle.dark,
                    bankcardBean.bankAccount ?? "",
                    style: ThemeService().theme.textTheme.bodyMedium),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => controller.saveWithdrawInfo(id: bankcardBean.id),
              child: Opacity(
                opacity: bankcardBean.state == 2 ? 0.5 : 1,
                child: const CustomAssetIcon(
                  name: "assets/images/edit.png",
                ),
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            InkWell(
              onTap: () {
                RouteUtil.popView();
                bankcardBean.currency_id =
                    controller.getMergerSelId(controller.wdFiatCurrTabSel.value);
                showCustomDeleteAddressWidget(
                    context: _context,
                    fiatCurrency: controller.wdFiatCurrTabSel.value,
                    currencyId: controller.getMergerSelId(controller.wdFiatCurrTabSel.value),
                    subData: bankcardBean.toJson());
              },
              child: const CustomAssetIcon(
                name: "assets/images/deletev2.png",
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  double _getInputWidth() {
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = _globalKeyInput.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    return size.width;
  }
}
