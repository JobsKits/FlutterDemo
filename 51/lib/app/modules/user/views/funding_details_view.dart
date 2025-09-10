import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/kernel/helpers/helper_account.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../controllers/funding_details_controller.dart';
import '../widget/funding_type_pop_widget.dart';

//交易明细、资金明细页面
class FundingDetailsView extends GetView<FundingDetailsController> {
  FundingDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (bool didPop, _) {
          FundingTypePopWidget.instance.hide();
        },
        child: Scaffold(
          backgroundColor: context.customTheme?.pageBg,
          appBar: AppBar(
            leading: BackButton(
              color: context.customTheme?.appbarText,
              onPressed: () {
                Get.back();
                dismissPop();
              },
            ),
            backgroundColor: context.customTheme?.navbarBg,
            title: Text(
              "资金明细",
              style: TextStyle(color: context.customTheme?.appbarText),
            ),
            centerTitle: true,
          ),
          body: _buildBody(context),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: Container(
          margin: EdgeInsets.only(top: 38.h, right: 33.w, left: 33.w),
          child: Column(
            children: [
              Row(
                children: [
                  CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        dismissPop();
                        FundingTypePopWidget.instance.show(
                            context, _buildTimeList(context),
                            top: controller.timeWidgetHeight);
                      },
                      child: Container(
                        key: controller.timeKey,
                        decoration: BoxDecoration(
                            color: context.customTheme?.selectBoxColor,
                            borderRadius: BorderRadius.circular(71.r),
                            border: Border.all(
                                color: context.customTheme?.lineColor ??
                                    Colors.white)),
                        height: 104.h,
                        width: 330.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Obx(() => Text(
                                "${controller.currentTimeName.value}",
                                style: TextStyle(
                                    color: context.customTheme?.title3Color))),
                            Icon(Icons.keyboard_arrow_down,
                                color: context.customTheme?.title3Color)
                          ],
                        ),
                      )),
                  SizedBox(
                    width: 38.w,
                  ),
                  CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      dismissPop();
                      FundingTypePopWidget.instance.show(
                          context, _buildTypeList(context),
                          top: controller.typeWidgetHeight);
                    },
                    child: Container(
                      key: controller.typeKey,
                      decoration: BoxDecoration(
                          color: context.customTheme?.selectBoxColor,
                          borderRadius: BorderRadius.circular(71.r),
                          border: Border.all(
                              color: context.customTheme?.lineColor ??
                                  Colors.white)),
                      height: 104.h,
                      width: 330.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Obx(() => Text("${controller.currentTypeName.value}",
                              style: TextStyle(
                                  color: context.customTheme?.title3Color))),
                          Icon(Icons.keyboard_arrow_down,
                              color: context.customTheme?.title3Color)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(child: _buildList()),
            ],
          ),
        ));
  }

  Widget _buildList() {
    return Obx(() => controller.fundingList.isNotEmpty
        ? ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller.scrollController,
            itemCount: controller.fundingList.length + 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == controller.fundingList.length) {
                return controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox();
              }
              return _buildItem2(context, index);
            })
        : SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: emptyWidget(),
          ));
  }

  Widget _buildItem(int index) {
    String busiTypeStr = controller.fundingList[index].busiType ?? '0';
    int busiType = int.tryParse(busiTypeStr) ?? 0;
    String title = HelperAccount.instance.getBalanceLogTitle(busiType);
    num totalAmount = controller.fundingList[index].totalAmount ?? 0;
    String amountStr = '';
    Color amountColor = Colors.green;
    if (totalAmount > 0) {
      amountStr = '+${totalAmount / 1000}';
      amountColor = Colors.red;
    } else {
      amountStr = '${totalAmount / 1000}';
      amountColor = Colors.green;
    }
    return Container(
      height: 330.h,
      margin: EdgeInsets.only(top: 24.h),
      width: double.infinity,
      padding: EdgeInsets.all(33.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 40.sp,
                        color: const Color(0xff3f4b4d),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      "备注:${controller.fundingList[index].busi_type_name}",
                      style: TextStyle(fontSize: 36.sp),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amountStr,
                    style: TextStyle(
                      fontSize: 48.sp,
                      color: amountColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    "成功",
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "订单号: ${controller.fundingList[index].operCode}",
                style: TextStyle(
                  fontSize: 33.sp,
                  color: Colors.grey,
                ),
              ),
              Text(
                "交易时间: ${DateTimeUtils.formatTimestamp(controller.fundingList[index].transDatetime?.toInt() ?? 0)}",
                style: TextStyle(
                  fontSize: 33.sp,
                  color: Colors.grey,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildItem2(BuildContext context, int index) {
    String busiTypeStr = controller.fundingList[index].transType ?? '0';
    int busiType = int.tryParse(busiTypeStr) ?? 0;
    String title = controller.typeList.firstWhereOrNull(
            (item) => item['trans_type'] == busiType)?['text'] ??
        "-";
    num totalAmount = controller.fundingList[index].totalAmount ?? 0;
    String amountStr = '';
    Color amountColor = Colors.green;
    if (totalAmount > 0) {
      amountStr = '+${(totalAmount / 1000).truncateToFixed(2)}';
      amountColor = Colors.red;
    } else {
      amountStr = (totalAmount / 1000).truncateToFixed(2);
      amountColor = Colors.green;
    }
    return Container(
      height: 200.h,
      margin: EdgeInsets.only(top: 36.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      decoration: BoxDecoration(
          color: context.customTheme?.pageTwoBg,
          borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 42.sp,
                            color: context.customTheme?.titleColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        (controller.fundingList[index].busi_type_name == null ||
                                controller
                                    .fundingList[index].busi_type_name!.isEmpty)
                            ? ""
                            : "(${controller.fundingList[index].busi_type_name})",
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: context.customTheme?.title2Color,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          AppManager.instance.tapVibrate();
                          Get.dialog(Dialog(
                            backgroundColor:
                                context.customTheme?.dialogBgColor ??
                                    Colors.white,
                            child: Container(
                              height: 480.h,
                              padding: EdgeInsets.only(
                                top: 56.w,
                                left: 40.w,
                                right: 40.w,
                              ),
                              decoration: BoxDecoration(
                                  color: context.customTheme?.dialogBgColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.r))),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      child: Column(
                                        children: [
                                          Text(
                                            "备注",
                                            style: TextStyle(
                                                fontSize: 60.sp,
                                                fontWeight: FontWeight.bold,
                                                color: context
                                                    .customTheme?.titleColor),
                                          ),
                                          SizedBox(
                                            height: 120.h,
                                          ),
                                          Text(
                                            "${controller.fundingList[index].remark}",
                                            style: TextStyle(
                                                fontSize: 52.sp,
                                                color: context
                                                    .customTheme?.title3Color),
                                          ),
                                        ],
                                      )),
                                  Positioned(
                                    right: 0,
                                    top: -40.h,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        AppManager.instance.tapVibrate();
                                        Get.back();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10.w),
                                        child: Icon(
                                          Icons.close,
                                          color:
                                              context.customTheme?.dialogXColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            Icons.error_outline,
                            size: 42.w,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "${DateTimeUtils.formatTimestamp(controller.fundingList[index].transDatetime?.toInt() ?? 0)}",
                    style: TextStyle(
                      fontSize: 33.sp,
                      color: context.customTheme?.title2Color,
                    ),
                  )
                ],
              ),
              Text(
                amountStr,
                style: TextStyle(
                  fontSize: 48.sp,
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeList(BuildContext context) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        FundingTypePopWidget.instance.hide();
      },
      child: Container(
        width: 1.sw,
        height: 1.sh,
        alignment: Alignment.topCenter,
        color: Colors.black.withOpacity(0.4),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: context.customTheme?.pageTwoBg,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r))),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
                alignment: Alignment.center,
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: controller.typeList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.92,
                    crossAxisSpacing: 18.w,
                    mainAxisSpacing: 18.w,
                  ),
                  itemBuilder: (context, index) {
                    return CommonRipple(
                        onTap: () {
                          AppManager.instance.tapVibrate();
                          controller.changeTypeIndex(index);
                          FundingTypePopWidget.instance.hide();
                          controller.updateType();
                        },
                        child: Obx(
                          () => Container(
                            alignment: Alignment.center,
                            height: 118.h,
                            decoration: BoxDecoration(
                                color:
                                    controller.currentTypeIndex.value == index
                                        ? context.theme.primaryColor
                                        : context.customTheme?.selectBoxColor,
                                borderRadius: BorderRadius.circular(27.r)),
                            child: Text(
                              "${controller.typeList[index]["text"]}",
                              style: TextStyle(
                                  fontSize: 42.sp,
                                  color:
                                      controller.currentTypeIndex.value == index
                                          ? context.customTheme?.msTextColor
                                          : context.customTheme?.mnTextColor),
                            ),
                          ),
                        ));
                  },
                )),
            SizedBox(
              height: 40.h,
            ),
            CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                FundingTypePopWidget.instance.hide();
              },
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

  Widget _buildTimeList(BuildContext context) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        FundingTypePopWidget.instance.hide();
      },
      child: Container(
        width: 1.sw,
        height: 1.sh,
        alignment: Alignment.topCenter,
        color: Colors.black.withOpacity(0.4),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: context.customTheme?.pageTwoBg,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.r),
                      bottomRight: Radius.circular(40.r))),
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
              alignment: Alignment.center,
              child: GridView.builder(
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
                  return CommonRipple(
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
                                  : context.customTheme?.selectBoxColor,
                              borderRadius: BorderRadius.circular(27.r)),
                          child: Text(
                            "${controller.timeList[index]["timeTitle"]}",
                            style: TextStyle(
                                fontSize: 42.sp,
                                color:
                                    controller.currentTimeIndex.value == index
                                        ? context.customTheme?.msTextColor
                                        : context.customTheme?.mnTextColor),
                          ),
                        ),
                      ));
                },
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                FundingTypePopWidget.instance.hide();
              },
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

  Widget emptyWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 300.h,
          ),
          Image.asset(
            Assets.theme1.images.user.noFundingDataBg.path,
            width: 480.w,
            height: 339.h,
          ),
          SizedBox(
            height: 76.h,
          ),
          Text(
            "暂无任何数据",
            style: TextStyle(fontSize: 36.sp, color: const Color(colorAAAFBB)),
          )
        ],
      ),
    );
  }

  void dismissPop() {
    if (FundingTypePopWidget.instance.isShowing()) {
      FundingTypePopWidget.instance.hide();
    }
  }
}
