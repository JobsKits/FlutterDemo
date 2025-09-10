import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:flutter_bet/utils/num_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_error_tips_text.dart.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

class DepositAmountView extends GetView<WalletCtrl> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getGiftViewWidth();
    });
    return _rootView(context);
  }

  final GlobalKey rootViewGlobalKey = GlobalKey();

  final GlobalKey _globalKeyTextField = GlobalKey();
  final GlobalKey _globalKeyGiftView = GlobalKey();
  final GlobalKey<RotatingArrowState> _rotatingAmountArrowKey = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  Widget _rootView(BuildContext context) {
    return _amountWidget(context);
  }

  Widget payWidget(BuildContext context) {
    return CustomBigMainButton(
      colorStyle: CustomButtonColorStyle.tertiary,
      onTap: (btnCtr) {
        if (!controller.fiatCurrTabSel.value) {
          controller.cryptoConfirmPayment(context, btnCtr);
        } else {
          controller.confirmPayment(context, btnCtr);
        }
      },
      title: S.current.vault_confirm_payment,
      fontWeight: FontWeight.w600,
    ).marginOnly(top: 16);
  }

  Widget _amountWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        CustomAsterisksTipsText(
          text: S.current.random_text_107,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        controller.amtType.value == 1 ? _amountChooseWidgetV2(context) : _amountInputWidget(),
        Obx(() {
          return errorView();
        }),
        const SizedBox(
          height: 16,
        ),
        _amountSelect(),
        payWidget(context),
      ],
    );
  }

  Widget errorView() {
    return controller.errView(controller.amtShowErr.value, controller.amtErrorStr.value);
  }

  Widget _amountInputWidget() {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Obx(() {
                return CustomMainTextField(
                  decoration: controller.getBoxDecoration(showErr: controller.amtShowErr.value),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  // 只允许输入数字和小数点
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly,
                  // ],
                  // errorText: controller.amtErrorStr.value,
                  showError: controller.amtShowErr.value,
                  hintColor: AppThemes.walletHintColor,
                  hintText: "${controller.amtMix.value}-${controller.amtMax.value}",
                  isRemoveHint: true,
                  text: controller.amtSel.value,
                  inputCallBack: (str) {
                    for (int i = 0; i < controller.amtList.length; i++) {
                      controller.amtList[i]['isSelect'] = false;
                      //https://jira.vgtech.org/browse/STAK-11483 请勿删除
                      // if (controller.amtList[i]['amount'] == str) {
                      //   controller.amtList[i]['isSelect'] = true;
                      // }
                    }
                    controller.amtList.refresh();
                    controller.amtSel.value = str;
                    controller.getAmountErrorHintStr();
                  },
                );
              }),
            ],
          ),
        ),
        giftView()
      ],
    );
  }

  Widget giftView() {
    return Container(
      padding: const EdgeInsets.only(left: 13, right: 13, top: 10, bottom: 10),
      alignment: Alignment.center,
      height: AppValues.defaultTextHeight,
      decoration: BoxDecoration(color: ThemeService().colorScheme.tertiary),
      child: giftAmtWidget(),
    );
  }

  Widget _amountChooseWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () {
              _startAnimation(_rotatingAmountArrowKey);
              DialogUtils.showCustomBubbleDialog(
                  context,
                  Container(
                    constraints: BoxConstraints(maxHeight: _getWalletHeight(3)),
                    child: Scrollbar(
                      controller: controller.scrollAmountChooseFiatController,
                      radius: const Radius.circular(10),
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: controller.scrollAmountChooseFiatController,
                        child: Column(
                          children: controller.amtFixedList
                              .map((bean) => InkWell(
                                    onTap: () {
                                      Get.back();
                                      for (var item in controller.amtFixedList) {
                                        item['isSelect'] = false;
                                      }
                                      bean['isSelect'] = bean['isSelect'] ? false : true;

                                      for (var item in controller.amtList) {
                                        item['isSelect'] = false;
                                      }
                                      for (int i = 0; i < controller.amtList.length; i++) {
                                        if (controller.amtList[i]['amount'] == bean['amount']) {
                                          controller.amtList[i]['isSelect'] = true;
                                        } else {
                                          controller.amtList[i]['isSelect'] = false;
                                        }
                                      }
                                      controller.amtList.refresh();
                                      controller.amtSel.value = bean['amount'];
                                      controller.getAmountErrorHintStr();
                                      controller.hideKeyboard(context);
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                                        color: bean['isSelect'] == true
                                            ? AppThemes.textColorSecondary
                                            : null,
                                        width: double.infinity,
                                        child: CustomText(
                                          bean['amount'],
                                          textAlign: TextAlign.center,
                                          textColorStyle: CustomTextColorStyle.dark,
                                        )),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  112,
                  bubbleLeftOffset: _getInputWidth(_globalKeyTextField) + 64,
                  widgetKey: _globalKeyTextField,
                  backgroundColor: AppThemes.widgetColorWhite,
                  globalKey: _rotatingAmountArrowKey);
            },
            child: Container(
              key: _globalKeyTextField,
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.only(top: 9, bottom: 9),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: controller.amtShowErr.value == true
                          ? AppThemes.reverseStateColor
                          : ThemeService().colorScheme.tertiary,
                      width: 2),
                  color: ThemeService().colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: Row(
                children: [
                  const SizedBox(
                    width: AppValues.width_12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return CustomText(
                              controller.amtSel.value.isEmpty
                                  ? S.current.random_text_654
                                  : controller.amtSel.value,
                              textColorStyle: controller.amtSel.value.isEmpty
                                  ? CustomTextColorStyle.normal
                                  : CustomTextColorStyle.panda,
                              style: ThemeService()
                                  .theme
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500));
                        })
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 13,
                      right: 13,
                    ),
                    alignment: Alignment.center,
                    height: AppValues.defaultTextHeight,
                    decoration: BoxDecoration(color: ThemeService().colorScheme.tertiary),
                    child: giftAmtWidget(),
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
        Obx(() {
          return Visibility(
            visible: controller.amtShowErr.value == true,
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              child: CustomErrorTipsText(
                text: controller.amtErrorStr.value,
              ),
            ),
          );
        })
      ],
    );
  }

  Widget _amountChooseWidgetV2(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              GestureDetector(onTap: () {
                _startAnimation(_rotatingAmountArrowKey);
                DialogUtils.showCustomBubbleDialog(
                    context,
                    Container(
                      constraints: BoxConstraints(maxHeight: 207),
                      child: Scrollbar(
                        controller: controller.scrollAmountChooseFiatController,
                        radius: const Radius.circular(10),
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: controller.scrollAmountChooseFiatController,
                          child: Column(
                            children: controller.amtFixedList
                                .map((bean) => InkWell(
                                      onTap: () {
                                        Get.back();
                                        for (var item in controller.amtFixedList) {
                                          item['isSelect'] = false;
                                        }
                                        bean['isSelect'] = bean['isSelect'] ? false : true;

                                        for (var item in controller.amtList) {
                                          item['isSelect'] = false;
                                        }
                                        // for (int i = 0; i < controller.amtList.length; i++) {
                                        //   if (controller.amtList[i]['amount'] == bean['amount']) {
                                        //     controller.amtList[i]['isSelect'] = true;
                                        //   } else {
                                        //     controller.amtList[i]['isSelect'] = false;
                                        //   }
                                        // }
                                        controller.amtList.refresh();
                                        controller.amtSel.value = bean['amount'];
                                        controller.getAmountErrorHintStr();
                                        controller.hideKeyboard(context);
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                                          color: bean['isSelect'] == true
                                              ? AppThemes.textColorSecondary
                                              : null,
                                          width: double.infinity,
                                          child: CustomText(
                                            bean['amount'],
                                            textAlign: TextAlign.center,
                                            textColorStyle: CustomTextColorStyle.dark,
                                          )),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    207,
                    // bubbleLeftOffset: _getInputWidth(_globalKeyTextField) + 64,
                    widgetKey: _globalKeyTextField,
                    backgroundColor: AppThemes.widgetColorWhite,
                    globalKey: _rotatingAmountArrowKey);
              }, child: Obx(() {
                return CustomMainTextField(
                  decoration: controller.getBoxDecoration(showErr: controller.amtShowErr.value),
                  key: _globalKeyTextField,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  // errorText: controller.amtErrorStr.value,
                  showError: controller.amtShowErr.value,
                  textColor: controller.amtSel.value.isEmpty
                      ? ThemeService().colorScheme.onSurface
                      : (ThemeService.instance.isDarkMode)
                          ? AppThemes.textColorWhite
                          : AppThemes.textColorDark,
                  enabled: false,
                  hintText: S.current.random_text_1311,
                  text: controller.amtSel.value,
                );
              })),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: RotatingArrow(
                  key: _rotatingAmountArrowKey,
                ),
              ),
            ],
          ),
        ),
        Container(
          key: _globalKeyGiftView,
          // right: 1,
          // top: 1,
          // bottom: 1,
          child: giftView(),
        ),
      ],
    );
  }

  Widget _amountSelect() {
    return Obx(() {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 16, crossAxisSpacing: 12, childAspectRatio: 2.3, crossAxisCount: 3),
        itemCount: controller.amtList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: _itemAmount(index),
            onTap: () {
              for (var item in controller.amtList) {
                item['isSelect'] = false;
              }
              controller.amtSel.value = controller.amtList[index]['amount'];
              controller.amtList[index]['isSelect'] =
                  controller.amtList[index]['isSelect'] ? false : true;
              controller.amtList.refresh();

              for (var item in controller.amtFixedList) {
                item['isSelect'] = false;
              }
              // for (int i = 0; i < controller.amtFixedList.length; i++) {
              //   if (controller.amtFixedList[i]['amount'] == controller.amtList[index]['amount']) {
              //     controller.amtFixedList[i]['isSelect'] = true;
              //   } else {
              //     controller.amtFixedList[i]['isSelect'] = false;
              //   }
              // }

              controller.getAmountErrorHintStr();
              controller.hideKeyboard(context);
            },
          );
        },
      );
    });
  }

  Widget _itemAmount(int index) {
    return Container(
      decoration: controller.amtList[index]['isSelect']
          ? BoxDecoration(
              border: Border.all(color: AppThemes.secondaryColor, width: 2),
              color: AppThemes.walletAmountBg,
              borderRadius: BorderRadius.circular(4))
          : BoxDecoration(
              border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
              borderRadius: const BorderRadius.all(
                Radius.circular(4),
              )),
      child: amountStyle(
          "${controller.amtList[index]?['amount'] ?? ""}", controller.amtList[index]['isSelect']),
    );
  }

  Widget amountStyle(String amount, bool isSelect) {
    return Stack(
      children: [
        Positioned(
          bottom: -1,
          right: -1,
          child: Visibility(
            visible: isSelect,
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: ThemeService().colorScheme.primary,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(3), bottomLeft: Radius.circular(4)),
              ),
              child: const CustomAssetIcon(
                name: 'assets/images/properly_ic.png',
                size: 10,
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  amount,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppThemes.widgetColorWhite),
                  strutStyle: const StrutStyle(forceStrutHeight: true, height: 1, leading: 0.5),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget giftAmtWidget() {
    return Obx(() {
      return CustomText(
          textColorStyle: CustomTextColorStyle.normal,
          textAlign: TextAlign.center,
          "${S.current.random_text_1132}"
          "${controller.giftAmt.value > 0 ? NumUtil.keepDecimals(controller.giftAmt.value, digits: 8, minDigits: 2, doZero: false, intercept: true) : "0.00"}"
          // "${controller.giftAmt.value > 0 ?.toCoinAmountFormat(controller.getMergerSelId(controller.fiatCurrTabSel.value), "${controller.giftAmt.value}") : "0.00"}"
          // controller.giftAmt.value >= 1
          //     ? "${S.current.random_text_1132}${controller.giftAmt.value}"
          //     : "${S.current.random_text_1132}${controller.giftAmt.value}"
          );
    });
  }

  double _getWalletHeight(double ratio) {
    double? totalHeight;
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = rootViewGlobalKey.currentContext!.findRenderObject() as RenderBox;
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
    return size.width / 2;
  }

  void _getGiftViewWidth() {
    var findRenderObject = _globalKeyGiftView.currentContext?.findRenderObject();
    if (findRenderObject != null) {
      final RenderBox renderBox =
          _globalKeyGiftView.currentContext?.findRenderObject() as RenderBox;
      controller.giftViewWidth.value = renderBox.size.width;
    }
  }
}
