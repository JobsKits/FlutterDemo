import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import 'logic.dart';

class PlanWidget extends StatefulWidget {
  const PlanWidget({Key? key}) : super(key: key);

  @override
  State<PlanWidget> createState() => _PlanWidgetState();
}

class _PlanWidgetState extends State<PlanWidget> {
  final logic = Get.lazyPut(() => PlanLogic());
  final state = Get.find<PlanLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            S.current.random_text_206,
            style: ThemeService().textTheme.bodyMedium?.copyWith(color: AppThemes.onSurfaceColor),
          ),
          SizedBox(height: AppValues.alliancePadding_12.h),
          Text(
              S.current.random_text_205,
              style: ThemeService().textTheme.bodyMedium?.copyWith(color: AppThemes.errorColor)),
          SizedBox(height: AppValues.alliancePadding_20.h),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<PlanLogic>();
    super.dispose();
  }
}
