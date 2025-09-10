import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_receive_button.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../controllers/controller_yuebao_page.dart';
import '../../widget/common_input_widget.dart';

/// 余额宝购买弹窗
class YuebaoBuyPlanDialog extends StatefulWidget {
  final bool? isFixed;
  const YuebaoBuyPlanDialog({
    super.key,
    this.isFixed = true,
  });

  @override
  State<YuebaoBuyPlanDialog> createState() => _YuebaoBuyPlanDialogState();
}

class _YuebaoBuyPlanDialogState extends State<YuebaoBuyPlanDialog> {
  final ControllerYuebaoPage controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            width: 983.w,
            constraints: BoxConstraints(maxHeight: 900.h, minHeight: 800.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.r),
              color: const Color(colorFFFFFF),
            ),
            padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 50.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleWidget(),
                SizedBox(height: 30.h),
                // Obx(() => _buildCenterWidget()),
                _buildCenterWidget(),
                SizedBox(height: 40.h),
                Text(
                  widget.isFixed == true ? '购买金额' : '转入金额',
                  style: TextStyle(
                    fontSize: 46.sp,
                    color: const Color(color3B3B3B),
                  ),
                  textAlign: TextAlign.left,
                ),
                Obx(() => _buildInputWidget()),
                SizedBox(height: 70.h),
                Obx(() => _buildReceiveBtnWidget()),
              ],
            ),
          ),
          Positioned(
            top: 30.h,
            right: 30.w,
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

  // 构建标题
  Widget _buildTitleWidget() {
    return Center(
      child: Text(
        '购买方案',
        style: TextStyle(
          fontSize: 52.sp,
          color: const Color(color3B3B3B),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 106.w,
      height: 106.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(53.r),
        color: const Color(colorF6F6F6),
      ),
      child: Center(
        child: SvgPicture.asset(
          Assets.theme1.images.activity.yuebao.iconWallet,
          width: 65.w,
          height: 65.h,
        ),
      ),
    );
  }

  /// 构建金额显示区域
  Widget _buildCenterWidget() {
    num rate = double.tryParse(
            '${(controller.detailData.value.daily_rate ?? 0) / 100}') ??
        0.00;

    int day = int.parse('${controller.detailData.value.product_cycle ?? 0}');
    return Container(
      height: 210.h,
      // width: 320.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.white, // 背景颜色
        boxShadow: [
          BoxShadow(
            color: const Color(colorB7B7B7).withOpacity(0.25), // 颜色
            blurRadius: 6, // 阴影的模糊半径
            spreadRadius: 2, // 阴影的扩散半径
            offset: Offset(0, -2.h), // x, y 偏移
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        children: [
          _buildIcon(),
          SizedBox(width: 50.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.detailData.value.plan_name!,
                  style: TextStyle(
                    fontSize: 45.sp,
                    color: const Color(color3A373A),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '利率：',
                        style: TextStyle(
                          fontSize: 39.sp,
                          color: const Color(color868686),
                        ),
                        children: [
                          TextSpan(
                            text: ' ${rate.truncateToFixed(2)}%',
                            style: const TextStyle(
                              color: Color(colorD73F4C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 50.w),
                    Visibility(
                      visible: widget.isFixed == true,
                      child: RichText(
                        text: TextSpan(
                          text: '周期：',
                          style: TextStyle(
                            fontSize: 39.sp,
                            color: const Color(color868686),
                          ),
                          children: [
                            TextSpan(
                              text: ' ${parseNumber(day)}天',
                              style: const TextStyle(
                                color: Color(color5077CF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 构建金额输入框
  Widget _buildInputWidget() {
    bool isFixed = widget.isFixed == true;

    print('===> ${controller.detailData.value.toString()}');

    // 最小值
    double minVal = (controller.detailData.value.min_balance ?? 0) / 1000;
    // 最大值
    double maxVal = (controller.detailData.value.max_balance_limit ?? 0) / 1000;

    // 用户余额
    double balance = controller.acctBalance.value;

    String placeholder = '';

    String suffix = maxVal > 0 ? ', 最大${parseNumber(maxVal)}' : '';
    if (isFixed) {
      placeholder =
          minVal == 0 ? '请输入购买金额' : '单笔最少购买${parseNumber(minVal)}${suffix}';
    } else {
      placeholder =
          minVal == 0 ? '请输入转入金额' : '单笔最少转入${parseNumber(minVal)}${suffix}';
    }

    bool isReadOnly = balance < minVal || balance == 0;
    return CommonInputWidget(
      minValue: 0,
      maxValue: maxVal > balance ? balance : (maxVal == 0 ? balance : maxVal),
      readOnly: isReadOnly,
      textInputType: const TextInputType.numberWithOptions(decimal: true),
      inputWidgetType: InputWidgetTypeEnum.customeType,
      defaultContent: controller.defaultBuyAmount.value,
      onChanged: (value) => controller.setBuyAmount(value),
      placeholder: placeholder,
    );
  }

  /// 构建领取按钮
  Widget _buildReceiveBtnWidget() {
    bool isFixed = widget.isFixed == true;
    return CommonReceiveButton(
      title: isFixed ? '购买' : '转入',
      loading: controller.isDetailBtnLoading.value,
      onTap: () async {
        await controller.reqBuyPlan();
      },
    );
  }
}
