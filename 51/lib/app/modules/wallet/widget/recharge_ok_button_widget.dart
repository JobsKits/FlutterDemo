import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_list_item_widget.dart';
import 'package:flutter_tiyu_app/app/widget/common_gradient.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';

import '../../../../theme/theme.service.dart';

import '../../../../utils/CommonRipple.dart';
// import '../../../../utils/common_color.dart';

///充值页面的确认充值按钮组件
class RechargeOkButtonWidget extends StatelessWidget {
  final String text;
  final bool isCanRecharge;
  final VoidCallback? clickButton;
  const RechargeOkButtonWidget({
    super.key,
    required this.text,
    this.isCanRecharge = true,
    this.clickButton,
  });

  @override
  Widget build(BuildContext context) {
    return CommonRipple(
      onTap: () => isCanRecharge && clickButton != null ? clickButton!() : null,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            // color: const Color(theme01MainColor),
            gradient: CommonGradient.getButtonLinearGradient(
              disabled: !isCanRecharge,
            ),
            borderRadius: BorderRadius.circular(
                ThemeService.to.currentTheme.value?.model == "blackGold"
                    ? 16.r
                    : 79.r)),
        margin: EdgeInsets.only(top: 60.h),
        width: double.infinity,
        height: 125.h,
        child: Text(
          text,
          style: TextStyle(
              color: context.customTheme?.rechargeMoneyColor, fontSize: 52.sp),
        ),
      ),
    );
  }
}
