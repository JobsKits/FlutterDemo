import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../model/wallet/BankcardBean.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_big_outline_button.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/input/custom_main_text_field.dart';
import 'binding_bank_card_controller.dart';

const kCustomPassWorldWidget = 'PromptToPw';

class PromptToPw extends StatefulWidget {
  PromptToPw({super.key });

  @override
  State<StatefulWidget> createState() {
    return _PassWorldState();
  }
}

class _PassWorldState extends State<PromptToPw> with SingleTickerProviderStateMixin {

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
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: ThemeService().colorScheme.background,
        ),
        child: Container(
          margin: const EdgeInsets.all(AppValues.defaultMargin),
          child: Column(
            children: [
              _topView(),
              Divider(
                indent: 0.0,
                endIndent: 0.0,
                thickness: 1,
                color: ThemeService().colorScheme.tertiary,
              ),
              const SizedBox(
                height: 32,
              ),
              CustomText("${S.current.wallet_setFundPassword}。",textColorStyle: CustomTextColorStyle.normal,),
              const SizedBox(
                height: 32,
              ),
              SizedBox(height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomBigOutlineButton(
                        onTap: (btr){
                          Get.back();
                        },title: S.current.wallet_cancel,lineColor:ThemeService().colorScheme.primary,textColor: ThemeService().colorScheme.primary,),
                    ),
                    const SizedBox(width:AppValues.defaultMargin,),
                    Expanded(child: CustomBigMainButton(title: S.current.wallet_goToSettings,onTap: (customButtonController){
                      GlobalState.instance.index = 8;
                      RouteUtil.pushToView(Routes.setupPage, offLast: true, arguments: {'pageIndex':1});
                    },)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CustomIcon(
          color: AppThemes.iconColor,
          asset: "assets/images/personal_center_icon/password_clock.webp",
          size: 18,
        ),
        const SizedBox(
          width: 4,
        ),
        CustomText(
          S.current.wallet_enterFundPassword,
          style: ThemeService()
              .theme
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

Future<void> showCustomPromptToPwWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomPassWorldWidget,
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
            PromptToPw(),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
