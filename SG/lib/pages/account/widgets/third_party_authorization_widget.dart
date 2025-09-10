import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/account/ThirdPartyAuthorizationToController.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../generated/l10n.dart';
import '../../../widget/custom_text.dart';

class ThirdPartyAuthorizationWidget extends GetView<FiatPaymentDetailsToController> {
  const ThirdPartyAuthorizationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<FiatPaymentDetailsToController>(
          () => FiatPaymentDetailsToController(),
    );
    // TODO: implement build
    return Column(
      children: [
        Obx(() => Visibility(
          visible: controller.dic.keys.isNotEmpty,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: ThemeService().colorScheme.tertiary,
                    width: 64,
                    height: 2,
                  ),
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  CustomText(
                    S.current.random_text_1021,
                    style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  Container(
                    color: ThemeService().colorScheme.tertiary,
                    width: 64,
                    height: 2,
                  ),
                ],
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
            ],
          ),
        )),
        Container(
          // margin: const EdgeInsets.only(left: 22,right: 22),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Obx(() => (controller.dic['FaceBook'] != null && controller.dic['FaceBook']['state'] == 1) ?
            Expanded(
              child: CustomIconButton(
                widgetHeight: 40,
                widgetWidth: 82,
                iconHeight: 16,
                iconWidth: 16,
                onTap: controller.goToThirdPartyFacebook,
                borderRadius: AppValues.smallRadius,
                backgroundColor: ThemeService().colorScheme.tertiary,
                iconWidget: Image.asset('assets/images/login/ic_logo_facebook.png'),
              ),
            ) : Container()),
            const SizedBox(
              width: 5,
            ),
            Obx(() => (controller.dic['Google'] != null && controller.dic['Google']['state'] == 1) ?
            Expanded(
              child: CustomIconButton(
                widgetHeight: 40,
                widgetWidth: 82,
                iconHeight: 16,
                iconWidth: 16,
                onTap: controller.goToThirdPartyGoogle,
                borderRadius: AppValues.smallRadius,
                backgroundColor: ThemeService().colorScheme.tertiary,
                iconWidget: Image.asset('assets/images/login/ic_logo_gmail.png'),
              ),
            ) : Container()),
            const SizedBox(
              width: 5,
            ),
            Obx(() => (controller.dic['Line'] != null && controller.dic['Line']['state'] == 1) ?
            Expanded(
              child: CustomIconButton(
                widgetHeight: 40,
                widgetWidth: 82,
                iconHeight: 16,
                iconWidth: 16,
                onTap: controller.goToThirdPartyLine,
                borderRadius: AppValues.smallRadius,
                backgroundColor: ThemeService().colorScheme.tertiary,
                iconWidget: Image.asset('assets/images/login/ic_logo_line.png'),
              ),
            ) : Container()),
            const SizedBox(
              width: 5,
            ),
            Obx(() => (controller.dic['Twitch'] != null && controller.dic['Twitch']['state'] == 1) ?
            Expanded(
              child: CustomIconButton(
                widgetHeight: 40,
                widgetWidth: 82,
                iconHeight: 16,
                iconWidth: 16,
                onTap: controller.goToThirdPartyTwitch,
                borderRadius: AppValues.smallRadius,
                backgroundColor: ThemeService().colorScheme.tertiary,
                iconWidget: Image.asset('assets/images/login/ic_logo_twitch.png'),
              ),
            ) : Container()),
            // const Expanded(child: SizedBox.shrink()),
          ]),
        )
      ],
    );
  }
}
