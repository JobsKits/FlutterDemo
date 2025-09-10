import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/sport/custom_sport_expand/custom_sport_expand.dart';
import 'logic.dart';

class RecommendationWidget extends StatelessWidget {
  RecommendationWidget({Key? key}) : super(key: key);

  final logic = Get.lazyPut(() => RecommendationLogic());
  final state = Get.find<RecommendationLogic>().state;
  final GlobalKey _leftPopKey = GlobalKey();
  final GlobalKey _rightPopKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.current.alliance_activity_name,
                      textAlign: TextAlign.start,
                      style: ThemeService()
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppThemes.onSurfaceColor)),
                  SizedBox(
                    height: AppValues.activeIndicatorSize,
                  ),
                  GestureDetector(
                    onTap: (){
                      DialogUtils.showCustomBubbleDialog(
                          context, _buildBubbleChild(), AppValues.allianceWidth_124,
                          widgetKey: _leftPopKey, backgroundColor: ThemeService().colorScheme.tertiary);
                    },
                    child: Container(
                      key: _leftPopKey,
                      width: AppValues.allianceHeight_158.w,
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
                          CustomText(S.current.random_text_207,
                              style: ThemeService()
                                  .theme
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                          Expanded(child: SizedBox()),
                          CustomAssetIcon(
                            name: "assets/images/top_drop_down arrow.webp",
                            size: AppValues.iconSize_18.w,
                          ),
                          SizedBox(
                            width: AppValues.allianceWidth_6.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.current.alliance_sort,
                      textAlign: TextAlign.start,
                      style: ThemeService()
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppThemes.onSurfaceColor)),
                  SizedBox(
                    height: AppValues.activeIndicatorSize,
                  ),
                  GestureDetector(
                    onTap: (){
                      DialogUtils.showCustomBubbleDialog(
                          context, _buildBubbleChild(), AppValues.allianceWidth_124,
                          widgetKey: _rightPopKey, backgroundColor: ThemeService().colorScheme.tertiary);
                    },
                    child: Container(
                      key: _rightPopKey,
                      width: AppValues.allianceHeight_158.w,
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
                          CustomText(S.current.random_text_207,
                              style: ThemeService()
                                  .theme
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                          Expanded(child: SizedBox()),
                          CustomAssetIcon(
                            name: "assets/images/top_drop_down arrow.webp",
                            size: AppValues.iconSize_18.w,
                          ),
                          SizedBox(
                            width: AppValues.allianceWidth_6.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
                left: AppValues.alliancePadding_12.w, right: AppValues.alliancePadding_12.w),
            height: AppValues.allianceHeight_54.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.current.text_field_user_name_tips,
                  style: ThemeService()
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppThemes.onSurfaceColor),
                ),
                Text(
                  S.current.random_text_209,
                  style: ThemeService()
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppThemes.onSurfaceColor),
                ),
                Text(
                  S.current.alliance_commission,
                  style: ThemeService()
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppThemes.onSurfaceColor),
                ),
              ],
            ),
          ),
          Container(
            height: AppValues.allianceHeight_216.h,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CustomSportExpand(
                  padding: EdgeInsets.zero,
                  title: Container(
                    padding: EdgeInsets.only(
                        left: AppValues.alliancePadding_12.w,
                        right: AppValues.alliancePadding_12.w),
                    height: AppValues.allianceHeight_54.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.angleDown,
                              size: AppValues.allianceIcon_10_45.w,
                            ),
                            SizedBox(width: AppValues.allianceHeight_4.h),
                            Text(
                              'test01',
                              style: ThemeService()
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppThemes.onSurfaceColor),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Text(
                          '7',
                          style: ThemeService()
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppThemes.onSurfaceColor),
                        ),
                        Row(
                          children: [
                            Text(
                              'test01',
                              style: ThemeService()
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppThemes.onSurfaceColor),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(width: AppValues.allianceHeight_4.h),
                            FaIcon(
                              FontAwesomeIcons.angleDown,
                              size: AppValues.allianceIcon_10_45.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).expanded(),
                  decoration: BoxDecoration(
                      color: ThemeService().theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppValues.smallRadius)),
                  trailing: Container(),
                  isExpanded: true,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: AppValues.alliancePadding_12.w,
                          right: AppValues.alliancePadding_12.w),
                      color: ThemeService().theme.scaffoldBackgroundColor,
                      height: AppValues.allianceHeight_54.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.current.random_text_210,
                            style: ThemeService()
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppThemes.onSurfaceColor),
                          ),
                          Text(
                            S.current.random_text_210,
                            style: ThemeService()
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppThemes.onSurfaceColor),
                          ),
                          Text(
                            S.current.random_text_210,
                            style: ThemeService()
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppThemes.onSurfaceColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              itemCount: 10,
            ),
          ),
          SizedBox(height: AppValues.allianceHeight_20.h),
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
}
