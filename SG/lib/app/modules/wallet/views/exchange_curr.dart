import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/vault_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../pages/personal_center/wallet/auth_widget.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/num_util.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../controllers/exchange_ctrl.dart';

class ExchangeCurr extends GetView<ExchangeCtrl> {
  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _globalExchangeKey = GlobalKey();

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<RotatingArrowState> _rotatingArrowExchangeKey = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  late ExchangeCtrl walletController;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ExchangeCtrl());
    walletController = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
              left: AppValues.defaultMargin,
              right: AppValues.defaultMargin,
              top: AppValues.defaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return Row(
                  children: [
                    CustomAsterisksTipsText(
                        text: S.current.random_text_709c1(
                            walletController.currentCurrencyBean.value.name ?? '')),
                    // const Spacer(),
                    // CustomText(S.current.random_text_652 + " ",
                    //     textColorStyle: CustomTextColorStyle.normal),
                    // CustomText(
                    //     walletController.formatBalance(walletController.exchangeRate.value),
                    //     textColorStyle: CustomTextColorStyle.normal)
                  ],
                );
              }),
              const SizedBox(
                height: 8,
              ),
              _inputWidget(1, context),
              const SizedBox(
                height: AppValues.defaultMargin,
              ),
              Obx(() {
                // if (LangUtil().isEnIn() || LangUtil().isPtBr()) {
                //   return CustomAsterisksTipsText(
                //     text:
                //         "${S.current.random_text_707}(${walletController.exChangeCurrencyBean.value.name})",
                //   );
                // }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomAsterisksTipsText(
                      text: (LangUtil().isEnIn() || LangUtil().isPtBr())
                          ? "${S.current.random_text_707}(${walletController.exChangeCurrencyBean.value.name})"
                          : "${S.current.random_text_707}${walletController.exChangeCurrencyBean.value.name}",
                    ),
                    CustomText(
                        "${S.current.random_text_652}${walletController.formatBalance(walletController.exchangeRate.value)}",
                        textColorStyle: CustomTextColorStyle.normal)
                  ],
                );
              }),
              const SizedBox(
                height: 4,
              ),
              _inputWidget(2, context),
              const SizedBox(
                height: 5,
              ),
              CustomText(
                S.current.random_text_1163,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                textColorStyle: CustomTextColorStyle.normal,
              ),
              const SizedBox(
                height: 16,
              ),
              Obx(() {
                double payAmount = double.parse(walletController.currentCurrencyText.value.isEmpty
                    ? "0.0"
                    : walletController.currentCurrencyText.value);
                double exChangeCurrency = double.parse(
                    walletController.exChangeCurrencyText.value.isEmpty
                        ? "0.0"
                        : walletController.exChangeCurrencyText.value);
                return CustomBigMainButton(
                  fontWeight: FontWeight.w600,
                  isEnable: payAmount > 0 &&
                          exChangeCurrency > 0 &&
                          walletController.countdownTime.value == 0
                      ? true
                      : false,
                  onTap: (btnCtr) {
                    walletController.balanceTransfer(context, btnCtr);
                  },
                  colorStyle: CustomButtonColorStyle.tertiary,
                  title: walletController.countdownTime.value > 0
                      ? "${walletController.countdownTime.value}s"
                      : S.current.vault_confirm_payment,
                );
              }),
              const SizedBox(
                height: AppValues.margin_20,
              ),
            ],
          ),
        ),
        Obx(() {
          return Visibility(
              visible: VaultUtil.isSecretNot() && !VaultUtil.isEmailCheckStateNotBind(),
              child: const AuthWidget());
        }),
      ],
    );
  }

  //flag 1:当前货币 2:兑换货币
  Widget _inputWidget(int flag, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              flag == 1
                  ? Obx(() {
                      //支付币
                      return CustomMainTextField(
                          keyboardType: TextInputType.number,
                          decoration: controller.getBoxDecoration(showErr: false),
                          showError: false,
                          errorText: "",
                          // text :walletController.currentCurrencyBean.value.currency_type==2?double.parse(walletController.currentCurrencyText.value).toStringAsFixed(8):double.parse(walletController.currentCurrencyText.value).toStringAsFixed(2),
                          text: walletController.currentCurrencyText.value,
                          controller: walletController.currentCurrencyTextController,
                          isCursorEnd: false,
                          inputCompletionCallBack: (str, isSubmitted) {
                            walletController.currentCurrencyText.value = NumUtil.keepDecimals(
                                double.tryParse(walletController.currentCurrencyText.value),
                                digits:
                                    walletController.currentCurrencyBean.value.currency_type == 2
                                        ? 8
                                        : 2);
                          },
                          inputCallBack: (str) {
                            if (str.isNotEmpty) {
                              double inputAmount = double.parse(str);
                              double currencyAmount = double.parse(
                                  walletController.currentCurrencyBean.value.amount ?? "0.0");
                              if (inputAmount > currencyAmount) {
                                walletController.currentCurrencyText.value =
                                    walletController.getExchangeCurrencyAmount();
                                walletController.currentCurrencyTextController?.text =
                                    walletController.getExchangeCurrencyAmount();
                                walletController.currentCurrencyTextController?.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: walletController.getExchangeCurrencyAmount().length),
                                );
                              } else {
                                if (inputAmount == currencyAmount) {
                                  walletController.currentCurrencyTextController?.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: walletController
                                            .currentCurrencyTextController!.text.length),
                                  );
                                }
                                walletController.currentCurrencyText.value = str;
                              }
                              walletController.checkCurrentCurrencyTextAmount();
                            } else {
                              walletController.currentCurrencyText.value = str;
                            }
                            walletController.convertCurrency(double.parse(
                                walletController.currentCurrencyText.value.isEmpty
                                    ? "0.0"
                                    : walletController.currentCurrencyText.value));
                          });
                    })
                  : Obx(() {
                      log("兑换货币 = ${walletController.exChangeCurrencyBean.value.currency_type}");
                      return CustomMainTextField(
                          keyboardType: TextInputType.number,
                          decoration: controller.getBoxDecoration(showErr: false),
                          showError: false,
                          errorText: "",
                          controller: walletController.exChangeCurrencyTextController,
                          // text :walletController.exChangeCurrencyBean.value.currency_type==2?double.parse(walletController.exChangeCurrencyText.value).toStringAsFixed(8):double.parse(walletController.exChangeCurrencyText.value).toStringAsFixed(2),
                          // text : walletController.exChangeCurrencyText.value ,
                          text: walletController
                              .exchangeStr(walletController.exChangeCurrencyText.value),
                          isCursorEnd: false,
                          inputCompletionCallBack: (str, isSubmitted) {
                            walletController.exChangeCurrencyText.value = NumUtil.keepDecimals(
                                double.tryParse(walletController.exChangeCurrencyText.value),
                                digits:
                                    walletController.exChangeCurrencyBean.value.currency_type == 2
                                        ? 8
                                        : 2);
                          },
                          inputCallBack: (str) {
                            walletController
                                .calculateAmount(double.parse(str.isEmpty ? "0.0" : str));
                          });
                    }),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            walletController.resetSearchList(flag);
            _startAnimation(flag == 1 ? _rotatingArrowKey : _rotatingArrowExchangeKey);
            DialogUtils.showCustomBubbleDialog(context, _selectCoinsType(context, flag),
                LangUtil().isEnIn() || LangUtil().isPtBr() ? 200 : 180,
                widgetKey: flag == 1 ? _globalKey : _globalExchangeKey,
                backgroundColor: AppThemes.textColorWhite,
                globalKey: flag == 1 ? _rotatingArrowKey : _rotatingArrowExchangeKey,
                bubbleArrowWidth: 12,
                arrowBasisOffset: 40,
                positionedRight: 32,
                bubbleArrowHeight: 8, onDismissCallback: () {
              //   walletController.scale.value = 0.9;
              //   Future.delayed(const Duration(milliseconds: 100), () {
              //     walletController.scale.value = 1.0;
              //   });
            });
          },
          child: Container(
            width: 100,
            key: flag == 1 ? _globalKey : _globalExchangeKey,
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: AppValues.defaultTextHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: ThemeService().colorScheme.tertiaryContainer,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  return CustomNetWorkImage(
                    placeholder: const CustomAssetIcon(
                      name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                    ),
                    errorWidget: const CustomAssetIcon(
                      name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                    ),
                    imageUrl: flag == 1
                        ? walletController.currentCurrencyBean.value.coinIc ?? ""
                        : walletController.exChangeCurrencyBean.value.coinIc ?? "",
                    width: 18,
                    height: 18,
                  );
                }),
                const SizedBox(
                  width: 4,
                ),
                Obx(() {
                  return CustomText(
                      flag == 1
                          ? walletController.currentCurrencyBean.value.name ?? ""
                          : walletController.exChangeCurrencyBean.value.name ?? "",
                      style: ThemeService()
                          .theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600));
                }),
                RotatingArrow(
                  key: flag == 1 ? _rotatingArrowKey : _rotatingArrowExchangeKey,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _selectCoinsTypeNoBar(BuildContext context, int flag) {
    return Obx(() {
      return Container(
        constraints: const BoxConstraints(maxHeight: 200),
        child: RawScrollbar(
          thumbVisibility: false,
          padding: EdgeInsets.zero,
          minOverscrollLength: 40,
          minThumbLength: 40,
          thumbColor: AppThemes.textColorSecondary,
          controller: walletController.exchangeCurrscrollController,
          radius: const Radius.circular(6),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...flag == 1
                    ? walletController.searchAvailableAmountList.asMap().entries.map((entry) {
                        int index = entry.key;
                        return _coinItem(index, flag, walletController.searchAvailableAmountList);
                      }).toList()
                    : walletController.searchAllAmountList.asMap().entries.map((entry) {
                        int index = entry.key;
                        return _coinItem(index, flag, walletController.searchAllAmountList);
                      }).toList(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _selectCoinsType(BuildContext context, int flag) {
    log("neco 支付类型 $flag");
    if (walletController.globalController.currTypeLists.isEmpty) {
      walletController.globalController.syncData();
    }
    return Column(
      children: [
        const SizedBox(height: AppValues.margin_10),
        _buildSearchView(flag),
        const SizedBox(height: AppValues.margin_12),
        Obx(() {
          return Container(
            color: AppThemes.widgetColorWhite,
            constraints: const BoxConstraints(maxHeight: 200),
            child: RawScrollbar(
              thumbVisibility: false,
              padding: EdgeInsets.zero,
              minOverscrollLength: 40,
              minThumbLength: 40,
              thumbColor: AppThemes.textColorSecondary,
              controller: walletController.exchangeCurrscrollController,
              radius: const Radius.circular(6),
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: walletController.exchangeCurrscrollController,
                  padding: EdgeInsets.zero,
                  itemCount: flag == 1
                      ? walletController.searchAvailableAmountList.length
                      : walletController.searchAllAmountList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _coinItem(
                        index,
                        flag,
                        flag == 1
                            ? walletController.searchAvailableAmountList
                            : walletController.searchAllAmountList);
                  }),
            ),
          );
        })
      ],
    );
  }

  // Widget _selectCoinsTypeNoBar(BuildContext context, int flag) {
  //   return Obx(() {
  //     return Container(
  //       constraints: const BoxConstraints(maxHeight: 200),
  //       child: RawScrollbar(
  //         thumbVisibility: false,
  //         padding: EdgeInsets.zero,
  //         minOverscrollLength: 40,
  //         minThumbLength: 40,
  //         thumbColor: AppThemes.textColorSecondary,
  //         controller: walletController.exchangeCurrscrollController,
  //         radius: const Radius.circular(6),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               ...flag == 1
  //                   ? walletController.searchAvailableAmountList.asMap().entries.map((entry) {
  //                 int index = entry.key;
  //                 return _coinItem(index, flag, walletController.searchAvailableAmountList);
  //               }).toList()
  //                   : walletController.searchAllAmountList.asMap().entries.map((entry) {
  //                 int index = entry.key;
  //                 return _coinItem(index, flag, walletController.searchAllAmountList);
  //               }).toList(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   });
  // }

  Widget _coinItem(int index, int flag, List<CurrencyBean> list) {
    bool isSelected;
    if (flag == 1) {
      isSelected = walletController.isPaySelectedItem(list[index]);
    } else {
      isSelected = walletController.isExchangeSelectedItem(list[index]);
    }
    return CupertinoButton(
      minSize: 32.0,
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      onPressed: () {
        Get.back();
        if (isSelected) {
          return;
        }
        CurrencyBean currencyBean = list[index];
        if (flag == 1) {
          walletController.payCurrFun(currencyBean);
        } else {
          walletController.exchangeCurrFun(currencyBean);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            CustomNetWorkImage(
              imageUrl: list[index].coinIc ?? "",
              width: 18,
              height: 18,
            ),
            const SizedBox(
              width: 8,
            ),
            CustomText(
              list[index].name ?? " ",
              style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? ThemeService().colorScheme.primary : AppThemes.black,
                  // color:AppThemes.black,
                  fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            CustomText(
              list[index].amount ?? " ",
              style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? ThemeService().colorScheme.primary : AppThemes.black,
                  // color:AppThemes.black,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  _buildSearchView(int flag) {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_10),
      child: CupertinoSearchTextField(
        prefixInsets: const EdgeInsets.only(left: 10),
        prefixIcon: const CustomAssetIcon(
          name: "assets/images/top_search_ic.png",
          size: 16,
        ),
        itemColor: AppThemes.secondaryIconColor,
        placeholder: S.current.wallet_search,
        // placeholderStyle: const TextStyle(color: AppThemes.white566771, fontWeight: FontWeight.w500),
        placeholderStyle:
            const TextStyle(color: AppThemes.tertiaryColor, fontWeight: FontWeight.w500),
        decoration: BoxDecoration(
          color: AppThemes.widgetColorWhite,
          border: Border.all(color: AppThemes.whiteD5DCEB, width: 2.0),
          // Add a border
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // 阴影颜色
              spreadRadius: 0, // 扩散半径
              blurRadius: 2, // 模糊半径
              offset: const Offset(0, 1), // 阴影偏移量
            ),
          ],
        ),
        style: const TextStyle(
            fontSize: 14, color: AppThemes.tertiaryColor, fontWeight: FontWeight.w500),
        onChanged: (String value) {
          log('The text has changed to: $value');
          if (flag == 1) {
            walletController.updateSearchAvailableAmountList(value);
          } else {
            walletController.updateSearchAllAmountList(value);
          }
          // flag==1?walletController.availableAmountList.length:walletController.allAmountList.length
          // walletController.globalController.updateSearchList(value);
        },
        onSubmitted: (String value) {
          log('Submitted text: $value');
        },
      ),
    );
  }
}
