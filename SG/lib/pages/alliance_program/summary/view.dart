import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import 'logic.dart';

class SummaryWidget extends StatefulWidget {
  const SummaryWidget({Key? key}) : super(key: key);

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  final logic = Get.lazyPut(() => SummaryLogic());
  final state = Get.find<SummaryLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(color: Colors.black, height: AppValues.allianceHeight_190.h),
          Padding(
            padding: EdgeInsets.all(AppValues.alliancePadding_12.w),
            child: Text(
              S.current.random_text_211,
              style: ThemeService().textTheme.bodyMedium?.copyWith(color: AppThemes.onSurfaceColor),
              maxLines: 10,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: AppValues.alliancePadding_10.w,
                right: AppValues.alliancePadding_10.w,
                bottom: AppValues.alliancePadding_20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  name: 'stake.com/?c=rCiS8vWh',
                  style: ThemeService().textTheme.bodyMedium,
                  direction: Direction.right,
                  backgroundColor: ThemeService().theme.colorScheme.tertiary,
                  iconWidget: Image.asset(
                    'assets/images/alliance/alliance_copy.webp',
                    width: AppValues.iconSize_18.w,
                    height: AppValues.iconSize_18.w,
                  ),
                  widgetWidth: AppValues.allianceHeight_190.w,
                  widgetHeight: AppValues.allianceHeight_42.h,
                  borderRadius: AppValues.smallRadius,
                  iconHeight: AppValues.allianceHeight_18.h,
                  iconWidth: AppValues.allianceHeight_18.w,
                ),
                CustomIconButton(
                  name: S.current.random_text_212,
                  style: ThemeService().textTheme.bodyMedium,
                  direction: Direction.right,
                  backgroundColor: ThemeService().theme.colorScheme.tertiary,
                  iconWidget: Image.asset(
                    'assets/images/alliance/alliance_share.webp',
                    width: 18,
                    height: 18,
                  ),
                  widgetWidth: AppValues.allianceWidth_118.w,
                  widgetHeight: AppValues.allianceHeight_42.h,
                  borderRadius: AppValues.smallRadius,
                  iconHeight: AppValues.allianceHeight_18.h,
                  iconWidth: AppValues.allianceHeight_18.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<SummaryLogic>();
    super.dispose();
  }
}
