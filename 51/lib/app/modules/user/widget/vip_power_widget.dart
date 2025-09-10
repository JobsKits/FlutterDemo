import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:get/get.dart';

class VipPowerWidget extends StatelessWidget {
  final String title;
  final bool power;
  const VipPowerWidget({
    super.key,
    required this.title,
    required this.power,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          power
              ? Assets.theme1.images.user.iconYes
              : Assets.theme1.images.user.iconNo,
          width: 39.w,
          height: 39.h,
          color: context.theme.primaryColor,
        ),
        SizedBox(
          width: 17.w,
        ),
        Text(
          title,
          style: TextStyle(color: const Color(colorCAF8FF), fontSize: 33.sp),
        ),
      ],
    );
  }
}
