import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../services/theme/theme_service.dart';
import '../../../../widget/progress/custom_linear_progress_indicator.dart';
import '../../../constant/app_themes.dart';
import '../../../widget/custom_text.dart';

///投注额度 进度条
class ActivityProgressBarWidget extends StatelessWidget {
  final double? value; //0-1
  final double? minHeight;
  final double? minWidth;
  final double borderRadius;
  final String? content; //文案显示

  const ActivityProgressBarWidget({
    super.key,
    this.value = 0,
    this.minHeight = 16,
    this.minWidth,
    this.borderRadius = 4,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //进度条
        Container(
          height: minHeight,
          width: minWidth ?? double.infinity,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            color: ThemeService().theme.colorScheme.tertiary,
            // color: ThemeService().theme.colorScheme.tertiary.withOpacity(0.9),
            // color: AppThemes.secondaryIconColor,
            // color: Color(0xFF2F4554).withOpacity(0.12),
          ),
          child: FractionallySizedBox(
              widthFactor: value! >= 0 && value! <= 1 ? value : 1,
              child: Container(
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    // 渐变颜色
                    // colors: (value! < 1)
                    //     ? [Color(0xFF5DCCF6), Color(0xFFEC5128)]
                    //     : [Color(0xFFEC5128), Color(0xFFEC5128)],
                    colors: [Colors.white, Colors.white],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                ),
              )),
        ),

        //文案
        Container(
          height: minHeight,
          alignment: Alignment.center,
          child: CustomText(
            content ?? "",
            style: ThemeService()
                .textTheme
                .labelLarge
                ?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
