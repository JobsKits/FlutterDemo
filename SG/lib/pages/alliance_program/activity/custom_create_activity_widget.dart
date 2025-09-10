import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/input/custom_main_text_field.dart';

const CustomAllianceCreateActivityWidget = 'CustomAllianceCreateActivityWidget';

class CustomCreateActivityWidget extends StatefulWidget {
  const CustomCreateActivityWidget({super.key});

  @override
  State<CustomCreateActivityWidget> createState() {
    return _CustomVaultState();
  }
}

class _CustomVaultState extends State<CustomCreateActivityWidget>
    with SingleTickerProviderStateMixin {
  var showNameError = false;
  var showContentError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin.w),
      decoration: BoxDecoration(
        borderRadius:
        const BorderRadius.only(topLeft: Radius.circular(AppValues.smallRadius), topRight: Radius.circular(AppValues.smallRadius)),
        color: ThemeService().theme.scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTop(),
          SizedBox(
            height: AppValues.margin_12.w,
          ),
          Container(
              margin: EdgeInsets.only(left: AppValues.margin_12.w),
              child: CustomText("${S.current.alliance_activity_name}*")),
          SizedBox(
            height: AppValues.margin_4.w,
          ),
          Container(
            margin: EdgeInsets.only(
                top: AppValues.padding_4, left: AppValues.margin_12.w, right: AppValues.margin_12.w),
            child: Material(
              child: CustomMainTextField(
                showError: showNameError,
                errorText: S.current.random_text_197,
                inputCallBack: (e){
                  setState(() {
                    showNameError = e.length < 3;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: AppValues.margin_12.w,
          ),
          Container(
              margin: EdgeInsets.only(left: AppValues.margin_12.w),
              child: CustomText("${S.current.alliance_activity_name}*")),
          SizedBox(
            height: AppValues.margin_4.w,
          ),
          Container(
            margin: EdgeInsets.only(
                top: AppValues.padding_4.h, left: AppValues.margin_12.w, right: AppValues.margin_12.w),
            child: Material(
              child: CustomMainTextField(
                showError: showContentError,
                  errorText: S.current.random_text_197,
                inputCallBack: (e){
                  setState(() {
                    showContentError = e.length < 3;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: AppValues.margin_12.w,
          ),
          Container(
            margin: EdgeInsets.only(
                top: AppValues.padding_4.h, left: AppValues.margin_12.w, right: AppValues.margin_12.w),
            child: CustomBigMainButton(
              title: S.current.alliance_create_activity,
              borderRadius: BorderRadius.circular(4),
              onTap: (buttonCtr) {},
            ),
          ),
          SizedBox(
            height: AppValues.margin_20.w,
          ),
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
          height: AppValues.allianceHeight_25.h,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(left: AppValues.defaultPadding.w),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(
                          width: AppValues.allianceHeight_4.h,
                        ),
                        CustomIcon(
                          color: AppThemes.iconColor,
                          asset: "assets/images/top_wallet.webp",
                          size: AppValues.iconSize_18.w,
                        ),
                        SizedBox(
                          width: AppValues.allianceHeight_4.w,
                        ),
                        CustomText(
                          S.current.alliance_create_activity,
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
              ),
              Positioned.fill(
                child: Row(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    GestureDetector(
                      onTap: () {
                        RouteUtil.popView();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: AppValues.defaultPadding.w),
                        child: CustomIcon(
                          asset: 'assets/images/normal/ic_normal_close.webp',
                          size: AppValues.iconSize_18.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppValues.defaultPadding.w,
        ),
      ],
    );
  }
}

Future<void> showCustomAllianceCreateActivityWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: CustomAllianceCreateActivityWidget,
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
            const CustomCreateActivityWidget(),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
