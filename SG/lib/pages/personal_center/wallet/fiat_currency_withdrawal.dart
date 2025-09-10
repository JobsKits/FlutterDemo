import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/model/wallet/BankcardBean.dart';
import 'package:flutter_bet/pages/personal_center/wallet/binding_pix.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/custom_password_tip.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/deposit_empty_view.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/scale_tabbar.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_tips*_text.dart.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../utils/vault_util.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_empty_widget.dart';
import '../../../widget/custom_error_tips_text.dart.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/dialog/dialog_utils.dart';
import 'auth_widget.dart';
import 'binding_bank_card.dart';

double bubbleWidth = 220;

final GlobalKey _globalKeyInput = GlobalKey();

class FiatCurrencyWithdrawal extends StatelessWidget {
  final WalletController walletController;

  FiatCurrencyWithdrawal({
    super.key,
    required this.walletController,
  });

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getView(context)
      ],
    );
  }


  Widget getView(BuildContext context) {
    return Obx(() {
    if( walletController.ifHaveDrawalPayMe.value == false ) {
      // return  CustomEmptyWidget(
      //   imgPath: 'assets/images/ic_no_bet_bill.png',);
      return DepositEmptyView(tips: S.current.random_text_795,);
    }
      return Obx(() => walletController.ifBindCard.value ? noDataView() : contentView(context));
    });
  }

  rootView(BuildContext context) {
    return walletController.ifHaveDrawalPayMe.value == false ?
    const CustomEmptyWidget(
      imgPath: 'assets/images/ic_no_bet_bill.png',) : contentView(context);


    // return walletController.ifHaveDrawalPayMe.value == false ?
    // const CustomEmptyWidget(
    //   imgPath: 'assets/images/ic_no_bet_bill.png',)
    //     : walletController.ifBindCard.value == true
    //     ? bindView(context) : contentView(context);
  }

  Widget contentView(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
              left: AppValues.defaultMargin, right: AppValues.defaultMargin),
          child: Column(
            children: [
              const SizedBox(height: 4),
              // paymentType(), //https://vgstake.atlassian.net/browse/STAK-452
              const SizedBox(
                height: 12,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  //https://vgstake.atlassian.net/browse/STAK-486
                  child: CustomAsterisksTipsText(
                    // text: walletController.currencyWithdrawalSelectCoinAndAmountId.value=="702"? "PIX账号":S.current.fiat_currency_drawing_bank,
                    text: walletController.currencyWithdrawalSelectCoinAndAmountId.value == "702"
                        ? S.current.wallet_pixAccount
                        : S.current.wallet_paymentBankCard,
                  )),
              const SizedBox(
                height: 4,
              ),
              Obx(() {
                return _selectBank(S.current.fiat_currency_select_the_payment_bank, context);
              }),
              _amountInputWidget(),
              const SizedBox(
                height: 10,
              ),
              _passWordWidget(isAuthView: true),
              const SizedBox(
                height: 10,
              ),
              CustomBigMainButton(
                colorStyle: CustomButtonColorStyle.tertiary,
                onTap: (buttonCtr) {
                  walletController.withdraw(context, buttonCtr);
                },
                title:S.current.random_text_710,
              ),
            ],
          ),
        ),
        Visibility(visible: VaultUtil.isSecretNot()&&!VaultUtil.isEmailCheckStateNotBind(), child: const AuthWidget())

      ],
    );
  }

  Widget noDataView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_16),
          child: Column(
          children: [
            _tips(),
            _button(),
          ],
        )),
        Visibility(visible: VaultUtil.isSecretNot()&&!VaultUtil.isEmailCheckStateNotBind(), child: const AuthWidget())

      ],
    );
  }

  Widget _tips(){
    return Container(
      margin: const EdgeInsets.only(top: AppValues.padding_16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/personal_center_icon/wallet/cards_tips_bg.png'),
          fit: BoxFit.fill
        )
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 22, bottom: 22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3, right: 6,left: 4),
                child: Image.asset('assets/images/personal_center_icon/wallet/cards_warning.png', width: 16),
              ),
              Flexible( // 使用 Flexible 包裹 Column
                child: Padding(
                  padding: const EdgeInsets.only(right: AppValues.margin_20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        S.current.random_text_655c1,
                        textColorStyle: CustomTextColorStyle.secondary,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        softWrap: true, // 设置 softWrap 为 true
                      ),
                      CustomText(
                        S.current.random_text_655c2,
                        textColorStyle: CustomTextColorStyle.secondary,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        softWrap: true, // 设置 softWrap 为 true
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.only(top: AppValues.margin_14),
      child: CustomBigMainButton(
        colorStyle:  CustomButtonColorStyle.tertiary,
        onTap: (btnCtr) {
          walletController.tabController.animateTo(2);
        },
        title: S.current.random_text_656,
      ), 
    );
  }

  Widget bindView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppValues.defaultMargin),
        _warningWidget(),
        getBindContent(
            walletController.currencyWithdrawalSelectCoinAndAmountId.value == "702", context),
      ],
    );
  }

  Widget getBindContent(bool isBrl, BuildContext context) {
    log("neco getBindContent");
    return isBrl ? BindingPix(
      currencyId: walletController.currencyWithdrawalSelectCoinAndAmountId.value,
      bankTree: walletController.currencyWdSelCoinBankTree.value, flag: "1",)
        : BindingBankCard(
      currencyId: walletController.currencyWithdrawalSelectCoinAndAmountId.value,
      bankTree: walletController.currencyWdSelCoinBankTree.value, flag: "1",);
  }

  Widget _warningWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomAssetIcon(
          name: "assets/images/personal_center_icon/warning.webp",
          size: 14,
        ),
        const SizedBox(width: 4),
        CustomText("${S.current.wallet_pleaseBindWithdrawalMethodBeforeMakingWithdrawal}！",
            style: ThemeService()
                .theme
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500, color: AppThemes.scoreTextColor))
      ],
    );
  }

