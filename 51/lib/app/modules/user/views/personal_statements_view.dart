import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/empty_widget.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../controllers/personal_statements_controller.dart';
import '../widget/funding_type_pop_widget.dart';

//个人报表页面
class PersonalStatementsView extends GetView<PersonalStatementsController> {
  const PersonalStatementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (bool didPop, _) {
          dismissPop();
        },
        child: Scaffold(
          backgroundColor: context.customTheme?.pageBg,
          appBar: AppBar(
            backgroundColor: context.customTheme?.navbarBg,
            leading: BackButton(
              color: context.customTheme?.appbarText,
              onPressed: () {
                Get.back();
                dismissPop();
              },
            ),
            title: Text(
              "报表",
              style: TextStyle(color: context.customTheme?.appbarText),
            ),
            centerTitle: true,
          ),
          body: _buildBody(context),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 33.w, right: 33.h, top: 33.h),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildTimeView(context),
                  ),
                  SizedBox(width: 30.w),
                  Expanded(
                    flex: 1,
                    child: _buildBigGameTypeView(context),
                  ),
                  SizedBox(width: 30.w),
                  Expanded(
                    flex: 1,
                    child: _buildTypeView(context),
                  ),
                  SizedBox(width: 30.w),
                  CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      controller.changeSort();
                    },
                    child: Obx(() => Row(
                          children: [
                            Text(
                              "${controller.listSortText}",
                              style: TextStyle(
                                  fontSize: 42.sp,
                                  color: context.customTheme?.titleColor),
                            ),
                            SizedBox(
                              width: 18.w,
                            ),
                            SvgPicture.asset(
                              Assets.theme1.images.user
                                  .iconPersonalStatementsArrow,
                              width: 40.w,
                              height: 40.h,
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(top: 45.h, left: 30.w, right: 30.w),
          child: Obx(() => controller.itemList.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.itemList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _buildItemView(context, index);
                  })
              : EmptyWidget()),
        ))
      ],
    );
  }

  Widget _buildItemView(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
      decoration: BoxDecoration(
          color: index % 2 == 0
              ? context.customTheme?.pageTwoBg
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: RichText(
                      text: TextSpan(
                          text: "${controller.itemList[index].dataTypeName}/",
                          style: TextStyle(
                            fontSize: 36.sp,
                            color: Color(colorA0A0A0),
                          ),
                          children: [
                    TextSpan(
                        text: "${controller.itemList[index].playName}",
                        style: TextStyle(color: Colors.black))
                  ]))),
              Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "注单量",
                          style: TextStyle(
                            fontSize: 36.sp,
                            color: Color(colorA0A0A0),
                          ),
                          children: [
                            TextSpan(
                                text:
                                    " ${controller.itemList[index].planCount}",
                                style: TextStyle(color: Colors.black))
                          ]))),
              Expanded(
                  child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                          text: "投注",
                          style: TextStyle(
                            fontSize: 36.sp,
                            color: Color(colorA0A0A0),
                          ),
                          children: [
                            TextSpan(
                                text:
                                    ((controller.itemList[index].playAmount?.toDouble() ?? 0) / 1000).truncateToFixed(2),
                                style: TextStyle(color: Colors.black))
                          ])))
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text("${controller.itemTime}",
                      style: TextStyle(
                          fontSize: 36.sp, color: Color(colorA0A0A0)))),
              Expanded(
                  child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                          text: "总输赢",
                          style: TextStyle(
                            fontSize: 36.sp,
                            color: Color(colorA0A0A0),
                          ),
                          children: [
                            TextSpan(
                                text:
                                    " ${((controller.itemList[index].profit?.toDouble() ?? 0) / 1000).truncateToFixed(2)}",
                                style:
                                    TextStyle(color: context.theme.primaryColor))
                          ]))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeView(BuildContext context) {
    return _buildSelectButton(context, onTap: () {
      AppManager.instance.tapVibrate();
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(context, child: _buildTypeGrid(), clickClose: () {
            AppManager.instance.tapVibrate();
            FundingTypePopWidget.instance.hide();
          }),
          top: controller.typeWidgetHeight);
    }, key: controller.typeKey, showName: controller.currentTypeName);
  }

  //游戏大类平台
  Widget _buildBigGameTypeView(BuildContext context) {
    return _buildSelectButton(context, onTap: () {
      AppManager.instance.tapVibrate();
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(context, child: _buildBigGameTypeGrid(),
              clickClose: () {
            AppManager.instance.tapVibrate();
            FundingTypePopWidget.instance.hide();
          }),
          top: controller.bigGameTypeWidgetHeight);
    },
        key: controller.bigGameTypeKey,
        showName: controller.currentBigGameTypeName);
  }

  Widget _buildTimeView(context) {
    return _buildSelectButton(context, onTap: () {
      AppManager.instance.tapVibrate();
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(context, child: _buildTimeGrid(), clickClose: () {
            AppManager.instance.tapVibrate();
            FundingTypePopWidget.instance.hide();
          }),
          top: controller.timeWidgetHeight);
    }, key: controller.timeKey, showName: controller.currentTimeName);
  }

  Widget _buildSelectButton(BuildContext context,
      {VoidCallback? onTap, Key? key, required RxString showName}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        key: key,
        decoration: BoxDecoration(
            color: context.customTheme?.selectBoxColor,
            borderRadius: BorderRadius.circular(71.r),
            border: Border.all(
                color: context.customTheme?.lineColor ?? Colors.white)),
        height: 104.h,
        padding: EdgeInsets.only(left: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Obx(
              () => FittedBox(
                fit: BoxFit.scaleDown, // 自动缩小以适配宽度
                child: Text(
                  showName.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: context.customTheme?.title2Color,
                    height: 1,
                  ),
                  maxLines: 2,
                ),
              ),
            )),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(colorBCBCBC),
            )
          ],
        ),
      ),
    );
  }

  _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.timeList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.92,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.changeTimeIndex(index);
              FundingTypePopWidget.instance.hide();
              controller.updateTime();
            },
            child: Obx(
              () => Container(
                alignment: Alignment.center,
                height: 118.h,
                decoration: BoxDecoration(
                    color: controller.currentTimeIndex.value == index
                        ? context.theme.primaryColor
                        : context.customTheme?.pageTwoBg,
                    borderRadius: BorderRadius.circular(27.r)),
                child: Text("${controller.timeList[index]["timeTitle"]}",
                    style: TextStyle(
                      fontSize: 42.sp,
                      color: controller.currentTimeIndex.value == index
                          ? context.customTheme?.msTextColor
                          : context.customTheme?.mnTextColor,
                    )),
              ),
            ));
      },
    );
  }

  //游戏大类弹窗列表
  _buildBigGameTypeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.tabList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.92,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              if (controller.currentTabIndex.value != index) {
                AppManager.instance.tapVibrate();
              }
              controller.changeTabIndex(index);
              FundingTypePopWidget.instance.hide();
            },
            child: Obx(
              () => Container(
                alignment: Alignment.center,
                height: 118.h,
                decoration: BoxDecoration(
                    color: controller.currentTabIndex.value == index
                        ? context.theme.primaryColor
                        : context.customTheme?.pageTwoBg,
                    borderRadius: BorderRadius.circular(27.r)),
                child: Text("${controller.tabList[index].title}",
                    style: TextStyle(
                      fontSize: 42.sp,
                      color: controller.currentTabIndex.value == index
                          ? context.customTheme?.msTextColor
                          : context.customTheme?.mnTextColor,
                    )),
              ),
            ));
      },
    );
  }

  _buildTypeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.platformList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.92,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              if (controller.currentTypeIndex.value != index) {
                AppManager.instance.tapVibrate();
              }
              controller.changeTypeIndex(index);
              FundingTypePopWidget.instance.hide();
              controller.updateType();
            },
            child: Container(
              alignment: Alignment.center,
              height: 118.h,
              decoration: BoxDecoration(
                  color: controller.currentTypeIndex.value == index
                      ? context.theme.primaryColor
                      : context.customTheme?.pageTwoBg,
                  borderRadius: BorderRadius.circular(27.r)),
              child: Text("${controller.platformList[index].play_cname}",
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: controller.currentTypeIndex.value == index
                        ? context.customTheme?.msTextColor
                        : context.customTheme?.mnTextColor,
                  )),
            ));
      },
    );
  }

  //构建选择弹窗的列表
  Widget _buildSelectList(BuildContext context,
      {required Widget child, VoidCallback? clickClose}) {
    return InkWell(
      onTap: clickClose,
      child: Container(
        width: 1.sw,
        height: 1.sh,
        alignment: Alignment.topCenter,
        color: Colors.black.withOpacity(0.4),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: context.customTheme?.navbarBg,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r))),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
                alignment: Alignment.center,
                child: child),
            SizedBox(
              height: 40.h,
            ),
            InkWell(
              onTap: clickClose,
              child: SvgPicture.asset(
                Assets.theme1.images.user.iconClosePop,
                width: 68.w,
                height: 44.h,
              ),
            )
          ],
        ),
      ),
    );
  }

  void dismissPop() {
    if (FundingTypePopWidget.instance.isShowing()) {
      FundingTypePopWidget.instance.hide();
    }
  }
}
