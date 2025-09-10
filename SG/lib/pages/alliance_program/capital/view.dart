import 'package:flutter/material.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/dialog/dialog_utils.dart';
import 'logic.dart';

class CapitalWidget extends StatefulWidget {
  const CapitalWidget({Key? key}) : super(key: key);

  @override
  State<CapitalWidget> createState() => _CapitalWidgetState();
}

class _CapitalWidgetState extends State<CapitalWidget> {
  final logic = Get.lazyPut(() => CapitalLogic());
  final state = Get.find<CapitalLogic>().state;
  final GlobalKey _popKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: AppValues.allianceHeight_62.h,
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: AppValues.margin_12),
                  padding: const EdgeInsets.only(
                      top: AppValues.defaultPadding, bottom: AppValues.defaultPadding),
                  child: CustomAssetIcon(
                    name: "assets/images/alliance/alliance_sort.webp",
                    size: AppValues.iconSize_18.w,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: AppValues.margin_12),
                    padding: const EdgeInsets.only(
                        top: AppValues.defaultPadding, bottom: AppValues.defaultPadding),
                    child: CustomText(S.current.alliance_activity,
                        style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ThemeService().colorScheme.onSurface))),
                SizedBox(width: AppValues.allianceWidth_14_5.w),
                GestureDetector(
                  onTap: () {
                    DialogUtils.showCustomBubbleDialog(
                        context, _buildBubbleChild(), AppValues.allianceWidth_124,
                        widgetKey: _popKey, backgroundColor: ThemeService().colorScheme.tertiary);
                  },
                  child: Container(
                    key: _popKey,
                    padding: const EdgeInsets.only(
                        top: AppValues.defaultPadding, bottom: AppValues.defaultPadding),
                    decoration: BoxDecoration(
                        color: ThemeService().colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppValues.radius_2),
                            bottomLeft: Radius.circular(AppValues.radius_2))),
                    child: Row(
                      children: [
                        SizedBox(
                          width: AppValues.margin_12.w,
                        ),
                        CustomText(S.current.random_text_200,
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        SizedBox(
                          width: AppValues.margin_12.w,
                        ),
                        CustomAssetIcon(
                          name: "assets/images/top_drop_down arrow.webp",
                          size: AppValues.iconSize_18.w,
                        ),
                        SizedBox(
                          width: AppValues.iconSmallSize.w,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: AppValues.defaultPadding.w, right: AppValues.defaultPadding.w),
            height: AppValues.allianceHeight_54.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.current.random_text_201,
                  style: ThemeService()
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppThemes.onSurfaceColor),
                ),
                Text(
                  S.current.random_text_201,
                  style: ThemeService()
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppThemes.onSurfaceColor),
                ),
                Text(
                  S.current.random_text_201,
                  style: ThemeService()
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppThemes.onSurfaceColor),
                ),
              ],
            ),
          ),
          Container(
            height: AppValues.allianceWidth_216.h,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(
                      left: AppValues.defaultPadding.w, right: AppValues.defaultPadding.w),
                  color: index % 2 == 0
                      ? ThemeService().colorScheme.surfaceVariant
                      : Colors.transparent,
                  height: AppValues.allianceHeight_54.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.random_text_201,
                        style: ThemeService()
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppThemes.onSurfaceColor),
                      ),
                      Text(
                        S.current.random_text_201,
                        style: ThemeService()
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppThemes.onSurfaceColor),
                      ),
                      Text(
                        S.current.random_text_201,
                        style: ThemeService()
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppThemes.onSurfaceColor),
                      ),
                    ],
                  ),
                );
              },
              itemCount: 10,
            ),
          ),
          SizedBox(height: AppValues.alliancePadding_12),
          CustomBigMainButton(
            title: S.current.alliance_monery_takeout,
            borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius),
            onTap: (buttonCtr) {},
          ),
          SizedBox(height: AppValues.alliancePadding_12.h),
          Text(
            S.current.alliance_monery_takeout,
            style: ThemeService().textTheme.bodyMedium?.copyWith(color: AppThemes.onSurfaceColor),
          ),
          SizedBox(height: AppValues.alliancePadding_20.h),
        ],
      ),
    );
  }

  Widget _buildBubbleChild() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppValues.smallPadding),
        child: Column(
          children: [
            1,
            1,
            1,
            1,
          ].map((text) {
            return Container(
              alignment: Alignment.center,
              height: AppValues.allianceHeight_30.h,
              child: CustomText(
                S.current.random_text_200,
                textColorStyle: CustomTextColorStyle.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<CapitalLogic>();
    super.dispose();
  }
}
