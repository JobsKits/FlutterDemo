import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/setup/contact/logic.dart';
import 'package:flutter_bet/pages/setup/widgets/setup_social_account_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/formatter/custom_number_formatter.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../utils/common_util.dart';
import '../../../widget/custom_asset_icon.dart';

class SetupContactPage extends StatelessWidget {
  SetupContactPage({super.key});

  final _areaCodeGlobalKey = GlobalKey();

  // TODO: implement controller
  final SetupContactController self = Get.put(SetupContactController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement buildBody
    self.context = context;
    return KeyboardVisibilityProvider(
      child: Container(
        margin: const EdgeInsets.only(bottom: 38),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ThemeService().colorScheme.surface,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppValues.padding_10, vertical: AppValues.defaultMargin),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEmail(context),
                const SizedBox(
                  height: 28,
                ),
                _buildPhone(context),
                const SizedBox(
                  height: 28,
                ),
                _buildSocialAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return Container(
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
          color: ThemeService().theme.scaffoldBackgroundColor,
          border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      CustomText(
                        S.current.random_text_1079,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Obx(() => Visibility(
                          visible: self.isBindEmail.value,
                          child: Container(
                            margin: const EdgeInsets.only(left: AppValues.defaultPadding),
                            padding: const EdgeInsets.symmetric(horizontal: AppValues.halfPadding),
                            height: 18,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(46),
                                color: ThemeService().colorScheme.primaryContainer),
                            child: CustomText(
                              S.current.random_text_725,
                              style: const TextStyle(
                                  color: AppThemes.oddBackColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          )))
                    ],
                  ),
                  const SizedBox(
                    height: AppValues.defaultPadding,
                  ),
                  Container(
                    height: 1,
                    color: ThemeService().colorScheme.tertiary,
                  ),
                  const SizedBox(
                    height: AppValues.defaultPadding,
                  ),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   padding: const EdgeInsets.only(bottom: AppValues.smallPadding),
                  //   child: CustomText(S.current.random_text_1079,style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
                  // ),
                  Stack(
                    children: [
                      Obx(() {
                        return CustomMainTextField(
                          title: S.current.random_text_1079,
                          text: self.emailText.value,
                          hintText: S.current.random_text_1079,
                          hintColor: AppThemes.hintTextColor,
                          // style: TextStyle(color: controller.canEditorEmail.value && controller.noSendEmail.value ? AppThemes.textColorWhite : AppThemes.onSurfaceColor),
                          errorText: self.emailErrorText.value,
                          required: true,
                          // isChecked: !controller.canEditorEmail.value,
                          enabled: self.canEditorEmail.value && !self.isBindEmail.value && !(self.isShowTime.value && self.isClick.value),
                          showError: self.isEmailTextError.value,
                          inputCallBack: (value) => self.changeEmail(value),
                          inputCompletionCallBack: (value, isSubmitted) =>
                              self.onInputEmail(value),
                        );
                      }),
                      Obx(() => Visibility(
                        visible: !self.canEditorEmail.value,
                        child: Container(
                          margin: const EdgeInsets.only(top: 22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppValues.smallRadius),
                            color: ThemeService().colorScheme.tertiary
                          ),
                          height: 40,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
                            child: CustomText(self.emailText.value,style: const TextStyle(fontSize: 16),),
                          )
                        )
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: AppValues.defaultMargin,
                  ),
                ],
              ),
            ),
            Obx(() => Visibility(
                visible: true.obs.value,//!controller.isBindEmail.value,
                child: Column(
                  children: [
                    Container(
                      height: 2,
                      color: ThemeService().colorScheme.tertiary,
                    ),
                    const SizedBox(
                      height: AppValues.defaultMargin,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Obx(() {
                        //   return Visibility(
                        //     visible: controller.isGmail.value && !controller.canSaveEmail.value,
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         controller.goToGoogleEmail();
                        //       },
                        //       child: Container(
                        //         height: 40,
                        //         decoration: BoxDecoration(
                        //             color: ThemeService().colorScheme.primary,
                        //             borderRadius: BorderRadius.circular(4)),
                        //         padding: const EdgeInsets.only(left: 8, right: 8),
                        //         child: Row(
                        //           children: [
                        //             CustomText(S.current.wallet_email_open,
                        //                 style: ThemeService()
                        //                     .theme
                        //                     .textTheme
                        //                     .bodyMedium
                        //                     ?.copyWith(fontWeight: FontWeight.w600)),
                        //             const SizedBox(
                        //               width: 8,
                        //             ),
                        //             const CustomAssetIcon(
                        //               name: "assets/images/personal_center_icon/gmail_ic.webp",
                        //               size: 14,
                        //               color: AppThemes.widgetColorWhite,
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // }),
                        const Spacer(),
                        Obx(() => Visibility(
                            visible: self.isShowTime.value && self.isClick.value,
                            child: Padding(
                              padding: const EdgeInsets.only(right: AppValues.halfPadding),
                              child: CustomText('${self.seconds.value}s',textColorStyle: CustomTextColorStyle.normal),
                            ))),
                        Obx(() {
                          print("SSSSSS = ${self.emailText.value}");
                          if(self.canResendEmail.value && self.emailText.isNotEmpty){
                            print("AAA_1");
                          }else{
                            print("AAA_2");
                            print(self.canResendEmail.value);
                            print(self.emailText.isNotEmpty);
                          }

                          return GestureDetector(
                            onTap: () {
                              self.isClick.value = !self.isClick.value;
                              self.onEmailCheck(context, null);
                            },
                            child: CustomText(
                              S.current.resend_email_text,/// 重新发送
                              style:TextStyle(color: self.canResendEmail.value && self.emailText.isNotEmpty ? AppThemes.textColorWhite : const Color(0xff697384)),
                              // textColorStyle: controller.canResendEmail.value
                              //     ? CustomTextColorStyle.white
                              //     : CustomTextColorStyle.normal,
                            ),
                          );
                          //   SizedBox(
                          //   width:106,
                          //   child: CustomBigMainButton(
                          //     title: S.current.resend_email_text,
                          //     isEnable: controller.canResendEmail.value,
                          //     onTap: (btn) => controller.onEmailCheck(context,btn),
                          //   ),
                          // );
                        }),
                        const SizedBox(
                          width: AppValues.defaultPadding,
                        ),
                        Obx(() {
                          return CustomBigMainButton(
                            title: S.current.button_save_text,/// 保存
                            isEnable: self.canSaveEmail.value && self.emailText.isNotEmpty && !self.sended.value,
                            colorStyle: CustomButtonColorStyle.tertiary,
                            maxWidth: 100,
                            onTap: (btnCtr) => self.onUpdateEmail(context, btnCtr),
                          );
                        }),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                )))
          ],
        ));
  }

  Widget _buildPhone(BuildContext context) {
    return Container(
        // padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
          color: ThemeService().theme.scaffoldBackgroundColor,
          border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 28,
                  ),
                  Row(
                    children: [
                      CustomText(
                        S.current.phone_number_text,
                        style: ThemeService()
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Obx(() => Visibility(
                          visible: self.isBindPhone.value,
                          child: Container(
                            margin: const EdgeInsets.only(left: AppValues.defaultPadding),
                            padding: const EdgeInsets.symmetric(horizontal: AppValues.halfPadding),
                            height: 18,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(46),
                                color: ThemeService().colorScheme.primaryContainer),
                            child: CustomText(
                              S.current.random_text_725,
                              style: const TextStyle(
                                  color: AppThemes.oddBackColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          )))
                    ],
                  ),
                  const SizedBox(
                    height: AppValues.defaultPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          S.current.change_area_code_tips_text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textColorStyle: CustomTextColorStyle.normal,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppValues.defaultPadding,
                  ),
                  Container(
                    height: 1,
                    color: ThemeService().colorScheme.tertiary,
                  ),
                  const SizedBox(
                    height: AppValues.defaultPadding,
                  ),
                  // Container(
                  //   height: 1,
                  //   color: AppThemes.onSurfaceColor,
                  // ),
                  // const SizedBox(
                  //   height: AppValues.defaultPadding,
                  // ),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   child: CustomText(S.current.random_text_1080,style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
                  // ),
                  // const SizedBox(
                  //   height: AppValues.smallPadding,
                  // ),
                  GestureDetector(
                    onTap: () async {
                      // if (controller.isBindPhone.value) {
                      //   return;
                      // }
                      self.showArray.value = self.areaCodeArray;
                      self.setupLogic.showArray.value = self.areaCodeArray;
                      if (self.areaCodeArray?.isEmpty == true) return;

                      ///有弹出键盘，先关闭键盘
                      if (self.isKeyboardVisible) {
                        KeyboardUtils.hideKeyboard(context);
                        await Future.delayed(const Duration(milliseconds: 300));
                      }
                      self.setupLogic.jumpTo();
                      // DialogUtils.showCustomBubbleDialog(
                      //   Get.context!,
                      //   // _buildAreaList(Get.context!, controller.areaCodeArray ?? []),
                      //   _buildAreaList(Get.context!),
                      //   // bubbleWith,
                      //   120,
                      //   widgetKey: _areaCodeGlobalKey,
                      //   // backgroundColor: ThemeService().colorScheme.tertiary,
                      //   // globalKey: widget._rotatingArrowKey,
                      // );
                      // Future.delayed(const Duration(milliseconds: 20), () {
                      //   controller.setupLogic.scrollController
                      //       .jumpTo((controller.areaCodeSelectIndex - 3) * 38);
                      // });
                    },
                    child: Obx(() {
                      return CustomMainTextField(
                        key: _areaCodeGlobalKey,
                        title: S.current.change_area_code_title_text,//'区域',
                        required: true,
                        // isChecked: controller.isBindPhone.value,
                        text: self.areaCodeText.value,// '+65'.obs.value,
                        enabled: false,
                        showArrow: true,
                        maxLength: 200,
                        contentPadding: const EdgeInsets.only(
                          left: AppValues.defaultPadding,
                          right: AppValues.defaultPadding * 2 + AppValues.smallPadding,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: AppValues.defaultMargin,
                  ),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   child: CustomText(S.current.phone_number_text,style: TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
                  // ),
                  // const SizedBox(
                  //   height: AppValues.smallPadding,
                  // ),
                  Obx(() {
                    return CustomMainTextField(
                      title: S.current.phone_number_text,
                      text: self.phoneText.value,
                      maxLength: 11,
                      showError: self.isPhoneError.value,
                      errorText: self.phoneErrorText.value,
                      hintText: S.current.phone_number_text,
                      hintColor: AppThemes.hintTextColor,
                      keyboardType: TextInputType.number,
                      // inputFormatters: [CustomNumberFormatter()],
                      required: true,
                      // enabled: !controller.isBindPhone.value,
                      inputCallBack: (value) => self.onInputPhone(value),
                    );
                  }),
                  const SizedBox(
                    height: AppValues.defaultMargin,
                  ),
                ],
              ),
            ),
            Obx(() => Visibility(
                visible: true.obs.value,
                child: Column(
                  children: [
                    Container(
                      height: 2,
                      color: ThemeService().colorScheme.tertiary,
                    ),
                    const SizedBox(
                      height: AppValues.defaultMargin,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() {
                          return CustomBigMainButton(
                            title: self.userPhone.isNotEmpty && self.needPhone.value
                                ? S.current.kyc_level_verify_title_text
                                : S.current.button_save_text,
                            colorStyle: CustomButtonColorStyle.tertiary,
                            maxWidth: 100,
                            isEnable: self.canSavePhone.value,
                            onTap: (btnCtr) => self.onUpdatePhone(context, btnCtr),
                          );
                        }),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppValues.defaultMargin,
                    ),
                  ],
                )))
          ],
        ));
  }

  Widget _buildSocialAccount(BuildContext context) {
    return Container(
        // padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
          color: ThemeService().theme.scaffoldBackgroundColor,
          border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
        ),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 28,
                    ),
                    Row(
                      children: [
                        CustomText(
                          S.current.social_account_text,
                          style: ThemeService()
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppValues.defaultPadding,
                    ),
                    Container(
                      height: 1,
                      color: ThemeService().colorScheme.tertiary,
                    ),
                    const SizedBox(
                      height: AppValues.sportPadding_20,
                    ),
                    SetupSocialAccountWidget(
                      iconAsset: 'assets/images/setup/ic_facebook.png',
                      name: 'Facebook',
                      text: self.facebookText.value,
                      inputCompletionCallBack: (value) {
                        self.facebookText.value = value;
                        // controller.syncUserInfo(context, {"facebook": value});
                      },
                      inputCallBack: (value) {
                        self.onInputFacebook(value);
                      },
                    ),
                    const SizedBox(
                      height: AppValues.sportHeight_28,
                    ),
                    SetupSocialAccountWidget(
                      iconAsset: 'assets/images/setup/ic_whatsup.png',
                      name: 'Whatsapp',
                      text: self.whatsappText.value,
                      inputCompletionCallBack: (value) {
                        self.whatsappText.value = value;
                        // controller.syncUserInfo(context, {"whatsapp": value});
                      },
                      inputCallBack: (value) {
                        self.onInputWhatsapp(value);
                      },
                    ),
                    const SizedBox(
                      height: AppValues.sportHeight_28,
                    ),
                    SetupSocialAccountWidget(
                      iconAsset: 'assets/images/setup/ic_telegram.png',
                      name: 'Telegram',
                      text: self.telegramText.value,
                      inputCompletionCallBack: (value) {
                        self.telegramText.value = value;
                        // controller.syncUserInfo(context, {"telegram": value});
                      },
                      inputCallBack: (value) {
                        self.onInputTelegram(value);
                      },
                    ),
                    const SizedBox(
                      height: AppValues.sportHeight_28,
                    ),
                    SetupSocialAccountWidget(
                      iconAsset: 'assets/images/setup/ic_line.png',
                      name: 'Line',
                      text: self.lineText.value,
                      inputCompletionCallBack: (value) {
                        self.lineText.value = value;
                        // controller.syncUserInfo(context, {"line": value});
                      },
                      inputCallBack: (value) {
                        self.onInputLine(value);
                      },
                    ),
                    const SizedBox(
                      height: AppValues.sportHeight_28,
                    ),
                    SetupSocialAccountWidget(
                      iconAsset: 'assets/images/setup/ic_x.png',
                      name: 'X',
                      text: self.xText.value,
                      inputCompletionCallBack: (value) {
                        self.xText.value = value;
                        // controller.syncUserInfo(context, {"twitter": value});
                      },
                      inputCallBack: (value) {
                        self.onInputX(value);
                      },
                    ),
                    const SizedBox(
                      height: AppValues.sportHeight_28,
                    ),
                    SetupSocialAccountWidget(
                      iconAsset: 'assets/images/setup/ic_zalo.png',
                      name: 'Zalo',
                      text: self.zaloText.value,
                      inputCompletionCallBack: (value) {
                        self.zaloText.value = value;
                        // controller.syncUserInfo(context, {"zalo": value});
                      },
                      inputCallBack: (value) {
                        self.onInputZalo(value);
                      },
                    ),
                    const SizedBox(
                      height: AppValues.sportHeight_28,
                    ),
                    SetupSocialAccountWidget(
                      iconAsset: 'assets/images/setup/ic_viber.png',
                      name: 'Viber',
                      text: self.viberText.value,
                      inputCompletionCallBack: (value) {
                        self.viberText.value = value;
                        // controller.syncUserInfo(context, {"viber": value});
                      },
                      inputCallBack: (value) {
                        self.onInputViber(value);
                      },
                    ),
                    const SizedBox(
                      height: AppValues.sportHeight_28,
                    ),
                    SetupSocialAccountWidget(
                      iconAsset: 'assets/images/setup/ic_vx.png',
                      name: 'Wechat',
                      text: self.wechatText.value,
                      inputCompletionCallBack: (value) {
                        self.wechatText.value = value;
                        // controller.syncUserInfo(context, {"wechat": value});
                      },
                      inputCallBack: (value) {
                        self.onInputWechat(value);
                      },
                    ),
                    const SizedBox(
                      height: AppValues.sportHeight_28,
                    ),
                    // SetupSocialAccountWidget(
                    //   iconAsset: 'assets/images/setup/ic_qq.png',
                    //   name: 'QQ',
                    //   text: controller.userModel.value.ext?.qq ?? '',
                    //   inputCompletionCallBack: (value) {
                    //     controller.syncUserInfo(context, {"qq": value});
                    //   },
                    // ),
                  ],
                ),
              ),
              Container(
                height: 2,
                color: ThemeService().colorScheme.tertiary,
              ),
              const SizedBox(
                height: AppValues.defaultMargin,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomBigMainButton(
                    fontWeight: FontWeight.w600,
                    title: S.current.button_save_text,
                    colorStyle: CustomButtonColorStyle.tertiary,
                    isEnable: self.isEnableSaveButton.value,
                    maxWidth: 100,
                    onTap: (btnCtr) => {self.saveSocialInfo(context)},
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: AppValues.defaultMargin,
              ),
            ],
          );
        }));
  }

  // Widget _buildAreaList(BuildContext context, List<MobileAreaCodeModel> list) {
  //   return SingleChildScrollView(
  //     child: Container(
  //       constraints: const BoxConstraints(
  //         maxHeight: 200,
  //       ),
  //       child: ListView.builder(
  //           padding: const EdgeInsets.only(
  //               top: AppValues.defaultPadding,
  //               bottom: AppValues.defaultPadding),
  //           itemCount: list.length,
  //           itemBuilder: (context, index) {
  //             final model = list[index];
  //             return GestureDetector(
  //               onTap: () => controller.onSelectAreaCode(index),
  //               child:
  //               AreaListCard(code: '${model.attr}', name: model.name ?? ''),
  //             );
  //           }),
  //       ),
  //     );
  //   }
  // }

  /// 移至 SetupPage
  // Widget _buildAreaList(BuildContext context) {
  //   return Scrollbar(
  //     radius: const Radius.circular(10),
  //     child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             const SizedBox(height: AppValues.margin_10),
  //             CustomText(
  //               S.current.random_text_1164,
  //               style: TextStyle(color: Color(0xffa7a7a7)),
  //             ),
  //             Container(
  //                 constraints: const BoxConstraints(
  //                   maxHeight: 200,
  //                 ),
  //                 child: Obx(() =>
  //                     ListView.builder(
  //                         controller: controller.scrollController,
  //                         padding: const EdgeInsets.only(bottom: 6),
  //                         itemCount: controller.showArray.length,
  //                         itemBuilder: (context, index) {
  //                           final code = controller.showArray[index];
  //                           return GestureDetector(
  //                             onTap: () => controller.onSelectAreaCode(index),
  //                             child: Container(
  //                                 margin: const EdgeInsets.only(top: 6, left: 6, right: 6),
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(4),
  //                                   // color: month['isSelected'] == true
  //                                   //     ? ThemeService().colorScheme.secondary
  //                                   //     : null,
  //                                 ),
  //                                 alignment: Alignment.centerLeft,
  //                                 height: 34,
  //                                 width: double.infinity,
  //                                 child: Row(
  //                                   children: [
  //                                     Obx(() =>
  //                                         CustomIcon(
  //                                           asset: 'assets/images/login/gou.png',
  //                                           color: controller.areaCodeText.value.contains(
  //                                               code.attr!)
  //                                               ? AppThemes.black
  //                                               : Colors.transparent,
  //                                           size: 16,
  //                                         )),
  //                                     CustomText(
  //                                       code.attr!,
  //                                       style: const TextStyle(color: AppThemes.black),
  //                                     ),
  //                                   ],
  //                                 )),
  //                           );
  //                         }))),
  //           ],
  //         )),
  //   );
  // }

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
            self.showArray.value = self.areaCodeArray;
          } else if (CommonUtil.isNumber(value)) {
            self.showArray.value =
                self.areaCodeArray.where((element) => element.attr!.contains(value)).toList();
          } else {
            self.showArray.value =
                self.areaCodeArray.where((element) => element.name!.contains(value)).toList();
          }
        },
        onSubmitted: (String value) {
          // log('Submitted text: $value');
        },
      ),
    );
  }
}

class AreaListCard extends StatelessWidget {
  final String code;
  final String name;

  const AreaListCard({super.key, required this.code, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      height: 34,
      width: double.infinity,
      color: ThemeService().colorScheme.tertiary,
      child: Row(
        children: [
          CustomText(code),
          const SizedBox(
            width: AppValues.smallPadding,
          ),
          Expanded(child: CustomText(name)),
        ],
      ),
    );
  }
}
