import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';

import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

class EmptyWidget extends StatefulWidget {
  final bool? isShowLogin;
  final bool? isBetDelay;
  const EmptyWidget({
    super.key,
    this.isShowLogin = false,
    this.isBetDelay = false,
  });

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 300.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: widget.isBetDelay == true,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: Text(
                '由于注单延迟，投注记录数据彩金会有延迟 !!!',
                style: TextStyle(
                  fontSize: 38.sp,
                  color: const Color(color2D2D2D),
                ),
              ),
            ),
          ),
          Image.asset(
            Assets.theme1.images.activity.imgEmpty.path,
            width: 500.w,
          ),
          SizedBox(
            height: 80.h,
          ),
          widget.isShowLogin == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '请登录后查看，',
                      style: TextStyle(
                        fontSize: 38.sp,
                        color: const Color(colorAAAFBB),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        showLoginDialog();
                      },
                      child: Text(
                        '立即登录',
                        style: TextStyle(
                          fontSize: 38.sp,
                          color: context.theme.primaryColor,
                        ),
                      ),
                    )
                  ],
                )
              : Text(
                  '暂无任何数据',
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