//金额输入框
  Widget _amountInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAsterisksTipsText(
              text: S.current.vault_amount,
            ),
            //https://vgstake.atlassian.net/browse/STAK-486
            // const CustomText("R\$ 0.00", textColorStyle: CustomTextColorStyle.normal),

            //https://jira.vgtech.org/browse/STAK-854
            // Obx(() {
            //   return CustomText(
            //       "US\$ ${walletController.withdrawRateCount.toStringAsFixed(
            //           2)}", textColorStyle: CustomTextColorStyle.normal);
            // }),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        _inputWidget(),
      ],
    );
  }

//输入框
  Widget _inputWidget() {
    return Stack(
      children: [
        Obx(() {
          return CustomMainTextField(

            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            showError: walletController.inputAmountShowError.value,
            errorText: walletController.inputAmountShowErrorText.value,
            text: walletController.inputAmount.value,
            controller: walletController.walletNumberController,
            inputCallBack: (str) {
              if (str.isNotEmpty) {
                double inputAmount = double.parse(str);
                double currencyAmount = double.parse(walletController.withdrawBalance.value);
                double currencyAmountTotal = double.parse(walletController.currencyAmount.value);
                if (inputAmount > currencyAmount) {
                  walletController.inputAmount.value = walletController.withdrawBalance.value;
                  walletController.walletNumberController?.text =  walletController.inputAmount.value;
                  walletController.walletNumberController?.selection = TextSelection.fromPosition(TextPosition(offset: walletController.walletNumberController!.text.length),);
                  walletController.withdrawExchangeRateCount(walletController.withdrawBalance.value);
                  if(currencyAmount!=currencyAmountTotal){
                    walletController.inputAmountShowError.value = true;
                    walletController.inputAmountShowErrorText.value = "${S.current.random_text_711}${walletController.withdrawBalance.value}${S.current.random_text_712}${walletController.remainingBalance.value}";
                  }
                } else {
                  if (inputAmount == currencyAmount) {
                    walletController.walletNumberController?.selection = TextSelection.fromPosition(
                      TextPosition(offset: walletController.walletNumberController!.text.length),);
                  }
                  walletController.inputAmount.value = str;
                  walletController.withdrawExchangeRateCount(walletController.inputAmount.value);
                  walletController.checkInputAmount();
                }
              } else {
                walletController.inputAmount.value = str;
                walletController.withdrawExchangeRateCount(walletController.inputAmount.value);
                walletController.inputAmountShowError.value = false;
              }
            },
            isCursorEnd: false,
          );
        }),
        Obx(() {
          return Positioned(
              right: 107,
              child: Container(
                padding: EdgeInsets.only(top: 11, bottom: 11),
                height: AppValues.defaultTextHeight,
                child: CustomNetWorkImage(
                  placeholder: const CustomAssetIcon(
                    name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                  ),
                  errorWidget: const CustomAssetIcon(
                    name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                  ),
                  imageUrl: walletController.currencyWithdrawalSelectCoinIc.value,
                  width: 18,
                  height: 18,
                ),
              ));
        }),
        Positioned(
            right: 0,
            child: InkWell(
              onTap: () {
                //原来需求
                // walletController.inputAmount.value = walletController.getCurrencyAmount();
                // walletController.walletNumberController!.text = walletController.inputAmount.value;
                // walletController.withdrawExchangeRateCount(walletController.inputAmount.value);
                // walletController.walletNumberController!.selection = TextSelection.fromPosition(
                //   TextPosition(offset: walletController.walletNumberController!.text.length),
                // );
                //最新业务
                walletController.inputAmount.value = walletController.withdrawBalance.value;
                walletController.walletNumberController!.text = walletController.inputAmount.value;
                walletController.withdrawExchangeRateCount(walletController.inputAmount.value);
                walletController.walletNumberController!.selection = TextSelection.fromPosition(
                  TextPosition(offset: walletController.walletNumberController!.text.length),
                );
                // walletController.checkInputAmount();
              },
              child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ThemeService().colorScheme.tertiaryContainer,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
                child: CustomText(S.current.vault_max_value,
                    style: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
            ))
      ],
    );
  }

  Widget _selectBank(String hintStr, BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            _startAnimation(_rotatingArrowKey);
            DialogUtils.showCustomBubbleDialog(context, _selectBankType(), _getInputWidth(),
                widgetKey: _globalKeyInput,
                backgroundColor: AppThemes.widgetColorWhite,
                bubbleArrowHeight: 8,
                bubbleArrowWidth: 8,
                globalKey: _rotatingArrowKey,
                arrowBasisOffset: -120.0
            );
          },
          child: Column(
            children: [
              CustomMainTextField(
                showError: walletController.curSelectBankShowError.value,
                text: "\t\t\t\t\t${walletController.curSelectBank.value} ${walletController
                    .curSelectBankAccount.value}",
                enabled: false,
                key: _globalKeyInput,
              ),
              Visibility(
                  visible: walletController.curSelectBankShowError.value,
                  child: Container(margin: const EdgeInsets.only(top: 4),
                      child: CustomErrorTipsText(
                        textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ThemeService().colorScheme.error),
                        text: walletController.currencyWithdrawalSelectCoinAndAmountId.value ==
                            "702" ? S.current.wallet_pleaseSelectPIXAccount : S.current
                            .fiat_currency_select_the_payment_bank,))),
            ],
          ),
        ),
        Visibility(
          visible: walletController.curSelectBank.value.isEmpty ? false : true,
          child: Positioned(
              left: 10,
              child: Container(
                height: AppValues.defaultTextHeight,
                margin: const EdgeInsets.only(right: 9),
                child: CustomAssetIcon(
                  // color: AppThemes.widgetColorWhite,
                  name: walletController.currencyWithdrawalSelectCoinAndAmountId.value == "702"
                      ? "assets/images/personal_center_icon/pix_ic.webp"
                      : "assets/images/personal_center_icon/bank.webp",
                  size: 14,
                ),
              )),
        ),
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

  ///支付方式列表
  Widget paymentType() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        height: 40,
        width: double.infinity,
        child: ScaleTabBar(
          labelPadding: const EdgeInsets.only(left: 2, right: 12),
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          indicator: const BoxDecoration(),
          controller: walletController.tabControllerWithdrawalPay,
          tabs: walletController.withdrawalPayTabs
              .asMap()
              .entries
              .map((element) {
            return _itemPay(element.key);
          }).toList(),
          isScrollable: true,
        ));
  }

  ///支付方式item
  Widget _itemPay(int index) {
    return Obx(() {
      return Container(
        decoration: walletController.withDrawalPayList[index].isSelect == true
            ? BoxDecoration(
            color: ThemeService().colorScheme.secondary,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ))
            : BoxDecoration(
            color: ThemeService().colorScheme.tertiary,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            )),
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 8,
            ),
            const CustomAssetIcon(
              name: "assets/images/personal_center_icon/vip.webp",
            ),
            Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: CustomText(
                "${walletController.withDrawalPayList[index].name}",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    });
  }

  //资金密码
  Widget _passWordWidget({bool isAuthView = false}) {
    return Visibility(
        visible: isAuthView,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CustomAsterisksTipsText(text: S.current.wallet_fundPassword),
            Obx(() {
              return CustomAsterisksTipsText(
                  text: walletController.pwdTypeBean.isNotEmpty ? walletController
                      .pwdTypeBean['typeName'] : "");
            }),
            const SizedBox(
              height: AppValues.margin_4,
            ),
            Stack(
              children: [
                Obx(() {
                  return CustomMainTextField(
                    isUpdatePsdOffset: true,
                    showError: walletController.inputPassWordShowError.value,
                    errorText: walletController.inputPassWordShowErrorText.value,
                    maxLength: 6,
                    isPwd: true,
                    text: walletController.inputPassWord.value,
                    inputCallBack: (str) {
                      walletController.inputPassWord.value = str;
                      walletController.checkInputPassWord();
                    },
                  );
                }),
                Positioned(
                    right: 0,
                    child: Container(
                      width: walletController.globalController.isChinese()? 100 :126,
                      height: AppValues.defaultTextHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: ThemeService().colorScheme.tertiaryContainer,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
                      child: CustomPasswordTips(onPwdTypeSelected: (selectedPwdType) {
                        walletController.pwdTypeBean.value = selectedPwdType;
                        walletController. inputPassWordShowErrorText.value = S.current.binding_bank_card_please_enter+
                            "${ walletController.pwdTypeBean["title"]}";
                        log("neco  密码配置 ${walletController.pwdTypeBean['title']}");
                      },),
                    ))
              ],

            ),
          ],
        ));
  }

  Widget _selectBankType() {
    return Container(
      constraints: const BoxConstraints(
          maxHeight: 200),
      child: SingleChildScrollView(
        child: Column(
          children: walletController.bankList.isNotEmpty ? walletController.bankList.map((bank) {
            return _bankItem(bank);
          }).toList() : [
            const SizedBox(height: 20,),
            Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10),
                child: CustomText(S.current.random_text_657, textColorStyle: CustomTextColorStyle.dark)),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  Widget _bankItem(BankcardBean bankcardBean) {
    return GestureDetector(
      onTap: () {
        if (bankcardBean.state == 2) {
          return;
        }
        for (int i = 0; i < walletController.bankList.length; i++) {
          walletController.bankList[i].isSelect = false;
        }
        var isSelect = bankcardBean.isSelect ?? false;
        bankcardBean.isSelect = isSelect ? false : true;
        walletController.bankList.refresh();
        walletController.curSelectBankId.value = bankcardBean.id ?? "";
        walletController.curSelectBank.value =
        (bankcardBean.uid != null) ? (bankcardBean.bankName ?? "") : (bankcardBean.name ?? "");
        walletController.curSelectBankShowError.value =
            walletController.assertField(walletController.curSelectBank.value);
        walletController.curSelectBankAccount.value = bankcardBean.bankAccount ?? "";
        RouteUtil.popView();
      },
      child: Opacity(
        opacity: bankcardBean.state == 2 ? 0.5 : 1,
        child: Container(
          // color: bankcardBean.isSelect == true ? ThemeService().colorScheme.primary : Colors
          //     .transparent,
          color: Colors.transparent,
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: (bankcardBean.uid ?? "").isEmpty
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              const SizedBox(width: 16,),
              CustomAssetIcon(
                // color: AppThemes.onPrimaryContainer,
                name: walletController.currencyWithdrawalSelectCoinAndAmountId.value == "702"
                    ? "assets/images/personal_center_icon/pix_ic.webp"
                    : "assets/images/personal_center_icon/bank.webp",
                size: 18,
              ),
              SizedBox(
                width: (bankcardBean.uid ?? "").isNotEmpty ? 12 : 0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    (bankcardBean.uid != null)
                        ? (bankcardBean.bankName ?? "")
                        : (bankcardBean.name ?? ""),
                    textColorStyle: bankcardBean.isSelect == true ?CustomTextColorStyle.blue: CustomTextColorStyle.dark,
                    style: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        // ?.copyWith(color: AppThemes.widgetColorWhite.withOpacity(bankcardBean.state == 2 ? 0.5 : 1)),
                  ),
                  Visibility(
                    visible: (bankcardBean.uid ?? "").isEmpty ? false : true,
                    child: CustomText(
                      textColorStyle: bankcardBean.isSelect == true ?CustomTextColorStyle.blue: CustomTextColorStyle.dark,
                      bankcardBean.bankAccount ?? "",
                      style: ThemeService()
                          .theme
                          .textTheme
                          .bodyMedium
                          // ?.copyWith(color: bankcardBean.state == 2 ? AppThemes.iconColor : AppThemes
                          // .widgetColorWhite),
                    ),
                  ),
                ],
              )
            ],
          ),
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
