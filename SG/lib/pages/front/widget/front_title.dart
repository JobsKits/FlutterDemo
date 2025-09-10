import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/front/front_logic.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../services/account_service.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_vip_progress_indicator.dart';
import '../../account/register/register_widget.dart';
import '../../account/widgets/third_party_authorization_widget.dart';

class FrontTitle extends GetView<FrontLogic> {
  FrontTitle({super.key});

  final GlobalStateController globalController =
      Get.find<GlobalStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => globalController.isLogin.value
        ? _buildWithNoLogin()
        : _buildWithLogin(context));
  }

  Widget _buildWithLogin(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_40),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: AppValues.defaultMargin)
                .copyWith(top: 50),
            child: CustomText(
              S.current.random_text_287,
              style: ThemeService().textTheme.headlineSmall,
            ),
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Container(
            child: CustomBigMainButton(
                onTap: (buttonCtr) {
                  showCustomRegisterWidget(context: context);
                  // RouteUtil.pushToView(Routes.registerPage);
                },
                title: S.current.random_text_288,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppValues.largeRadius),
                )),
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buiildLine(),
              const SizedBox(
                width: AppValues.defaultPadding,
              ),
              CustomText(
                S.current.login_text_other_use,
                style: ThemeService().textTheme.labelLarge,
              ),
              const SizedBox(
                width: AppValues.defaultPadding,
              ),
              _buiildLine(),
            ],
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          const ThirdPartyAuthorizationWidget(),
        ],
      ),
    );
  }

  Widget _buildWithNoLogin() {
    return Container(
      child: <Widget>[
        Image.asset(
            "assets/images/personal_center_icon/vip_level/svg-vip-back.webp"),
        Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                  top: AppValues.margin_30, left: AppValues.defaultMargin),
              child: CustomText(
                '${S.current.random_text_290}${AccountService.sharedInstance.currentUser?.username}',
                style: ThemeService().textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.animate();
                    GlobalState.instance.index = 3;
                    DialogUtils.goToPage(Routes.personalVip);
                  },
                  child: Obx(() {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      transform: Matrix4.translationValues(
                          controller.state.xOffset.value, 0.0, 0.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          CustomText(S.current.vip_your_progress),
                          const SizedBox(
                            width: 8,
                          ),
                          const CustomAssetIcon(
                              name:
                                  "assets/images/personal_center_icon/ic_vip_next.webp"),
                        ],
                      ),
                    );
                  }),
                ),
                Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: CustomText(
                        (controller.completeRate * 100).toInt().toString() +
                            "%")),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
              child: CustomVipProgressIndicator(
                value: controller.completeRate,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: AppValues.width_12,
                    ),
                    CustomAssetIcon(
                            name:
                                "assets/images/personal_center_icon/vip_level/level_${controller.currentUser.vip!}.webp")
                        .tight(width: 27, height: 24),
                    const SizedBox(
                      width: 6,
                    ),
                    CustomText(
                      controller.currentAlias,
                      // 'VIP${AccountService.sharedInstance.getUserInfo().vip}' ??
                      //     S.current.vip_level,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppValues.fontTileSmallSize),
                      textColorStyle: CustomTextColorStyle.normal,
                    )
                  ],
                ),
                Row(
                  children: [
                    Visibility(
                      visible: controller.currentLevel == "10" ? false : true,
                      child: CustomAssetIcon(
                              name:
                                  "assets/images/personal_center_icon/vip_level/level_${controller.vipLevel}.webp")
                          .tight(width: 27, height: 24),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Visibility(
                      visible: controller.currentLevel == "10" ? false : true,
                      child: CustomText(controller.nextAlias,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppValues.fontTileSmallSize),
                          textColorStyle: CustomTextColorStyle.white),
                    ),
                    const SizedBox(
                      width: AppValues.width_12,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: AppValues.margin_20,
            ),
          ],
        ).paddingAll(AppValues.halfPadding),
      ].toStack(),
    )
        .tight(width: double.infinity, height: Get.width / 375 * 215)
        .paddingBottom(AppValues.halfPadding);
  }

  Widget _buiildLine() {
    return Container(
      height: 2,
      width: 64,
      color: ThemeService().theme.colorScheme.tertiary,
    );
  }
}
