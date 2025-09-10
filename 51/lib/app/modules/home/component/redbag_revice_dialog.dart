import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import '../../../../utils/CommonRipple.dart';

class RadbagReviceDialog extends StatelessWidget {
  final double? price;
  const RadbagReviceDialog({super.key, this.price});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Container(
            width: 1.sw,
            height: 1.sh,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                Assets.theme1.images.home.radbagrainWinningBg.path,
              ),
              alignment: Alignment(0, 0.1),
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 260.w),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          Assets.theme1.images.home.radbagrainWinningTitle.path,
                          fit: BoxFit.contain,
                          width: 214.w,
                          height: 63.h,
                        ),
                      ),
                    ),
                    Align(
                      child: CommonRipple(
                        onTap: () {
                          AppManager.instance.tapVibrate();
                          Get.back();
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          child: const Icon(
                            Icons.close_sharp,
                            color: Colors.red,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 220.w),
                  ],
                ),
                SizedBox(height: 55.h),
                Image.asset(
                  Assets.theme1.images.home.radbagrainWinningTips1.path,
                  fit: BoxFit.contain,
                  width: 548.w,
                  height: 63.h,
                ),
                Image.asset(
                  Assets.theme1.images.home.radbagrainWinningTips2.path,
                  fit: BoxFit.contain,
                  width: 443.w,
                  height: 80.h,
                ),
                SizedBox(height: 55.h),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$price',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 112.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.0),
                        ),
                        Text(
                          '元',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 64.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '获奖彩金',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 44.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 110.h),
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Image.asset(
                    Assets.theme1.images.home.radbagrainWinningComfrim.path,
                    fit: BoxFit.contain,
                    width: 540.w,
                    height: 80.h,
                  ),
                ),
              ],
            )));
  }

  void getRedBag() {}
}
