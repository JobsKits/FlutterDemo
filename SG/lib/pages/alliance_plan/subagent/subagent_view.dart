import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/status/custom_load_state_view.dart';
import 'package:get/get.dart';

import '../../../utils/formatter/custom_length_formatter.dart';
import '../../../utils/formatter/custom_number_formatter.dart';
import '../../../utils/keyboard_util.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_button_controller.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_error_tips_text.dart.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/input/custom_main_text_field.dart';
import 'subagent_logic.dart';

///联盟计划-新增子代理tab
///agent01/02/12345678
class SubAgentPage extends StatefulWidget {
  BuildContext context;

  SubAgentPage({super.key, required this.context});

  @override
  State<SubAgentPage> createState() => _SubAgentPageState();
}

class _SubAgentPageState extends State<SubAgentPage> with AutomaticKeepAliveClientMixin {
  final logic = Get.put<SubAgentLogic>(SubAgentLogic());
  final state = Get.find<SubAgentLogic>().state;
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final _monthGlobalKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    log("============SubAgentPage...dispose...销毁");
    // KeyboardUtils.hideKeyboard(widget.context);
    Get.delete<SubAgentLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          SliverToBoxAdapter(child: _buildInputTextView()),
          const SliverPadding(padding: EdgeInsets.only(bottom: 150)),
        ],
      ),
    );
  }

  Widget _buildInputTextView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Obx(() {
        return CustomLoadStateLayout(
          configState: logic.pageState.value,
          configSuccess: Container(
            // padding: EdgeInsets.all(AppValues.defaultMargin),
            child: Column(
              children: [
                //CustomMainTextField   CustomTextField
                // SizedBox(height: AppValues.defaultMargin),
                CustomAsterisksTipsText(text: S.current.random_text_547),
                SizedBox(height: AppValues.margin_4),
                Obx(() {
                  return CustomMainTextField(
                    // hintText: S.current.please_input_password_tips,
                    text: logic.emailObs.value,
                    // contentPadding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin * 2.5),
                    maxLines: 1,
                    errorText: logic.emailErrorTipObs.value,
                    showError: logic.emailErrorObs.value,
                    inputCallBack: (value) {
                      logic.onInputCompleteEmail(value);
                    },
                    inputCompletionCallBack: (value, isSubmitted) {
                      logic.onInputCompleteEmail(value);
                    },
                  );
                }),
                SizedBox(height: AppValues.margin_12),
                CustomAsterisksTipsText(text: S.current.random_text_548),
                SizedBox(height: AppValues.margin_4),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Obx(() {
                      return CustomMainTextField(
                        // hintText: S.current.random_text_183,
                        text: logic.accountObs.value,
                        isPwd: false,
                        // contentPadding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin * 2.5),
                        maxLines: 1,
                        errorText: logic.accountErrorTipObs.value,
                        showError: logic.accErrorObs.value,
                        inputCallBack: (value) {
                          log('inputCallBack...value:$value');
                          logic.onInputCompleteAcc(value);
                        },
                        inputCompletionCallBack: (value, isSubmitted) {
                          log('inputCompletionCallBack...value:$value...isSubmitted:$isSubmitted');
                          logic.onInputCompleteAcc(value);
                        },
                      );
                    }),
                    // Positioned(
                    //   top: 12,
                    //   child: Container(
                    //       alignment: Alignment.centerLeft,
                    //       margin: EdgeInsets.only(left: AppValues.defaultMargin),
                    //       child: Image.asset(
                    //           height: 16, "assets/images/alliance/ic_alliance_account.webp")),
                    // ),
                  ],
                ),
                SizedBox(height: AppValues.margin_12),
                CustomAsterisksTipsText(text: S.current.random_text_549),
                SizedBox(height: AppValues.margin_4),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Obx(() {
                      return CustomMainTextField(
                        // hintText: S.current.please_input_password_tips,
                        text: logic.pwdObs.value,
                        isPwd: true,
                        // contentPadding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin * 2.5),
                        maxLines: 1,
                        errorText: logic.pwdErrorTipObs.value,
                        showError: logic.pwdErrorObs.value,
                        inputCallBack: (value) {
                          logic.onInputCompletePwd(value);
                        },
                        inputCompletionCallBack: (value, isSubmitted) {},
                      );
                    }),
                    // Positioned(
                    //   top: 12,
                    //   child: Container(
                    //       margin: EdgeInsets.only(left: AppValues.defaultMargin),
                    //       child: Image.asset(
                    //           height: 16, "assets/images/alliance/ic_alliance_pwd.webp")),
                    // ),
                  ],
                ),

                SizedBox(height: AppValues.margin_12),
                _buildBirthday(context),
                SizedBox(height: AppValues.largeMargin),
                Obx(() {
                  return CustomBigMainButton(
                    // title: S.current.random_text_185,
                    title: S.current.top_register,
                    isEnable: logic.isCanSubmitObs.value,
                    colorStyle: CustomButtonColorStyle.tertiary,
                    onTap: (CustomButtonController btnController) {
                      logic.onClickSubmit();
                    },
                  );
                })
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBirthday(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomAsterisksTipsText(
              text: S.current.text_field_birthday_tips,
              // textColorStyle: CustomTextColorStyle.normal,
            ),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
        const SizedBox(
          height: AppValues.smallPadding,
        ),
        Obx(() {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      return CustomMainTextField(
                        text: logic.dayText.value,
                        showError: logic.isDayError.value,
                        hintText: 'DD',
                        inputCallBack: (value) => logic.onInputDay(value),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CustomLengthTextInputFormatter(2),
                          CustomNumberFormatter()
                        ],
                      );
                    }),
                  ),
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _startAnimation(_rotatingArrowKey);

                      ///有弹出键盘，先关闭键盘
                      if (logic.isKeyboardVisible) {
                        KeyboardUtils.hideKeyboard(context);
                        await Future.delayed(const Duration(milliseconds: 300));
                      }
                      Future.delayed(const Duration(milliseconds: 100), () {
                        DialogUtils.showCustomBubbleDialog(
                            Get.context!,
                            _buildAreaList(Get.context!),
                            // bubbleWith,
                            100,
                            widgetKey: _monthGlobalKey,
                            backgroundColor: ThemeService().colorScheme.tertiary,
                            globalKey: _rotatingArrowKey
                            // globalKey: widget._rotatingArrowKey,
                            );
                      });
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 102,
                          child: Obx(() {
                            return CustomMainTextField(
                              showError: logic.isMonthError.value,
                              text: logic.monthText.value,
                              key: _monthGlobalKey,
                              hintText: S.current.monthly_text,
                              enabled: false,
                            );
                          }),
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
                    ),
                  ),
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  Expanded(
                    child: Obx(() {
                      return CustomMainTextField(
                        text: logic.yearText.value,
                        hintText: 'YYYY',
                        showError: logic.isYearError.value,
                        inputCallBack: (value) => logic.onInputYear(value),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CustomLengthTextInputFormatter(4),
                          CustomNumberFormatter()
                        ],
                      );
                    }),
                  ),
                ],
              ),
              Visibility(
                visible: logic.isDayError.value ||
                    logic.isMonthError.value ||
                    logic.isYearError.value ||
                    logic.birthdayErrorText.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppValues.smallPadding),
                  child: CustomErrorTipsText(
                    text: logic.birthdayErrorText.value,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildAreaList(BuildContext context) {
    return Scrollbar(
      controller: logic.scrollController, // Provide a ScrollController
      radius: const Radius.circular(10),
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: logic.scrollController, // Use the same ScrollController
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 180,
          ),
          child: Obx(() {
            return ListView.builder(
                padding: const EdgeInsets.only(bottom: 6),
                itemCount: logic.monthListObs.length,
                itemBuilder: (context, index) {
                  final month = logic.monthListObs[index];
                  return GestureDetector(
                    onTap: () {
                      RouteUtil.popView();
                      for (var item in logic.monthListObs) {
                        item['isSelected'] = false;
                      }
                      month['isSelected'] = month['isSelected'] == true ? false : true;
                      logic.monthListObs.refresh();
                      logic.onInputMonth(month['num'] as String);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 6, left: 6, right: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: month['isSelected'] == true
                            ? ThemeService().colorScheme.secondary
                            : null,
                      ),
                      alignment: Alignment.center,
                      height: 34,
                      width: double.infinity,
                      child: CustomText(month['month'] as String),
                    ),
                  );
                });
          }),
        ),
      ),
    );
  }

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }
}
