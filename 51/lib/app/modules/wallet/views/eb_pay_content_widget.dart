import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_module_title_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_ok_button_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_quick_input_money_widget.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/common_color.dart';
import '../controllers/recharge_controller.dart';

///EBpay的充值方式
class EbPayContentWidget extends StatelessWidget {
  EbPayContentWidget({super.key});
  late RechargeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20.h),
          width: double.infinity,
          height: 303.h,
          decoration: BoxDecoration(
              color: const Color(colorD5F6FB),
              borderRadius: BorderRadius.circular(36.r)),
          child: Stack(
            children: [
              Container(
                height: 212.h,
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36.r)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // CircleAvatar(
                        //   child: Image.asset(
                        //     Assets.theme1.images.recharge.iconRecharge33.path,
                        //     width: 120.w,
                        //     height: 120.h,
                        //   ),
                        // ),
                        SizedBox(
                          width: 25.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "EBpay钱包",
                              style: TextStyle(
                                  fontSize: 45.sp, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text("￥0.00",
                                    style: TextStyle(
                                        fontSize: 45.sp,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 12.w,
                                ),
                                SvgPicture.asset(
                                  Assets.theme1.images.recharge.iconRefresh,
                                  width: 45.w,
                                  height: 45.h,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 267.w,
                      height: 87.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Text(
                        "购买余额",
                        style: TextStyle(color: Colors.white, fontSize: 43.sp),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 19.h,
                left: 60.w,
                right: 60.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "★使用EBpay钱包笔笔加送2% ，提现再送1%",
                      style: TextStyle(
                          fontSize: 33.sp, color: const Color(color00A7B7F)),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          Assets.theme1.images.recharge.iconDownload.path,
                          width: 33.w,
                          height: 33.h,
                        ),
                        Text(
                          "下载钱包",
                          style: TextStyle(
                              fontSize: 33.sp, color: const Color(color008B9E)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36.r), color: Colors.white),
          padding:
              EdgeInsets.only(left: 30.w, right: 30.w, top: 45.h, bottom: 45.h),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 42.w),
                alignment: Alignment.center,
                height: 126.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: const Color(colorFDEEEB)),
                child: Text(
                  "★使用EBpay钱包充值，资金更安全，私密性更高；笔笔加送2% ，提现再送1%。",
                  style: TextStyle(fontSize: 33.sp, color: Colors.red),
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              RechargeModuleTitleWidget(
                str: "充值金额",
                fontSize: 45.sp,
              ),
              Container(
                margin: EdgeInsets.only(top: 27.h),
                height: 130.h,
                decoration: BoxDecoration(
                    color: const Color(colorF4F4F4),
                    borderRadius: BorderRadius.circular(30.r)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50.w,
                    ),
                    Text(
                      "￥",
                      style: TextStyle(
                          fontSize: 50.sp, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: TextField(
                      cursorColor: context.theme.primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 60.h, left: 24.w),
                        hintText: "请输入金额，单笔存款10USDT~10000USDT",
                        hintStyle: TextStyle(
                          fontSize: 36.sp,
                          color: const Color(colorBCBCBC),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none, // 去除边框线
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none, // 去除边框线
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none, // 去除边框线
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 37.h,
              ),
              RechargeQuickInputMoneyWidget(),
              const RechargeOkButtonWidget(
                text: '确认充值',
              )
            ],
          ),
        )
      ],
    );
  }
}
