import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:get/get.dart';
class TurntableWinDialog extends StatelessWidget {
  final double? price;
  const TurntableWinDialog({super.key, this.price});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent.withOpacity(0),
              ),
            ),
            Positioned(
              top: -200.h,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets
                        .theme1.images.activity.activityTurntableWinning.path),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                        height: price! > 0.0
                            ? MediaQuery.of(context).size.height / 2
                            : MediaQuery.of(context).size.height / 2 + 120.h),
                    if (price! > 0.0) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 50),
                          Text(
                            '${(price ?? 0).truncateToFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}元',
                            style: TextStyle(
                              color: const Color(0xFFDF0B10),
                              fontSize: 60.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 50),
                        ],
                      ),
                      Image.asset(
                        Assets.theme1.images.home.activityOpentitle1.path,
                        fit: BoxFit.contain,
                        width: 285.w,
                        height: 80.h,
                      ),
                    ],
                    SizedBox(height: 20.h),
                    Text(
                      price! > 0.0 ? '彩金已派发至您的账户钱包' : '本次抽奖未中奖\n再接再厉，大奖等您来！',
                      style: TextStyle(
                        color: price! > 0.0
                            ? const Color(0xFF3b3b3b)
                            : const Color(0xFFDF0B10),
                        fontSize: 38.sp,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 466.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.r),
                        gradient: LinearGradient(
                          colors: [Color(0xFFF04639), Color(0xFFFF514B)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFF514B),
                            offset: Offset(0, 6.w),
                            blurRadius: 10.w,
                          ),
                        ],
                      ),
                      height: 120.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: double.infinity,
                          child: Text(
                            '继续抽奖',
                            style: TextStyle(
                              fontSize: 48.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 90.w,
                        height: 90.w,
                        decoration: BoxDecoration(
                          color: context.theme.cardColor.withOpacity(.9),
                          borderRadius: BorderRadius.circular(90.w),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close_sharp,
                          color: Color(0xFFcecece),
                          size: 20,
                        ),
                      ).onTap(() {
                        Get.back();
                      }),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
