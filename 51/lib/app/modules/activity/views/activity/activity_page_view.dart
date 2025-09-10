import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_right_model/activity_pg_list.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_activity_page.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';

import 'package:flutter_tiyu_app/app/modules/activity/widget/empty_widget.dart';

import '../../../../../utils/CommonRipple.dart';
import '../../data/activity_bean.dart';
import './activity_list_item_widget.dart';

///活动页面
class ActivityPageView extends GetView<ControllerActivityPage> {
  const ActivityPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.customTheme?.pageBg,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Obx(() => _buildContentWidget(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    return Row(
      children: [
        _buildLeftBarWidget(context),
        Expanded(
          flex: 1,
          child: Obx(
            () => controller.tabList.isNotEmpty
                ? _buildNestedScrollView(context)
                : const SizedBox(),
          ),
        )
      ],
    );
  }

  Widget _buildNestedScrollView(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (metrics.atEdge &&
            metrics.pixels != 0 &&
            notification.direction == ScrollDirection.reverse) {
          controller.nextPage();
        } else if (metrics.atEdge &&
            metrics.pixels == 0 &&
            notification.direction == ScrollDirection.forward) {
          controller.previousPage();
        }
        return true;
      },
      child: PageView(
        controller: controller.pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          controller.jumpToPage(index);
        },
        children: controller.tabList.map((ele) {
          return _buildTabViewItem(context);
        }).toList(),
      ),
    );
  }

  Widget _buildLeftBarWidget(BuildContext context) {
    return Container(
      width: 200.w,
      height: 0.9.sh,
      margin: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...controller.tabList.map((tab) {
              int curIndex = controller.tabCurrentIndex.value;
              // 根据是否当前选中的tab来确定文本颜色
              bool isSelected = controller.tabList.indexOf(tab) == curIndex;
              String imgUrl = tab.categoryPic!;
              bool isSvg = imgUrl.endsWith(".svg");
              bool isNetImg = imgUrl.contains("http");
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  int index = controller.tabList.indexOf(tab);
                  controller.jumpToPage(index);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 26.h),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  constraints:
                      BoxConstraints(minWidth: 200.w, minHeight: 162.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: isSelected
                        ? context.theme.primaryColor.withOpacity(0.15)
                        : context.customTheme?.pageTwoBg,
                    border: isSelected
                      ? Border.all(
                        color: context.theme.primaryColor,
                        width: 0.5
                      ) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isSvg
                          ? tab.isShowCategoryPic == 1
                              ? SvgPicture.asset(
                                  isSelected ? tab.categoryPic2 ?? '' : imgUrl,
                                  width: 113.w,
                                  height: 99.h,
                                  colorFilter: isSelected
                                      ? const ColorFilter.mode(
                                          Color(colorFFFFFF),
                                          BlendMode.srcIn,
                                        )
                                      : null,
                                )
                              : const SizedBox()
                          : tab.isShowCategoryPic == 1
                              ? (isNetImg
                                  ? Image.network(
                                      isSelected
                                          ? tab.categoryPic2 ?? ''
                                          : imgUrl,
                                      width: 113.w,
                                      height: 99.h,
                                    )
                                  : Image.asset(
                                      imgUrl,
                                      width: 113.w,
                                      height: 99.h,
                                    ))
                              : const SizedBox(),
                      Text(
                        tab.categoryName ?? '',
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: isSelected
                              ? context.theme.primaryColor // 选中的颜色
                              : context.customTheme?.title2Color, // 未选中的颜色
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildTabViewItem(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.isTrue;
      final activityList = controller.rightModel.value.activityPgList;
      final isEmpty = activityList?.isEmpty ?? true;

      // Loading state
      if (isLoading && isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(context.theme.primaryColor),
          ),
        );
      }

      // Empty state
      if (isEmpty) {
        return const EmptyWidget();
      }

      // Content
      return _buildContentList();
    });
  }

  Widget _buildContentList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isFirstTab = controller.tabCurrentIndex.value == 0;
        final content = _buildScrollableContent(constraints);

        return NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.atEdge &&
                      notification.metrics.pixels == 0 &&
                      notification.direction == ScrollDirection.reverse) {
                    // Add haptic feedback or other actions here
                    return true;
                  }
                  return false;
                },
                child: content,
              );
      },
    );
  }

  Widget _buildScrollableContent(BoxConstraints constraints) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(30.w, 10.h, 10.w, 10.h),
      physics: const ClampingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...controller.rightModel.value.activityPgList!.map(
              (dataItem) => ActivityListItemWidget(dataItem: dataItem),
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldDisableListViewScroll(BuildContext context, double maxHeight) {
    List<ActivityListItemBean> data =
        controller.rightModel.value.activityPgList![controller.tabCurrentIndex.value] as List<ActivityListItemBean>;
    // Calculate approximate content height
    final itemHeight = 180.h; // Adjust this based on your item height
    final contentHeight = data.length * itemHeight;

    // Disable scrolling if content is shorter than viewport
    return contentHeight <= maxHeight;
  }
}
