import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

class SignInSuccessDialog extends StatefulWidget {
  final String amount;
  const SignInSuccessDialog({super.key, required this.amount});

  @override
  State<SignInSuccessDialog> createState() => _SignInSuccessDialogState();
}

class _SignInSuccessDialogState extends State<SignInSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            width: 790.w,
            constraints: BoxConstraints(minHeight: 644.h, maxHeight: 700.h),
            padding: EdgeInsets.only(top: 140.h, left: 60.w, right: 60.w),
            margin: EdgeInsets.only(top: 160.h, bottom: 160.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.r),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '成功签到',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50.sp,
                    color: const Color(color3B3B3B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 50.h),
                Container(
                  constraints: BoxConstraints(minHeight: 310.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                    color: const Color(0xFFF5F9F9),
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                            fontSize: 100.sp,
                            color: const Color(0xFF10C8E3),
                          ),
                          children: [
                            TextSpan(
                              text: widget.amount,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: '元',
                              style: TextStyle(
                                fontSize: 48.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        '恭喜您获得奖金',
                        style: TextStyle(
                          fontSize: 45.sp,
                          color: const Color(color3B3B3B),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0.h,
            left: 241.w,
            child: Image.asset(
              Assets.theme1.images.activity.signIn.signInDialogCoin.path,
              width: 308.w,
              height: 319.h,
            ),
          ),
          Positioned(
            top: 180.h,
            right: 110.w,
            child: InkWell(
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: SvgPicture.asset(
                  Assets.theme1.images.common.iconClose,
                  width: 40.w,
                  height: 40.h,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
