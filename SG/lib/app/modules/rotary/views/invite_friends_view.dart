import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/rotary/views/share_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../controllers/global_state_controller.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/share/custom_share_widget_item.dart';
import '../../../../pages/home/home_logic.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_ovalends_progressbar.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../controllers/rotary_controller.dart';
import 'number_animation.dart';

const kCustomInviteFriendsWidget = 'InviteFriendsView';

class InviteFriendsView extends StatefulWidget {
  final double achievedPrize;

  final double totalPrize;

  const InviteFriendsView({super.key, required this.achievedPrize, required this.totalPrize});

  @override
  State<StatefulWidget> createState() {
    return _InviteFriendsViewState();
  }
}

class _InviteFriendsViewState extends State<InviteFriendsView> with SingleTickerProviderStateMixin {
  late RotaryController controller = Get.find<RotaryController>();
  final HomeLogic homeLogic = Get.find<HomeLogic>();
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  var symbol = "";
  var currencyName = '';

  @override
  void initState() {
    super.initState();
    getCurrencySymbol();
  }

  void getCurrencySymbol() {
    for (int i = 0; i < globalController.currTypeInitialLists.length; i++) {
      if (homeLogic.state.currencyId.toString() == globalController.currTypeInitialLists[i].cur) {
        symbol = globalController.currTypeInitialLists[i].symbol ?? "";
        currencyName = globalController.currTypeInitialLists[i].name ?? "";
        break;
      }
    }
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
                const SizedBox(width: 16,),
                const CustomAssetIcon(
                  name: 'assets/images/rotary/pinwheel_icon.png',
                  size: 18,
                ),
                CustomText(
                 S.current.random_text_839,
                  textColorStyle: CustomTextColorStyle.white,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
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
            CustomText(
              "****87990 "+S.current.random_text_875,
              textColorStyle: CustomTextColorStyle.white,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomText(
              S.current.random_text_834,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textColorStyle: CustomTextColorStyle.normal,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomAssetIcon(
                  name: 'assets/images/rotary/bill_icon.png',
                  size: 37,
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomText("${widget.achievedPrize}",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                const SizedBox(
                  width: 10,
                ),
                CustomNetWorkImage(
                  width: 28,
                  height: 28,
                  imageUrl:
                  "${controller.coinIcDomain}${controller.currencyId.value}${controller.coinIcExtensionName}",
                ),
                // CustomText(
                //   symbol,
                //   style: TextStyle(color: AppThemes.widgetColorWhite, fontSize: 32),
                // ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CustomText(
                "${widget.achievedPrize}%\t\t\t",
                style: const TextStyle(
                    color: AppThemes.widgetColorWhite, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: double.infinity,
              height: 8,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: CustomPaint(
                painter: OvalEndsProgressBar(
                    progress: widget.achievedPrize / 100 >1?1:widget.achievedPrize / 100,
                    bgColor: ThemeService().colorScheme.surface), // 传入进度值
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CustomText(
                "${S.current.random_text_835}${controller.getShortfallAmount()}",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                textColorStyle: CustomTextColorStyle.normal,
              ),
                CustomNetWorkImage(
                  width: 13,
                  height: 13,
                  imageUrl:
                  "${controller.coinIcDomain}${controller.currencyId.value}${controller.coinIcExtensionName}",
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: CustomBigMainButton(
                  fontWeight: FontWeight.w600,
                  title: S.current.random_text_836,
                  colorStyle: CustomButtonColorStyle.tertiary,
                  onTap: (btn) {
                    showCustomShareWidget(context: context);
                  },
                )),
            // const SizedBox(
            //   height: 16,
            // ),
            // InkWell(
            //     onTap: () => RouteUtil.popView(),
            //     child: CustomText(
            //       "${S.current.random_text_837}${widget.achievedPrize} $currencyName ${S.current.random_text_838}",
            //       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            //       textColorStyle: CustomTextColorStyle.normal,
            //     )),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showCustomInviteFriendsWidget<T>({
  required BuildContext context,
  required double achievedPrize,
  required double totalPrize,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomInviteFriendsWidget,
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
            InviteFriendsView(
              achievedPrize: achievedPrize,
              totalPrize: totalPrize,
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
