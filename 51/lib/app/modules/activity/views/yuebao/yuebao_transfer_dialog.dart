import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_receive_button.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import '../../../../../utils/CommonRipple.dart';
import '../../controllers/controller_yuebao_page.dart';
import '../../widget/common_input_widget.dart';

/// 余额宝弹窗
class YuebaoTransferDialog extends StatefulWidget {
  final bool? isTransferIn;
  const YuebaoTransferDialog({
    super.key,
    this.isTransferIn = true,
  });

  @override
  State<YuebaoTransferDialog> createState() => _YuebaoTransferDialogState();
}

class _YuebaoTransferDialogState extends State<YuebaoTransferDialog> {
  late ControllerYuebaoPage controller;
  late bool showTitle;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ControllerYuebaoPage>()) {
      controller = Get.find();
    } else {
      controller = Get.put(ControllerYuebaoPage());
    }
  }

  @override
  void dispose() {
    Get.delete<ControllerYuebaoPage>();
    super.dispose();
  }

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
              color: context.customTheme?.dialogBgColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 50.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleWidget(),
                SizedBox(height: 30.h),
                Obx(() => _buildCenterWidget()),
                SizedBox(height: 40.h),
                Text(
                  widget.isTransferIn == true ? '转入金额' : '转出金额',
                  style: TextStyle(
                    fontSize: 46.sp,
                    color: context.customTheme?.titleColor,
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
            child: CommonRipple(
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
                  color: context.customTheme?.dialogXColor,
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
        widget.isTransferIn == true ? '转入' : '转出',
        style: TextStyle(
          fontSize: 52.sp,
          color: context.customTheme?.titleColor,
        ),
      ),
    );
  }

  // 构建icon
  Widget _buildIconWidget() {
    return SvgPicture.asset(
      widget.isTransferIn == true
          ? Assets.theme1.images.activity.yuebao.iconTransferIn
          : Assets.theme1.images.activity.yuebao.iconTransferOut,
      width: 64.w,
      height: 64.h,
      color: context.theme.primaryColor,
    );
  }

  // 构建盒子
  Widget _buildBalanceBoxWidget({
    required num money,
    required String title,
  }) {
    return Container(
      height: 210.h,
      width: 320.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: context.customTheme?.input2Color, // 背景颜色
        boxShadow: [
          BoxShadow(
            color: const Color(colorB7B7B7).withOpacity(0.25), // 颜色
            blurRadius: 6, // 阴影的模糊半径
            spreadRadius: 2, // 阴影的扩散半径
            offset: Offset(0, -2.h), // x, y 偏移
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 72.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.customTheme?.pageTwoBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r), // 左上角
                topRight: Radius.circular(30.r), // 右上角
                bottomLeft: const Radius.circular(0), // 左下角
                bottomRight: const Radius.circular(0), // 右下角
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 36.sp,
                  color: context.customTheme?.title3Color,
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              money == 0 ? '0' : parseNumber(money),
              style: TextStyle(
                color: context.theme.primaryColor,
                fontSize: 42.sp,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  /// 构建金额显示区域
  Widget _buildCenterWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBalanceBoxWidget(
            money: controller.balanceTreasure.value, title: '利息宝余额'),
        _buildIconWidget(),
        _buildBalanceBoxWidget(
            money: controller.acctBalance.value, title: '钱包金币'),
      ],
    );
  }

  /// 构建金额输入框
  Widget _buildInputWidget() {
    bool isTransferIn = widget.isTransferIn == true;

    double minDeposit =
        (controller.yuebaoDataConfig.value.deposit_amount_mini ?? 0) / 1000;
    double minBalance =
        (controller.yuebaoDataConfig.value.min_balance ?? 0) / 1000;
    double minVal = isTransferIn ? minDeposit : minBalance;

    double maxVal = isTransferIn
        ? controller.acctBalance.value
        : (controller.balanceTreasure.value - minVal);

    bool isReadOnly =
        isTransferIn ? controller.acctBalance.value < minVal : maxVal <= 0;
    return CommonInputWidget(
      minValue: 0,
      maxValue: maxVal,
      readOnly: isReadOnly,
      textInputType: const TextInputType.numberWithOptions(decimal: true),
      inputWidgetType: InputWidgetTypeEnum.customeType,
      defaultContent: controller.defaultTransferAmount.value,
      onChanged: (value) => controller.setTransferAmount(value),
      placeholder: isTransferIn ? '单笔最少转入${parseNumber(minVal)}' : '请输入转出金额',
      rightWidget: CommonRipple(
        onTap: () {
          AppManager.instance.tapVibrate();
          if (!isReadOnly) {
            controller.setMaxTransferAmount(truncateToFixed(maxVal, 3));
          }
        },
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Center(
            child: Text(
              '最大',
              style: TextStyle(
                color: context.theme.primaryColor,
                fontSize: 36.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double truncateToFixed(num value, int decimalPlaces) {
    num factor = pow(10, decimalPlaces).toDouble();
    return double.parse(
        ((value * factor).truncate() / factor).truncateToFixed(decimalPlaces));
  }

  /// 构建领取按钮
  Widget _buildReceiveBtnWidget() {
    bool isTransferIn = widget.isTransferIn == true;

    double minDeposit =
        (controller.yuebaoDataConfig.value.deposit_amount_mini ?? 0) / 1000;
    double minBalance =
        (controller.yuebaoDataConfig.value.min_balance ?? 0) / 1000;

    return CommonReceiveButton(
      title: isTransferIn ? '转入' : '转出',
      loading: controller.isTransferLoading.value,
      disabled: isTransferIn
          ? controller.acctBalance.value < minDeposit
          : (controller.balanceTreasure.value - minBalance) <= 0,
      onTap: () async {
        if (isTransferIn) {
          await controller.reqTransferInSafe();
        } else {
          await controller.reqTransferOutSafe();
        }
      },
    );
  }
}
