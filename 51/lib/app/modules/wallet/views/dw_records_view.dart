import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_manager.dart';
import '../../../../utils/clipboard_util.dart';
import '../../../../utils/common_color.dart';
import '../../user/widget/funding_type_pop_widget.dart';
import '../controllers/dw_records_controller.dart';

class DwRecordsView extends GetView<DwRecordsController> {
  const DwRecordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (bool didPop, _) {
          FundingTypePopWidget.instance.hide();
        },
        child: Scaffold(
          backgroundColor: context.customTheme?.pageBg,
          appBar: AppBar(
            backgroundColor: context.customTheme?.navbarBg,
            leading: BackButton(
              color: context.customTheme?.titleColor,
              onPressed: () {
                Get.back();
                dismissPop();
              },
            ),
            title: Text("交易记录",
                style: TextStyle(color: context.customTheme?.titleColor)),
            centerTitle: true,
          ),
          body: _buildBody(context),
        ));
  }

  Widget _buildBody(context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          margin: EdgeInsets.only(left: 33.w, right: 33.h, top: 33.h),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    // flex: ,
                    child: _buildPlatformView(context),
                  ),
                  SizedBox(width: 38.w),
                  Expanded(
                    // flex: 1,
                    child: _buildStatusView(context),
                  ),
                  SizedBox(width: 38.w),
                  Expanded(
                    // flex: 1,
                    child: _buildTimeView(context),
                  ),
                  SizedBox(width: 38.w),
                ],
              ),
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: controller.refreshData,
                      child: _buildContentList())),
            ],
          ),
        ))
      ],
    );
  }

  Widget _buildContentList() {
    return Obx(() => controller.recordsList.isNotEmpty
        ? ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.recordsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _buildItem(context, index);
            })
        : emptyWidget());
  }

  Widget _buildItem(BuildContext context, int index) {
    var item = controller.recordsList[index];
    return InkWell(
      onTap: () {
        AppManager.instance.tapVibrate();
        print("输出一下这里的数据是:${item.toString()}");
        Get.dialog(
            Dialog(
              backgroundColor: Colors.transparent,
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      width: 1.sw,
                      padding: EdgeInsets.all(50.h),
                      decoration: BoxDecoration(
                          color: context.customTheme?.dialogBgColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.r))),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  getStatusIcon(item.frontStatus),
                                  width: 160.w,
                                  height: 160.h,
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),
                                Text(
                                    "${item.chgCurr == "chg" ? "+" : "-"}${((item.deposit ?? 0) / 1000).truncateToFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 62.sp,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            context.customTheme?.titleColor)),
                                Divider(
                                  color: context.customTheme?.lineColor,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "状态",
                                      style: TextStyle(
                                          color:
                                              context.customTheme?.title2Color,
                                          fontSize: 36.sp),
                                    ),
                                    Text(getStatusTxt(item.frontStatus),
                                        style: TextStyle(
                                            color: context
                                                .customTheme?.titleColor)),
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                if (item.chgCurr == "chg") ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "充值方式",
                                        style: TextStyle(
                                            color: context
                                                .customTheme?.title2Color,
                                            fontSize: 36.sp),
                                      ),
                                      Text("${item.custPayName}",
                                          style: TextStyle(
                                              color: context
                                                  .customTheme?.titleColor)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  )
                                ],
                                if (item.chgCurr == "with") ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "提现方式",
                                        style: TextStyle(
                                            color: context
                                                .customTheme?.title2Color,
                                            fontSize: 36.sp),
                                      ),
                                      Text("${item.custPayName}",
                                          style: TextStyle(
                                              color: context
                                                  .customTheme?.titleColor)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  )
                                ],
                                if (item.chgCurr == "chg" &&
                                    item.sourcetypeName?.isNotEmpty ==
                                        true) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "充值通道",
                                        style: TextStyle(
                                            color: context
                                                .customTheme?.title2Color,
                                            fontSize: 36.sp),
                                      ),
                                      Text("${item.sourcetypeName}",
                                          style: TextStyle(
                                              color: context
                                                  .customTheme?.titleColor)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  )
                                ],
                                if (item.orderNo?.isNotEmpty == true) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "订单号",
                                        style: TextStyle(
                                            color: context
                                                .customTheme?.title2Color,
                                            fontSize: 36.sp),
                                      ),
                                      Row(
                                        children: [
                                          Text("${item.orderNo}",
                                              style: TextStyle(
                                                  color: context.customTheme
                                                      ?.titleColor)),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              AppManager.instance.tapVibrate();
                                              ClipboardUtil.copy(item.orderNo);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 8.h),
                                              child: SvgPicture.asset(
                                                Assets.theme1.images.common
                                                    .copySn,
                                                width: 30.w,
                                                height: 30.h,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Color(colorA9A9A9),
                                                        BlendMode.srcIn),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  )
                                ],
                                if (item.payType == 187) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "汇率",
                                        style: TextStyle(
                                            color: context
                                                .customTheme?.title2Color,
                                            fontSize: 36.sp),
                                      ),
                                      Text("${item.rate ?? 0}",
                                          style: TextStyle(
                                              color: context
                                                  .customTheme?.titleColor)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                ],
                                if (item.chgCurr == "with") ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "手续费",
                                        style: TextStyle(
                                            color: context
                                                .customTheme?.title2Color,
                                            fontSize: 36.sp),
                                      ),
                                      Text(
                                          ((item.handFee ?? 0) / 1000).truncateToFixed(2),
                                          style: TextStyle(
                                              color: context
                                                  .customTheme?.titleColor)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                ],
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "到账金额",
                                      style: TextStyle(
                                          color:
                                              context.customTheme?.title2Color,
                                          fontSize: 36.sp),
                                    ),
                                    Text(
                                        (double.parse(
                                                    ((item.deposit ?? 0) / 1000)
                                                        .truncateToFixed(2)) -
                                                double.parse(
                                                    ((item.handFee ?? 0) / 1000)
                                                        .truncateToFixed(2)))
                                            .truncateToFixed(2),
                                        style: TextStyle(
                                            color: context
                                                .customTheme?.titleColor)),
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "创建时间",
                                      style: TextStyle(
                                          color:
                                              context.customTheme?.title2Color,
                                          fontSize: 36.sp),
                                    ),
                                    Text(
                                        DateTimeUtils.formatTimestamp(
                                            (item.createTime ?? 0).toInt()),
                                        style: TextStyle(
                                            color: context
                                                .customTheme?.titleColor)),
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                if (item.chgCurr == "with" &&
                                    item.remark?.isNotEmpty == true)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "订单备注",
                                        style: TextStyle(
                                            color: context
                                                .customTheme?.title2Color,
                                            fontSize: 36.sp),
                                      ),
                                      SizedBox(width: 20.w),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            item.remark ?? '',
                                            style: const TextStyle(
                                                color: Colors.red),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    CircleAvatar(
                        radius: 40.w,
                        backgroundColor: Colors.white,
                        child: InkWell(
                          onTap: () {
                            AppManager.instance.tapVibrate();
                            Get.back();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Color(0xffc6c6c6),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            barrierDismissible: false);
      },
      child: Container(
        margin: EdgeInsets.only(top: 26.h),
        decoration: BoxDecoration(
            color: context.customTheme?.pageTwoBg,
            borderRadius: BorderRadius.circular(30.r)),
        padding: EdgeInsets.all(30.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${item.custPayName}",
                  style: TextStyle(
                      fontSize: 42.sp,
                      fontWeight: FontWeight.bold,
                      color: context.customTheme?.titleColor),
                ),
                Text(
                    "${item.chgCurr == "chg" ? "+" : "-"}${((item.deposit ?? 0) / 1000).truncateToFixed(2)}",
                    style: TextStyle(
                        fontSize: 42.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffDD9D51)))
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateTimeUtils.formatTimestamp((item.createTime ?? 0).toInt()),
                  style: TextStyle(
                      fontSize: 33.sp, color: context.customTheme?.title2Color),
                ),
                Text(
                  getStatusTxt(item.frontStatus),
                  style: TextStyle(
                      fontSize: 40.sp,
                      color: getStatusColor(context, item.frontStatus)),
                )
              ],
            ),
            Divider(
              color: context.customTheme?.lineColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                    visible: item.orderNo?.isNotEmpty == true,
                    child: Row(
                      children: [
                        Text(
                          "订单号：${item.orderNo}",
                          style:
                              TextStyle(color: context.customTheme?.titleColor),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        InkWell(
                          onTap: () {
                            AppManager.instance.tapVibrate();
                            ClipboardUtil.copy(item.orderNo);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 8.h),
                            child: SvgPicture.asset(
                              Assets.theme1.images.common.copySn,
                              width: 30.w,
                              height: 30.h,
                              colorFilter: const ColorFilter.mode(
                                  Color(colorA9A9A9), BlendMode.srcIn),
                            ),
                          ),
                        )
                      ],
                    )),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: context.customTheme?.arrowColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String getStatusTxt(num? status) {
    String statusTxt = "处理中";
    switch (status) {
      case 2:
        statusTxt = "成功";
        break;
      case 3:
        statusTxt = "失败";
        break;
      default:
        statusTxt = "处理中";
        break;
    }
    return statusTxt;
  }

  String getStatusIcon(num? status) {
    String statusTxt = Assets.theme1.images.recharge.iconRecordsIng;
    switch (status) {
      case 2:
        statusTxt = Assets.theme1.images.recharge.iconRecordsSuccess;
        break;
      case 3:
        statusTxt = Assets.theme1.images.recharge.iconRecordsFail;
        break;
      default:
        statusTxt = Assets.theme1.images.recharge.iconRecordsIng;
        break;
    }
    return statusTxt;
  }

  //拿到对应状态的颜色，1-处理中，2-成功，3-失败
  Color getStatusColor(BuildContext context, num? status) {
    Color statusColor = context.theme.primaryColor;
    switch (status) {
      case 2:
        statusColor = Colors.green;
        break;
      case 3:
        statusColor = Colors.red;
        break;
      default:
        statusColor = context.theme.primaryColor;
        break;
    }
    return statusColor;
  }

  Widget _buildTimeView(BuildContext context) {
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

  Widget _buildPlatformView(BuildContext context) {
    return _buildSelectButton(context, onTap: () {
      AppManager.instance.tapVibrate();
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(context, child: _buildPlatformGrid(),
              clickClose: () {
            AppManager.instance.tapVibrate();
            FundingTypePopWidget.instance.hide();
          }),
          top: controller.timeWidgetHeight);
    }, key: controller.platformKey, showName: controller.currentPlatformName);
  }

  Widget _buildStatusView(BuildContext context) {
    return _buildSelectButton(context, onTap: () {
      AppManager.instance.tapVibrate();
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(context, child: _buildStatusGrid(), clickClose: () {
            AppManager.instance.tapVibrate();
            FundingTypePopWidget.instance.hide();
          }),
          top: controller.timeWidgetHeight);
    }, key: controller.typeKey, showName: controller.currentStatusName);
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
                color: context.customTheme?.lineColor ?? Colors.transparent)),
        height: 104.h,
        padding: EdgeInsets.only(left: 30.w, right: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Obx(
                () => Text(
                  textAlign: TextAlign.center,
                  showName.value,
                  style: TextStyle(
                    fontSize: 42.sp,
                    color: context.customTheme?.title3Color,
                    height: 1,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(colorBCBCBC),
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
                child: Text(
                  "${controller.timeList[index]["timeTitle"]}",
                  style: TextStyle(
                      fontSize: 42.sp,
                      color: controller.currentTimeIndex.value == index
                          ? context.customTheme?.msTextColor
                          : context.customTheme?.mnTextColor),
                ),
              ),
            ));
      },
    );
  }

  _buildPlatformGrid() {
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
              if (controller.currentPlatformIndex != index) {
                AppManager.instance.tapVibrate();
              }
              controller.changePlatformIndex(index);
              controller.currentPlatformName.value =
                  controller.platformList[index]["platformTitle"];
              FundingTypePopWidget.instance.hide();
            },
            child: Container(
              alignment: Alignment.center,
              height: 118.h,
              decoration: BoxDecoration(
                  color: controller.currentPlatformIndex == index
                      ? context.theme.primaryColor
                      : context.customTheme?.pageTwoBg,
                  borderRadius: BorderRadius.circular(27.r)),
              child: Text(
                "${controller.platformList[index]["platformTitle"]}",
                style: TextStyle(
                    fontSize: 42.sp,
                    color: controller.currentPlatformIndex == index
                        ? context.customTheme?.msTextColor
                        : context.customTheme?.mnTextColor),
              ),
            ));
      },
    );
  }

  _buildStatusGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.statusList.length,
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
              controller.changeStatusIndex(index);
              controller.currentStatusName.value =
                  controller.statusList[index]["statusTitle"];
              FundingTypePopWidget.instance.hide();
              controller.updateStatus();
            },
            child: Container(
              alignment: Alignment.center,
              height: 118.h,
              decoration: BoxDecoration(
                  color: controller.currentStatusIndex == index
                      ? context.theme.primaryColor
                      : context.customTheme?.pageTwoBg,
                  borderRadius: BorderRadius.circular(27.r)),
              child: Text(
                "${controller.statusList[index]["statusTitle"]}",
                style: TextStyle(
                    fontSize: 42.sp,
                    color: controller.currentStatusIndex == index
                        ? context.customTheme?.msTextColor
                        : context.customTheme?.mnTextColor),
              ),
            ));
      },
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
}
