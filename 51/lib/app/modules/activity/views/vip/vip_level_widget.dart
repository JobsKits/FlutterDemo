import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_button.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';

import '../../controllers/controller_vip_page.dart';

enum VipRewardTypeEnum {
  promotion, // 晋级
  daily, // 日
  weekly, // 周
  month, // 周
}

class VipLevelWidget extends StatefulWidget {
  const VipLevelWidget({super.key});

  @override
  State<VipLevelWidget> createState() => _VipLevelWidgetState();
}

class _VipLevelWidgetState extends State<VipLevelWidget> {
  ControllerVipPage controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 348.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.theme1.images.activity.vip.vipLevelBg.path),
          fit: BoxFit.cover, // 使用 BoxFit.cover
          alignment: Alignment.topCenter, // 将图像对齐到顶部
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => _buildReceiveWidget()),
          SizedBox(height: 36.h),
          Obx(() => _buildRewardWidget()),
        ],
      ),
    );
  }

  Widget _buildReceiveWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            text: '待领取总奖金：',
            style: TextStyle(
              fontSize: 39.sp,
              color: context.theme.primaryColor,
            ),
            children: [
              TextSpan(
                text: ' ￥',
                style: TextStyle(
                  color: const Color(color3A373A),
                  fontSize: 42.sp,
                ),
              ),
              TextSpan(
                text: parseNumber(controller.totalReward.value),
                style: TextStyle(
                  color: const Color(color3A373A),
                  fontSize: 57.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 280.w,
          height: 94.h,
          child: CommonButton(
            title: controller.totalReward.value > 0 ? '一键领取' : '暂无领取',
            fontSize: 42,
            minHeight: 94,
            type: CommonButtonTypeEnum.LinearGradient,
            disabled: controller.totalReward.value <= 0,
            onTap: () {
              controller.handleReceive();
            },
            loading: controller.isReceiveLoading.value,
          ),
        )
      ],
    );
  }

  Widget _buildRewardWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildRewardItemWidget(
            type: VipRewardTypeEnum.promotion,
            amount: parseNumber(controller.levelReward.value),
            isLock: controller.isLevelReward.value,
          ),
          if (controller.dayHaveValue.value) ...[
            SizedBox(
              width: 30.w,
            ),
            _buildRewardItemWidget(
              type: VipRewardTypeEnum.daily,
              amount: parseNumber(controller.dayReward.value),
              isLock: controller.isDayReward.value,
            ),
          ],
          if (controller.weekHaveValue.value) ...[
            SizedBox(
              width: 30.w,
            ),
            _buildRewardItemWidget(
              type: VipRewardTypeEnum.weekly,
              amount: parseNumber(controller.weekReward.value),
              isLock: controller.isWeekReward.value,
            ),
          ],
          if (controller.monthHaveValue.value) ...[
            SizedBox(
              width: 30.w,
            ),
            _buildRewardItemWidget(
              type: VipRewardTypeEnum.month,
              amount: parseNumber(controller.monthReward.value),
              isLock: controller.isMonthReward.value,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRewardItemWidget({
    required VipRewardTypeEnum type,
    required String amount, // 金额
    required bool isLock,
  }) {
    return Stack(
      children: [
        Container(
          height: 160.h,
          constraints: BoxConstraints(minWidth: 350.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: const Color(colorFFFFFF),
            image: DecorationImage(
              image: AssetImage(
                  Assets.theme1.images.activity.vip.vipRewardBg.path),
              fit: BoxFit.cover, // 使用 BoxFit.cover
              alignment: Alignment.topCenter, // 将图像对齐到顶部
            ),
            // gradient: const RadialGradient(
            //   colors: [
            //     Color(0xFFECFDFF),
            //     Color(0xFFFFFFFF),
            //   ],
            //   stops: [0.36, 0.36], // 渐变的停止位置
            //   radius: 1.2, // 渐变半径
            //   center: Alignment(0.18, 0), // 渐变中心
            // ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8CD1DB).withOpacity(0.3), // 颜色
                blurRadius: 6, // 阴影的模糊半径
                spreadRadius: 1, // 阴影的扩散半径
                offset: Offset(0, -2.h), // x, y 偏移
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 50.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIcon(type),
              SizedBox(width: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      text: '',
                      style: const TextStyle(
                        color: Color(color3A373A),
                      ),
                      children: [
                        TextSpan(
                          text: '￥',
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: amount,
                          style: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTextWidget(type),
                ],
              )
            ],
          ),
        ),
        Positioned(left: 0, top: 0, child: _buildLockWidget(isLock))
      ],
    );
  }

  Widget _buildLockWidget(bool isLock) {
    return Container(
      width: 56.w,
      height: 49.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(!isLock
              ? Assets.theme1.images.activity.vip.vipLockBg.path
              : Assets.theme1.images.activity.vip.vipUnlockBg.path),
          fit: BoxFit.cover, // 使用 BoxFit.cover
        ),
        color: Colors.transparent,
      ),
      child: Center(
        child: SvgPicture.asset(
          !isLock
              ? Assets.theme1.images.activity.vip.iconLock
              : Assets.theme1.images.activity.vip.iconUnlock,
          width: 42.w,
          height: 42.h,
        ),
      ),
    );
  }

  Widget _buildTextWidget(VipRewardTypeEnum type) {
    switch (type) {
      case VipRewardTypeEnum.promotion:
        return Text(
          '晋级奖金',
          style: TextStyle(
            fontSize: 33.sp,
            color: const Color(color868686),
          ),
        );

      case VipRewardTypeEnum.daily:
        return Text(
          '日俸禄',
          style: TextStyle(
            fontSize: 33.sp,
            color: const Color(color868686),
          ),
        );

      case VipRewardTypeEnum.weekly:
        return Text(
          '周俸禄',
          style: TextStyle(
            fontSize: 33.sp,
            color: const Color(color868686),
          ),
        );

      case VipRewardTypeEnum.month:
        return Text(
          '月俸禄',
          style: TextStyle(
            fontSize: 33.sp,
            color: const Color(color868686),
          ),
        );
    }
  }

  // 构建ICON
  Widget _buildIcon(VipRewardTypeEnum type) {
    switch (type) {
      case VipRewardTypeEnum.promotion:
        return Image.asset(
          Assets.theme1.images.activity.vip.iconPromotion.path,
          width: 66.w,
          height: 66.h,
        );

      case VipRewardTypeEnum.daily:
        return Image.asset(
          Assets.theme1.images.activity.vip.iconDayReward.path,
          width: 66.w,
          height: 66.h,
        );

      case VipRewardTypeEnum.weekly:
        return Image.asset(
          Assets.theme1.images.activity.vip.iconWeekReward.path,
          width: 66.w,
          height: 66.h,
        );

      case VipRewardTypeEnum.month:
        return Image.asset(
          Assets.theme1.images.activity.vip.iconMonthReward.path,
          width: 66.w,
          height: 66.h,
        );
    }
  }
}
