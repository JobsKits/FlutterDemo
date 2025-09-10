import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/account/login/login_widget.dart';
import 'package:flutter_bet/pages/account/register/register_widget.dart';
import 'package:flutter_bet/pages/account/widgets/account_policy_widget.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_check_box.dart';
import 'package:flutter_bet/widget/custom_error_tips_text.dart.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import '../../../constant/app_themes.dart';
import '../../../widget/input/custom_main_text_field.dart';
import '../register/logic.dart';
import 'logic.dart';

const kCustomRegisterProtocolWidget = 'kCustomRegisterProtocolWidget';

class RegisterProtocolWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterProtocolWidget();
}

class _RegisterProtocolWidget extends State<RegisterProtocolWidget> {
  late RegisterProtocolController controller = Get.find<RegisterProtocolController>();
  final registerLogic = Get.find<RegisterLogic>();

  int webViewScrollY = 0;
  InAppWebViewController? webViewController;
  double webViewHeight = 350;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<RegisterProtocolController>();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.lazyPut(() => RegisterProtocolController());
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
                  margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                  decoration: BoxDecoration(
                    color: ThemeService().theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(AppValues.smallRadius),
                  ),
                  child: Column(
                    children: [
                      _buildTop(),
                      _buildBody(context),
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: CustomBigMainButton(
                            title: S.current.start_game_text,
                            colorStyle: CustomButtonColorStyle.normal,
                            onTap: (buttonCtr) {
                              registerLogic.ifClickStartGame.value = true;
                              if (registerLogic.isCheckProtocol.value) {
                                registerLogic.onStartGameButton(context);
                              }
                            }

                            // registerLogic.onContinueButton(context, buttonCtr),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Column(
      children: [
        const SizedBox(
          height: AppValues.largePadding,
        ),
        SizedBox(
          height: 25,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.only(left: AppValues.defaultMargin),
                  alignment: Alignment.center,
                  child: CustomText(
                    S.current.create_account_title_text,
                    style:
                        ThemeService().textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    GestureDetector(
                      onTap: () {
                        RouteUtil.popView();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: AppValues.defaultMargin),
                        child: CustomIcon(
                          asset: 'assets/images/normal/ic_normal_close.png',
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Container(
        //     padding: const EdgeInsets.symmetric(vertical: AppValues.defaultPadding),
        //     child: CustomText(
        //       S.current.register_protocol_title,
        //       textColorStyle: CustomTextColorStyle.normal,
        //       style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        //     )),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        CustomText(
          S.current.random_text_21,
          textColorStyle: CustomTextColorStyle.normal,
          style: ThemeService().textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: Column(
        children: [
          SizedBox(
            height: webViewHeight,
            child: InAppWebView(
              initialFile: 'assets/html/register_protocol.html',
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(transparentBackground: true),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onScrollChanged: (InAppWebViewController controller, int x, int y) {
                _checkWebVIfBottom(y);
              },
              onLoadStop: (controllers, url) async {
                registerLogic.contentHeight.value = await controllers.getContentHeight() ?? 0;
              },
            ),
          ),
          const SizedBox(
            height: AppValues.largePadding,
          ),
          _buildProtocol(context),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     CustomText(
          //       S.current.already_have_an_account_text,
          //       textColorStyle: CustomTextColorStyle.normal,
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         CustomSafeDialog.dismiss(context: context, tag: kCustomRegisterProtocolWidget);
          //         RouteUtil.pushToView(Routes.loginPage, offLast: true);
          //       },
          //       child: CustomText(
          //         S.current.top_login,
          //       ),
          //     ),
          //   ],
          // ),
          // const AccountPolicyWidget(),
          // const SizedBox(
          //   height: AppValues.largePadding,
          // ),
        ],
      ),
    );
  }

  Widget _buildProtocol(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        GestureDetector(
          onTap: () {
            if(!registerLogic.isCanClickProtocol.value){
              registerLogic.  ifClickStartGame.value = true;
              return;
            }
            registerLogic.onCheckProtocol();
          },
          child: Row(
            children: [
              Obx(() {
                return CustomCheckBox(
                  value: registerLogic.isCheckProtocol.value,
                );
              }),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: CustomText(
                  S.current.agree_terms_text,
                  textColorStyle: CustomTextColorStyle.normal,
                  style: ThemeService().textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          return Visibility(
            visible: !registerLogic.isCheckProtocol.value   && registerLogic .ifClickStartGame.value,
            child: Padding(
                padding: EdgeInsets.only(top: AppValues.smallPadding),
                child: CustomErrorTipsText(text: S.current.random_text_825)),
          );
        }),
        // Obx(() {
        //   return Visibility(
        //     visible: registerLogic.isCheckCode.value,
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: AppValues.smallPadding),
        //       child: CustomMainTextField(
        //         inputCallBack: (value) {
        //           registerLogic.codeText = value;
        //         },
        //       ),
        //     ),
        //   );
        // }),
      ],
    );
  }

  _checkWebVIfBottom(int currentY) {
    double currentPosition = currentY.toDouble();
    double bottomPosition = registerLogic.contentHeight.value - webViewHeight;

    if (currentPosition >= bottomPosition) {
      registerLogic.isCanClickProtocol.value = true;
    } else {
      registerLogic.isCanClickProtocol.value = false;
    }
  }

  Widget _buildAgreeTerms() {
    return Row(
      children: [
        GestureDetector(onTap: () {
          controller.isCheckTerms.value = !controller.isCheckTerms.value;
          _checkWebViewIfBottom(webViewScrollY);
        }, child: Obx(() {
          return CustomCheckBox(
            value: controller.isCheckTerms.value,
          );
        })),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.isCheckTerms.value = !controller.isCheckTerms.value;
            },
            child: CustomText(
              S.current.agree_terms_text,
              textColorStyle: CustomTextColorStyle.normal,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _checkWebViewIfBottom(int y) async {
    webViewScrollY = y;
    final contentHeight = await webViewController?.getContentHeight() ?? 0;
    bool isStartGameEnable = false;
    if (controller.isCheckTerms.value == true) {
      if (y >= (contentHeight - 300)) {
        controller.isAgreeTermsError.value = false;
        isStartGameEnable = true;
      } else {
        controller.isAgreeTermsError.value = true;
      }
    } else {
      controller.isAgreeTermsError.value = false;
    }
    controller.isStartGameEnable.value = isStartGameEnable;
  }
}

Future<void> showCustomRegisterProtocolWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomRegisterProtocolWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) => RegisterProtocolWidget());
}
