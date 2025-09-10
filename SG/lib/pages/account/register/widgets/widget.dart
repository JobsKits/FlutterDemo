import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/utils/formatter/custom_number_formatter.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/common_util.dart';
import '../../../../utils/keyboard_util.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_rotating_arrow.dart';
import '../../../../widget/dialog/dialog_utils.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../logic.dart';

class SwitchWidget extends GetView<RegisterLogic> {
  const SwitchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => controller.showPhone(false),
            child: Obx(() => Container(
              padding: const EdgeInsets.fromLTRB(AppValues.defaultMargin, 0, AppValues.defaultMargin, AppValues.defaultPadding),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 2,color: controller.isPhone.value ? Colors.transparent : ThemeService().colorScheme.primary))
              ),
              child: CustomText(S.current.random_text_1038,style: TextStyle(fontSize: 16,color: controller.isPhone.value ? AppThemes.textColorSecondary : AppThemes.textColorWhite,fontWeight: FontWeight.w600),),
            )),
          ),
          GestureDetector(
            onTap: () => controller.showPhone(true),
            child: Obx(() => Container(
              padding: const EdgeInsets.fromLTRB(AppValues.defaultMargin, 0, AppValues.defaultMargin, AppValues.defaultPadding),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 2,color: controller.isPhone.value ? ThemeService().colorScheme.primary : Colors.transparent))
              ),
              child: CustomText(S.current.phone_number_text,style: TextStyle(fontSize: 16,color: controller.isPhone.value ? AppThemes.textColorWhite : AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
            )),
          )
        ],
      ),
    );
  }
}

class PhoneWidget extends GetView<RegisterLogic> {
  PhoneWidget({Key? key}) : super(key: key);

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final _monthGlobalKey = GlobalKey();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() => CustomMainTextField(
          text: controller.phoneText,
          keyboardType: TextInputType.number,
          inputFormatters: [CustomNumberFormatter()],
          required: true,
          // title: S.current.login_text_field_account_tips,
          hintText: S.current.phone_number_text,
          hintColor: AppThemes.hintTextColor,
          contentPadding: const EdgeInsets.only(left: 80),
          showError: controller.isPhoneError.value,
          errorText: controller.phoneErrorText.value,
          inputCallBack: (value) => controller.onInputPhone(value,false),
          inputCompletionCallBack: (String value, bool isSubmitted) => controller.onPhoneCheck(value,true),
        )),
        GestureDetector(
          onTap: () async {
            controller.showArray.value = controller.areaCodeArray;
            _startAnimation(_rotatingArrowKey);

            ///有弹出键盘，先关闭键盘
            if (controller.isKeyboardVisible) {
              KeyboardUtils.hideKeyboard(Get.context!);
              await Future.delayed(const Duration(milliseconds: 300));
            }
            Future.delayed(const Duration(milliseconds: 100), () {
              DialogUtils.showCustomBubbleDialog(
                  Get.context!,
                  _buildAreaList(Get.context!),
                  // bubbleWith,
                  120,
                  // arrowBasisOffset: -70,
                  bubbleLeftOffset: AppValues.defaultMargin,
                  widgetKey: _monthGlobalKey,
                  // backgroundColor: ThemeService().colorScheme.tertiary,
                  globalKey: _rotatingArrowKey
                // globalKey: widget._rotatingArrowKey,
              );
              Future.delayed(const Duration(milliseconds: 20), () {
                controller.scrollController.jumpTo((controller.areaCodeSelectIndex - 3)* 38);
              });
            });
          },
          child: Obx(() =>  Container(
            width: 68,
            height: 40,
            key: _monthGlobalKey,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(width: 2,color: controller.isPhoneError.value ? ThemeService().colorScheme.error : ThemeService().colorScheme.tertiary))
            ),
            child: Row(
              children: [
                const SizedBox(width: 12,),
                Obx(() =>  CustomText(controller.areaCode.value,style: const TextStyle(fontWeight: FontWeight.w600),)),
                RotatingArrow(key: _rotatingArrowKey,color: Colors.white,),
              ],
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildAreaList(BuildContext context) {
    return Scrollbar(
      radius: const Radius.circular(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppValues.margin_10),
            CustomText(S.current.random_text_1164,style: TextStyle(color: Color(0xffa7a7a7)),),
            Container(
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              child: Obx(() => ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.only(bottom: 6),
                itemCount: controller.showArray.length,
                itemBuilder: (context, index) {
                  final code = controller.showArray[index];
                  return GestureDetector(
                    onTap: () {
                      RouteUtil.popView();
                      // for (var item in controller.list) {
                      //   item['isSelected'] = false;
                      // }
                      // month['isSelected'] = month['isSelected'] == true ? false : true;
                      // controller.list.refresh();
                      // controller.onInputMonth(month['num'] as String);
                      controller.areaCode.value = code.attr!;
                      controller.areaCodeSelectIndex = index;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 6, left: 6, right: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        // color: month['isSelected'] == true
                        //     ? ThemeService().colorScheme.secondary
                        //     : null,
                      ),
                      alignment: Alignment.centerLeft,
                      height: 34,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Obx(() => CustomIcon(
                            asset: 'assets/images/login/gou.png',
                            color: controller.areaCode.value == code.attr! ? AppThemes.black :Colors.transparent,
                            size: 16,
                          )),
                          CustomText(code.attr!,style: const TextStyle(color: AppThemes.black),),
                        ],
                      )
                    ),
                  );
                }
              ))
            ),
          ],
        )
      ),
    );
  }

  _buildSearchView() {
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
          // log('The text has changed to: $value');
          // globalController.updateSearchList(value);
          if (value.isEmpty) {
            controller.showArray.value = controller.areaCodeArray;
          } else if (CommonUtil.isNumber(value)) {
            controller.showArray.value = controller.areaCodeArray.where((element) => element.attr!.contains(value)).toList();
          } else {
            controller.showArray.value = controller.areaCodeArray.where((element) => element.name!.contains(value)).toList();
          }
          
        },
        onSubmitted: (String value) {
          // log('Submitted text: $value');
        },
      ),
    );
  }
}