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
import '../../controllers/controller_rebate_new_page.dart';

// import 'rebate_view_receive_btn_widget.dart';
// import 'rebate_view_card_item_widget.dart';
import '../../widget/animated_top_sheet.dart';

class RebateProportionView extends GetView<ControllerRebatePage> {
  const RebateProportionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          '返水比例',
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
      body: Container(
        color: context.customTheme?.pageBg,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: Obx(() => _buildBody(context)),
      ),
    );
  }

  /// 构建表头标题
  Widget _buildTableHeaderTitle(BuildContext context, String text,
      {double? fontSize}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize ?? 36.sp,
        color: context.customTheme?.title3Color,
        height: 1.05,
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

  Widget _buildGameSelectWidget(
    BuildContext context, {
    required String title,
    required bool isLeft, // 左侧
    VoidCallback? onTap,
  }) {
    return CommonRipple(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(47.r),
          border: Border.all(
              color: context.customTheme?.lineColor ?? Colors.transparent),
          gradient: LinearGradient(
            colors: [
              context.customTheme?.selectBoxColor ?? Colors.transparent,
              context.customTheme?.selectBoxColor ?? Colors.transparent
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        height: 100.h,
        // constraints: BoxConstraints(minHeight: 94.h, maxHeight: 104.h),
        padding: EdgeInsets.fromLTRB(20.w, 0, 30.w, 0),
        margin:
            isLeft ? EdgeInsets.only(right: 10.w) : EdgeInsets.only(left: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildTableHeaderTitle(context, title)),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: SvgPicture.asset(
                Assets.theme1.images.common.iconArrowDown,
                width: 38.w,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeaderWidget(BuildContext context) {
    return SizedBox(
      // color: const Color(colorFFFFFF),
      height: 100.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 3,
            child: _buildGameSelectWidget(context,
                isLeft: true,
                title: controller.proportionGameName.value, onTap: () {
              AppManager.instance.tapVibrate();
              Get.dialog(
                AnimatedTopSheet(
                  topHeight: 360.h,
                  currentType: controller.proportionGameType.value,
                  dataList: controller.gameTaData,
                  onTap: (type) {
                    AppManager.instance.tapVibrate();
                    bool isChangeGameType =
                        type != controller.proportionGameType.value;
                    int sgameType = controller.proportionSubGameType.value;

                    if (isChangeGameType) {
                      List<RebateDataChildItemBean> dataList =
                          controller.reabteData.value.list?[type] ?? [];

                      sgameType = int.parse(dataList[0].sgame_type!);
                    }

                    controller.reqRebateProportion(
                      gameType: type,
                      sgameType: sgameType,
                      needLoading: true,
                    );
                  },
                ),
                barrierDismissible: false, // 禁止默认的点击遮罩关闭
                barrierColor: Colors.transparent,
              );
            }),
          ),
          Expanded(
            flex: 3,
            child: _buildGameSelectWidget(context,
                isLeft: false,
                title: controller.proportionSubGameName.value, onTap: () {
              AppManager.instance.tapVibrate();
              Get.dialog(
                AnimatedTopSheet(
                  topHeight: 360.h,
                  currentType: controller.proportionSubGameType.value,
                  dataList: controller.subGameTabData,
                  onTap: (type) {
                    AppManager.instance.tapVibrate();
                    controller.reqRebateProportion(
                      sgameType: type,
                      gameType: controller.proportionGameType.value,
                      needLoading: true,
                    );
                  },
                ),
                barrierDismissible: false, // 禁止默认的点击遮罩关闭
                barrierColor: Colors.transparent,
              );
            }),
          ),
          Expanded(flex: 2, child: _buildTableHeaderTitle(context, '有效投注')),
          Expanded(flex: 2, child: _buildTableHeaderTitle(context, '返水比例')),
        ],
      ),
    );
  }

  Widget _buildTableBodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: List.generate(controller.proportionData.length, (index) {
        RebateProportionChildItemBean itemData =
            controller.proportionData[index];

        return Container(
          height: 120.h,
          color: index % 2 == 0
              ? context.customTheme?.pageTwoBg
              : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 3,
                child: _buildTableBodyText(
                    context, controller.proportionGameName.value),
              ),
              Expanded(
                flex: 3,
                child: _buildTableBodyText(
                    context, controller.proportionSubGameName.value),
              ),
              Expanded(
                flex: 2,
                child: _buildTableBodyText(context,
                    '${parseNumber((itemData.shuffle_lower ?? 0) / 1000)}+'),
              ),
              Expanded(
                flex: 2,
                child: _buildTableBodyText(
                    context, '${parseNumber((itemData.scale ?? 0) / 1000)}%'),
              ),
            ],
          ),
        );
      })),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        // 固定表头
        _buildTableHeaderWidget(context),
        SizedBox(height: 30.h),
        // 可滚动的表格内容
        Expanded(child: _buildTableBodyWidget(context))
      ],
    );
  }
}
