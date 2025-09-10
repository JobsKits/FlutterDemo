import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import 'logic.dart';

class CommissionWidget extends StatefulWidget {
  const CommissionWidget({Key? key}) : super(key: key);

  @override
  State<CommissionWidget> createState() => _CommissionWidgetState();
}

class _CommissionWidgetState extends State<CommissionWidget> {
  final logic = Get.lazyPut(() => CommissionLogic());
  final state = Get.find<CommissionLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: AppValues.allianceWidth_152.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.current.tab_bar_ent,
                        style: ThemeService()
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: AppValues.fontBodyMediumSize.sp)),
                    SizedBox(height: AppValues.allianceHeight_8.h),
                    Text(S.current.random_text_203,
                        style: ThemeService()
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppThemes.onSurfaceColor)),
                    SizedBox(height: AppValues.allianceHeight_8.h),
                    Container(
                      padding: EdgeInsets.all(AppValues.alliancePadding_12.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppValues.smallRadius),
                        ),
                        color: ThemeService().theme.colorScheme.surfaceVariant,
                      ),
                      child: Text('(Edge as decimal * wagered / 2) * commission rate',
                          style: ThemeService()
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppThemes.onSurfaceColor)),
                    ),
                  ],
                ),
              ),
              Divider(height: AppValues.allianceHeight_1.h),
              Container(
                width: AppValues.allianceWidth_152.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.current.tab_bar_sports,
                        style: ThemeService()
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: AppValues.fontBodyMediumSize.sp)),
                    SizedBox(height: AppValues.allianceHeight_8.h),
                    Text(S.current.random_text_204,
                        style: ThemeService()
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppThemes.onSurfaceColor)),
                    SizedBox(height: AppValues.allianceHeight_8.h),
                    Container(
                      padding: EdgeInsets.all(AppValues.alliancePadding_12.h),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(AppValues.smallRadius),
                        ),
                        color: ThemeService().theme.colorScheme.surfaceVariant,
                      ),
                      child: Text('(Edge as decimal * wagered / 2) * commission rate',
                          style: ThemeService()
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppThemes.onSurfaceColor)),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppValues.alliancePadding_12.h),
          Text(
              S.current.random_text_205,
              style: ThemeService().textTheme.bodyMedium?.copyWith(color: AppThemes.errorColor)),
          SizedBox(height: AppValues.allianceHeight_20.h),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<CommissionLogic>();
    super.dispose();
  }
}
