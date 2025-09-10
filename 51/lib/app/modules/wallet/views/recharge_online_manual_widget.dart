import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../../utils/common_color.dart';
import '../controllers/recharge_controller.dart';

/// 人工存款的充值方式
class RechargeOnlineManualWidget extends StatelessWidget {
  RechargeOnlineManualWidget({super.key});
  late RechargeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "官方充值专员",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(color2D2D2D)),
          ),
          SizedBox(
            height: 8.h,
          ),
          const Text("使用人工充值，为了您的资金安全，请勿添加除以下专员外的任何联系方式或第三方聊天应用"),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Color(colorEEEEEE)))),
                child: Row(
                  children: [
                    UnconstrainedBox(
                      child: CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: 62.w,
                        child: const Placeholder(),
                      ),
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("大额充值秒到"),
                              SizedBox(
                                width: 13.w,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 92.w,
                                height: 42.h,
                                decoration: BoxDecoration(
                                  color: index == 3
                                      ? Colors.red
                                      : const Color(color00DD6C),
                                  borderRadius: BorderRadius.circular(37.r),
                                ),
                                child: Text(
                                  index == 3 ? "忙碌" : "空闲",
                                  style: TextStyle(
                                      fontSize: 26.sp, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16.w, right: 10.w),
                            color: const Color(colorFFEFDF),
                            child: Text(
                              "额度：8632122",
                              style: TextStyle(
                                  color: const Color(colorFF5702),
                                  fontSize: 33.sp),
                            ),
                          ),
                          Text(
                            "支持：支付宝/微信/银行卡",
                            style: TextStyle(
                                fontSize: 36.sp,
                                color: const Color(color979797)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 184.w,
                      decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(79.r)),
                      height: 83.h,
                      alignment: Alignment.center,
                      child: Text(
                        "充值",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            },
            shrinkWrap: true,
          )
        ],
      ),
    );
  }
}
