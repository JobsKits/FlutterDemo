import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/account/widgets/account_policy_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_error_tips_text.dart.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/refresh/widget/cupertino/easy_refresh_path.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../utils/common_util.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_asset_icon.dart';
import 'forget_password_controller.dart';

class ForgetPasswordWidget extends StatefulWidget {
  const ForgetPasswordWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ForgetPasswordWidget();
}

class _ForgetPasswordWidget extends State<ForgetPasswordWidget> {
  bool _showTokenInvalid = false;
  late ForgetPasswordController controller =
  Get.find<ForgetPasswordController>();
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final _monthGlobalKey = GlobalKey();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<ForgetPasswordController>();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.lazyPut(() => ForgetPasswordController());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () => RouteUtil.popView(),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                  const EdgeInsets.all(AppValues.defaultMargin),
                  margin:
                  const EdgeInsets.symmetric(
                      horizontal: AppValues.defaultMargin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppValues.smallRadius),
                    color: ThemeService().theme.scaffoldBackgroundColor,
                  ),
                  child: _buildIndex(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildIndex() {
    return Column(
      children: [
        SizedBox(
            // height: 45,
            width: double.infinity,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CustomIcon(asset: 'assets/images/login/ic_setting.png'),
                const SizedBox(
                  width: AppValues.smallPadding,
                ),
                CustomText(
                  S.current.forget_password_text,
                  style: ThemeService().textTheme.titleMedium,
                ),
                const Expanded(child: SizedBox.shrink()),
                GestureDetector(
                    onTap: () {
                      RouteUtil.popView();
                    },
                    child: const CustomIcon(
                        asset: 'assets/images/normal/ic_normal_close.png')),
              ],
            )),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Obx(() {
                  return CustomMainTextField(
                    // title: S.current.email_address_text,
                    hintText: S.current.random_text_1012,
                    hintColor: AppThemes.hintTextColor,
                    required: true,
                    text: controller.accountText,
                    contentPadding: EdgeInsets.only(left: controller.isPhone.value ? 80 : AppValues.defaultPadding),
                    showError: controller.isAccountError.value,
                    errorText: controller.accountErrorText.value,
                    inputCallBack: (value) => controller.onInputAccount(value),
                    inputCompletionCallBack: (value, isSubmitted) => controller.onAccountCheck(context, value),
                  );
                }),
                Obx(() => Visibility(
                  visible: controller.isPhone.value,
                  child: areacodeWidget()
                ))
              ],
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            Obx(() {
              return CustomBigMainButton(
                title: S.current.recover_password_text,
                colorStyle: CustomButtonColorStyle.tertiary,
                isEnable: controller.isButtonEnable.value,
                onTap: (btnCtr) => controller.onSubmit(context, btnCtr),
              );
            }),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: S.current.random_text_1013,
                  style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: S.current.contact_customer_service,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  recognizer: TapGestureRecognizer()
                  ..onTap = () => controller.onTapService()
                )
              ])
            )
          ],
        ),
      ],
    );
  }

  Widget areacodeWidget() {
    return GestureDetector(
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
          child: Obx(() => Container(
            width: 68,
            height: 40,
            key: _monthGlobalKey,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(width: 2,color: controller.isAccountError.value ? ThemeService().colorScheme.error : ThemeService().colorScheme.tertiary))
            ),
            child: Row(
              children: [
                const SizedBox(width: 12,),
                Obx(() =>  CustomText(controller.areaCode.value,style: const TextStyle(fontWeight: FontWeight.w600),)),
                RotatingArrow(key: _rotatingArrowKey,color: Colors.white,),
              ],
            ),
          ))
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
                maxHeight: 300,
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

  _buildTokenInvalid() {
    return Column(
      children: [
        SizedBox(
            height: 45,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CustomIcon(asset: 'assets/images/login/ic_setting.png'),
                const SizedBox(
                  width: AppValues.smallPadding,
                ),
                CustomText(
                  S.current.recover_password_title_text,
                  style: ThemeService().textTheme.titleMedium,
                ),
                const Expanded(child: SizedBox.shrink()),
                GestureDetector(
                    onTap: () {
                      RouteUtil.popView();
                    },
                    child: const CustomIcon(
                        asset: 'assets/images/normal/ic_normal_close.png')),
              ],
            )),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 42,
              child: Center(
                child: CustomText(
                  S.current.token_invalid_text,
                  style: ThemeService().textTheme.titleMedium,
                  textColorStyle: CustomTextColorStyle.error,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            CustomText(
              S.current.resend_email_text,
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            CustomBigMainButton(
              title: S.current.logout_text,
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const AccountPolicyWidget(),
            const SizedBox(
              height: AppValues.largePadding,
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> showCustomForgetPasswordWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: 'CustomForgetPasswordWidget',
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return const ForgetPasswordWidget();
      });
}
