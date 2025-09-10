import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../controllers/controller_yuebao_page.dart';

import 'yuebao_top_widget.dart';

class YuebaoView extends StatefulWidget {
  const YuebaoView({super.key});

  @override
  State<YuebaoView> createState() => _YuebaoViewState();
}

class _YuebaoViewState extends State<YuebaoView> {
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
    if (Get.arguments != null) {
      final arguments = Get.arguments as Map<String, dynamic>;
      showTitle = arguments['showTitle'] ?? false;
    } else {
      showTitle = false;
    }
  }

  @override
  void dispose() {
    Get.delete<ControllerYuebaoPage>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: showTitle == true
          ? AppBar(
              title: const Text("利息宝"),
              backgroundColor: context.customTheme?.navbarBg,
              centerTitle: true,
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: _buildBody(context),
        // child: SingleChildScrollView(
        //   child: _buildBody(),
        // ),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      children: [
        YuebaoTopWidget(),
        Divider(height: 1.h, color: const Color(colorE8E8E8)),
        _buildTabBar(context),
        Expanded(child: _buildTabView()),
      ],
    );
  }

  /// 构建Tab
  Widget _buildTabBar(BuildContext context) {
    return Container(
      width: Get.width,
      color: context.customTheme?.pageTwoBg,
      child: TabBar(
        controller: controller.tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
        padding: EdgeInsets.zero, // 去除整体的边距
        tabs: controller.tabData.map((ele) => Text(ele.title)).toList(),
        onTap: (index) {
          AppManager.instance.tapVibrate();
          controller.jumpToPage(index, isTab: true);
        },
        unselectedLabelColor: const Color(color8D8D8D), // 未选中文字颜色
        labelColor: context.theme.primaryColor, // 选中文字颜色
        indicatorSize: TabBarIndicatorSize.label, // 指示器大小计算方式
        indicatorColor: context.theme.primaryColor, // 指示器颜色
        automaticIndicatorColorAdjustment: true,
        dividerHeight: 0,
        labelStyle: TextStyle(fontSize: 42.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 42.sp),
      ),
    );
  }

  /// 构建内容区
  Widget _buildTabView() {
    return PageView(
      controller: controller.pageController,
      onPageChanged: (index) => controller.jumpToPage(index, isTab: false),
      children: controller.tabData
          .map(
            (ele) => Container(child: ele.child),
          )
          .toList(),
    );
  }
}
