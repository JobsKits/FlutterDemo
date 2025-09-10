import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

// import 'package:flutter_tiyu_app/gen/assets.gen.dart';

import '../../../../theme/theme.service.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../routes/app_pages.dart';
import '../controllers/recharge_controller.dart';
import '../data//recharge_type_bean.dart';
import '../widget/recharge_expand_widget.dart';
import './recharge_offline_view.dart';
import './recharge_online_widget.dart';
import './recharge_quick_view.dart';

///充值主页面钱包
class RechargeView extends StatefulWidget {
  const RechargeView({super.key});

  @override
  State<RechargeView> createState() => _RechargeViewState();
}

class _RechargeViewState extends State<RechargeView> {
  RechargeController controller =
      Get.put(RechargeController(), permanent: true);
  @override
  void dispose() {
    Get.delete<RechargeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        backgroundColor: context.customTheme?.pageBg,
        // appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildAppBar2(context),
            Expanded(
                child: RefreshIndicator(
              onRefresh: controller.initData,
              child: _buildBody(context),
            ))
          ],
        ),
      ),
    );
  }

  _buildAppBar2(BuildContext context) {
    return Container(
      color: context.customTheme?.navbarBg,
      width: double.infinity,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20.h,
          bottom: 20.h,
          left: 40.w,
          right: 40.w),
      child: Stack(
        children: [
          Positioned(
              child: Container(
            padding: EdgeInsets.only(right: 12.w),
            margin: EdgeInsets.only(right: 33.w),
            decoration: BoxDecoration(
                color: context.customTheme?.pageTwoBg,
                borderRadius: BorderRadius.circular(35.r)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70.w,
                  height: 70.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.r),
                      color: context.theme.primaryColor),
                  child: Text(
                    "￥",
                    style: TextStyle(
                        fontSize: 41.sp,
                        color: context.customTheme?.rechargeMoneyColor),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Obx(() => Text(
                      LoginManager.instance.balanceStr.value,
                      style: TextStyle(
                          fontSize: 41.sp,
                          color: context.customTheme?.titleColor),
                    )),
                SizedBox(
                  width: 20.w,
                ),
                _buildRefreshIcon(),
              ],
            ),
          )),
          Center(
              child: Text(
            "充值",
            style: TextStyle(
                color: context.customTheme?.titleColor, fontSize: 51.sp),
          )),
          Positioned(
            right: 0,
            child: Row(
              children: [
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    if (TenantManager.instance.isCanOpenCustomerService) {
                      Get.toNamed(Routes.CUSTOMER_SERVICE);
                    } else {
                      Get.toNamed(Routes.WEB_VIEW_INAPP, arguments: {
                        "url": TenantManager
                            .instance.tenantBean?.tenant?.onlineAddr, //请求地址
                        "title": "在线客服",
                      });
                    }
                  },
                  child: SvgPicture.asset(
                    Assets.theme1.images.user.iconCustomServiceSvg,
                    colorFilter:
                        ColorFilter.mode(Color(0xff949AB4), BlendMode.srcIn),
                    width: 60.w,
                    height: 60.h,
                  ),
                ),
                SizedBox(
                  width: 34.w,
                ),
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.toNamed(Routes.DW_RECORDS,
                        arguments: {"isRecharge": true});
                  },
                  child: SvgPicture.asset(
                    colorFilter:
                        ColorFilter.mode(Color(0xff949AB4), BlendMode.srcIn),
                    Assets.theme1.images.recharge.iconDwRecords,
                    width: 60.w,
                    height: 60.h,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //标题栏
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      // backgroundColor: const Color(colorF4F4F4),
      backgroundColor: const Color(colorF4F4F4),
      // title: const SizedBox(),
      title: _titleText("充值渠道", 51.sp),
      // leading: Center(
      //   child: Padding(
      //     padding: EdgeInsets.only(left: 33.w), // 调整左侧间距
      //     child: _titleText("充值渠道", 51.sp),
      //   ),
      // ),
      leadingWidth: 270.w,
      actions: [
        Container(
          padding: EdgeInsets.only(left: 12.w, right: 12.w),
          margin: EdgeInsets.only(right: 33.w),
          decoration: BoxDecoration(
              color: const Color(colorEDEDED),
              borderRadius: BorderRadius.circular(35.r)),
          child: Row(
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.r),
                    color: context.theme.primaryColor),
                child: Text(
                  "￥",
                  style: TextStyle(fontSize: 41.sp, color: Colors.white),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Obx(() => Text(
                    LoginManager.instance.balanceStr.value,
                    style: TextStyle(
                        fontSize: 41.sp, color: const Color(color434343)),
                  )),
              SizedBox(
                width: 20.w,
              ),
              _buildRefreshIcon(),
            ],
          ),
        )
      ],
    );
  }

  // 刷新Icon
  Widget _buildRefreshIcon() {
    return Obx(() {
      if (controller.isRefreshBalance.value) {
        return AnimatedBuilder(
          animation: controller.animationController,
          child: SvgPicture.asset(
            Assets.theme1.images.recharge.iconRefresh,
            width: 50.w,
            height: 50.h,
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: controller.animationController.value * 2.0 * pi, // 旋转角度
              child: child,
            );
          },
        );
      }

      return CommonRipple(
        onTap: () {
          AppManager.instance.tapVibrate();
          DebounceThrottle.debounce(controller.reqMoney)();
        },
        child: SvgPicture.asset(
          Assets.theme1.images.recharge.iconRefresh,
          width: 50.w,
          height: 50.h,
        ),
      );
    });
  }

  //内容主体
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller.rechargeScrollController,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 2500.h,
        ),
        child: Obx(() => controller.isShowErrorView.value
            ? errorView()
            : Column(
                children: [
                  _buildRechargeTypeTab(context),
                  SizedBox(
                    height: 32.h,
                  ),
                  Obx(() => controller.tabList.isNotEmpty
                      ? ((controller.tabList[controller.currentTabIndex.value]
                                  .isManualRecharge ??
                              false)
                          ? manualRechargeView(context)
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: Column(
                                children: [
                                  Obx(() => _buildRechargeTypeList()), //充值渠道列表
                                  Obx(() => controller
                                          .showRechargeTypeList.isNotEmpty
                                      ? _currentContentWidget()
                                      : _buildEmptyView()), //当前内容组件 ： 可以根据不同充值内容替换
                                  _buildBottomInfo() //底部信息栏
                                ],
                              ),
                            ))
                      : SizedBox())
                ],
              )),
      ),
    );
  }

  Widget errorView() {
    return Container(
      width: 1.sw,
      margin: EdgeInsets.only(top: 0.3.sh),
      child: Column(
        children: [
          Icon(
            Icons.error,
            color: Colors.grey,
            size: 100.w,
          ),
          SizedBox(
            height: 50.h,
          ),
          Text("请求异常，请下拉刷新重试!")
        ],
      ),
    );
  }

  //人工充值的UI
  Widget manualRechargeView(BuildContext context) {
    return Obx(() {
      if (controller.manualRechargeList.isNotEmpty) {
        String? desc;
        try {
          if (controller.manualBean.value?.value != null &&
              controller.manualBean.value!.value!.isNotEmpty) {
            desc = jsonDecode(controller.manualBean.value?.value ?? "")['desc'];
          }
        } catch (e) {
          print("转换出错：${e}");
        }
        bool isHasDesc = desc != null && desc!.isNotEmpty;

        return Container(
          width: double.infinity,
          padding:
              EdgeInsets.only(left: 44.w, right: 44.w, top: 46.h, bottom: 20.h),
          decoration: BoxDecoration(
              color: context.customTheme?.pageTwoBg,
              borderRadius: BorderRadius.circular(36.r)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isHasDesc
                    ? SizedBox()
                    : Text(
                        "官方充值专员",
                        style: TextStyle(
                            fontSize: 45.sp, fontWeight: FontWeight.bold),
                      ),
                SizedBox(
                  height: isHasDesc ? 0 : 8.h,
                ),
                isHasDesc
                    ? HtmlWidget(desc)
                    : Text(
                        "使用人工充值，为了您的资金安全，请勿添加除以下专员外的任何联系方式或第三方聊天应用",
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: Color(color979797),
                        ),
                      ),
                // RichText(
                //     text: TextSpan(
                //         text: "使用人工充值，额外",
                //         style: TextStyle(
                //             fontSize: 36.sp, color: Color(color979797)),
                //         children: [
                //       TextSpan(
                //           text: "加赠2%", style: TextStyle(color: Colors.red)),
                //       TextSpan(text: "，请勿添加除以下专员外的任何联系方式或第三方聊天应用。"),
                //     ])),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount:
                        controller.manualRechargeList[0]?.tenantPayInfo?.length,
                    itemBuilder: (context, index) {
                      return _buildManualRechargeItem(context, index);
                    })
              ],
            ),
          ),
        );
      } else {
        return Center(
          child: SizedBox(
            width: 126.w,
            height: 126.h,
            child: LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              colors: [context.theme.primaryColor],
            ),
          ),
        );
      }
    });
  }

  Widget _buildManualRechargeItem(BuildContext context, int index) {
    var item = controller.manualRechargeList[0]?.tenantPayInfo?[index];
    String imgDomain = TenantManager.instance.appImgDomainPath.value;
    String headImageUrl = item?.head ?? "";
    if (!headImageUrl.contains("http")) {
      if (!headImageUrl.startsWith("/")) {
        headImageUrl = "/$headImageUrl";
      }
      headImageUrl = "$imgDomain$headImageUrl";
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(colorEEEEEE), // 下划线颜色
            width: 1.h, // 下划线粗细
          ),
        ),
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: headImageUrl,
              width: 125.w,
              height: 125.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 30.w,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                      child: Text(
                    "${item?.channelCustomName ?? item?.payName}",
                    style: TextStyle(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w500,
                        color: context.customTheme?.rechargeSecondTypeBgColor),
                  )),
                  SizedBox(
                    width: 13.w,
                  ),
                  Container(
                    width: 92.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(color00DD6C),
                      borderRadius: BorderRadius.circular(25.h),
                    ),
                    child: Text(
                      "空闲",
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
                // crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Container(
                color: context.customTheme?.manualRechargeBgColor,
                margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                padding:
                    ThemeService.to.currentTheme.value?.model == "blackGold"
                        ? null
                        : EdgeInsets.only(left: 20.w, right: 20.w),
                child: Row(
                  children: [
                    Text(
                      "额度：",
                      style: TextStyle(
                        fontSize: 33.sp,
                        color: context.customTheme?.manualRechargeTxtColor1,
                      ),
                    ),
                    Text(
                      "${((item?.agentBalance ?? 0) / 1000)}",
                      style: TextStyle(
                        fontSize: 33.sp,
                        color: context.customTheme?.manualRechargeTxtColor2,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                "${item?.channelCustomName2}",
                style: TextStyle(
                  fontSize: 36.sp,
                  color: const Color(0xFF979797),
                ),
              ),
            ],
          )),
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              // print("输出信息：${item.toString()}");
              String url1 = item?.kf_url ?? "";
              String url2 = item?.qrCodeAddr ?? "";
              if (url1.isNotEmpty || url2.isNotEmpty) {
                Get.toNamed(Routes.RECHARGE_WEB_VIEW, arguments: {
                  "url": url1.isNotEmpty ? url1 : url2,
                  "title": item?.payOrgNameReal,
                  "availableCredits": "${(item?.agentBalance ?? 0) / 1000}",
                  "desc": "${item?.remark}",
                });
              } else {
                Get.snackbar("打开失败", "客服地址为空");
              }
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                item?.kf_type == 0
                    ? Container(
                        width: 184.w,
                        height: 83.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius:
                                ThemeService.to.currentTheme.value?.model ==
                                        "blackGold"
                                    ? BorderRadius.circular(15.r)
                                    : BorderRadius.circular(79.r)),
                        child: Text(
                          "充值",
                          style: TextStyle(
                              fontSize: 45.sp,
                              color: context.customTheme?.rechargeMoneyColor),
                        ),
                      )
                    : Container(
                        width: 184.w,
                        height: 83.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                ThemeService.to.currentTheme.value?.model ==
                                        "blackGold"
                                    ? BorderRadius.circular(15.r)
                                    : BorderRadius.circular(79.r)),
                        child: Text(
                          "投诉",
                          style: TextStyle(
                              fontSize: 45.sp,
                              color: context.customTheme?.rechargeMoneyColor),
                        ),
                      ),
                Visibility(
                    visible: num.parse(item?.maxPercentage ?? "0") > 0,
                    child: Positioned(
                      top: -20.h,
                      right: -10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(colorF70054), // 标签背景颜色
                          borderRadius: BorderRadius.circular(36.r), // 圆角
                        ),
                        child: Text(
                          '送${item?.maxPercentage}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Container(
      height: 200.h,
      alignment: Alignment.center,
      child: Text("暂无任何渠道"),
    );
  }

  //构建充值渠道的tab
  Widget _buildRechargeTypeTab(BuildContext context) {
    return Obx(
      () => Container(
        color: context.customTheme?.pageTwoBg,
        padding: EdgeInsets.only(top: 10.h, left: 60.w),
        width: 1.sw,
        height: 114.h,
        child: controller.tabList.isNotEmpty
            ? TabBar(
                onTap: (index) {
                  if (controller.currentTabIndex.value != index) {
                    AppManager.instance.tapVibrate();
                  }
                  controller.changeTabIndex(index);
                },
                // tabAlignment: TabAlignment.start,
                // isScrollable: true,
                labelPadding: EdgeInsets.only(right: 50.w),
                labelStyle: TextStyle(
                    color: context.theme.primaryColor, fontSize: 51.sp),
                indicatorColor: context.theme.primaryColor,
                unselectedLabelStyle: TextStyle(
                    color: context.customTheme?.rechargeTabBarUnSelectTextColor,
                    fontSize: 42.sp),
                dividerHeight: 1.h,
                controller: controller.tabController,
                tabs: List.generate(controller.tabList.length, (index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Tab(
                        text: controller.tabList[index].title,
                      ),
                      Obx(() {
                        String maxPercentage =
                            controller.tabList[index].maxPercentage ?? '';
                        if (controller.isShowDiscount.value &&
                            maxPercentage != '' &&
                            maxPercentage != '0') {
                          return Positioned(
                            right: -10.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(colorF70054), // 标签背景颜色
                                borderRadius: BorderRadius.circular(36.r), // 圆角
                              ),
                              child: Text(
                                '送${maxPercentage}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      })
                    ],
                  );
                }),
              )
            : SizedBox(
                child: Container(),
              ),
      ),
    );
  }

  Widget _currentContentWidget() {
    if (controller.currentRechargeMarkType.value == RechargeMarkType.offline) {
      return RechargeOfflineView();
    }
    if (controller.currentRechargeMarkType.value == RechargeMarkType.online) {
      return RechargeOnlineWidget();
    }

    if (controller.currentRechargeMarkType.value == RechargeMarkType.quick) {
      return RechargeQuickView();
    }
    return const SizedBox();
  }

  Widget _buildRechargeTypeAnimateList() {
    var currentData = controller.tabList[controller.currentTabIndex.value].data;
    if (currentData != null &&
        currentData.isNotEmpty &&
        currentData[0].payOrgId == 187) return SizedBox.shrink();
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Obx(() => controller.showRechargeTypeList.isNotEmpty
          ? Container(
              margin: EdgeInsets.only(bottom: 20.h),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: (!controller.isExpand.value
                        ? controller.showRechargeTypeList.take(9).toList()
                        : controller.showRechargeTypeList)
                    .length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 21.h,
                    mainAxisSpacing: 30.w,
                    childAspectRatio: 2.87),
                itemBuilder: (context, index) {
                  String imgUrl = controller.getRechargeTypeIcon(
                      payOrgId:
                          controller.showRechargeTypeList[index].payOrgId!);
                  var item = controller.showRechargeTypeList[index];
                  if (item.iconUrl != null &&
                      item.iconUrl != "null" &&
                      item.iconUrl!.isNotEmpty) {
                    imgUrl = item.iconUrl!;
                  }
                  bool isNetWork = imgUrl.contains("http");
                  return CommonRipple(
                    onTap: () {
                      if (controller.currentRechargeTypeIndex.value != index) {
                        AppManager.instance.tapVibrate();
                      }
                      controller.changeRechargeTypeIndex(index);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Obx(() => Container(
                              height: 119.h,
                              padding: EdgeInsets.symmetric(horizontal: 26.w),
                              alignment: Alignment.center,
                              decoration: controller
                                          .currentRechargeTypeIndex.value ==
                                      index
                                  ? BoxDecoration(
                                      color: context
                                          .customTheme!.rechargeTypeBgColor,
                                      borderRadius: BorderRadius.circular(27.r),
                                      border: Border.all(
                                          color: context.theme.primaryColor))
                                  : BoxDecoration(
                                      color: context.customTheme?.pageTwoBg,
                                      borderRadius:
                                          BorderRadius.circular(27.r)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 32.w,
                                    child: isNetWork
                                        ? Image.network(
                                            imgUrl,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                Assets.theme1.images.home
                                                    .errorImg.path,
                                                fit: BoxFit
                                                    .cover, // 根据需要调整 fit 属性
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            imgUrl,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                Assets.theme1.images.home
                                                    .errorImg.path,
                                                fit: BoxFit
                                                    .cover, // 根据需要调整 fit 属性
                                              );
                                            },
                                          ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10.w),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown, // 自动缩小以适配宽度
                                            child: Text(
                                              "${controller.showRechargeTypeList[index].name}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: controller
                                                            .currentRechargeTypeIndex
                                                            .value ==
                                                        index
                                                    ? context.theme.primaryColor
                                                    : context.customTheme?.titleColor,
                                                fontSize: 41.sp,
                                                height: 1.2,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )))
                                ],
                              ),
                            )),
                        Obx(() {
                          String maxPercentage = controller
                                  .showRechargeTypeList[index].maxPercentage ??
                              '';
                          int? length = controller.showRechargeTypeList[index]
                              .beforeRecommendLength;
                          String channel_custom_name2 = controller
                                  .showRechargeTypeList[index]
                                  .tenantPayMerchant?[length ?? 0]
                                  .channelCustomName2 ??
                              '';
                          if (controller.isShowDiscount.value &&
                              ((maxPercentage.isNotEmpty &&
                                      maxPercentage != '0') ||
                                  channel_custom_name2.isNotEmpty)) {
                            return Positioned(
                              top: -14.h,
                              right: -10.w,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 340.w, // 最大宽度限制
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: const Color(colorF70054), // 标签背景颜色
                                  borderRadius:
                                      BorderRadius.circular(36.r), // 圆角
                                ),
                                child: Text(
                                  channel_custom_name2.isNotEmpty
                                      ? channel_custom_name2
                                      : '送${maxPercentage}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        }),
                      ],
                    ),
                  );
                },
              ),
            )
          : SizedBox()),
    );
  }

  //充值渠道列表
  Widget _buildRechargeTypeList() {
    return Column(
      children: [
        _buildRechargeTypeAnimateList(),
        RechargeExpandWidget(
          text: controller.isExpand.value ? "折叠" : "展开",
          isVisible: controller.isShowMore.value,
          openOrExpand: controller.openOrExpandList,
          isExpand: controller.isExpand.value,
        )
      ],
    );
  }

  Widget _buildBottomInfo() {
    return Column(
      children: [
        SizedBox(
          height: 57.h,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "温馨提示",
            //   style: TextStyle(
            //     color: Color(colorFE000E),
            //   ),
            // ),
            // SizedBox(
            //   height: 16.h,
            // ),
            // const Text("1.充值金额为USDT，充值成功后会按官方汇率自动转换成人民币添加至您的账户。"),
            // SizedBox(
            //   height: 16.h,
            // ),
            // const Text("2.为及时到账，请务必输入正确的转入地址后4位数"),
            // SizedBox(
            //   height: 39.h,
            // ),
            // HtmlWidget(
            //   "${TenantManager.instance.tenantBean?.sysOptions?.chargedesc1}",
            // ),
            controller.describe.isNotEmpty
                ? HtmlWidget(
                    "${controller.describe}",
                  )
                : SizedBox(),
            _buildContactCustomer(),
          ],
        ),
        SizedBox(
          height: 262.h,
        )
      ],
    );
  }

  // 联系客服
  Widget _buildContactCustomer() {
    return Container(
      width: double.infinity,
      height: 108.h,
      margin: EdgeInsets.only(top: 20.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
      child: RichText(
        text: TextSpan(
            text: "无法充值，或不知道怎么充值可联系 →   ",
            style: TextStyle(fontSize: 36.sp, color: const Color(color0177FF)),
            children: [
              TextSpan(
                text: "在线客服 >",
                style: const TextStyle(
                  color: Color(colorFE000E),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(colorFE000E),
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => DebounceThrottle.debounce(
                      controller.handleContactCustomer)(),
              )
            ]),
      ),
    );
  }

  Widget _titleText(String str, double fontSize) {
    return RichText(
      text: TextSpan(
          text: "*",
          style: TextStyle(fontSize: fontSize, color: Colors.red),
          children: [
            TextSpan(text: str, style: const TextStyle(color: Colors.black))
          ]),
    );
  }
}
