import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100.h, bottom: 50.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Assets.theme1.images.agentCenter.iconEmpty.path,
            width: 500.w,
          ),
          SizedBox(
            height: 80.h,
          ),
          Text(
            '暂无数据',
            style: TextStyle(
              fontSize: 38.sp,
              color: const Color(colorAAAFBB),
            ),
          )
        ],
      ),
    );
  }
}
