import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/share/custom_share_widget_item.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../../redPacket/controllers/exchange_controller.dart';
import '../../redPacket/views/exchange_view.dart';
import '../controllers/rotary_controller.dart';
import 'invite_friends_view.dart';
import 'number_animation.dart';
import 'share_view.dart';

const kCustomWithDrawalViewWidget = 'WithDrawalView';

class WithDrawalView extends StatefulWidget {
  final double achievedPrize, totalPrize;

  final int state, withdrawType;

  const WithDrawalView(
      {super.key,
      required this.achievedPrize,
      required this.totalPrize,
      required this.state,
      required this.withdrawType});

  @override
  State<StatefulWidget> createState() {
    return _WithDrawalState();
  }
}

class _WithDrawalState extends State<WithDrawalView> with SingleTickerProviderStateMixin {
  late RotaryController controller = Get.find<RotaryController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: ThemeService().colorScheme.background,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                CustomText(S.current.random_text_1011,
                    style: const TextStyle(
                        color: AppThemes.widgetColorWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                const Spacer(),
                InkWell(
                  onTap: () => RouteUtil.popView(),
                  child: const CustomAssetIcon(
                    name: 'assets/images/bet_slip/ic_close_bet.webp',
                    size: 18,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            // topViewState(),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberAnimation(
                  startNumber: widget.achievedPrize / 10,
                  targetNumber: widget.achievedPrize,
                ),
                const SizedBox(
                  width: 6,
                ),
                // CustomText(
                //   "${controller.symbol.value}",
                //   style: TextStyle(color: AppThemes.widgetColorWhite, fontSize: 32),
                // ),
                CustomNetWorkImage(
                  width: 32,
                  height: 32,
                  imageUrl: "${controller.coinIcDomain}${controller.currencyId.value}${controller.coinIcExtensionName}",
                )
              ],
            ),
            // SizedBox(
            //   height: 16,
            // ),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 16,
            //     ),
            //     CustomText("提款账户"),
            //     Spacer(),
            //     CustomText("55115674356790"),
            //     SizedBox(
            //       width: 16,
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 5,
            // ),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 16,
            //     ),
            //     CustomText("支付方式"),
            //     Spacer(),
            //     CustomText("PIX"),
            //     SizedBox(
            //       width: 16,
            //     ),
            //   ],
            // ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 13, top: 14),
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ThemeService().colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(4)
              ),
              child: SizedBox(height: 115, child: stateView()),
            ),
            Container(
                height: 44,
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: CustomBigMainButton(
                    isEnable: widget.state == 5 ? false : true,
                    fontWeight: FontWeight.w600,
                    title: stateTitle(),
                    //差 申请state
                    colorStyle: CustomButtonColorStyle.tertiary,
                    onTap: (btn) {
                      RouteUtil.popView();
                      if (widget.state == 1) {
                        showCustomShareWidget(context: context);
                        // showCustomInviteFriendsWidget(
                        //     context: context,
                        //     achievedPrize: widget.achievedPrize,
                        //     totalPrize: widget.totalPrize);
                      } else {
                        showCustomExchangeWidget(
                            context: context,
                            amount: widget.achievedPrize,
                            typeEvent: TypeEvent.luckWheel);
                        // controller.apply();
                      }
                    })),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget topViewState() {
    return widget.achievedPrize >= widget.totalPrize
        ? CustomText(
            S.current.random_text_856,
            textColorStyle: CustomTextColorStyle.normal,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                "${widget.totalPrize}",
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 12, color: AppThemes.onTertiaryColor),
                textColorStyle: CustomTextColorStyle.normal,
              ).marginOnly(right: 2),
              CustomNetWorkImage(
                width: 12,
                height: 12,
                imageUrl: "${controller.coinIcDomain}${controller.currencyId.value}${controller.coinIcExtensionName}",
              )
            ],
          );
  }

  Widget stateView() {
    return ListView.builder(
        itemCount: 3,
        itemExtent: 42,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return stateItem(index);
        });
  }

  Widget stateItem(int index) {
    return SizedBox(
        width: double.infinity,
        child: IntrinsicHeight(
            //重点是这个控件
            child: Stack(
              children: [
                index == 0 || index == 1
                    ? Container(
                        margin: const EdgeInsets.only(left: 8, top: 12, bottom: 1),
                        width: 1,
                        color: index == 0 ? const Color(0Xff00E701) : const Color(0XffB1BAD3),
                      )
                    : Container(),
                index == 0 || index == 1
                    ? const CustomAssetIcon(
                        name: "assets/images/rotary/success.png",
                        width: 17,
                        height: 17,
                      )
                    : CustomAssetIcon(
                        name: stateImg(),
                        width: 17,
                        height: 17,
                      ),
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Flexible(
                      child: index == 0
                          ? CustomText(S.current.random_text_857)/// 付款请求已提交
                          : index == 1 ? CustomText(stateContent(), softWrap: true) :  bottomHintStr(),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
            )
        )
    );
  }

  Widget prizeWithIcon() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${widget.totalPrize.toStringAsFixed(2)}",
            style: TextStyle(color: stateColor(), fontWeight: FontWeight.w500),
          ),
          const WidgetSpan(child: SizedBox(width: 4)),
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.all(0), // Adjust spacing as needed
              child: CustomNetWorkImage(
                width: 13,
                height: 13,
                imageUrl: "${controller.coinIcDomain}${controller.currencyId.value}${controller.coinIcExtensionName}",
              ),
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 4)),
        ],
      ),
    );
  }

  Widget bottomHintStr() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        prizeWithIcon(),
        Flexible(
          child: Wrap(
            children: [
              Text(
                S.current.random_text_860, // 将存入您的钱包账户
                style: TextStyle(color: stateColor(), fontWeight: FontWeight.w500),
                maxLines: null, // 允许无限换行
                overflow: TextOverflow.visible, // 通过使溢出可见来处理溢出
              ),
            ],
          ),
        ),
      ],
    );
  }

  String stateContent() {
    if (widget.state == 1) {
      return "${S.current.random_text_858}${controller.getShortfallAmount()}${S.current.random_text_859}";/// 您还需要_才能提现到钱包
    } else {
      if (widget.withdrawType == 2) {
        return S.current.random_text_879;/// 申请转入钱包
      } else {
        return S.current.random_text_880;/// 您可以转入到钱包
      }
    }
  }

  String stateTitle() {
    if (widget.state == 1) {
      return S.current.random_text_861;/// 邀请朋友帮忙
    } else {
      if (widget.withdrawType == 2) {
        if (widget.state == 5) {
          return S.current.random_text_884;/// 待审核
        } else {
          return S.current.random_text_881;/// 立即申请
        }
      } else {
        return S.current.random_text_882;/// 立即转入钱包
      }
    }
  }

  Color stateColor() {
    if (widget.state == 1) {
      return ThemeService().colorScheme.onSurface;
    } else {
      if (widget.withdrawType == 2) {
        return ThemeService().colorScheme.onSurface;
      } else {
        return AppThemes.textColorWhite;
      }
    }
  }

  String stateImg() {
    if (widget.state == 1) {
      return "assets/images/rotary/default.png";
    } else {
      if (widget.withdrawType == 2) {
        return "assets/images/rotary/default.png";
      } else {
        return "assets/images/rotary/success.png";
      }
    }
  }
}

Future<void> showCustomWithDrawalWidget<T>({
  required BuildContext context,
  required double achievedPrize,
  totalPrize,
  required int state,
  withdrawType,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomWithDrawalViewWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            WithDrawalView(
              achievedPrize: achievedPrize,
              totalPrize: totalPrize,
              state: state,
              withdrawType: withdrawType,
            ),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
