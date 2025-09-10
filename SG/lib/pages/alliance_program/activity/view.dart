import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_icon_button.dart';
import '../../../widget/custom_divider_widget.dart';
import '../../../widget/sport/custom_sport_expand/custom_sport_expand.dart';
import 'custom_create_activity_widget.dart';
import 'logic.dart';

class ActivityWidget extends StatelessWidget {
  ActivityWidget({Key? key}) : super(key: key);

  final logic = Get.lazyPut(() => ActivityLogic());
  final state = Get.find<ActivityLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: AppValues.allianceHeight_36.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.current.random_text_198,
                  style: ThemeService()
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: AppValues.fontBodyMediumSize.sp),
                ),
                Text('0.00000', style: ThemeService().textTheme.bodyMedium),
                SizedBox(width: AppValues.padding_4.w),
                Image.asset('assets/images/alliance/alliance_m.webp',
                    height: AppValues.iconSize_18.w, width: AppValues.iconSize_18.w),
              ],
            ),
          ),
          SizedBox(height: AppValues.alliancePadding_12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: AppValues.allianceHeight_44.h,
                child: Column(
                  children: [
                    Text(S.current.random_text_199,
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    Text('0',
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(width: AppValues.allianceHeight_91.w),
              Container(
                height: AppValues.allianceHeight_44.h,
                child: Column(
                  children: [
                    Text(S.current.random_text_199,
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    Text('0',
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: AppValues.allianceHeight_44.h,
                child: Column(
                  children: [
                    Text(S.current.random_text_199,
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    Text('0',
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(width: AppValues.allianceHeight_91.w),
              Container(
                height: AppValues.allianceHeight_44.h,
                child: Column(
                  children: [
                    Text(S.current.random_text_199,
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    Text('0',
                        style: ThemeService()
                            .theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          CustomSportExpand(
            padding: EdgeInsets.only(
                left: AppValues.defaultPadding.w, right: AppValues.defaultPadding.w),
            title: Container(
              padding: EdgeInsets.only(right: AppValues.defaultPadding.w),
              height: AppValues.allianceHeight_54.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '',
                    style: ThemeService()
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppThemes.onSurfaceColor),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    height: AppValues.allianceHeight_36.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.current.random_text_198,
                          style: ThemeService()
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: AppValues.fontBodyMediumSize.sp),
                        ),
                        Text('0.00000', style: ThemeService().textTheme.bodyMedium),
                        SizedBox(width: AppValues.padding_4.w),
                        Image.asset('assets/images/alliance/alliance_m.webp',
                            height: AppValues.iconSize_18.w, width: AppValues.iconSize_18.w),
                      ],
                    ),
                  ),
                ],
              ),
            ).expanded(),
            decoration: BoxDecoration(
                color: ThemeService().theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius)),
            trailing: FaIcon(
              FontAwesomeIcons.angleDown,
              size: AppValues.allianceIcon_9_41.w,
            ),
            // titlePadding: EdgeInsets.only(bottom: 14.5.h),
            // childrenPadding: EdgeInsets.only(bottom: 19.h),
            // controller: expandableWidgetController2,
            isExpanded: true,
            children: [
              CustomDividerWidget(),
              SizedBox(height: AppValues.alliancePadding_12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: AppValues.allianceHeight_44.h,
                    child: Column(
                      children: [
                        Text(S.current.random_text_199,
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Text('0',
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(width: AppValues.allianceHeight_91.w),
                  Container(
                    height: AppValues.allianceHeight_44.h,
                    child: Column(
                      children: [
                        Text(S.current.random_text_199,
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Text('0',
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: AppValues.allianceHeight_44.h,
                    child: Column(
                      children: [
                        Text(S.current.random_text_199,
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Text('0',
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(width: AppValues.allianceHeight_91.w),
                  Container(
                    height: AppValues.allianceHeight_44.h,
                    child: Column(
                      children: [
                        Text(S.current.random_text_199,
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Text('0',
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: AppValues.allianceHeight_44.h,
                    child: Column(
                      children: [
                        Text(S.current.random_text_199,
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Text('0',
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(width: AppValues.allianceHeight_91.w),
                  Container(
                    height: AppValues.allianceHeight_44.h,
                    child: Column(
                      children: [
                        Text(S.current.random_text_199,
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Text('0',
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: AppValues.allianceHeight_44.h,
                    child: Column(
                      children: [
                        Text(S.current.random_text_199,
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Text('0',
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(width: AppValues.allianceHeight_91.w),
                  Container(
                    height: AppValues.allianceHeight_44.h,
                    child: Column(
                      children: [
                        Text(S.current.random_text_199,
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Text('0',
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
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
                widgetWidth: AppValues.allianceWidth_303.w,
                widgetHeight: AppValues.allianceHeight_42.h,
                borderRadius: AppValues.smallRadius,
                iconHeight: AppValues.iconSize_18.h,
                iconWidth: AppValues.iconSize_18.w,
              ),
              SizedBox(height: AppValues.alliancePadding_12.h),
            ],
          ),
          SizedBox(height: AppValues.alliancePadding_12.h),
          CustomBigMainButton(
            title: S.current.alliance_monery_takeout,
            borderRadius: BorderRadius.circular(AppValues.roundedButtonRadius),
            onTap: (buttonCtr) {
              showCustomAllianceCreateActivityWidget(context: context);
            },
          ),
          SizedBox(height: AppValues.alliancePadding_20.h),

        ],
      ),
    );
  }
}
