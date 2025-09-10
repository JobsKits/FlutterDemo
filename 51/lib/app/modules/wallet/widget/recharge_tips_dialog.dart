import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';

///充值、提现的引导弹窗
class RechargeTipsDialog extends StatelessWidget {
  final String rechargeBtnStr;
  final String dialogContent;
  final VoidCallback? customRecharge; //接口定义的充值方式
  final VoidCallback? normalRecharge; //正常充值方式
  final bool isRecharge;

  const RechargeTipsDialog(
      {super.key,
      required this.rechargeBtnStr,
      required this.dialogContent,
      this.customRecharge,
      this.normalRecharge,
      this.isRecharge = true});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: IntrinsicHeight(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, // 渐变的开始位置（从上到下）
                end: Alignment.bottomCenter, // 渐变的结束位置（从下到上）
                colors: [Color(0xffD1F3FC), Colors.white], // 渐变的颜色
                stops: [0.0, 0.3],
              ),
              borderRadius: BorderRadius.circular(40.r)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 66.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 55.h,
                    ),
                    Text(
                      "推荐${rechargeBtnStr}",
                      style: TextStyle(
                          fontSize: 66.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 75.h,
                    ),
                    HtmlWidget(
                      "${dialogContent}",
                      textStyle: TextStyle(color: Colors.black),
                    ),
                    rechargeBtnStr.isNotEmpty
                        ? CommonRipple(
                            onTap: customRecharge,
                            child: Container(
                              width: double.infinity,
                              height: 115.h,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 50.h),
                              decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(66.r)),
                              child: Text(
                                "${rechargeBtnStr}",
                                style: TextStyle(
                                    fontSize: 54.sp, color: Colors.white),
                              ),
                            ),
                          )
                        : SizedBox(),
                    InkWell(
                      onTap: normalRecharge,
                      child: Container(
                        width: double.infinity,
                        height: 115.h,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 40.h, bottom: 60.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(66.r),
                            border:
                                Border.all(color: context.theme.primaryColor)),
                        child: Text(
                          isRecharge ? "继续充值" : "继续提现",
                          style: TextStyle(
                              fontSize: 54.sp,
                              color: context.theme.primaryColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 38.h,
                right: 46.w,
                child: InkWell(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      Get.back();
                    },
                    child: Image.asset(
                      Assets.theme1.images.recharge.iconRecommend.path,
                      width: 278.w,
                      height: 236.h,
                    )),
              ),
              Positioned(
                bottom: -140.h,
                right: 0,
                left: 0,
                child: InkWell(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      Get.back();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.clear,
                        size: 72.w,
                        color: Colors.black26,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
