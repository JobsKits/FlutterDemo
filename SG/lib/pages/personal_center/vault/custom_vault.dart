import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/personal_center/vault/vault_tabbar.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';

const kCustomVaultWidget = 'CustomVaultWidget';
final GlobalKey _vaultGlobalKey = GlobalKey();

class CustomVaultWidget extends StatefulWidget {
    const CustomVaultWidget({super.key});

  @override
  State<CustomVaultWidget> createState() {
    return _CustomVaultState();
  }
}

class _CustomVaultState extends State<CustomVaultWidget> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      decoration:   BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: ThemeService().theme.scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          _buildTop(),
          // VaultTabBar(vaultGlobalKey: _vaultGlobalKey,)
        ],
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
                        asset: "assets/images/personal_center_icon/vault.webp",
                        size: 18,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      CustomText(
                        S.current.vault,
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

}

Future<void> showCustomVaultWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomVaultWidget,
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
            CustomVaultWidget(key: _vaultGlobalKey,),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
  String truncateText(String str, int maxLength) {
    if(str.isEmpty){
      return "";
    }
    if (str.length > maxLength) {
      return str.substring(0, maxLength);
    }
    return str;
  }
}
