import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'dart:math' as math;

import '../../../../gen/assets.gen.dart';
import '../../../../utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';

///充值界面的展开收起组件
class RechargeExpandWidget extends StatelessWidget {
  const RechargeExpandWidget({
    super.key,
    required this.text,
    required this.isVisible,
    required this.openOrExpand,
    this.isExpand,
  });
  final String text;
  final bool isVisible;
  final VoidCallback openOrExpand;
  final bool? isExpand;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          AppManager.instance.tapVibrate();
          DebounceThrottle.debounce(openOrExpand)();
        },
        child: Container(
          margin: EdgeInsets.only(top: 12.h),
          padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  style: TextStyle(
                      fontSize: 33.sp, color: const Color(color929292))),
              SizedBox(
                width: 12.w,
              ),
              Transform.rotate(
                angle: isExpand == true ? math.pi : 0,
                child: SvgPicture.asset(
                  Assets.theme1.images.recharge.iconArrowDown,
                  width: 28.w,
                  height: 17.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
