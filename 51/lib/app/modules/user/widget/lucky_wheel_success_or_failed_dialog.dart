import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';

//大转盘成功或者失败的弹窗
class LuckyWheelSuccessOrFailedDialog extends StatelessWidget {
  final bool isSuccess;
  final String successMoney;
  const LuckyWheelSuccessOrFailedDialog(
      {super.key, this.isSuccess = false, this.successMoney = ""});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 0.18.sh),
                width: 1.sw,
                height: 1051.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(isSuccess
                            ? Assets
                                .theme1.images.user.wheelDialogBgSuccess.path
                            : Assets
                                .theme1.images.user.wheelDialogBgFail.path))),
                child: isSuccess
                    ? Column(
                        children: [
                          SizedBox(
                            height: 550.h,
                          ),
                          _buildSuccessText(),
                          Container(
                            margin: EdgeInsets.only(
                                left: 300.w, right: 300.w, top: 80.h),
                            height: 115.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(66.r)),
                            child: Text(
                              "继续抽奖",
                              style: TextStyle(
                                  fontSize: 54.sp, color: Colors.white),
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 620.h,
                          ),
                          Text(
                            "本次抽奖未中奖\n再接再厉，大奖等您来！",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 45.sp, color: Colors.red),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 300.w, right: 300.w, top: 100.h),
                            height: 115.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(66.r)),
                            child: Text(
                              "继续抽奖",
                              style: TextStyle(
                                  fontSize: 54.sp, color: Colors.white),
                            ),
                          )
                        ],
                      )),
            SizedBox(height: 80.h),
            CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.back();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 45.w,
                child: Icon(
                  Icons.close,
                  color: Color(colorCECECE),
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildSuccessText() {
    return Column(
      children: [
        RichText(
            text: TextSpan(
                text: "${successMoney}",
                style: TextStyle(fontSize: 100.sp, color: Colors.red),
                children: [
              TextSpan(text: "元", style: TextStyle(fontSize: 50.sp))
            ])),
        Text("恭喜您获得", style: TextStyle(fontSize: 45.sp, color: Colors.red)),
        SizedBox(
          height: 10.h,
        ),
        Text(
          "彩金已派发至您的账户钱包",
          style: TextStyle(fontSize: 33.sp),
        ),
      ],
    );
  }
}
