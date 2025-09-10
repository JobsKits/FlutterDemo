

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';

class SportEventCountWidget extends StatelessWidget{
  const SportEventCountWidget({super.key,required this.count});

  final String? count;//扩展 里面有多是个子item；

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        left: AppValues.sportHeight_7.w,
        right: AppValues.sportHeight_7.w,
        top: AppValues.sportHeight_2.h,
        bottom: AppValues.sportHeight_2.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0), // Adjust the radius value as needed
        color: ThemeService().colorScheme.tertiary, //Background color
      ),
      child: CustomText(
        count??"",
        style: const TextStyle(
            color: AppThemes.textColorSecondary, fontSize: AppValues.fontBodySmallSize),
      ),
    );
  }

}