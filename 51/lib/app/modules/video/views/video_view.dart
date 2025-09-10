import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/controllers/lottery_half_screen_controller.dart';
import 'package:flutter_tiyu_app/app/modules/video/widget/video_category_list_widget.dart';
import 'package:flutter_tiyu_app/app/modules/video/widget/video_content_list_widget.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/login_manager.dart';
import '../../login/views/login_dialog.dart';
import '../controllers/video_controller.dart';
import '../widget/video_black_list_widget.dart';

///视频页面
class VideoView extends GetView<VideoController> {
  const VideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Offset _iconPosition = const Offset(15, 64);
    return Scaffold(
      backgroundColor: const Color(colorF4F4F4),
      body: Stack(
        children: [
          // Main content (RefreshIndicator, Column with content)
          RefreshIndicator(
            onRefresh: controller.reqTabData,
            child: Column(
              children: [
                _buildTitle(context),
                _buildTabBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                      children: [
                        _buildBanner(),
                        // _buildSearchView(),
                        _buildVideoCategory(),
                        _buildContentList(),
                        SizedBox(
                          height: 50.h,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Positioned Draggable at the top layer
          Positioned(
            right: 33.w,
            bottom: 520.h,
            child: Draggable(
              feedback: Image.asset(
                Assets.theme1.images.lottery.lotteryHomeK3.path,
                fit: BoxFit.cover,
                width: 150.w,
              ),
              childWhenDragging: Container(),
              onDragEnd: (dragDetails) {
                final screenSize = MediaQuery.of(context).size;
                final safePadding = MediaQuery.of(context).padding;
                const iconWidth = 150;
                const iconHeight = 150;

                double newX = dragDetails.offset.dx;
                double newY = dragDetails.offset.dy;

                // Limit X axis within screen bounds
                if (newX < 0) {
                  newX = 0;
                } else if (newX + iconWidth > screenSize.width) {
                  newX = screenSize.width - iconWidth - safePadding.top;
                }

                // Limit Y axis within screen bounds
                if (newY < 0) {
                  newY = 0;
                } else if (newY + iconHeight > screenSize.height) {
                  newY = screenSize.height -
                      iconHeight * 2 -
                      15 -
                      safePadding.bottom;
                }

                _iconPosition = Offset(newX, newY);
              },
              child: CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  // Handle tap event
                  // Get.to(() => const LotteryHomePage(),
                  //     opaque: false,
                  //     fullscreenDialog: true,
                  //     transition: Transition.noTransition);
                  // HalfScreenImagePage.showHalfScreenImage(context, '');
                  HalfScreenController.showHalfScreenImage();
                },
                child: Image.asset(
                  Assets.theme1.images.lottery.lotteryHomeK3.path,
                  fit: BoxFit.cover,
                  width: 150.w,
                ),
              ),
            ),
          ),

          Obx(() => _floatButton()),
        ],
      ),
    );
  }

  Widget _buildContentList() {
    return Obx(() => controller.currentTabIndex.value == 0
        ? Column(
            children: List.generate(controller.homeList.length, (index) {
              return Obx(() => VideoContentListWidget(
                    data: controller.homeList[index],
                    clickMore: () {
                      controller.goCategoryMoreDetailView(
                          id: controller.homeList[index].id!.toInt(),
                          type: controller.homeList[index].type!,
                          title: controller.homeList[index].title!);
                    },
                  ));
            }),
          )
        : (controller.secondList.isNotEmpty
            ? (controller.tabList[controller.currentTabIndex.value].id! ==
                    130 //黑料单独写页面
                ? VideoBlackListWidget()
                : VideoCategoryListWidget(
                    clickMore: () {
                      controller.goCategoryMoreDetailView(
                          id: controller
                              .tabList[controller.currentTabIndex.value].id!,
                          type: controller
                              .tabList[controller.currentTabIndex.value].type!,
                          title: controller
                              .tabList[controller.currentTabIndex.value].name!);
                    },
                    clickRefresh: () {
                      controller.refreshTabList();
                    },
                    // key: controller.homeListKeys[index],
                    data: controller.secondList,
                  ))
            : SizedBox()));
  }

  //构建视频分类按钮
  Widget _buildVideoCategory() {
    return Container(
      height: 270.h,
      padding: EdgeInsets.only(top: 35.h, bottom: 35.h, left: 33.w),
      child: Obx(() => GridView.builder(
          itemCount: controller.categoryList.length,
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20.w,
              mainAxisSpacing: 20.w,
              childAspectRatio: 0.4),
          itemBuilder: (context, index) {
            return CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.goCategoryDetailView(index);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r)),
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  "${controller.categoryList[index].classify}",
                  style: TextStyle(fontSize: 43.sp, color: Color(colorADADAD)),
                ),
              ),
            );
          })),
    );
  }

  //每个item长短不一，所以使用listView来实现
  Widget _buildBanner() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 33.w, top: 24.h),
      height: 300.h,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) {
            if (index % 2 == 0) {
              return Container(
                width: 641.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      36.r,
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            Assets.theme1.images.video.videoBanner1.path)),
                    color: Colors.black26),
                height: 293.h,
                margin: EdgeInsets.only(right: 28.w),
              );
            } else {
              return Container(
                width: 286.w,
                margin: EdgeInsets.only(right: 28.w),
                height: 286.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      36.r,
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            Assets.theme1.images.video.videoBanner2.path)),
                    color: Colors.black26),
              );
            }
          }),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: Colors.white,
      key: controller.tabBarKey,
      child: Obx(() => controller.tabList.isNotEmpty
          ? TabBar(
              onTap: (index) {
                if (controller.currentTabIndex.value != index) {
                  AppManager.instance.tapVibrate();
                }
                controller.tabChange(index);
              },
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 2.h,
                    color: context.theme.primaryColor), // 设置指示器的高度和颜色
              ),
              // indicatorColor: Color(theme01MainColor),
              controller: controller.tabController,
              unselectedLabelStyle: TextStyle(
                color: const Color(colorB6B9C0),
                fontSize: 45.sp,
              ),
              labelStyle: TextStyle(
                  color: context.theme.primaryColor,
                  fontSize: 45.sp,
                  fontWeight: FontWeight.bold),
              dividerHeight: 0.5.h,
              tabs: List.generate(controller.tabList.length, (index) {
                return Tab(
                  text: controller.tabList[index].title,
                );
              }))
          : const SizedBox()),
    );
  }

  ///构建标题
  Widget _buildTitle(context) {
    return Container(
      key: controller.titleKey,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 33.w, right: 33.w),
        height: 150.h,
        child: Row(
          children: [
            CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.tabsController.jumpToPage(0);
              },
              child: SizedBox(
                width: 180.w,
                height: 78.h,
                child: controller.homeController.iconPath.value.isNotEmpty
                    ? Image.network(controller.homeController.iconPath.value)
                    : SizedBox(),
              ),
            ),
            Expanded(child: _buildSearchView()),
            // Obx(() => Visibility(
            //     visible: !LoginManager.instance.isLogin.value,
            //     child: _buildLoginWidget(context)))
            Obx(() => LoginManager.instance.isLogin.value
                ? _buildWalletView(context)
                : _buildLoginWidget(context))
          ],
        ),
      ),
    );
  }

  Widget _buildLoginWidget(context) {
    return Row(
      children: [
        SizedBox(
          width: 160.w,
          height: 72.h,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.r), // 设置圆角半径
                ),
                side: BorderSide(color: Color(0XFF10c8e3), width: 1 // 边框宽度
                    ),
              ),
              onPressed: () {
                AppManager.instance.tapVibrate();
                //注册
                showAppDialog(
                  context: context,
                  widget: const LoginDialog(
                    isShowLogin: false,
                  ),
                );
              },
              child: Text(
                "注册",
                style: TextStyle(fontSize: 42.sp, color: Color(0XFF10c8e3)),
              )),
        ),
        SizedBox(
          width: 20.w,
        ),
        SizedBox(
          width: 160.w,
          height: 72.h,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.r), // 设置圆角半径
                  ),
                  backgroundColor: Color(0XFF10c8e3),
                  padding: EdgeInsets.zero),
              onPressed: () {
                AppManager.instance.tapVibrate();
                //登录
                showAppDialog(
                  context: context,
                  widget: const LoginDialog(
                    isShowLogin: true,
                  ),
                );
              },
              child: Text("登录",
                  style: TextStyle(fontSize: 42.sp, color: Colors.white))),
        ),
      ],
    );
  }

  // 钱包控件
  Widget _buildWalletView(BuildContext context) {
    return Container(
      height: 78.h,
      decoration: BoxDecoration(
          color: const Color(colorF4F4F4),
          borderRadius: BorderRadius.circular(79.r)),
      padding: EdgeInsets.only(left: 30.w, right: 2.w),
      child: Row(
        children: [
          Text(
            "￥${LoginManager.instance.balanceStr.value}",
            style: TextStyle(fontSize: 39.sp),
          ),
          SizedBox(
            width: 20.w,
          ),
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.homeController.reqMoney(true);
            },
            child: SvgPicture.asset(
              Assets.theme1.images.user.iconRefresh,
              width: 40.w,
              height: 40.h,
              colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcIn),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.tabsController.jumpToPage(2);
            },
            child: Icon(
              Icons.add_circle_outlined,
              color: context.theme.primaryColor,
              size: 66.w,
            ),
          )
        ],
      ),
    );
  }

  //构建搜索布局
  Widget _buildSearchView() {
    return Container(
      height: 95.h,
      padding: EdgeInsets.only(left: 36.w, right: 36.w),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  Get.toNamed(Routes.VIDEO_SEARCH);
                },
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      color: Color(0xfff6f6f7)),
                  padding: EdgeInsets.only(right: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 26.w, right: 28.w),
                        child: SvgPicture.asset(
                          Assets.theme1.images.video.iconSearch,
                          width: 42.w,
                          height: 42.h,
                        ),
                      ),
                      Obx(() => Text(
                            "大家都在搜",
                            style: TextStyle(
                                fontSize: !LoginManager.instance.isLogin.value
                                    ? 30.sp
                                    : 33.sp,
                                color: Color(0xffb3b8c3)),
                          ))
                    ],
                  ),
                ),
              )),
          // SizedBox(
          //   width: 30.w,
          // ),
          // Container(
          //   height: 92.h,
          //   width: 92.w,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(50),
          //       color: Color(0xfff6f6f7)),
          //   margin: EdgeInsets.only(right: 32.w, left: 45.w),
          //   child: UnconstrainedBox(
          //     child: SvgPicture.asset(
          //       Assets.theme1.images.video.iconHistory,
          //       width: 46.w,
          //       height: 46.h,
          //     ),
          //   ),
          // ),
          // Container(
          //   height: 92.h,
          //   width: 92.w,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(50),
          //       color: Color(0xfff6f6f7)),
          //   margin: EdgeInsets.only(right: 32.w),
          //   child: UnconstrainedBox(
          //       child: SvgPicture.asset(
          //     Assets.theme1.images.video.iconCollect,
          //     width: 46.w,
          //     height: 46.h,
          //   )),
          // ),
          // CommonRipple(
          //   onTap: () {
          //     Get.toNamed(Routes.VIDEO_CATEGORY);
          //   },
          //   child: Container(
          //     height: 92.h,
          //     width: 210.w,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50),
          //         color: Color(0xfff6f6f7)),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         SvgPicture.asset(
          //           Assets.theme1.images.video.iconCategory,
          //           width: 46.w,
          //           height: 46.h,
          //         ),
          //         SizedBox(
          //           width: 15.w,
          //         ),
          //         Text(
          //           "分类",
          //           style:
          //               TextStyle(fontSize: 45.sp, color: Color(colorACACAC)),
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  showAppDialog(
      {required BuildContext context,
      required Widget widget,
      bool isEnable = false}) {
    showDialog(
        barrierDismissible: isEnable,
        context: context,
        builder: (context) {
          return widget;
        });
  }

  Widget _floatButton() {
    return Visibility(
      visible: controller.isShowScrollTopButton.value,
      child: Positioned(
        right: 33.w,
        bottom: 90.h,
        child: CommonRipple(
          onTap: () {
            AppManager.instance.tapVibrate();
            controller.scrollTop();
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(75.r),
            ),
            margin: EdgeInsetsDirectional.zero,
            child: Container(
              width: 150.w,
              height: 184.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(75.r)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(Icons.upload_rounded),
                  Image.asset(
                    Assets.theme1.images.common.iconTop.path,
                    width: 54.w,
                    height: 54.h,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "TOP",
                    style: TextStyle(
                      fontSize: 33.sp,
                      color: const Color(color838383),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
