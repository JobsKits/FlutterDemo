import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_info_qrcode_item.dart';
// import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_common_container.dart';

import '../controllers/recharge_detail_controller.dart';

///充值页面，充值的详情界面
class RechargeDetailView extends GetView<RechargeDetailController> {
  const RechargeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorF4F4F4),
      appBar: AppBar(
        title: Text(controller.title.value),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 60.w),
            child: SvgPicture.asset(
              Assets.theme1.images.recharge.iconCustom,
              width: 67.w,
              height: 67.h,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 200.h),
          margin: EdgeInsets.only(top: 44.h, left: 30.w, right: 30.w),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(horizontal: 50.w, vertical: 100.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36.r)),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "100",
                          style: TextStyle(
                              fontSize: 98.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "存入金额(USDT)",
                          style: TextStyle(
                              fontSize: 42.sp, color: const Color(color555555)),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 100.h),
                      height: 2.h,
                      color: const Color(colorEDEDED),
                    ),
                    SizedBox(
                      height: 48.h,
                    ),
                    RechargeInfoQrcodeItem(
                      usdtType: 'TRC20',
                      qrCodeAddr: '',
                      payNo: '0x2c7b2808dff3dd1f4863jjedjep2aaffekjfhfff',
                    ),
                  ],
                ),
              ),
              _buildPaymentInfo(),
              SizedBox(
                height: 45.h,
              ),
              _buildTips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      margin: EdgeInsets.only(top: 34.h),
      padding:
          EdgeInsets.only(top: 52.h, left: 67.w, right: 67.w, bottom: 82.h),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(36.r)),
      child: Column(
        children: [
          _buildOrderText(
              leftText: "剩余支付时间",
              rightText: "19:11",
              leftTextColor: const Color(color8D8D8D),
              rightTextColor: Colors.red),
          _buildOrderText(
            leftText: "汇率",
            rightText: "1 USDT ≈ 7.15 CNY",
            leftTextColor: const Color(color8D8D8D),
          ),
          _buildOrderText(
            leftText: "实际到账金额",
            rightText: "7.15 CNY",
            leftTextColor: const Color(color8D8D8D),
          ),
          _buildOrderText(
            leftText: "订单号",
            rightText: "3328374413",
            leftTextColor: const Color(color8D8D8D),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderText(
      {required String leftText,
      required String rightText,
      required Color leftTextColor,
      Color rightTextColor = Colors.black}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(leftText, style: TextStyle(fontSize: 42.sp, color: leftTextColor)),
        Text(
          rightText,
          style: TextStyle(fontSize: 42.sp, color: rightTextColor),
        ),
      ],
    );
  }

  Widget _buildTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "温馨提示",
          style: TextStyle(fontSize: 43.sp, color: Colors.red),
        ),
        RichText(
            text: TextSpan(
                text: "收款地址定期更换，",
                style:
                    TextStyle(fontSize: 36.sp, color: const Color(color8D8D8D)),
                children: const [
              TextSpan(text: "请勿保存作为长期使用", style: TextStyle(color: Colors.red)),
              TextSpan(text: "，收款前请确认与系统展示是否一致。"),
            ]))
      ],
    );
  }
}
