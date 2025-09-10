// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import '../../../../utils/CommonRipple.dart';
import '../controllers/agent_center_controller.dart';

// 代理中心
class AgentCenterView extends GetView<AgentCenterController> {
  const AgentCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          "推广中心",
          style: TextStyle(
              fontSize: 57.sp, color: context.customTheme?.appbarText),
        ),
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          _buildAction(context),
        ],
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildTabBar(context), Expanded(child: _buildTabView())],
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    // if (controller.currentTabIndex.value == 2) {
    //   return CommonRipple(
    //     onTap: () {
    //       Get.toNamed(Routes.AGENT_CENTER_TRANSFER_SUB);
    //     },
    //     child: Padding(
    //       padding: EdgeInsets.only(right: 33.w),
    //       child: Text(
    //         '下级开户',
    //         style: TextStyle(
    //           fontSize: 45.sp,
    //           color: const Color(0xFFFF9A24),
    //         ),
    //       ),
    //     ),
    //   );
    // }
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        Get.toNamed(Routes.AGENT_CENTER_REGISTER);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 33.w),
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.theme1.images.agentCenter.iconAdd,
              width: 44.w,
              height: 44.h,
              color: context.customTheme?.appbarText,
            ),
            SizedBox(width: 10.w),
            Text(
              '下级开户',
              style: TextStyle(
                fontSize: 39.sp,
                color: context.customTheme?.appbarText,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 构建活动头部
  PreferredSize _buildTabBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w), // 统一左侧 padding 值
        child: Obx(
          () => TabBar(
            controller: controller.tabController,
            tabAlignment: TabAlignment.fill,
            labelPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            padding: EdgeInsets.zero, // 去除整体的边距
            // tabs: controller.agentCenterData
            //     .map((ele) => Text(ele.title))
            //     .toList(),
            tabs: controller.agentCenterData
                .map((ele) => Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.h,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            ele.title,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ))
                .toList(),
            onTap: (index) {
              if (controller.currentTabIndex.value != index) {
                AppManager.instance.tapVibrate();
              }
              controller.jumpToPage(index);
            },
            unselectedLabelColor: const Color(colorAFAFAF), // 未选中文字颜色
            labelColor: context.theme.primaryColor, // 选中文字颜色
            indicatorSize: TabBarIndicatorSize.label, // 指示器大小计算方式
            indicatorColor: context.theme.primaryColor, // 指示器颜色
            automaticIndicatorColorAdjustment: true,
            dividerHeight: 0,
            labelStyle: TextStyle(fontSize: 43.sp, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 43.sp),
          ),
        ),
      ),
    );
  }

  /// 构建内容区
  Widget _buildTabView() {
    return PageView(
      controller: controller.pageController,
      onPageChanged: (index) => controller.jumpToPage(index),
      children: controller.agentCenterData.map((ele) => ele.child).toList(),
    );
  }
}
