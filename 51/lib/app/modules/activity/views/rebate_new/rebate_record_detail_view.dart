// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/rebate_bean.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
// import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
// import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../../../../utils/CommonRipple.dart';
import '../../../../data/new_home_game_tab_bean.dart';
import '../../controllers/controller_rebate_new_page.dart';

// import 'rebate_view_receive_btn_widget.dart';
// import 'rebate_view_card_item_widget.dart';

class RebateRecordDetailView extends GetView<ControllerRebatePage> {
  const RebateRecordDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          '返水详情',
          style: TextStyle(
            color: context.customTheme?.appbarText,
            fontSize: 57.sp,
          ),
        ),
        centerTitle: true,
        leading: CommonRipple(
          onTap: () {
            AppManager.instance.tapVibrate();
            Get.back();
          },
          child: SizedBox(
            width: 54.w,
            height: 54.h,
            child: Center(
              child: SvgPicture.asset(
                Assets.theme1.images.common.iconBack,
                width: 34.w,
                height: 54.h,
                color: context.customTheme?.appbarText,
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Obx(() => _buildLeftWidget(context)),
          Expanded(flex: 1, child: _buildTabViewWidget(context))
        ],
      ),
    );
  }

  Widget _buildLeftWidget(BuildContext context) {
    return Container(
        width: 170.w,
        margin: EdgeInsets.only(right: 30.w),
        child: Column(
          children: [
            ...controller.tabList.map((tab) {
              int curIndex = controller.detailCurrentTabIndex.value;
              // 根据是否当前选中的tab来确定文本颜色
              bool isSelected = controller.tabList.indexOf(tab) == curIndex;

              String imgUrl = "";
              NewHomeGameTabBean? gameItem =
                  controller.homeController.homeCategoryList.firstWhereOrNull(
                      (item) => item.title.contains(tab.gameName));
              if (gameItem != null) {
                imgUrl = gameItem.iconPath;
              } else {
                imgUrl = tab.imgUrl;
              }

              bool isSvg = imgUrl.endsWith(".svg");
              bool isNetImg = imgUrl.contains("http");

              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  int index = controller.tabList.indexOf(tab);
                  controller.jumpToDetailPage(index);
                },
                child: Container(
                  height: 150.h,
                  constraints: BoxConstraints(minWidth: 168.w),
                  margin: EdgeInsets.only(bottom: 26.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: isSelected
                          ? context.theme.primaryColor.withOpacity(0.3)
                          : context.customTheme?.pageTwoBg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isSvg
                          ? SvgPicture.asset(
                              imgUrl,
                              width: 52.w,
                              height: 52.h,
                              colorFilter: isSelected
                                  ? const ColorFilter.mode(
                                      Color(colorFFFFFF),
                                      BlendMode.srcIn,
                                    )
                                  : null,
                            )
                          : (isNetImg
                              ? Image.network(
                                  imgUrl,
                                  width: 52.w,
                                  height: 52.h,
                                )
                              : Image.asset(
                                  imgUrl,
                                  width: 52.w,
                                  height: 52.h,
                                )),
                      SizedBox(height: 10.h),
                      Text(
                        tab.gameName,
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: isSelected
                              ? const Color(colorFFFFFF) // 选中的颜色
                              : const Color(colorC7CBD3), // 未选中的颜色
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        ));
  }

  // 构建tabView
  Widget _buildTabViewWidget(BuildContext context) {
    return controller.tabList.isEmpty
        ? const SizedBox()
        : PageView(
            controller: controller.detailPageController,
            onPageChanged: (index) {
              controller.jumpToDetailPage(index);
            },
            children: controller.tabList.map(
              (ele) {
                return _buildTabViewItem(context, ele.gameType);
              },
            ).toList(),
          );
  }

  /// 构建表头标题
  Widget _buildTableHeaderTitle(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 36.sp,
        color: context.customTheme?.titleColor,
        height: 1.1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTableBodyText(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 36.sp,
        color: context.customTheme?.title2Color,
        height: 1.1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<RebateHistoryDetailItemBean> _getData(String gameType) {
    switch (gameType) {
      case '100':
        return controller.historyDetailData.value.g100;
      case '101':
        return controller.historyDetailData.value.g101;
      case '102':
        return controller.historyDetailData.value.g102;
      case '103':
        return controller.historyDetailData.value.g103;
      case '104':
        return controller.historyDetailData.value.g104;
      case '106':
        return controller.historyDetailData.value.g106;
      default:
        return [];
    }
  }

  Widget _buildTabViewItem(BuildContext context, String gameType) {
    List<RebateHistoryDetailItemBean> dataList = _getData(gameType);

    return Column(children: [
      // 固定表头
      Container(
        color: context.customTheme?.pageTwoBg,
        height: 100.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _buildTableHeaderTitle(context, '游戏名称')),
            Expanded(child: _buildTableHeaderTitle(context, '打码量')),
            Expanded(child: _buildTableHeaderTitle(context, '返水比例')),
            Expanded(child: _buildTableHeaderTitle(context, '返水金币')),
          ],
        ),
      ),

      // 可滚动的表格内容
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              dataList.length,
              (index) {
                RebateHistoryDetailItemBean itemData = dataList[index];
                return Container(
                  height: 120.h,
                  color: index % 2 == 0
                      ? context.customTheme?.pageTwoBg
                      : const Color(colorFFFFFF),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _buildTableBodyText(
                            context, itemData.game_name ?? '-'),
                      ),
                      Expanded(
                        child: _buildTableBodyText(context,
                            parseNumber2((itemData.amount ?? 0) / 1000)),
                      ),
                      Expanded(
                        child: _buildTableBodyText(
                            context,
                            parseNumber2((itemData.scale ?? 0) / 1000) == "-"
                                ? "-"
                                : '${parseNumber2((itemData.scale ?? 0) / 1000)}%'),
                      ),
                      Expanded(
                        child: _buildTableBodyText(
                            context,
                            parseNumber2(
                                (itemData.shuffle_amount ?? 0) / 1000)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ]);
  }
}
