import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/num_util.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar_h5.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_click_animation_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../../pages/activity/all_promotions/all_promotions_view.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../controllers/red_packet_controller.dart';

class RedPacketView extends GetView<RedPacketController> {
  const RedPacketView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: const CustomBackIconButton(
      //     style: CustomBackIconButtonStyle.normal,
      //   ),
      //   title: Text(S.current.random_text_945,
      //       style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      //   centerTitle: true,
      // ),
      body: _rootView(context),
    );
  }

  Widget _rootView(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      primary: false,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: AppValues.barTopHeightMargin)),
        SliverToBoxAdapter(child: CustomAppBarH5(
          onTap: () {
            RouteUtil.popView();
            AllPromotionsPage.openPage();
          },
        )),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () {},
            child: Container(
              height: 153,
              margin: const EdgeInsets.only(top: AppValues.defaultPadding),
              padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
              child: Obx(() {
                return CustomNetWorkImage(
                  imageUrl: "${AppUrlsValues.envConfig.asset_url}/${controller.imageUrl.value}",
                );
              }),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.defaultPadding, vertical: AppValues.defaultPadding),
              child: CustomText(
                controller.time.value,
                style: const TextStyle(color: AppThemes.onTertiaryColor, fontSize: 12),
              ),
            );
          }),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
            padding: const EdgeInsets.symmetric(vertical: AppValues.padding_18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: const Color(0xff0f212e),
            ),
            child: redPacketState(context),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        //每场红包
        // SliverToBoxAdapter(
        //   child: LangUtil().isViVn()||LangUtil().isTh()?
        //   Column(
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Obx(() {
        //             return CustomAsterisksTipsText(
        //               text: S.current.random_text_999+
        //                   "${controller.redPacketDetail['limit']?['bonus']}",
        //               asterisksTipsOrientationStyle: CustomAsterisksTipsOrientationStyle.left,
        //             );
        //           }),
        //           const SizedBox(width: 2,),
        //           const CustomAssetIcon(
        //             name: "assets/images/coin_icon/ic_eth.png",
        //             size: 14,
        //           ),
        //         ],
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Obx(() {
        //             return CustomText(
        //               S.current.random_text_1000+
        //                   "${controller.redPacketDetail['limit']?['daily']}",
        //               textColorStyle: CustomTextColorStyle.normal,
        //             );
        //           }),
        //           const SizedBox(width: 2,),
        //           const CustomAssetIcon(
        //             name: "assets/images/coin_icon/ic_eth.png",
        //             size: 14,
        //           ),
        //         ],
        //       )
        //     ],
        //   )
        //       : Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Obx(() {
        //         return CustomAsterisksTipsText(
        //           text: S.current.random_text_999+
        //               "${controller.redPacketDetail['limit']?['bonus']}",
        //           asterisksTipsOrientationStyle: CustomAsterisksTipsOrientationStyle.left,
        //         );
        //       }),
        //       const SizedBox(width: 2,),
        //       const CustomAssetIcon(
        //         name: "assets/images/coin_icon/ic_eth.png",
        //         size: 14,
        //       ),
        //       Obx(() {
        //         return CustomText(
        //           S.current.random_text_1000+
        //               "${controller.redPacketDetail['limit']?['daily']}",
        //           textColorStyle: CustomTextColorStyle.normal,
        //         );
        //       }),
        //       const SizedBox(width: 2,),
        //       const CustomAssetIcon(
        //         name: "assets/images/coin_icon/ic_eth.png",
        //         size: 14,
        //       ),
        //     ],
        //   ),
        // ),
        // const SliverToBoxAdapter(
        //   child: SizedBox(
        //     height: 20,
        //   ),
        // ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
            child: _eventDescriptionView(context),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Obx(() {
            return Container(
                margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
                decoration: controller.term.value.isNotEmpty
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0), color: const Color(0xff0f212e))
                    : null,
                child: controller.ruleType.value == 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            S.current.register_protocol_title,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ).marginOnly(left: 14, top: 18, bottom: 18),
                          // CustomText(controller.term.value),
                          descView().marginOnly(
                            left: 14,
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding:
                                const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
                            child: Obx(() {
                              return Visibility(
                                visible: controller.redPacketDetail['button']?['button'] == 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.goToPageView();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, left: 20, right: 20),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      color: AppThemes.chatRoomButtonColor,
                                    ),
                                    child: CustomText(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppThemes.loginSendColor),
                                      controller.bottomText.value,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Html(
                            data: controller.term.value,
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding:
                                const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
                            child: Obx(() {
                              return Visibility(
                                visible: controller.redPacketDetail['button']?['button'] == 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.goToPageView();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15, left: 20, right: 20),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      color: AppThemes.chatRoomButtonColor,
                                    ),
                                    child: CustomText(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppThemes.loginSendColor),
                                      controller.bottomText.value,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ));
          }),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: AppValues.barBottomHeightMargin,
          ),
        ),
      ],
    );
  }

  Widget descView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: controller.parts.map<Widget>((part) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomText('•',
                style: TextStyle(
                    fontSize: 16, color: AppThemes.onTertiaryColor, fontWeight: FontWeight.w500)),
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: buildTextWithImage(part),
              ),
            ),
            // ...buildTextWithImage(part)
          ],
        );
      }).toList(),
    );
  }

  List<Widget> buildTextWithImage(String text) {
    List<Widget> spans = [];
    List<String> parts = text.split('USDT\$\$currency\$\$');
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(CustomText(
          "${parts[i].trim()}\n",
          textAlign: TextAlign.start,
          style: const TextStyle(color: AppThemes.onTertiaryColor),
        ).marginOnly(left: 0));
      }
      if (i < parts.length - 1) {
        spans.add(Baseline(
          baseline: 2,
          baselineType: TextBaseline.ideographic,
          child: CustomNetWorkImage(
            imageUrl:
                "${controller.globalController.coinIcDomain}706${controller.globalController.coinIcExtensionName}",
            width: 18,
            height: 18,
          ).marginOnly(left: 6, right: 6),
        ));
      }
    }
    return spans;
  }

  Widget redPacketState(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Visibility(
            visible: !controller.showOverlay.value,
            child: _redPacketView(context),
          ),
          // bonusState : 1 本场红包已被领完
          // bonusState : 2 本场红包已参与
          // bonusState : 3 立即领取
          if (controller.showOverlay.value)
            if (controller.bonusState.value == 1)
              _noBonusView(
                  subtitle: S.current.random_text_1002, // 本场红包已被领完
                  time:
                      " ${controller.periodBonusTime.value} ${controller.periodEndBonusTime.value}")
            else if (controller.bonusState.value == 2)
              _noBonusView(
                  subtitle: S.current.random_text_1003, // 本场红包已参与
                  time:
                      " ${controller.periodBonusTime.value} ${controller.periodEndBonusTime.value}")
            else if (controller.bonusState.value == 3)
              _bonusView(context), // 这个页面可以领取红包
        ],
      );
    });
  }

  // 这个页面可以拆红包，第一个页面
  Widget _redPacketView(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: InkWell(
              onTap: () {
                if (!controller.globalController.isLoginState()) {
                  controller.globalController.doGoToRegister(Get.overlayContext, duration: 100);
                  return;
                }
                if (!controller.openState.value) {
                  CustomSnackBar.show(S.current.random_text_1004, context,
                      title: S.current.snack_bar_normal_tips,
                      preIcon: CustomSnackBarIcons.activityIc);
                  return;
                }
                controller.showOverlay.value = true; //!controller.showOverlay.value;
                // if (controller.bonusState.value == 3) {
                //   controller.getReceive();
                // }
              },
              child: Container(
                  height: 335,
                  width: 320,
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/red_packet/red_packet_bg.png",
                      fit: BoxFit.cover))),
        ),
        Positioned(
            left: 10,
            right: 10,
            top: 54,
            child: Center(
                child: CustomText(
              S.current.random_text_955,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xffFFF385)),
            ))),
        Positioned(
            left: 0,
            right: 0,
            bottom: 112,
            child: InkWell(
                onTap: () {
                  bool test() {
                    if (controller.tongue.value.contains("")) {
                      return true;
                    }

                    if (controller.tongue.isEmpty) {
                      return true;
                    }

                    if (controller.tongue.value.contains("pt_BR")) {
                      CustomSnackBar.show(S.current.random_text_1298, context,
                          title: S.current.snack_bar_normal_tips,
                          preIcon: CustomSnackBarIcons.activityIc);
                      return false;
                    }

                    if (controller.tongue.value.contains("vi_VN")) {
                      CustomSnackBar.show(S.current.random_text_1299, context,
                          title: S.current.snack_bar_normal_tips,
                          preIcon: CustomSnackBarIcons.activityIc);
                      return false;
                    }

                    if (controller.tongue.value.contains("th_TH")) {
                      CustomSnackBar.show(S.current.random_text_1300, context,
                          title: S.current.snack_bar_normal_tips,
                          preIcon: CustomSnackBarIcons.activityIc);
                      return false;
                    }

                    if (controller.tongue.value.contains("en_US")) {
                      CustomSnackBar.show(S.current.random_text_1301, context,
                          title: S.current.snack_bar_normal_tips,
                          preIcon: CustomSnackBarIcons.activityIc);
                      return false;
                    }

                    if (controller.tongue.value.contains("hi_IN")) {
                      CustomSnackBar.show(S.current.random_text_1302, context,
                          title: S.current.snack_bar_normal_tips,
                          preIcon: CustomSnackBarIcons.activityIc);
                      return false;
                    }

                    if (controller.tongue.value.contains("zh_CN")) {
                      CustomSnackBar.show(S.current.random_text_1303, context,
                          title: S.current.snack_bar_normal_tips,
                          preIcon: CustomSnackBarIcons.activityIc);
                      return false;
                    }
                    return true;
                  }

                  // 检查登陆
                  if (!controller.globalController.isLoginState()) {
                    controller.globalController.doGoToRegister(Get.overlayContext, duration: 100);
                    return;
                  }
                  // 检查活动开启
                  if (!controller.openState.value) {
                    CustomSnackBar.show(S.current.random_text_1004, context,
                        title: S.current.snack_bar_normal_tips,
                        preIcon: CustomSnackBarIcons.activityIc);
                    return;
                  }
                  // bonusState ：1 本场红包已被领完
                  // bonusState ：2 本场红包已参与
                  // bonusState ：3 立即领取
                  switch (controller.bonusState.value) {
                    case 1: // 本场红包已被领完
                      if (controller.tongue.value.isEmpty) {
                        controller.showOverlay.value = !controller.showOverlay.value;
                      }
                      if (!Get.locale.toString().contains(controller.tongue.value)) {
                        if (test()) {
                          controller.showOverlay.value = !controller.showOverlay.value;
                        }
                      }
                      break;
                    case 2: // 本场红包已参与
                      // 温馨提示：本场红包已参与...
                      CustomSnackBar.show(S.current.random_text_1003, context,
                          title: S.current.snack_bar_normal_tips,
                          preIcon: CustomSnackBarIcons.activityIc);
                      controller.showOverlay.value = !controller.showOverlay.value;
                      break;
                    default: // 立即领取
                      if (!Get.locale.toString().contains(controller.tongue.value)) {
                        if (test()) {
                          controller.showOverlay.value = !controller.showOverlay.value;
                        }
                      }
                      // 第一次领，就是为空
                      if (controller.tongue.value.isEmpty) {
                        controller.showOverlay.value = !controller.showOverlay.value;
                      }
                  }
                  // if (controller.bonusState.value == 3) {
                  //   controller.getReceive();
                  // }
                },
                child: Obx(() => controller.openState.value
                    ? const CustomClickAnimationIcon()
                    : const CustomAssetIcon(
                        name: "assets/images/activity/ic_red_click.webp",
                        width: 19,
                        height: 26,
                      )))),
        Positioned(
            left: 0,
            right: 0,
            bottom: 19,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomAssetIcon(
                  name: "assets/images/red_packet/clock.png",
                  size: 22,
                ),
                const SizedBox(
                  width: 2,
                ),
                Obx(() {
                  return CustomText(
                    " ${controller.periodTime.value} ${controller.periodEndTime.value}",
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  );
                })
              ],
            ))),
      ],
    );
  }

  Widget _eventDescriptionView(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: const Color(0xff0f212e)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(left: 14, right: 12, top: 16),
              child: Obx(() {
                return LangUtil().isViVn()
                    ? CustomText(
                        "Mỗi Ngày ${controller.custom.length} lần",
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                      )
                    : LangUtil().isPtBr()
                        ? CustomText(
                            "${controller.custom.length} vezes por dia",
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                          )
                        : LangUtil().isEnIn()
                            ? CustomText(
                                "${controller.custom.length} times a day",
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                              )
                            : CustomText(
                                "${S.current.random_text_1006}${controller.custom.length}${S.current.random_text_120}",
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                              );
              })),
          // Obx(() {
          //   return LangUtil().isViVn() || LangUtil().isTh() || LangUtil().isPtBr()
          //       ? Container(
          //           height: 20,
          //           child: Column(
          //             children: [
          //               CustomAsterisksTipsText(
          //                 textStyle: const TextStyle(
          //                     fontSize: 13,
          //                     fontWeight: FontWeight.w400,
          //                     color: AppThemes.reverseStateColor),
          //                 asterisksTipsOrientationStyle: CustomAsterisksTipsOrientationStyle.left,
          //                 text: controller.eventTimeDes.value,
          //               ),
          //               Flexible(
          //                 fit: FlexFit.tight,
          //                 child: Flexible(
          //                   child: FittedBox(
          //                     child: CustomAsterisksTipsText(
          //                       textStyle: const TextStyle(
          //                         fontSize: 13,
          //                         fontWeight: FontWeight.w400,
          //                         color: AppThemes.reverseStateColor,
          //                       ),
          //                       text: controller.weekly.value,
          //                       asterisksTipsOrientationStyle:
          //                           CustomAsterisksTipsOrientationStyle.left,
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ).marginOnly(left: 12),
          //         )
          //       : Row(
          //           children: [
          //             const SizedBox(
          //               width: 12,
          //             ),
          //             CustomAsterisksTipsText(
          //               textStyle: const TextStyle(
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.w400,
          //                   color: AppThemes.reverseStateColor),
          //               asterisksTipsOrientationStyle: CustomAsterisksTipsOrientationStyle.left,
          //               text: controller.eventTimeDes.value,
          //             ),
          //             Flexible(
          //               child: FittedBox(
          //                 child: CustomAsterisksTipsText(
          //                   textStyle: const TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.w400,
          //                       color: AppThemes.reverseStateColor),
          //                   text: controller.weekly.value,
          //                   asterisksTipsOrientationStyle: CustomAsterisksTipsOrientationStyle.left,
          //                 ),
          //               ),
          //             )
          //           ],
          //         );
          // }),

          Obx(() {
            // controller.weekly.value = "每周二、周三、周五、周九、周十、周六和周八";
            // controller.weekly.value = "每周二、周三、周五、周九、周六和周八";
            // controller.weekly.value = "每周二、周六和周八";
            // return checkTextWidth(
            //     '${controller.eventTimeDes.value} ${controller.weekly.value}',
            //     13,
            //     FontWeight.w400,
            //     MediaQuery.of(context).size.width - 30
            // ) ? Column_CustomAsterisksTipsText(context,controller.eventTimeDes.value, controller.weekly.value) :
            // Row_CustomAsterisksTipsText(context,controller.eventTimeDes.value, controller.weekly.value);
            return Column_CustomAsterisksTipsText(
                context, controller.eventTimeDes.value, controller.weekly.value);
          }),
          const SizedBox(
            height: 9,
          ),
          Obx(() {
            return _timeView(controller.custom);
          }),
          const SizedBox(
            height: 14,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Obx(() {
                return LangUtil().isViVn()
                    ? CustomText(
                        "Mỗi ngày ${controller.base.length} lần",
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                      )
                    : LangUtil().isPtBr()
                        ? CustomText(
                            "${controller.base.length} vezes por dia",
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                          )
                        : LangUtil().isEnIn()
                            ? CustomText(
                                "${controller.base.length} times a day",
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                              )
                            : CustomText(
                                "${S.current.random_text_1006}${controller.base.length}${S.current.random_text_120}",
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                              );
              })),
          Container(
            margin: const EdgeInsets.only(left: 14),
            child: CustomAsterisksTipsText(
              asterisksTipsOrientationStyle: CustomAsterisksTipsOrientationStyle.left,
              text: S.current.random_text_960,
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          Obx(() {
            return _timeView(controller.base);
          }),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  bool checkTextWidth(String text,
      double fontSize,
      FontWeight fontWeight,
      double screenWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    double textWidth = textPainter.size.width;

    print(text);
    print(screenWidth);
    print(textWidth);

    return textWidth > screenWidth;
  }

  Widget _timeView(List<dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: data.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10, crossAxisSpacing: 5, childAspectRatio: 3.0, crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return Obx(() {
            return _itemItemView(data[index]);
          });
        },
      ),
    );
  }

  Widget _itemItemView(var bean) {
    return Container(
      decoration: BoxDecoration(
          color: ThemeService().colorScheme.surfaceVariant,
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 5),
            child: CustomAssetIcon(
              color: AppThemes.onTertiaryColor,
              name: "assets/images/red_packet/clock.png",
              size: 12,
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Expanded(
            child: Center(
              child: CustomText(bean['time'].replaceAll("~", "-")),
            ),
          ),
        ],
      ),
    );
  }
  /// 没有红包的View = 没有红包 + 已经参与红包
  Widget _noBonusView({String title = "", required String subtitle, time}) {
    return Stack(
      children: [
        Container(
            alignment: Alignment.center,
            height: 335,
            child: Image.asset(
              "assets/images/red_packet/bonus_bg.png",
              fit: BoxFit.cover,
            )),
        Positioned(
            right: -250,
            left: 0,
            top: 20,
            child: InkWell(
              onTap: () {
                controller.showOverlay.value = !controller.showOverlay.value;
                // controller.showOverlay.value = false;
              },
              child: const CustomAssetIcon(
                name: 'assets/images/ic_closed.png',
                color: AppThemes.deepBlue,
                size: 14,
              ),
            )),
        Positioned(
            left: 0,
            right: 0,
            top: 54,
            child: Center(
                child: CustomText(
              title,
              style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xffbf1735)),
              textAlign: TextAlign.center,
            ))),
        Positioned(
            left: 0,
            right: 0,
            top: title.isEmpty ? 87 : 117,
            child: Center(
              child: CustomText(
                subtitle,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600, color: AppThemes.deepBlue),
                textAlign: TextAlign.center,
              ),
            )),
        Positioned(
            left: 0,
            right: 0,
            bottom: 74,
            child: Center(
                child: CustomText(
              S.current.random_text_961,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w500, color: AppThemes.widgetColorWhite),
            ))),
        Positioned(
            left: 0,
            right: 0,
            bottom: 19,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomAssetIcon(
                  name: "assets/images/red_packet/clock.png",
                  size: 22,
                ),
                const SizedBox(
                  width: 2,
                ),
                CustomText(
                  time,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                )
              ],
            ))),
      ],
    );
  }
  /// 这个页面可以领取红包
  Widget _bonusView(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
              height: 335,
              width: 320,
              alignment: Alignment.center,
              child: Image.asset("assets/images/red_packet/bonus_bg.png", fit: BoxFit.cover)),
        ),
        Positioned(
            right: -250,
            left: 0,
            top: 20,
            child: InkWell(
              onTap: () {
                controller.showOverlay.value = !controller.showOverlay.value;
                // controller.showOverlay.value = false;// 打开
                // controller.showOverlay.value = true;// 关闭
              },
              child: const CustomAssetIcon(
                name: 'assets/images/ic_closed.png',
                color: AppThemes.deepBlue,
                size: 14,
              ),
            )),
        Positioned(
            left: 0,
            right: 0,
            top: 62,
            child: Center(
                child: CustomText(
              S.current.random_text_962, // 幸运奖金
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFBF1735)),
            ))),
        Positioned(
            left: 0,
            right: 0,
            top: 117,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  log("neco 金额${controller.bonusAmount.value}");
                  return CustomText(
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppThemes.deepBlue
                    ),
                    // "${MoneyUtil.toCoinAmountFormat(controller.globalController.coinCur, controller.bonusAmount.value)}",
                    // "${NumUtil.getValue(digits: 8, double.tryParse(controller.bonusAmount.value))}",
                    // 红包活动红包金额除了BTC/ETH其他币种的红包金额都只需要保留两位小数进行展示即可
                    "${NumUtil.getValue(
                        digits: controller.currExchangeTypeSelected != null && controller.currExchangeTypeSelected.value.isCryptoCoin() ? 8: 2,
                        double.tryParse(controller.bonusAmount.value)
                    )}",
                  );
                }),
                CustomNetWorkImage(
                  placeholder: const CustomAssetIcon(
                    name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                  ),
                  errorWidget: const CustomAssetIcon(
                    name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                  ),
                  imageUrl:
                      "${controller.globalController.coinIcDomain}${controller.globalController.coinCur}${controller.globalController.coinIcExtensionName}",
                  width: 28,
                  height: 28,
                )
              ],
            ))),
        Positioned(
            left: 80,
            right: 80,
            bottom: 19,
            child: InkWell(
              // onTap: () => showCustomExchangeWidget(context: context, amount: double.parse(controller.bonusAmount.value),typeEvent: TypeEvent.redPacket),
              onTap: () => controller.redPacketExchange(context),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  gradient: const LinearGradient(
                    colors: [Color(0xffFFD687), Color(0xffFFF4D5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF570707).withOpacity(0.25),
                      blurRadius: 3, // 阴影模糊程度
                      offset: const Offset(0, 3), // 阴影偏移量
                    ),
                  ],
                ),
                child: CustomText(
                  // S.current.random_text_777,
                  S.current.random_text_904,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFBF1735)),
                ),
              ),
            )),
      ],
    );
  }

  Widget Row_CustomAsterisksTipsText(
      BuildContext context, String eventTimeDescription, String weeklyDescription) {
    return Row(
      children: [
        const SizedBox(
          width: 14,
        ),
        CustomAsterisksTipsText(
          textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w400, color: AppThemes.reverseStateColor),
          asterisksTipsOrientationStyle: CustomAsterisksTipsOrientationStyle.left,
          text: controller.eventTimeDes.value,
        ),
        const SizedBox(
          width: 10,
        ),
        CustomAsterisksTipsText(
            text: controller.weekly.value,
            textStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w400, color: AppThemes.reverseStateColor),
            asterisksTipsOrientationStyle: CustomAsterisksTipsOrientationStyle.left)
      ],
    );
  }

  Widget Column_CustomAsterisksTipsText(
      BuildContext context, String eventTimeDescription, String weeklyDescription) {
    return Column(
      children: [
        CustomAsterisksTipsText(
          textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w400, color: AppThemes.reverseStateColor),
          asterisksTipsOrientationStyle: CustomAsterisksTipsOrientationStyle.left,
          text: eventTimeDescription,
        ).marginOnly(left: 14),
        Row(
          children: [
            Baseline(
              baseline: 16,
              baselineType: TextBaseline.ideographic,
              child: CustomText(
                "*\t",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: ThemeService()
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500, color: AppThemes.reverseStateColor),
              ),
            ),
            Expanded(
              child: CustomText(
                weeklyDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppThemes.reverseStateColor,
                ),
                textColorStyle: CustomTextColorStyle.normal,
              ),
            ),
          ],
        ).marginOnly(left: 14),
      ],
    );
  }
}
