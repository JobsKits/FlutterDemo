import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import '../../controllers/controller_yuebao_page.dart';
import 'yuebao_transfer_dialog.dart';

class YuebaoTopWidget extends StatelessWidget {
  YuebaoTopWidget({super.key});

  final ControllerYuebaoPage controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 460.h),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-1.0, -1.0),
          end: const Alignment(-0.2, 0.4),
          colors: [
            context.theme.primaryColor,
            context.theme.primaryColor.withOpacity(0.3),
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(50.w, 20.h, 50.w, 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => _buildDepositWidget(context)),
          SizedBox(height: 50.h),
          Divider(
              height: 1.h, color: const Color(colorE8E8E8).withOpacity(0.5)),
          SizedBox(height: 50.h),
          Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '结算周期：${controller.standard.value}分钟',
                            style: TextStyle(
                              fontSize: 40.sp,
                              color: context.customTheme?.titleColor,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '待领取  ',
                                  style: TextStyle(
                                    fontSize: 40.sp,
                                    color: context.customTheme?.titleColor,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  '${controller.genAmount.value}',
                                  style: TextStyle(
                                    fontSize: 40.sp,
                                    color: Colors.red,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  '（可领取',
                                  style: TextStyle(
                                    fontSize: 40.sp,
                                    color: context.customTheme?.titleColor,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  '${controller.reciveAmount.value}',
                                  style: TextStyle(
                                    fontSize: 40.sp,
                                    color: Colors.red,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  ')',
                                  style: TextStyle(
                                    fontSize: 40.sp,
                                    color: context.customTheme?.titleColor,
                                    height: 1,
                                  ),
                                ),
                              ])
                        ]),
                    const Spacer(),
                    _buildReviceButtonWidget(context),
                  ]))
        ],
      ),
    );
  }

  Widget _buildDepositWidget(BuildContext context) {
    num amount = controller.balanceTreasure.value;
    num rate = (controller.yuebaoInterestData.value.day_skill ?? 0) / 100;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: SvgPicture.asset(
            Assets.theme1.images.activity.yuebao.iconPig,
            width: 105.w,
            height: 105.h,
          ),
        ),
        SizedBox(width: 30.w),
        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '已存入金额',
                      style: TextStyle(
                        color: context.theme.primaryColor,
                        fontSize: 40.sp,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      amount == 0 ? '0.00' : amount.truncateToFixed(2),
                      style: TextStyle(
                        color: context.customTheme?.titleColor,
                        fontSize: 48.sp,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0.h,
                left: 210.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(colorF70054), // 标签背景颜色
                    borderRadius: BorderRadius.circular(36.r), // 圆角
                  ),
                  child: Text(
                    '日利率：${parseNumber(rate)}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _buildOptButtonWidget(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildReviceButtonWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 184.w,
          child: CommonButton(
            title: '领取',
            bgColor: context.theme.primaryColor,
            color: const Color(colorFFFFFF),
            disabled: controller.reciveAmount.value <= 0.0 ? true : false,
            disabledBgColor: const Color(colorD4D4D4),
            disabledColor: const Color(color888888),
            borderRadius: 16,
            onTap: () {
              if (controller.reciveAmount.value <= 0.0) {
                return;
              }
              controller.clearTransferValue();
              controller.reqReviceYuEbao();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptButtonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 184.w,
          child: CommonButton(
            title: '转入',
            borderRadius: 16,
            onTap: () {
              Get.dialog(
                const YuebaoTransferDialog(
                  isTransferIn: true,
                ),
                barrierDismissible: false,
              );
            },
          ),
        ),
        SizedBox(width: 20.w),
        SizedBox(
          width: 184.w,
          child: CommonButton(
            title: '转出',
            bgColor: Colors.red,
            color: Colors.white,
            borderRadius: 16,
            onTap: () {
              controller.clearTransferValue();
              Get.dialog(
                const YuebaoTransferDialog(
                  isTransferIn: false,
                ),
                barrierDismissible: false,
              );
            },
          ),
        ),
      ],
    );
  }
}
