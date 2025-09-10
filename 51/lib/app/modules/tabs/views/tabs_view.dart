import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_list_item_widget.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/common_color.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/tenant_manager.dart';
import '../../../routes/app_pages.dart';
import '../../../widget/bottom_nav_lottie_icon.dart';
import '../controllers/tabs_controller.dart';

class TabsView extends GetView<TabsController> {
  TabsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          // extendBody: true, // 允许内容扩展到导航栏区域
          body: Stack(
            children: [
              PageView.builder(
                itemCount: controller.pageList.length,
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.changePageIndex(index);
                },
                itemBuilder: (context, index) {
                  return controller.pageList[index];
                },
              ),
              // _buildFloatButton(),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            padding: EdgeInsets.zero,
            height: 150.h,
            color: context.customTheme?.navbarBg, // 设置透明
            child: Obx(() => controller.bottomViewLoading.value
                ? SizedBox()
                : Row(
                    children: List.generate(
                        controller.defaultBottomItemList.length, (index) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (controller.currentIndex.value != index) {
                              AppManager.instance.tapVibrate();
                              controller.jumpToPage(index);
                            }
                          },
                          child: Container(
                            color: context.customTheme?.navbarBg,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // controller.currentIndex.value == index
                                    //     ? Image.asset(
                                    //         controller.defaultBottomItemList[index]
                                    //             .selectIconPath,
                                    //         width: 55.w,
                                    //         height: 55.h,
                                    //         repeat: ImageRepeat.noRepeat,
                                    //       )
                                    //     : Image.asset(
                                    //         controller.defaultBottomItemList[index]
                                    //             .iconPath,
                                    //         width: 55.w,
                                    //         height: 55.h,
                                    //         repeat: ImageRepeat.noRepeat,
                                    //       ),
                                    // if (controller.defaultBottomItemList[index]
                                    //         .inPath.isNotEmpty &&
                                    //     controller.defaultBottomItemList[index]
                                    //         .outPath.isNotEmpty)
                                    BottomNavLottieIcon(
                                      inAsset: controller
                                          .defaultBottomItemList[index].inPath,
                                      outAsset: controller
                                          .defaultBottomItemList[index].outPath,
                                      selected: controller.currentIndex.value ==
                                          index,
                                    ),
                                    if (controller
                                        .shouldShowRedDot(index)) // 是否显示红点的逻辑
                                      Positioned(
                                        top: -5.h, // 适当调整位置以放置红点
                                        right: -20.w, // 适当调整位置以放置红点
                                        child: (controller.collections.length >
                                                0) // 判断 collections.length 是否大于 0
                                            ? Container(
                                                padding: EdgeInsets.all(
                                                    2.w), // 内边距让数字更居中
                                                constraints: BoxConstraints(
                                                  minWidth:
                                                      40.w, // 确保容器大小足够显示数字
                                                  minHeight: 40.h,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    controller
                                                        .collections.length
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          24.sp, // 根据需求调整字体大小
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox
                                                .shrink(), // 如果 collections.length 为 0，则不显示红点
                                      ),
                                    Obx(() => Visibility(
                                        visible: controller
                                                .shouldShowRedDot2(index) &&
                                            controller.rechargeMax.value != "0",
                                        child: Positioned(
                                          top: -26.h, // 适当调整位置以放置红点
                                          right: -60.w, // 适当调整位置以放置红点
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.h,
                                                horizontal: 10.w), // 内边距让数字更居中
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.r)),
                                            child: Center(
                                              child: Text(
                                                "送${controller.rechargeMax.value}%",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24.sp, // 根据需求调整字体大小
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ), // 如果 collections.length 为 0，则不显示红点
                                        )))
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  controller
                                      .defaultBottomItemList[index].title.tr,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 40.sp,
                                    color:
                                        controller.currentIndex.value == index
                                            ? context.theme?.primaryColor
                                            : const Color(colorABACB2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  )),
          ),
        ));
  }

  Widget _buildFloatButton() {
    return Positioned(
      right: 33.w,
      bottom: 500.h,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(75.r),
        ),
        margin: EdgeInsetsDirectional.zero,
        child: InkWell(
          onTap: () {
            AppManager.instance.tapVibrate();
            if (TenantManager.instance.isCanOpenCustomerService) {
              Get.toNamed(Routes.CUSTOMER_SERVICE);
            } else {
              String? onlineAddr =
                  TenantManager.instance.tenantBean?.tenant?.onlineAddr;
              if (onlineAddr != null) {
                String? type = TenantManager
                    .instance.tenantBean?.sysOptions?.customerServiceSkipType;
                if (type == '1') {
                  launchUrl(Uri.parse(onlineAddr),
                      mode: LaunchMode.externalApplication);
                } else {
                  Get.toNamed(Routes.WEB_VIEW_INAPP, arguments: {
                    "url": onlineAddr, //请求地址
                    "title": "在线客服",
                  });
                }
              }
            }
          },
          child: _buildButtonContent(),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Container(
      width: 150.w,
      height: 190.h,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(75.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.theme1.images.home.iconCustomService.path,
            width: 100.w,
            height: 100.h,
          ),
          Text(
            "客服",
            style: TextStyle(
                fontSize: 33.sp, color: const Color(theme01MainColor)),
          )
        ],
      ),
    );
  }
}
