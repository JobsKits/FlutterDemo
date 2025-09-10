// import 'dart:ui';
import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/rebate_bean.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/rebate_new/rebate_rule_dialog.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
// import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
// import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../../../data/new_home_game_tab_bean.dart';
import '../../controllers/controller_rebate_new_page.dart';

import 'rebate_view_receive_btn_widget.dart';
import 'rebate_view_card_item_widget.dart';

class RebateView extends GetView<ControllerRebatePage> {
  const RebateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: null,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: Column(
        children: [
          // 顶部组件
          Obx(() => _buildTopWidget()),
          // 内容区域
          Expanded(
            flex: 1,
            child: Obx(() => _buildContentWidget(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildTopWidget() {
    return RebateViewReceiveBtnWidget(
      amount: controller.reabteData.value.shuffle_amount_sum ?? 0,
      displayTomorr: controller.reabteData.value.rebate_time == 1,
      tomorrAmount: controller.reabteData.value.t_shuffle_amount_sum ?? 0,
      showReceive: controller.reabteData.value.is_auto == 0, // 自动返水领取
      onTabReceive: () {
        AppManager.instance.tapVibrate();
        controller.handleReceiveRebate();
      },
      onTabRecord: () {
        AppManager.instance.tapVibrate();
        controller.handleRebateRecord();
      },
      loading: controller.isLoading.value,
      historyLoading: controller.isHistoryLoading.value,
    );
  }

  Widget _buildLeftBarWidget(BuildContext context) {
    return Container(
      width: 170.w,
      height: 0.85.sh,
      margin: EdgeInsets.only(right: 30.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
          children: [
            // 动态生成 Tab 列表
            ..._buildTabList(context),
            // 返水记录按钮
            _buildRebateRecordButton(context),
            // 返水规则按钮
            _buildRebateRuleButton(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTabList(BuildContext context) {
    return controller.tabList.map((tab) {
      int curIndex = controller.currentTabIndex.value;
      bool isSelected = controller.tabList.indexOf(tab) == curIndex;
      String imgUrl = _getTabImageUrl(tab);

      return InkWell(
        onTap: () {
          AppManager.instance.tapVibrate();
          controller.jumpToPage(controller.tabList.indexOf(tab));
        },
        child: Container(
          height: 150.h,
          margin: EdgeInsets.only(bottom: 26.h),
          constraints: BoxConstraints(minWidth: 168.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: isSelected
                ? context.theme.primaryColor
                : context.customTheme?.pageTwoBg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 显示图标
              _buildTabIcon(imgUrl, isSelected),
              SizedBox(height: 10.h),
              // 显示游戏名称
              Text(
                tab.gameName,
                style: TextStyle(
                  fontSize: 42.sp,
                  color: isSelected
                      ? const Color(colorFFFFFF) // 选中的颜色
                      : const Color(colorC7CBD3), // 未选中的颜色
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  String _getTabImageUrl(dynamic tab) {
    NewHomeGameTabBean? gameItem = controller.homeController.homeCategoryList
        .firstWhereOrNull((item) => item.title.contains(tab.gameName));
    return gameItem?.iconPath ?? tab.imgUrl;
  }

  Widget _buildTabIcon(String imgUrl, bool isSelected) {
    bool isSvg = imgUrl.endsWith(".svg");
    bool isNetImg = imgUrl.contains("http");

    if (isSvg) {
      return SvgPicture.asset(
        imgUrl,
        width: 52.w,
        height: 52.h,
        colorFilter: isSelected
            ? const ColorFilter.mode(
                Color(colorFFFFFF),
                BlendMode.srcIn,
              )
            : null,
      );
    } else if (isNetImg) {
      return Image.network(
        imgUrl,
        width: 52.w,
        height: 52.h,
      );
    } else {
      return Image.asset(
        imgUrl,
        width: 52.w,
        height: 52.h,
      );
    }
  }

  Widget _buildRebateRecordButton(BuildContext context) {
    return InkWell(
      onTap: () {
        AppManager.instance.tapVibrate();
        controller.handleRebateRecord();
      },
      child: Container(
        height: 150.h,
        margin: EdgeInsets.only(bottom: 26.h),
        constraints: BoxConstraints(minWidth: 168.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: context.customTheme?.pageTwoBg,
        ),
        child: Center(
          child: Text(
            '返水\n记录',
            style: TextStyle(
              color: context.theme.primaryColor,
              fontSize: 42.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRebateRuleButton(BuildContext context) {
    return InkWell(
      onTap: () {
        AppManager.instance.tapVibrate();
        Get.dialog(RebateRuleDialog(rule: controller.reabteData.value.rule));
      },
      child: Container(
        height: 150.h,
        margin: EdgeInsets.only(bottom: 26.h),
        constraints: BoxConstraints(minWidth: 168.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: context.customTheme?.pageTwoBg,
        ),
        child: Center(
          child: Text(
            '返水\n规则',
            style: TextStyle(
              color: context.theme.primaryColor,
              fontSize: 42.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    return Row(
      children: [
        _buildLeftBarWidget(context),
        Expanded(child: _buildTabViewWidget()),
      ],
    );
  }

  // 构建tabView
  Widget _buildTabViewWidget() {
    return controller.tabList.isEmpty
        ? const SizedBox()
        : PageView(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.jumpToPage(index);
            },
            children: controller.tabList.map(
              (ele) {
                return Obx(() => _buildTabViewItem(ele.gameType));
              },
            ).toList(),
          );
  }

  Widget _buildTabViewItem(String gameType) {
    List<RebateDataChildItemBean> dataList =
        controller.reabteData.value.list?[int.parse(gameType)] ?? [];

    if (dataList.isEmpty) {
      return const SizedBox();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await controller.reqRebateData(); // 调用刷新数据的方法
      },
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          RebateDataChildItemBean itemData = dataList[index];
          return Container(
            margin: EdgeInsets.only(bottom: 30.h),
            child: RebateViewCardItemWidget(
              betAmount: itemData.play_amount ?? 0,
              play_id: num.parse(itemData.play_id!),
              imgUrl: controller.getImageUrl(
                gameType: gameType,
                playId: itemData.play_id!,
              ),
              proportion: itemData.scale ?? 0,
              reward: itemData.shuffle_amount ?? 0,
              percentage: itemData.next_scale ?? 0,
              upAmount: itemData.up_amount ?? 0,
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.reqRebateProportion(
                    gameType: int.parse(itemData.game_type!),
                    sgameType: int.parse(itemData.sgame_type!));
              },
            ),
          );
        },
      ),
    );
  }
}
