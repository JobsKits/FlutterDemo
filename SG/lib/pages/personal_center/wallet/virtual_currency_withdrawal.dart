import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/model/wallet/CoinBean.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/custom_password_tip.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/custom_select_coin_widget.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/deposit_empty_view.dart';
import 'package:flutter_bet/widget/custom_tips*_text.dart.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_error_tips_text.dart.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../utils/route_util.dart';
import '../../../utils/vault_util.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_empty_widget.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/dialog/dialog_utils.dart';
import 'auth_widget.dart';
import 'binding_virtual_address.dart';
import 'decimal_input_formatter.dart';

final GlobalKey _globalKeyInput = GlobalKey();

class VirtualCurrencyWithdrawal extends StatelessWidget {
  final WalletController walletController;

  final GlobalKey globalKeyS;

  VirtualCurrencyWithdrawal({
    super.key,
    required this.walletController,
    required this.globalKeyS,
  });

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        getView(context),
      ],
    );
  }

  Widget getView(BuildContext context) {
    // return
    //   walletController.ifHaveDrawalPayMe.value == false ?
    //   const CustomEmptyWidget(
    //     imgPath: 'assets/images/ic_no_bet_bill.png',)
    //       :
    //   walletController.ifBindAddress.value == true
    //       ? BindingVirtualAddress(
    //     currencyId: walletController.currencyWithdrawalSelectCoinAndAmountId.value,
    //     contractType: walletController.currencyWithdrawalSelectContract,
    //     name: walletController.currencyWithdrawalSelectCoin.value,
    //     flag: "1",
    //     selContracts: walletController.currencyDepSelContract.value,
    //     selContractIds: walletController.currencySelContractId.value,
    //   )
    //       : contentView(context);

    return Obx(() {
      if( walletController.ifHaveDrawalPayMe.value == false ) {
        // return  CustomEmptyWidget(
        //   imgPath: 'assets/images/ic_no_bet_bill.png',);
        return DepositEmptyView(tips: S.current.random_text_795,);
      }else{
        return  walletController.ifBindAddress.value ? noDataView() : contentView(context);
      }
    });
  }


  Widget contentView(BuildContext context) {
    return Column(
      children: [
        Container(
          margin:
          const EdgeInsets.only(left: AppValues.defaultMargin, right: AppValues.defaultMargin),
          child: Column(
            children: [
              Row(children: [
                CustomNetWorkImage(
                  imageUrl: walletController.currencyWithdrawalSelectCoinIc.value,
                  width: 18,
                  height: 18,
                ),
                const SizedBox(
                  width: 4,
                ),
                CustomAsterisksTipsText(
                    text:
                    "${walletController.currencyWithdrawalSelectCoin}${S.current.vault_address}"),
              ]),
              const SizedBox(
                height: 4,
              ),
              _selectAddress(S.current.fiat_currency_select_the_payment_bank, context),
              Obx(() {
                return _flagAndMemos();
              }),
              _amountInputWidget(),

              const SizedBox(
                height: 10,
              ),
              Obx(() {
                return CustomAsterisksTipsText(
                    text: walletController.pwdTypeBean.isNotEmpty ? walletController
                        .pwdTypeBean['typeName'] : "");
              }),
              const SizedBox(
                height: 4,
              ),
              Stack(
                children: [
                  Obx(() {
                    return CustomMainTextField(
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
                        child: CustomPasswordTips(
                          onPwdTypeSelected: (selectedPwdType) {
                            walletController.pwdTypeBean.value = selectedPwdType;
                            walletController. inputPassWordShowErrorText.value = S.current.binding_bank_card_please_enter+
                                "${ walletController.pwdTypeBean["title"]}";
                            log("neco  密码配置 ${walletController.pwdTypeBean['title']}");
                          },
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomBigMainButton(
                colorStyle: CustomButtonColorStyle.tertiary,
                onTap: (btnCtr) {
                  walletController.coinWithdraw(context, btnCtr);
                },
                title: S.current.random_text_710,
              ),
              const SizedBox(
                height: 12,
              ),
              //未来需要
              Visibility(
                visible: false,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    children: [
                      CustomText(
                        S.current.random_text_449,
                        textColorStyle: CustomTextColorStyle.normal,
                      ),
                      CustomAssetIcon(
                        name: "assets/images/pe/ic_pe_football.png",
                        size: 12,
                      ),
                      CustomText(S.current.random_text_450,
                          textColorStyle: CustomTextColorStyle.normal),
                      CustomText("1.0000000", textColorStyle: CustomTextColorStyle.normal),
                      CustomAssetIcon(
                        name: "assets/images/pe/ic_pe_football.png",
                        size: 12,
                      ),
                      CustomText(S.current.random_text_451,
                          textColorStyle: CustomTextColorStyle.normal),
                      // Row(
                      //   children: const [
                      //     CustomText("1.0000000",textColorStyle: CustomTextColorStyle.normal),
                      //     CustomAssetIcon(
                      //       name: "assets/images/pe/ic_pe_football.png",
                      //       size: 12,
                      //     ),
                      //     CustomText("作为您提款的交易费用。",textColorStyle: CustomTextColorStyle.normal),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
         return Visibility(visible: VaultUtil.isSecretNot()&&!VaultUtil.isEmailCheckStateNotBind(), child: const AuthWidget());
        })
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
      child: Padding(
        padding: const EdgeInsets.only(top: 22,bottom: 22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40,),

            Padding(
              padding: const EdgeInsets.only(top: 3,right: 6),
              child: Image.asset('assets/images/personal_center_icon/wallet/cards_warning.png',width: 16,),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: AppValues.margin_20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(S.current.random_text_655c1,textColorStyle: CustomTextColorStyle.secondary,style: TextStyle(fontWeight: FontWeight.w500),),
                    CustomText(S.current.random_text_655c2,textColorStyle: CustomTextColorStyle.secondary,style: TextStyle(fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 2,)
          ],
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

  Widget _flagAndMemos() {
    return Visibility(
      visible: walletController.currencySelCurrencyId.value == "720" ||
          walletController.currencySelCurrencyId.value == "721",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomText(
            walletController.currencySelCurrencyId.value == "720" ? S.current.random_text_660 : S.current.random_text_661,
            textColorStyle: CustomTextColorStyle.normal,
          ),
          const SizedBox(
            height: 4,
          ),
          CustomMainTextField(
            text: walletController.memo.value,
            inputCallBack: (str) {
              walletController.memo.value = str;
            },
          ),
        ],
      ),
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
        CustomAsterisksTipsText(
          text: S.current.vault_amount,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     CustomAsterisksTipsText(text: S.current.vault_amount),
        //     //https://jira.vgtech.org/browse/STAK-854
        //     Obx(() {
        //       return CustomText("US\$ ${walletController.withdrawRateCount.toStringAsFixed(2)}",
        //           textColorStyle: CustomTextColorStyle.normal);
        //     }),
        //   ],
        // ),
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
        // S.current.vault_the_minimal_amount_is(0.0002)
        Obx(() {
          return CustomMainTextField(
            //https://jira.vgtech.org/browse/STAK-877
              inputFormatters: [DecimalInputFormatter()],
              // hintText: "0.000000000",
              showError: walletController.inputAmountShowError.value,
              errorText: walletController.inputAmountShowErrorText.value,
              text: walletController.inputAmount.value,
              controller: walletController.walletCoinAmountController,
              isCursorEnd: false,
              inputCallBack: (str) {
                if (str.isNotEmpty) {
                  double inputAmount = double.parse(str);
                  double currencyAmount = double.parse(walletController.withdrawBalance.value);
                  double currencyAmountTotal = double.parse(walletController.currencyAmount.value);
                  if (inputAmount > currencyAmount) {
                    walletController.inputAmount.value = walletController.withdrawBalance.value;
                    walletController.walletCoinAmountController?.text =
                        walletController.inputAmount.value;
                    walletController.walletCoinAmountController!.selection =
                        TextSelection.fromPosition(
                          TextPosition(
                              offset: walletController.walletCoinAmountController!.text.length),
                        );
                    walletController.withdrawExchangeRateCount(walletController.withdrawBalance.value);
                    if(currencyAmount!=currencyAmountTotal){
                      walletController.inputAmountShowError.value = true;
                      walletController.inputAmountShowErrorText.value = "${S.current.random_text_711}${walletController.withdrawBalance.value}${S.current.random_text_712}${walletController.remainingBalance.value}";
                    }
                  } else {
                    if (inputAmount == currencyAmount) {
                      walletController.walletCoinAmountController!.selection =
                          TextSelection.fromPosition(
                            TextPosition(
                                offset: walletController.walletCoinAmountController!.text.length),
                          );
                    }
                    walletController.inputAmount.value = str;
                    walletController.withdrawExchangeRateCount(str);
                    walletController.checkInputAmount();
                  }
                } else {
                  walletController.inputAmount.value = str;
                  walletController.withdrawExchangeRateCount(str);
                  walletController.inputAmountShowError.value = false;

                }
              });
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
            child: GestureDetector(
              onTap: () {
                //原来需求
                // walletController.inputAmount.value = walletController.currencyAmount.value;
                // walletController.walletCoinAmountController?.text =
                //     walletController.inputAmount.value;
                // walletController.withdrawExchangeRateCount(walletController.inputAmount.value);
                // walletController.walletCoinAmountController!.selection = TextSelection.fromPosition(
                //   TextPosition(offset: walletController.walletCoinAmountController!.text.length),
                // );

                //https://jira.vgtech.org/browse/STAK-4426
                double withdrawBalance = double.parse(walletController.withdrawBalance.value);
                if(withdrawBalance<=0){
                  return ;
                }
                //最新需求
                walletController.inputAmount.value = walletController.withdrawBalance.value;
                walletController.walletCoinAmountController?.text =
                    walletController.inputAmount.value;
                walletController.withdrawExchangeRateCount(walletController.inputAmount.value);
                walletController.walletCoinAmountController!.selection = TextSelection.fromPosition(
                  TextPosition(offset: walletController.walletCoinAmountController!.text.length),
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

  Widget _selectAddress(String hintStr, BuildContext context) {
    return Stack(
      children: [
        GestureDetector(onTap: () {
          _startAnimation(_rotatingArrowKey);
          DialogUtils.showCustomBubbleDialog(context, _selectAddressType(), _getInputWidth(),
              widgetKey: _globalKeyInput,
              backgroundColor: AppThemes.widgetColorWhite,
              bubbleArrowHeight: 8,
              bubbleArrowWidth: 8,
              globalKey: _rotatingArrowKey,
              arrowBasisOffset: -120.0

          );
        }, child: Obx(() {
          return Column(
            children: [
              CustomMainTextField(
                showError: walletController.curSelectAddressShowError.value,
                text:
                "\t\t\t\t\t${walletController.curSelectAddress.value} ${walletController
                    .curSelectBankAccount.value}",
                enabled: false,
                key: _globalKeyInput,
              ),
              Visibility(
                  visible: walletController.curSelectAddressShowError.value,
                  child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: CustomErrorTipsText(
                        textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500, color: ThemeService().colorScheme.error),
                        text: S.current.vault_this_field_is_required,
                      ))),
            ],
          );
        })),
        Obx(() {
          return Visibility(
            visible: walletController.curSelectAddress.value.isEmpty ? false : true,
            child: Positioned(
                left: 10,
                child: Container(
                  height: AppValues.defaultTextHeight,
                  margin: const EdgeInsets.only(right: 9),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: CustomNetWorkImage(
                    imageUrl: walletController.currencyWithdrawalSelectCoinIc.value,
                    width: 20,
                  ),
                )),
          );
        }),
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

  Widget _selectAddressType() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        child: Column(
          children:  walletController.addressList.isNotEmpty? walletController.addressList.map((bank) {
            return _addressItem(bank);
          }).toList():[const SizedBox(height: 20,),Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 10),
              child: CustomText(S.current.random_text_662,textColorStyle: CustomTextColorStyle.dark,)),SizedBox(height: 20,)],
        ),
      ),
    );
  }

  Widget _addressItem(CoinBean coinBean) {
    return GestureDetector(
      onTap: () {
        if (coinBean.state == 2) {
          return;
        }
        for (int i = 0; i < walletController.addressList.length; i++) {
          walletController.addressList[i].isSelect = false;
        }
        var isSelect = coinBean.isSelect ?? false;
        coinBean.isSelect = isSelect ? false : true;
        walletController.addressList.refresh();
        walletController.curSelectAddressId.value = coinBean.id ?? "";
        walletController.curSelectAddress.value = coinBean.address ?? "";
        walletController.curSelectAddressShowError.value =
            walletController.assertField(walletController.curSelectAddress.value);
        RouteUtil.popView();
      },
      child: Opacity(
        opacity: coinBean.state == 2 ? 0.5 : 1,
        child: Container(
          // color: coinBean.isSelect == true ? ThemeService().colorScheme.primary : Colors.transparent,
          color: Colors.transparent,
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            mainAxisAlignment:
            (coinBean.uid ?? "").isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 16,
              ),
              CustomNetWorkImage(
                width: 18,
                height: 18,
                // color: AppThemes.widgetColorWhite.withOpacity( coinBean.state==2?0.5:1),
                imageUrl: walletController.currencyWithdrawalSelectCoinIc.value,
              ),
              SizedBox(
                width: (coinBean.uid ?? "").isNotEmpty ? 12 : 0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    textColorStyle: coinBean.isSelect == true ?CustomTextColorStyle.blue: CustomTextColorStyle.dark,
                    coinBean.address ?? "",
                    // style: ThemeService().theme.textTheme.bodyMedium?.copyWith(color: AppThemes.widgetColorWhite.withOpacity(coinBean.state == 2 ? 0.5 : 1)),
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
