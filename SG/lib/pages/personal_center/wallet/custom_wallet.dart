import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
final GlobalKey _walletGlobalKey = GlobalKey();

const kCustomWalletWidget = 'CustomWalletWidget';

class CustomWalletWidget extends StatefulWidget {
  const CustomWalletWidget({super.key });
  @override
  State<StatefulWidget> createState() {
     return _WalletState();
  }
}

class _WalletState extends State<CustomWalletWidget> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration:  BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: ThemeService().colorScheme.background,
        ),
        child: Column(
          children: [
            _buildTop(),
            // WalletTabBar(walletGlobalKey: _walletGlobalKey,)
          ],
        ),
      ),
    );
  }
  _buildTop( ) {
    return Column(
      children: [
        const SizedBox(
          height: AppValues.largePadding,
        ),
        SizedBox(
          height: 30,
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
                        S.current.wallet,
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // const Expanded(child: SizedBox.shrink()),
                    InkWell(
                      onTap: () {
                        RouteUtil.popView();
                      },
                      child: Container(
                        // color: Colors.cyan,
                        child: const Padding(
                          padding: EdgeInsets.only(left: AppValues.defaultPadding,right: AppValues.defaultPadding,top: 6,bottom: 6),
                          child: CustomIcon(
                            asset: 'assets/images/normal/ic_normal_close.png',
                            size: 18,
                          ),
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
}


Future<void> showCustomWalletWidget<T>({required BuildContext context, bool barrierDismissible = true, bool useRootNavigator = true,}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomWalletWidget,
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
            CustomWalletWidget(key: _walletGlobalKey,),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
