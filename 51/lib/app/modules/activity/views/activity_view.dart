import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

import '../controllers/activity_controller.dart';

///活动页面
class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(colorF4F4F4),
      appBar: ThemeService.to.currentTheme.value?.model == 'blue' ||
                ThemeService.to.currentTheme.value?.model == 'gold3'
        ? AppBar(
            title: null,
            centerTitle: true,
            toolbarHeight:
                statusBarHeight.h + kToolbarHeight.h, // 保证 AppBar 高度
            backgroundColor: context.customTheme?.navbarBg,
            automaticallyImplyLeading: false, // 统一左侧无返回按钮
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight.h),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w), // 统一左侧 padding 值
                child: Obx(() => _buildTabBar(context)),
              ),
            ),
          )
        : AppBar(
            title: null,
            centerTitle: true,
            toolbarHeight:
                statusBarHeight.h + kToolbarHeight.h * 2.2, // 保证 AppBar 高度
            backgroundColor: context.customTheme?.navbarBg,
            automaticallyImplyLeading: false, // 统一左侧无返回按钮
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight.h * 2.2),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w), // 统一左侧 padding 值
                child: Column(
                  children: [_buildTitle(context), _buildTabBar(context)],
                ),
              ),
            ),
          ),
      body: Obx(() => _buildTabView()),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(left: 33.w, right: 33.w),
        height: 150.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 325.w,
                  height: 78.h,
                  child: InkWell(
                    child: TenantManager.instance.tenantBean?.logoManage!
                                .firstWhere((value) => value.messageId == 29)
                                .picAddr
                                ?.isNotEmpty ??
                            false
                        ? Image.network(TenantManager
                                .instance.tenantBean?.logoManage!
                                .firstWhere((value) => value.messageId == 29)
                                .picAddr ??
                            '')
                        : SizedBox(),
                  ),
                ),
              ],
            ),
            Obx(() => LoginManager.instance.isLogin.value
                ? _buildWalletView(context)
                : _buildLoginWidget(context))
          ],
        ),
      ),
    );
  }

  Widget _buildWalletView(BuildContext context) {
    return Container(
      height: 78.h,
      decoration: BoxDecoration(
          color: context.customTheme?.pageTwoBg,
          borderRadius: BorderRadius.circular(79.r)),
      padding: EdgeInsets.only(left: 30.w, right: 2.w),
      child: Row(
        children: [
          Text(
            "￥${LoginManager.instance.balanceStr.value}",
            style: TextStyle(
                fontSize: 39.sp, color: context.customTheme?.titleColor),
          ),
          SizedBox(
            width: 20.w,
          ),
          GestureDetector(
            onTap: () {
              // controller.retrieveAndCheckBalance(true, '');
            },
            child: SvgPicture.asset(
              Assets.theme1.images.user.iconRefresh,
              width: 40.w,
              height: 40.h,
              colorFilter: ColorFilter.mode(
                  context.customTheme?.titleColor ?? Colors.transparent,
                  BlendMode.srcIn),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          GestureDetector(
            onTap: () {
              var isOpenVideo = TenantManager.instance.tenantBean!.isOpenVideo;
              controller.tabsController
                  .jumpToPage(isOpenVideo == 'true' ? 2 : 1);
            },
            child: Icon(
              Icons.add_circle_outlined,
              color: context.theme.primaryColor,
              size: 66.w,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginWidget(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 160.w,
          height: 72.h,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.r), // 设置圆角半径
                ),
                side: BorderSide(
                  color: context.theme.primaryColor, width: 1, // 边框宽度
                ),
              ),
              onPressed: () {
                showRegisterDialog();
              },
              child: Text(
                "注册",
                style: TextStyle(
                    fontSize: 42.sp, color: context.theme.primaryColor),
              )),
        ),
        SizedBox(
          width: 20.w,
        ),
        SizedBox(
          width: 160.w,
          height: 72.h,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.r), // 设置圆角半径
                  ),
                  backgroundColor: context.theme.primaryColor,
                  padding: EdgeInsets.zero),
              onPressed: () {
                showLoginDialog();
              },
              child: Text("登录",
                  style: TextStyle(fontSize: 42.sp, color: Colors.white))),
        ),
      ],
    );
  }
  /// Build the tab bar
  PreferredSizeWidget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: controller.tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      padding: EdgeInsets.zero,
      tabs: controller.activityData.asMap().entries.map((entry) {
        final index = entry.key;
        final ele = entry.value;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(ele.title),
            ),
            if (controller.shouldShowRedDot(index))
              Positioned(
                top: -5.h,
                right: -20.w,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  constraints: BoxConstraints(
                    minWidth: 40.w,
                    minHeight: 40.h,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      controller.tabsController.collections.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }).toList(),
      onTap: (index) {
        AppManager.instance.tapVibrate();
        bool isNotLogin = !LoginManager.instance.isLogin.value;
        if (![0, 1].contains(index) && isNotLogin) {
          controller.tabController.index = controller.currentTabIndex.value;
          showLoginDialog(callback: () {
            controller.jumpToPage(index);
          });
          return;
        } else {
          controller.jumpToPage(index);
        }
      },
      unselectedLabelColor: const Color(colorAFAFAF), // 未选中文字颜色
      labelColor: context.theme.primaryColor, // 选中文字颜色
      indicatorSize: TabBarIndicatorSize.label, // 指示器大小计算方式
      indicatorColor: [0, 1].contains(controller.currentTabIndex.value)
          ? Colors.transparent
          : context.theme.primaryColor, // 指示器颜色
      automaticIndicatorColorAdjustment: true,
      dividerHeight: 15.h,
      labelStyle: TextStyle(fontSize: 54.sp, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 54.sp),
    );
  }

  /// Build the tab view content
  Widget _buildTabView() {
    return TabBarView(
      controller: controller.tabController,
      children: controller.activityData.map((ele) => ele.child).toList(),
    );
  }
}