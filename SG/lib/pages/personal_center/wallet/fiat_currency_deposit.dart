import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/pages/personal_center/wallet/auth_widget.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/deposit_empty_view.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/scale_tabbar.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/vault_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../model/wallet/BankcardBean.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_empty_widget.dart';
import '../../../widget/custom_error_tips_text.dart.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/network_image/custom_network_image_placeholder.dart';
double bubbleWidth = 114;
final GlobalKey _globalKeyTextField = GlobalKey();
const double bankRatio = 2.5; //银行系数
final GlobalKey _globalKeyInput = GlobalKey();
final GlobalKey _globalKeyChannel= GlobalKey();

class FiatCurrencyDeposit extends StatelessWidget {
  final WalletController controller;
  final GlobalKey globalKeyS;

  FiatCurrencyDeposit({super.key, required this.controller, required this.globalKeyS});

  final GlobalKey<RotatingArrowState> _rotatingAmountArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<RotatingArrowState> _rotatingChannelArrowKey = GlobalKey<RotatingArrowState>();


  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  final GlobalKey<RotatingArrowState> _rotatingBankArrowKey = GlobalKey<RotatingArrowState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return getView(context);
        })
      ],
    );
  }

  Widget getView(BuildContext context) {
    return controller.isLoadingCompleted.value == false ? SizedBox(
        height: 150,
        child: CustomNetWorkImagePlaceholder(

          color: AppThemes.surfaceVariant.withOpacity(0),
          placeholderType: NetWorkImagePlaceholderType.loading,
        )) :
     controller.isPayment.value == false ||  controller.isChannel.value == false
         ? DepositEmptyView(tips:S.current.random_text_713,)
         : contentView(context);
  }

  Widget contentView(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20,left: AppValues.defaultMargin,right: AppValues.defaultMargin),
          child: Column(
            children: [
              CustomAsterisksTipsText(text: S.current.random_text_653),
              _paymentType(),
              _selectBankWidget(context),
              _channelView(context),
              Visibility(visible: controller.paymentType.value == 2 ? true : false,
                  child: _bankDepositNameWidget()),
              _amountInputWidget(context),
              const SizedBox(
                height: 10,
              ),
              _amountSelect(controller),
              const SizedBox(
                height: 10,
              ),
              CustomBigMainButton(
                colorStyle:  CustomButtonColorStyle.tertiary,
                onTap: (btnCtr) {
                  // CustomSafeDialog.dismiss(context: controller.context!, tag: kCustomWalletWidget);
                  // showCustomWalletDetailsWidget(context: controller.context!);
                  // controller.thirdDeposit(controller.context!, buttonCtr, controller.cid.value, controller.mid.value, controller.amountSel.value, controller.bankCode.value);
                  controller.confirmPayment(context, btnCtr);
                },
                title: S.current.vault_confirm_payment,
              ),
            ],
          ),
        ),

        Visibility(visible: VaultUtil.isSecretNot()&&!VaultUtil.isEmailCheckStateNotBind(), child: const AuthWidget())
      ],
    );
  }

  Widget _selectBankWidget(BuildContext context) {
    return Visibility(
        visible: controller.thirdBankList.isNotEmpty,
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomAsterisksTipsText( text:  S.current.wallet_bankSelection,),
            ),
            const SizedBox(
              height: 4,
            ),
            // _selectBank(S.current.binding_bank_card_select_bank, context)
            _selectBank("", context)
          ],
        ));
  }

  Widget _selectBank(String hintStr, BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onTap: () {
              _startAnimation(_rotatingBankArrowKey);
              DialogUtils.showCustomBubbleDialog(
                  context, _selectBankType(), _getInputWidth(_globalKeyInput),
                  widgetKey: _globalKeyInput,
                  backgroundColor: AppThemes.widgetColorWhite,
                  bubbleArrowHeight: 8,
                  bubbleArrowWidth: 8,
                  globalKey: _rotatingBankArrowKey);
            },
            child: CustomMainTextField(
              errorText: controller.curThirdSelectBankErrorText.value,
              showError: controller.curThirdSelectBankShowError.value,
              text: controller.curThirdSelectBank.value,
              hintText: hintStr,
              enabled: false,
              key: _globalKeyInput,
            )),
        Positioned(
            right: 0,
            child: Container(
              height: AppValues.defaultTextHeight,
              margin: const EdgeInsets.only(right: 9),
              child: RotatingArrow(
                key: _rotatingBankArrowKey,
              ),
            ))
      ],
    );
  }

  Widget _selectBankType() {
    return Container(
      constraints: BoxConstraints(maxHeight: _getWalletHeight(bankRatio)),
      child: Scrollbar(
        controller: controller.scrollAbcBankController, // Provide a ScrollController
        radius: const Radius.circular(10),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: controller.scrollAbcBankController,
          child: Column(
            children: controller.thirdBankList.map((bank) {
              return _bankItem(bank);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _bankItem(BankcardBean bankcardBean) {
    return GestureDetector(
      onTap: () {
        for (var item in controller.thirdBankList) {
          item.isSelect = false;
        }
        bankcardBean.isSelect = bankcardBean.isSelect==true ? false : true;
        controller.thirdBankList.refresh();
        controller.curThirdSelectBank.value =
        (bankcardBean.uid != null) ? (bankcardBean.bankName ?? "") : (bankcardBean.name ?? "");
        controller.curThirdSelectBankShowError.value =
            controller.assertField(controller.curThirdSelectBank.value);
        controller.bankCode.value = bankcardBean.id ?? "";
        RouteUtil.popView();
      },
      child: Container(
        color:bankcardBean.isSelect == true ? AppThemes.textColorSecondary : Colors.transparent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 8),
        child: CustomText(
          (bankcardBean.uid != null) ? (bankcardBean.bankName ?? "") : (bankcardBean.name ?? ""),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
            textColorStyle: CustomTextColorStyle.dark,
        ),
      ),
    );
  }

//金额输入框
  Widget _amountInputWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Visibility(
            visible: controller.amountType.value == 2,
            //勿删
            // child: CustomText(
            //   textColorStyle: CustomTextColorStyle.normal,
            //   "${S.current.vault_recharge_amount}:${controller.currencySymbol.value}",
            // )
            child: CustomAsterisksTipsText(
              text: "${S.current.vault_recharge_amount}",
            )
        ),
        const SizedBox(
          height: 4,
        ),
        controller.amountType.value == 1
            ? Obx(() {
          return _amountChooseWidget(context);
        })
            : Obx(() {
          return Column(
            children: [
              CustomMainTextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                errorText: controller.errorStr.value,
                showError: controller.amountShowError.value == true,
                enabled: controller.amountType.value == 2,
                // hintText: controller.amountType.value == 2 ? "请输入金额" : "请选择金额",
                hintText:  "${controller.amountMix.value}-${controller.amountMax.value}" ,
                isRemoveHint:true,
                text: controller.amountSel.value,
                inputCallBack: (str) {
                  for (int i = 0; i < controller.amountList.length; i++) {
                    // if (controller.amountList[i]['amount'] == str) {
                    //   controller.amountList[i]['isSelect'] = true;
                    // } else {
                    //   controller.amountList[i]['isSelect'] = false;
                    // }
                    //https://jira.vgtech.org/browse/STAK-7084
                    controller.amountList[i]['isSelect'] = false;
                  }
                  controller.amountList.refresh();
                  //待观察
                  controller.amountSel.value = str;
                  controller.getAmountErrorHintStr();
                },
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _amountChooseWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CustomText("${S.current.vault_recharge_amount}:${controller.currencySymbol.value} ",
        //     textColorStyle: CustomTextColorStyle.normal),
        CustomAsterisksTipsText(text: "${S.current.vault_recharge_amount}" ),
        GestureDetector(
            onTap: () {
              _startAnimation(_rotatingAmountArrowKey);
              DialogUtils.showCustomBubbleDialog(
                  context,
                  Container(
                    constraints: BoxConstraints(maxHeight: _getWalletHeight(3)),
                    child: Scrollbar(
                      controller: controller.scrollAmountChooseFiatController, // Provide a ScrollController
                      radius: const Radius.circular(10),
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: controller.scrollAmountChooseFiatController,
                        child: Column(
                          children: controller.amountFixedList
                              .map((bean) =>
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  for (var item in controller.amountFixedList) {
                                    item['isSelect'] = false;
                                  }
                                  bean['isSelect'] = bean['isSelect'] ? false : true;

                                  for (var item in controller.amountList) {
                                    item['isSelect'] = false;
                                  }
                                  for (int i = 0; i < controller.amountList.length; i++) {
                                    if (controller.amountList[i]['amount'] == bean['amount']) {
                                      controller.amountList[i]['isSelect'] = true;
                                    } else {
                                      controller.amountList[i]['isSelect'] = false;
                                    }
                                  }
                                  controller.amountList.refresh();
                                  controller.amountSel.value = bean['amount'];
                                  controller.getAmountErrorHintStr();
                                  controller.hideKeyboard(context);
                                },
                                child: Container(
                                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                    color: bean['isSelect'] == true ? AppThemes.textColorSecondary : null,
                                    width: double.infinity,
                                    child: CustomText(bean['amount'],textColorStyle: CustomTextColorStyle.dark,)),
                              ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  _getInputWidth(_globalKeyTextField),
                  widgetKey: _globalKeyTextField,
                  backgroundColor: AppThemes.widgetColorWhite,
                  globalKey: _rotatingAmountArrowKey);
            },
            child: Container(
              // height: AppValues.defaultTextHeight,
              key: _globalKeyTextField,
              margin: const EdgeInsets.only(top:4),
              padding: const EdgeInsets.only(
                  top: 9, bottom: 9),
              decoration: BoxDecoration(
                  border: Border.all(color: controller.amountShowError.value == true
                      ? AppThemes.reverseStateColor
                      : ThemeService().colorScheme.tertiary, width: 2),
                  color: ThemeService().colorScheme.surface,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(4))),
              child: Row(
                children: [
                  const SizedBox(
                    width: AppValues.width_12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[ CustomText(
                          controller.amountSel.value.isEmpty?S.current.random_text_654:controller.amountSel.value,
                          textColorStyle: controller.amountSel.value.isEmpty?CustomTextColorStyle.normal:CustomTextColorStyle.panda,
                          style: ThemeService()
                              .theme
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500))],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  RotatingArrow(
                    key: _rotatingAmountArrowKey,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ),
            )),
        Visibility(
          visible: controller.amountShowError.value == true,
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            child: CustomErrorTipsText(
              text: controller.errorStr.value,
            ),
          ),
        )
      ],
    );
  }

//金额选择列表
  Widget _amountSelect(WalletController controller) {
    return Obx(() {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.8, crossAxisCount: 3),
        itemCount: controller.amountList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: _itemAmount(index, controller),
            onTap: () {
              for (var item in controller.amountList) {
                item['isSelect'] = false;
              }
              controller.amountSel.value = controller.amountList[index]['amount'];
              controller.amountList[index]['isSelect'] = controller.amountList[index]['isSelect'] ? false : true;
              controller.amountList.refresh();


              for (var item in controller.amountFixedList) {
                item['isSelect'] = false;
              }
              for (int i = 0; i < controller.amountFixedList.length; i++) {
                if (controller.amountFixedList[i]['amount'] == controller.amountList[index]['amount']) {
                  controller.amountFixedList[i]['isSelect'] = true;
                } else {
                  controller.amountFixedList[i]['isSelect'] = false;
                }
              }

              controller.getAmountErrorHintStr();
              controller.hideKeyboard(context);
            },
          );
        },
      );
    });
  }

//金额item
  Widget _itemAmount(int index, WalletController controller) {
    return Container(
      decoration: controller.amountList[index]['isSelect']
          ? BoxDecoration(
          border: Border.all(color: AppThemes.secondaryColor, width: 2),
          borderRadius: BorderRadius.circular(4))
          : BoxDecoration(
          border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          )),
      child: Center(
        child: Text(
          "${controller.amountList[index]?['amount'] ?? ""}",
        ),
      ),
    );
  }

  Widget _channelView(BuildContext context) {
    return Obx(() {
      return Visibility(
        //https://jira.vgtech.org/browse/STAK-129
        //https://jira.vgtech.org/browse/STAK-986
          visible: controller.paymentType.value ==2 || controller.channelTabs.length==1 ? false :true,
          child: Column(
            children: [
              // const SizedBox(
              //   height: 12,
              // ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: CustomText(
              //     S.current.fiat_currency_channel_selection,
              //     textColorStyle: CustomTextColorStyle.normal,
              //   ),
              // ),
              // const SizedBox(height: 10,),
              // // _channelSelect(), 勿删除
              _channelSelectV2(context),
            ],
          ));
    });
  }

  ///通道选择v1
  Widget _channelSelect() {
    // log("neco  controller.channelTabs ${controller.channelTabs.length}");
    return SizedBox(
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
          // controller: controller.tabControllerChannelType,
          tabs: controller.channelTabs
              .asMap()
              .entries
              .map((element) {
            return _itemChannel(element.key);
          }).toList(),
          isScrollable: true,
        )
    );
  }
  Widget _itemChannel(int index) {
    return Obx(() {
      return Container(
        // padding: const EdgeInsets.only(left: 8, right: 8),
        decoration: controller.channelList[index].isSelect == true
            ? BoxDecoration(
            color: ThemeService().colorScheme.secondary,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ))
            : BoxDecoration(
            color: ThemeService().colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            )),
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 4,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 8,),
                // const CustomAssetIcon(
                //   name: "assets/images/personal_center_icon/vip.webp",
                // ),
                CustomText(
                  "${controller.channelList[index].name}",
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 8,)
              ],
            ),
            const SizedBox(height: 4,),
            Row(
              children: [
                const SizedBox(width: 8,),
                CustomText(
                  "${controller.channelList[index].amountMin}-${controller.channelList[index]
                      .amountMax }",
                ),
                const SizedBox(width: 8,),

              ],
            ),
            const SizedBox(height: 4,),
          ],
        ),
      );
    });
  }

  Widget _channelSelectV2(BuildContext context) {
    log("neco  controller.channelTabs ${controller.channelList.length}");
    return Visibility(
      visible: controller.channelList.length==1 ? false :true,
      child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 14,),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomAsterisksTipsText(
                  text: S.current.fiat_currency_channel_selection,
                  // textStyle: CustomTextColorStyle.normal,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    _startAnimation(_rotatingChannelArrowKey);
                    DialogUtils.showCustomBubbleDialog(
                        context,
                        Container(
                          constraints: BoxConstraints(maxHeight: _getWalletHeight(2)),
                          child: SingleChildScrollView(
                            child: Column(
                              children: controller.channelList
                                  .map((bean) =>
                                  InkWell(
                                    onTap: () {
                                      controller.amountSel.value = "";
                                      controller. errorStr.value = "";
                                      controller. amountShowError.value = false;
                                      controller. paymentType.value= bean.paymentType ?? 0;
                                      for (var item in  controller.channelList) {
                                        item.isSelect = false;
                                      }
                                      bean.isSelect =bean.isSelect == true ? false : true;
                                      controller.channelList.refresh();
                                      controller.getAmount(bean);
                                      log("neco 支付类型 = ${   controller. paymentType.value}");

                                      Get.back();
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.only(left: 16,top: 8,bottom: 8 ),
                                        width: double.infinity,
                                        color: bean.isSelect==true?AppThemes.textColorSecondary :null,
                                        child: CustomText(bean.name??"",textColorStyle:CustomTextColorStyle.dark)),
                                  ))
                                  .toList(),
                            ),
                          ),
                        ),
                        _getInputWidth(_globalKeyChannel)-8,
                        widgetKey: _globalKeyChannel,
                        bubbleArrowHeight: 4,
                        bubbleArrowWidth: 8,
                        arrowBasisOffset: -120.0,
                        backgroundColor: AppThemes.widgetColorWhite,
                        globalKey: _rotatingChannelArrowKey,
                    );
                  },
                  child: Container(
                    height: AppValues.defaultTextHeight,
                    key: _globalKeyChannel,
                    margin: const EdgeInsets.only(top:2),
                    padding: const EdgeInsets.only(
                        top: 9, bottom: 9),
                    decoration: BoxDecoration(
                        border: Border.all(color:  ThemeService().colorScheme.tertiary, width: 2),
                        color: ThemeService().colorScheme.surface,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(4) )),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: AppValues.width_12,
                        ),
                        CustomText(
                            controller.channelSelectBean.value.name??"",
                            textColorStyle: controller.amountSel.value.isEmpty&&controller.channelTabs.length==1?CustomTextColorStyle.normal:CustomTextColorStyle.panda,
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        const Expanded(child: SizedBox()),
                        const SizedBox(
                          width: 4,
                        ),
                        RotatingArrow(
                          key: _rotatingChannelArrowKey,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                  ))
            ],
          )
      ),
    );
  }

  ///支付方式列表
  Widget _paymentType() {
    return Container(
        padding: const EdgeInsets.only(left: 7,right: 7,top: 5,bottom: 0),
        decoration: BoxDecoration(
            color: ThemeService().colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2, // 阴影模糊程度
              offset: const Offset(0, 2), // 阴影偏移量
            ),
          ],

        ),
        margin: const EdgeInsets.only(top: 4),
        height: 54,
        width: double.infinity,
        child: ScaleTabBar(
          indicatorWeight: 0.0,
          labelPadding: const EdgeInsets.only(left: 2, right: 5),
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          indicator: const BoxDecoration(),
          controller: controller.tabControllerPayType,
          tabs: controller.payTabs
              .asMap()
              .entries
              .map((element) {
            return _itemPay(element.key);
          }).toList(),
          isScrollable: true,
        )
    );
  }

  ///支付方式item
  Widget _itemPay(int index) {
    return Obx(() {
      return Container(
        alignment: Alignment.center,
        decoration: controller.payList[index].isSelect == true
            ? const BoxDecoration(
            color: AppThemes.tabBgColor,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ))
        :null,
            // :BoxDecoration(
            // border: Border.all(color:ThemeService().colorScheme.tertiary, width: 1),
            // borderRadius: const BorderRadius.all(
            //   Radius.circular(4),
            // )),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                padding: const EdgeInsets.only(left: 3, right: 3 ),
                decoration: BoxDecoration(
                  color: controller.getMarkBg(controller.payList[index].ptype ?? 0),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(3), bottomLeft: Radius.circular(4)),
                ),
                child: CustomText(controller.getMarkValue(controller.payList[index].pname ?? "",
                    controller.payList[index].promo ?? "",controller.payList[index].ptype ?? 0),
                  style:const TextStyle(fontSize: 11,fontWeight: FontWeight.w600),
                  textColorStyle: CustomTextColorStyle.white,),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 9,),
                    SizedBox(
                      // height: 20,
                      child: CustomNetWorkImage(
                        fit: BoxFit.fitWidth,
                        placeholder: const CustomAssetIcon(
                          name: 'assets/images/personal_center_icon/pay_default_ic.webp',),
                        errorWidget: const CustomAssetIcon(
                          name: 'assets/images/personal_center_icon/pay_default_ic.webp',),
                        width: 14,
                        height: 14,
                        imageUrl: "${controller.payIcDomain}payment/deposit/${controller
                            .payList[index].alias}${controller.coinIcExtensionName}",),
                    ),
                    const SizedBox(width: 3,),
                    CustomText(
                      "${controller.payList[index].name}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: AppThemes.widgetColorWhite),
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                        height: 1,
                        leading: 0.5
                      ),
                    ),
                    const SizedBox(width: 9,),
                  ],
                ),
              ],
            )
          ],
        ),
      );
    });
  }


  Widget _bankDepositNameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            CustomAsterisksTipsText(text: S.current.fiat_currency_Depositor_is_name, ),
           // https://jira.vgtech.org/browse/STAK-2713
            // Expanded(
            //   child: CustomText(S.current.fiat_currency_deposit_hint,
            //       style: ThemeService()
            //           .theme
            //           .textTheme
            //           .bodySmall
            //           ?.copyWith(fontWeight: FontWeight.w500, color: AppThemes.scoreTextColor)),
            // ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Obx(() {
          return CustomMainTextField(
            errorText: S.current.wallet_pleaseEnterNameDepositor,
            showError: controller.depositPeopleNameError.value,
            text: controller.depositPeopleName.value,
            inputCallBack: (str) {
              if (str.isNotEmpty) {
                controller.depositPeopleNameError.value = false;
              } else {
                controller.depositPeopleNameError.value = true;
              }
              controller.depositPeopleName.value = str;
            },
          );
        }),
      ],
    );
  }

  double _getWalletHeight(double ratio) {
    double? totalHeight;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = globalKeyS.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    totalHeight = size.height;
    return totalHeight / ratio;
  }

  double _getInputWidth(GlobalKey globalKey) {
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    return size.width;
  }
}
