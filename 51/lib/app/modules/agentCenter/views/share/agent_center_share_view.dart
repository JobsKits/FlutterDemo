import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../controllers/agent_center_share_controller.dart';
import '../../../activity/widget/common_receive_button.dart';

import './agent_center_qr_view.dart';

// 推广分享
class AgentCenterShareView extends GetView<AgentCenterShareController> {
  const AgentCenterShareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: null,
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadWidget(context),
          SizedBox(height: 50.h),
          _buildPromoteWidget(context),
        ],
      ),
    );
  }

  Widget _buildHeadWidget(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 1400.h),
      decoration: ThemeService.to.currentTheme.value?.model == 'blackGold'
          ? BoxDecoration(
              color: context.customTheme?.pageBg,
            )
          : BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    Assets.theme1.images.agentCenter.promoteShareHeadBg.path),
                fit: BoxFit.cover, // 使用 BoxFit.cover
                alignment: Alignment.topCenter, // 确保顶部对齐
              ),
            ),
      child: Column(
        children: [
          _buildCommissionWidget(context),
          const AgentCenterQrView(),
        ],
      ),
    );
  }

  Widget _buildCommissionWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40.w, right: 50.w, top: 80.h, bottom: 60.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ThemeService.to.currentTheme.value?.model == 'blackGold'
                    ? Assets.theme1.images.agentCenter.iconWalletBlackGold.path
                    : Assets.theme1.images.agentCenter.iconWallet.path,
                width: 136.w,
                height: 136.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '可领取佣金',
                    style: TextStyle(
                      fontSize: 39.sp,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  RichText(
                    text: TextSpan(
                      text: controller.bonus.value,
                      style: TextStyle(
                        fontSize: 48.sp,
                        color: const Color(color888888),
                      ),
                      children: [
                        TextSpan(
                          text: '元',
                          style: TextStyle(fontSize: 36.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          CommonReceiveButton(
            title: '领取',
            height: 100,
            fontSize: 45,
            constraints: BoxConstraints(maxWidth: 256.w),
            disabled: double.parse(controller.bonus.value) <= 0,
            loading: controller.isLoading.value,
            onTap: () {
              DebounceThrottle.debounce(controller.reqGetYongJin)();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPromoteWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customTheme?.pageTwoBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context, '推广说明'),
          _buildImage(),
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 40.h),
            child: _buildRuleWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
        child: controller.ruleImageUrl.value.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: controller.ruleImageUrl.value,
                width: double.infinity,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    color: Color(theme01MainColor),
                  ), // 加载中动画
                ),
              )
            : const SizedBox.shrink(),
      );
    });
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 46.h,
          margin: EdgeInsets.only(right: 20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: context.theme.primaryColor,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 51.sp,
            color: context.customTheme?.titleColor,
          ),
        )
      ],
    );
  }

  Widget _buildRuleText(String title,
      {bool? large, EdgeInsetsGeometry? padding}) {
    bool isLarge = large == true;
    Text textWidget = Text(
      title,
      style: TextStyle(
        fontSize: isLarge ? 48.sp : 39.sp,
        color: Colors.black,
        fontWeight: isLarge ? FontWeight.w600 : FontWeight.w400,
        height: 1.5,
      ),
    );

    if (padding != null) {
      return Padding(
        padding: padding,
        child: textWidget,
      );
    }
    return textWidget;
  }

  Widget _buildRuleText1(BuildContext context, String title,
      {EdgeInsetsGeometry? padding}) {
    Text textWidget = Text(
      title,
      style: TextStyle(
        fontSize: 48.sp,
        color: context.customTheme?.titleColor,
        fontWeight: FontWeight.w600,
        height: 1.5,
      ),
    );

    if (padding != null) {
      return Padding(
        padding: padding,
        child: textWidget,
      );
    }
    return textWidget;
  }

  Widget _buildRuleText2(BuildContext context, String title,
      {bool? bold, EdgeInsetsGeometry? padding}) {
    bool isBold = bold == true;
    Text textWidget = Text(
      title,
      style: TextStyle(
        fontSize: 36.sp,
        color: context.customTheme?.titleColor,
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
        height: 1.5,
      ),
    );

    if (padding != null) {
      return Padding(
        padding: padding,
        child: textWidget,
      );
    }
    return textWidget;
  }

  Widget _buildRuleWidget(BuildContext context) {
    return Obx(() {
      return HtmlWidget(
        controller.popularizeTutorial.value,
        textStyle: TextStyle(
          fontSize: 36.sp,
          color: context.customTheme?.titleColor,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      );
    });
  }
}
