import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../services/theme/theme_service.dart';
import '../../../../widget/progress/custom_linear_progress_indicator.dart';

///投注额度 进度条
class BettingLimitsProgressIndicator extends StatelessWidget {
  final double? value; //0-1
  final double? minHeight;
  final double? minWidth;
  final double borderRadius;

  const BettingLimitsProgressIndicator(
      {super.key, this.value = 0, this.minHeight = 16, this.minWidth, this.borderRadius = 4});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: minHeight,
      width: minWidth ?? double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: ThemeService().theme.colorScheme.tertiary,
      ),
      child: FractionallySizedBox(
          widthFactor: value! >= 0 && value! <= 1 ? value : 1,
          child: Container(
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                colors: (value! < 1)
                    ? [Color(0xFF5DCCF6), Color(0xFFEC5128)]
                    : [Color(0xFFEC5128), Color(0xFFEC5128)],
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
            ),
          )),
    );
  }
}
