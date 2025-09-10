import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/switch/custom_switch.dart';

import '../../../constant/app_cache_key.dart';
import '../../../services/account_service.dart';

const kCustomWalletSettingWidget = 'CustomWalletSettingWidget';


class CustomWalletSettingWidget extends StatefulWidget {
    const CustomWalletSettingWidget({super.key});


  @override
  State<StatefulWidget> createState() {
   return _CustomWalletSettingWidgetState();
  }
}
class _CustomWalletSettingWidgetState extends State<CustomWalletSettingWidget> with SingleTickerProviderStateMixin{
  late  var isCheck ;

  @override
  Widget build(BuildContext context) {
      isCheck = SPUtil().getBool("${CacheKey.isHiddenBalance}${AccountService.sharedInstance.currentUser?.uid}") ?? false;
      log("钱包设置 ${isCheck}");
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        decoration:   BoxDecoration(
          borderRadius:
          const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          color: ThemeService().colorScheme.background,
        ),
        child: Column(
          children: [
            _buildTop(),
            _buildContent(),
            const SizedBox(
              height: AppValues.largePadding,
            ),
          ],
        ),
      ),
    );
  }
  _buildTop() {
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
                child: Center(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 13,
                      ),
                      const CustomIcon(
                        color: AppThemes.iconColor,
                        asset: "assets/images/top_wallet.png",
                        size: 18,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      CustomText(
                        S.current.top_wallet_setting,
                        style: ThemeService()
                            .theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
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
                        padding: EdgeInsets.only(right: AppValues.defaultPadding),
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
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
      ],
    );
  }

  _buildContent(){

    return Row(
      children: [
        const SizedBox(
          width: AppValues.defaultPadding,
        ),
       CustomSwitch(value: isCheck , onChanged: (newValue) {
          setState(() {
            isCheck = ! isCheck;
            SPUtil().setBool("${CacheKey.isHiddenBalance}${AccountService.sharedInstance.currentUser?.uid}" , newValue);

          });
        },),
        const SizedBox(
          width: AppValues.defaultPadding,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(S.current.wallet_hideChangeBalance,),
              CustomText(S.current.wallet_yourZeroBalanceWillNotBeDisplayedInWallet,textColorStyle: CustomTextColorStyle.normal,),
            ],
          ),
        )
      ],
    );
  }

}

Future<void> showCustomWalletSettingWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomWalletSettingWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            CustomWalletSettingWidget(),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
