import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_component.dart';
import 'package:flutter_tiyu_app/app/modules/home/new_home_const.dart';
import 'package:flutter_tiyu_app/app/modules/home/views/new_home_view.detail.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/widget/keep_alive_wrapper.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/utils/CommonRipple.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/banner_jump_utils.dart';
import 'package:flutter_tiyu_app/utils/string_utils.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/game_constants.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../kernel/network/service.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/login_manager.dart';
import '../../../../utils/tenant_manager.dart';
import '../../../data/new_home_game_tab_bean.dart';
import '../../../routes/app_pages.dart';
import '../../../widget/common_marquee.dart';
import '../../../widget/new_common_game_list.dart';
import '../../../widget/new_home_game_tab.dart';
import '../../../widget/system_announcement_dialog.dart';
import '../../login/views/login_dialog.dart';
import '../../login/views/login_type_button_widget.dart';
import '../../settings/views/settings_withdrawal_pwd_dialog.dart';
import '../controllers/new_home_controller.dart';
import '../home_view_const.dart';
import '../model/announcement_bean.dart';
import 'hot_game_detail_view.dart';

//新版首页
class NewHomeView extends StatefulWidget {
  NewHomeView({super.key});

  @override
  State<NewHomeView> createState() => _NewHomeViewState();
}

class _NewHomeViewState extends State<NewHomeView> {
  get gameWidgetMap => null;
  late NewHomeController controller = Get.put(NewHomeController());
  late TabsController tabsController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorEEEEEE),
      body: _buildBody(context),
    );
  }

  //构建内容区域
  Widget _buildBody(context) {
    return Stack(children: [
      Column(children: [
        _buildTitle(context), //标题
        Expanded(
            child: Stack(
          children: [
            RefreshIndicator(
                onRefresh: controller.refreshData,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildBanner(),
                    ),
                    SliverToBoxAdapter(
                      child: _buildAnnouncement(context),
                    ),
                    SliverPersistentHeader(
                      pinned: true, // 使该组件固定在顶部
                      delegate: _TabBarHeaderDelegate(
                          isFixed: controller.isTabBarFixed.value),
                    ),
                    // 使用 IndexedStack 管理多个页面
                    SliverToBoxAdapter(
                      child: Obx(() => AnimatedContainer(
                            height: controller.pageViewHeight.value,
                            duration: const Duration(microseconds: 500),
                            // child:  PageView(
                            //   onPageChanged: (index) {
                            //     controller.changeTabIndex(index);
                            //   },
                            //   children: List.generate(
                            //       controller.homeCategoryList.length, (index) {
                            //     return _getPageByTabIndex(index);
                            //   }),
                            // ),
                            child: PageView.builder(
                                controller: controller.pageController,
                                physics: NeverScrollableScrollPhysics(),
                                onPageChanged: (index) {
                                  controller.changeTabIndex(index);
                                },
                                itemCount: controller.homeCategoryList.length,
                                itemBuilder: (context, index) {
                                  return _getPageByTabIndex(index);
                                }),
                          )),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Obx(() => AnimatedContainer(
                    //         height: controller.pageViewHeight.value,
                    //         duration: const Duration(microseconds: 500),
                    //         child: IndexedStack(
                    //           index: controller
                    //               .currentTabIndex.value, // 当前显示的 Tab 页面
                    //           children: List.generate(
                    //               controller.homeCategoryList.length, (index) {
                    //             return _getPageByTabIndex(index);
                    //           }),
                    //         ),
                    //       )),
                    // ),
                    SliverToBoxAdapter(
                      child: _buildBottomView(),
                    ),
                  ],
                  controller: controller.scrollController,
                )),
            ..._floatButton(), //客服、回到顶部按钮
            _menu(), // 首页侧边栏
          ],
        )),
      ]),
      const ActivitysComponent()
    ]);
  }

  Widget _getPageByTabIndex(int index) {
    NewHomeGameTabBean currentItem = controller.homeCategoryList[index];
    Widget pageWidget;

    // 根据 Tab 的 index 来确定对应的页面
    switch (currentItem.key) {
      case HomeGameCategory.CHESS_AND_CARDS_KEY:
        pageWidget = NewHomeViewDetail(
          globalKey: controller.tabPageKeys[index],
          key: ValueKey(currentItem.key),
          pageKey: HomePageDetailEnum.chess,
        );
        break;
      case HomeGameCategory.LOTTERY_KEY:
        pageWidget = NewHomeViewDetail(
          globalKey: controller.tabPageKeys[index],
          key: ValueKey(currentItem.key),
          pageKey: HomePageDetailEnum.lottery,
        );
        break;
      case HomeGameCategory.ELECTRONIC_KEY:
        pageWidget = NewHomeViewDetail(
          globalKey: controller.tabPageKeys[index],
          key: ValueKey(currentItem.key),
          pageKey: HomePageDetailEnum.electronic,
        );
        break;
      case HomeGameCategory.BLOCKCHAIN_KEY:
        pageWidget = NewHomeViewDetail(
          globalKey: controller.tabPageKeys[index],
          key: ValueKey(currentItem.key),
          pageKey: HomePageDetailEnum.blockChain,
        );
        break;
      case HomeGameCategory.FISHING_KEY:
        pageWidget = NewHomeViewDetail(
          globalKey: controller.tabPageKeys[index],
          key: ValueKey(currentItem.key),
          pageKey: HomePageDetailEnum.fishing,
        );
        break;
      case HomeGameCategory.LIVE_KEY:
        pageWidget = NewHomeViewDetail(
          globalKey: controller.tabPageKeys[index],
          key: ValueKey(currentItem.key),
          pageKey: HomePageDetailEnum.live,
        );
        break;
      case HomeGameCategory.SPORTS_KEY:
        pageWidget = NewHomeViewDetail(
          globalKey: controller.tabPageKeys[index],
          key: ValueKey(currentItem.key),
          pageKey: HomePageDetailEnum.sports,
        );
        break;
      case HomeGameCategory.COLLECT_KEY: //收藏
        pageWidget = NewHomeViewDetail(
          globalKey: controller.tabPageKeys[index],
          key: ValueKey(currentItem.key),
          pageKey: HomePageDetailEnum.collect,
        );
        break;
      case HomeGameCategory.RECENT_KEY: //最近
        pageWidget = NewHomeViewDetail(
          globalKey: controller.tabPageKeys[index],
          key: ValueKey(currentItem.key),
          pageKey: HomePageDetailEnum.recent,
        );
        break;
      case HomeGameCategory.RECOMMEND_KEY: //推荐

        pageWidget = KeepAliveWrapper(
            child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  key: controller.tabPageKeys[index],
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: _buildGameList(),
                  ),
                )));
        break;
      default:
        pageWidget = const SizedBox();
        break;
    }

    return pageWidget;
  }

  ///构建悬浮按钮组
  List<Widget> _floatButton() {
    return [
      Obx(() => Visibility(
          visible: controller.isShowScrollTopButton.value,
          child: Positioned(
              right: 33.w,
              bottom: 20.h,
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
              )))),
      // Positioned(
      //     right: 33.w,
      //     bottom: 300.h,
      //     child: Card(
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(75.r),
      //       ),
      //       child: CommonRipple(
      //         onTap: () {
      //           Get.toNamed(Routes.CUSTOMER_SERVICE);
      //         },
      //         child: Container(
      //           width: 150.w,
      //           height: 190.h,
      //           decoration: BoxDecoration(
      //               color: Colors.white,
      //               borderRadius: BorderRadius.circular(75.r)),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Image.asset(
      //                 Assets.theme1.images.home.iconCustomService.path,
      //                 width: 100.w,
      //                 height: 100.h,
      //               ),
      //               Text(
      //                 "客服",
      //                 style: TextStyle(
      //                     fontSize: 33.sp,
      //                     color: const Color(theme01MainColor)),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     )),
    ];
  }

  ///构建标题
  Widget _buildTitle(context) {
    print('iconPath:${NetworkService().baseURL}');
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 33.w, right: 33.w),
        height: 150.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Obx(() => SizedBox(
                      width: 60.w,
                      height: 60.h,
                      child: CommonRipple(
                        onTap: () {
                          AppManager.instance.tapVibrate();
                          controller.toggleMenu();
                        },
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(
                              controller.displayMenu.value ? 0 : math.pi),
                          child: Image.asset(
                            Assets.theme1.images.home.homeMenu.path,
                            fit: BoxFit.contain,
                            height: 44.h,
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  width: 20.w,
                ),
                Obx(
                  () => controller.iconPath.value.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: controller.iconPath.value,
                          fit: BoxFit.scaleDown,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 388.w,
                            margin: EdgeInsets.only(right: 20.w),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                              ),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            Obx(() => LoginManager.instance.isLogin.value
                ? _buildWalletView(context)
                : _buildLoginWidget(context))
          ],
        ),
      ),
    );
  }

  // 钱包控件
  Widget _buildWalletView(context) {
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
              controller.retrieveAndCheckBalance(true, '');
            },
            child: SvgPicture.asset(
              Assets.theme1.images.user.iconRefresh,
              width: 40.w,
              height: 40.h,
              colorFilter:
                  const ColorFilter.mode(Colors.black26, BlendMode.srcIn),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              var isOpenVideo = TenantManager.instance.tenantBean!.isOpenVideo;
              controller.tabsController
                  .jumpToPage(isOpenVideo == 'true' ? 2 : 1);
            },
            child: Icon(
              Icons.add_circle_outlined,
              color: const Color(theme01MainColor),
              size: 66.w,
            ),
          )
        ],
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
                side: const BorderSide(
                  color: Color(theme01MainColor), width: 1, // 边框宽度
                ),
              ),
              onPressed: () {
                AppManager.instance.tapVibrate();
                showRegisterDialog();
              },
              child: Text(
                "注册",
                style:
                    TextStyle(fontSize: 42.sp, color: Color(theme01MainColor)),
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
                  backgroundColor: Color(theme01MainColor),
                  padding: EdgeInsets.zero),
              onPressed: () {
                AppManager.instance.tapVibrate();
                showLoginDialog();
              },
              child: Text("登录",
                  style: TextStyle(fontSize: 42.sp, color: Colors.white))),
        ),
      ],
    );
  }

  /// 打开注册弹窗
  void showRegisterDialog() {
    Get.dialog(
      const LoginDialog(
        isShowLogin: false,
      ),
      barrierDismissible: false,
    );
  }

  /// 打开登录弹窗
  void showLoginDialog({VoidCallback? callback}) {
    if (LoginManager.instance.isLoginDialogShowing) {
      return;
    }
    LoginManager.instance.isLoginDialogShowing = true;
    Get.dialog(
      LoginDialog(
        isShowLogin: true,
        callback: callback,
      ),
      barrierDismissible: false,
    );
  }

  Widget _menu() {
    return Obx(
      () => Visibility(
        visible: controller.displayMenu.value,
        child: Container(
          color: Colors.black.withAlpha(180),
          width: Get.width,
          child: Stack(
            children: [
              SlideTransition(
                position: controller.slideAnimation,
                child: Row(
                  children: [
                    Container(
                      width: Get.width / 1.75,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() => LoginManager.instance.isLogin.value
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Row(children: [
                                          Text(
                                            "钱包余额：${LoginManager.instance.balanceStr.value}￥",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 42.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          CommonRipple(
                                            onTap: () {
                                              AppManager.instance.tapVibrate();
                                              controller
                                                  .retrieveAndCheckBalance(
                                                      true, '');
                                            },
                                            child: SvgPicture.asset(
                                              Assets.theme1.images.user
                                                  .iconRefresh,
                                              width: 40.w,
                                              height: 40.h,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.black26,
                                                      BlendMode.srcIn),
                                            ),
                                          ),
                                        ]),
                                      ),
                                      const SizedBox(height: 15),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: _buildButton('提现',
                                                    () async {
                                              AppManager.instance.tapVibrate();
                                              if (controller.hasPwd) {
                                                Get.toNamed(
                                                    Routes
                                                        .NEW_RECHARGE_WITHDRAWAL,
                                                    arguments: {
                                                      "isBand": true
                                                    });
                                              } else {
                                                // Get.toNamed(
                                                //     Routes.EDIT_PASSWORD,
                                                //     arguments: {
                                                //       "isLoginPwd": false
                                                //     })?.then((_) {
                                                //   controller.checkPwdStatus();
                                                // });
                                                await Get.dialog(
                                                    SettingsWithdrawalPwdDialog());
                                                controller.checkPwdStatus();
                                              }
                                            })),
                                            const SizedBox(width: 10),
                                            Expanded(
                                                child: _buildButton('充值', () {
                                              AppManager.instance.tapVibrate();
                                              var isOpenVideo = TenantManager
                                                      .instance
                                                      .tenantBean
                                                      ?.isOpenVideo ==
                                                  'true';
                                              controller.tabsController
                                                  .jumpToPage(
                                                      isOpenVideo ? 2 : 1);
                                            })),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 20),
                                        child: const Divider(
                                          color: Color(colorCECECE),
                                          thickness: 0.2,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 20.w),
                                  child: Text(
                                    '加入${controller.appName.value}，开启畅赢人生！',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 42.sp),
                                  ),
                                )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _gameButton(
                                  'hot',
                                  '客服',
                                  Assets.theme1.images.home.iconCustomServicePng
                                      .path),
                              SizedBox(width: 20.w),
                              _gameButton(
                                  'favorite',
                                  '收藏',
                                  Assets.theme1.images.home.homeMenuFavorite
                                      .path),
                              SizedBox(width: 20.w),
                              _gameButton(
                                  'record',
                                  '最近',
                                  Assets
                                      .theme1.images.home.homeMenuRecord.path),
                            ],
                          ),
                          if (LoginManager.instance.isLogin.value)
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 20), // 设置左右边距
                              padding: EdgeInsets.all(10.w), // 内边距
                              decoration: BoxDecoration(
                                color: const Color(0xffFFF6DF), // 背景颜色
                                border: Border.all(
                                    color: const Color(theme01MainColor),
                                    width: 1), // 边框颜色和宽度
                                borderRadius:
                                    BorderRadius.circular(15.w), // 圆角边框
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Row 内容两端对齐
                                crossAxisAlignment:
                                    CrossAxisAlignment.center, // 垂直方向居中对齐
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // 确保图片和文字居中对齐
                                    children: [
                                      Image.asset(
                                        color: Color(theme01MainColor),
                                        Assets.theme1.images.home.homeMenuYeb
                                            .path,
                                        fit: BoxFit.contain, // 根据需要调整 fit 属性
                                        height: 44.h,
                                      ),
                                      SizedBox(
                                          width: 15.w), // 设置 Image 和 Text 之间的间距
                                      Text(
                                        '利息宝：${controller.balanceTreasure.value == 0 ? '0.00' : controller.balanceTreasure.value.truncateToFixed(2)}元',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 42.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 50.w,
                                    color: const Color(theme01MainColor),
                                  ),
                                ],
                              ),
                            ).onTap(() {
                              AppManager.instance.tapVibrate();
                              controller.pushToActivity('利息宝');
                              controller.toggleMenu();
                            }),
                          if (!LoginManager.instance.isLogin.value)
                            SizedBox(
                              height: 40.h,
                            ),
                          Expanded(
                            child: _buildList(),
                          ),
                        ],
                      ),
                    ).onTap(() => null),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 80.h,
                      width: 80.w,
                      child: Image.asset(
                          Assets.theme1.images.home.homeMenuHidden.path),
                    ),
                  ],
                ),
              )
            ],
          ),
        ).onTap(() {
          AppManager.instance.tapVibrate();
          controller.toggleMenu();
        }),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onTap) {
    return Container(
      height: 104.h, // 按钮高度
      decoration: BoxDecoration(
        color: const Color(theme01MainColor), // 按钮背景色设置为红色
        borderRadius: BorderRadius.circular(20.r), // 圆角设置
      ),
      child: CommonRipple(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r), // CommonRipple 圆角，避免水波纹超出边界
        child: Center(
          child: Text(
            label,
            style:
                const TextStyle(color: Colors.white, fontSize: 16), // 字体颜色为白色
          ),
        ),
      ),
    );
  }

  //随便逛逛的按钮
  Widget _gameButton(
    String type,
    String title,
    String imageName,
  ) {
    return LoginTypeButtonWidget(
      title: title,
      iconPath: imageName,
      type: 'png',
      size: 180,
      buttonClick: () {
        AppManager.instance.tapVibrate();
        Get.back();
        if (type == 'hot') {
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
        } else if (type == 'favorite') {
          controller.changeTabIndex(
              controller.findTabIndex(HomeGameCategory.COLLECT_KEY));
        } else if (type == 'record') {
          controller.changeTabIndex(
              controller.findTabIndex(HomeGameCategory.RECENT_KEY));
        }
        controller.toggleMenu();
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: controller.homeMenuList.length,
      itemBuilder: (context, index) {
        var item = controller.homeMenuList[index];
        return CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.toggleMenu();
              controller.handleNavigation(index);
            },
            child: Container(
                height: 170.h,
                padding: EdgeInsets.symmetric(horizontal: 40.w), // 内边距
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Row 内容两端对齐
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              item['icon'],
                              fit: BoxFit.contain, // 根据需要调整 fit 属性
                              color: Color(theme01MainColor),
                              height: 44.h,
                            ),
                            const SizedBox(width: 10), // 设置 Image 和 Text 之间的间距
                            Text(
                              item['name'],
                              style: TextStyle(
                                color: const Color(color888888),
                                fontSize: 42.sp,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 50.w,
                          color: const Color(color888888),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      color: Color(colorCECECE),
                      thickness: 0.1,
                      height: 0.1,
                    ),
                  ],
                )));
      },
    );
  }

  ///构建Banner
  Widget _buildBanner() {
    return Container(
        color: Colors.white,
        height: 366.h,
        child: Stack(
          children: [
            Obx(() => CarouselSlider(
                  carouselController: controller.buttonCarouselController,
                  options: CarouselOptions(
                      height: 366.h,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll:
                          (controller.mBannerList.length > 1) ? true : false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 300),
                      autoPlayCurve: Curves.linear,
                      enlargeCenterPage: true,
                      enlargeFactor: 0,
                      scrollDirection: Axis.horizontal,
                      onPageChanged:
                          (int index, CarouselPageChangedReason reason) {
                        controller.changeBannerIndex(index);
                      }),
                  items: controller.mBannerList.map((value) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CommonRipple(
                          onTap: () async {
                            AppManager.instance.tapVibrate();
                            BannerJumpUtils().handleActivity(value);
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: "${value.subject}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )),
            Obx(() => (controller.mBannerList.length > 1)
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 24.h,
                    child: Container(
                      alignment: Alignment.center,
                      child: Obx(() => AnimatedSmoothIndicator(
                            activeIndex: controller.currentBannerIndex.value,
                            count: controller.mBannerList.length,
                            onDotClicked: (index) {
                              controller.buttonCarouselController
                                  .jumpToPage(index);
                            },
                            effect: WormEffect(
                                dotWidth: 22.w,
                                dotHeight: 22.w,
                                activeDotColor: Colors.white,
                                dotColor: Colors.black26),
                          )),
                    ))
                : const SizedBox())
          ],
        ));
  }

  ///构建公告
  Widget _buildAnnouncement(context) {
    return CommonRipple(
      onTap: () async {
        AppManager.instance.tapVibrate();
        if (controller.mMarqueeList.isNotEmpty) {
          List<AnnouncementBean> tempList = [];
          for (var item in controller.mMarqueeList) {
            if ((item.content ?? "").isImageUrl()) {
              CachedNetworkImageProvider imageProvider =
                  CachedNetworkImageProvider(item.content ?? "");
              await precacheImage(imageProvider, Get.context!);
              tempList.add(AnnouncementBean(imageProvider: imageProvider));
            } else {
              tempList.add(AnnouncementBean(html: (item.content ?? "")));
            }
          }
          Get.dialog(SystemAnnouncementDialog(
            title: "跑马灯详情",
            sAnnouncementList: controller.mMarqueeList,
            announcementList: tempList,
          ));
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 32.w,
        ),
        height: 110.h,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(Assets.theme1.images.home.iconAnnouncement,
                width: 40.w,
                height: 40.h,
                colorFilter: const ColorFilter.mode(
                    Color(theme01MainColor), BlendMode.srcIn)),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
                child: Obx(() => controller.marqueeTitle.value.isNotEmpty
                    ? CommonMarquee(
                        text: controller.marqueeTitle.value,
                        blankSpace: 300,
                      )
                    : const SizedBox())),
            Stack(
              clipBehavior: Clip.none,
              children: [
                CommonRipple(
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff4DB0FF),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    height: 50.h,
                    width: 124.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UnconstrainedBox(
                            child: SvgPicture.asset(
                          Assets.theme1.images.home.iconMessage2,
                          width: 30.w,
                          height: 30.h,
                          colorFilter:
                              ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        )),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text("消息",
                            style:
                                TextStyle(fontSize: 30.sp, color: Colors.white))
                      ],
                    ),
                  ),
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    if (LoginManager.instance.isLogin.value) {
                      //登录了才跳转
                      Get.toNamed(Routes.MESSAGE_NOTIFY);
                    } else {
                      showLoginDialog();
                    }
                  },
                ),
                Obx(() => Visibility(
                    visible: (tabsController.unreadCount.value > 0),
                    child: Positioned(
                        right: -10.w,
                        top: -30.h,
                        child: Container(
                          width: tabsController.unreadCount.value > 99
                              ? 60.w
                              : 40.w,
                          height: 40.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20.r)),
                          child: Text(
                            "${tabsController.unreadCount.value > 99 ? '99+' : tabsController.unreadCount.value}",
                            style:
                                TextStyle(fontSize: 26.sp, color: Colors.white),
                          ),
                        )))),
              ],
            ),
            SizedBox(
              width: 20.w,
            ),
            CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                if (TenantManager.instance.isCanOpenCustomerService) {
                  Get.toNamed(Routes.CUSTOMER_SERVICE);
                } else {
                  String? onlineAddr =
                      TenantManager.instance.tenantBean?.tenant?.onlineAddr;
                  if (onlineAddr != null) {
                    String? type = TenantManager.instance.tenantBean?.sysOptions
                        ?.customerServiceSkipType;
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
              child: Container(
                margin: EdgeInsets.only(right: 20.w),
                decoration: BoxDecoration(
                    color: const Color(0xffBE4FFF),
                    borderRadius: BorderRadius.all(Radius.circular(8.r))),
                height: 50.h,
                width: 124.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UnconstrainedBox(
                      child: SvgPicture.asset(
                        Assets.theme1.images.home.iconCustomServiceSvg,
                        width: 30.w,
                        height: 30.h,
                        colorFilter:
                            ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "客服",
                      style: TextStyle(fontSize: 30.sp, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // //通过id拿到界面
  // Widget getViewById() {
  //   NewHomeGameTabBean currentItem =
  //       controller.homeCategoryList[controller.currentTabIndex.value];
  //   Widget pageWidget;
  //   switch (currentItem.key) {
  //     case HomeGameCategory.CHESS_AND_CARDS_KEY:
  //       pageWidget = NewHomeViewDetail(
  //         pageKey: HomePageDetailEnum.chess,
  //         gameId: controller.gameId.value,
  //       );
  //       break;
  //     case HomeGameCategory.LOTTERY_KEY:
  //       pageWidget = NewHomeViewDetail(
  //         pageKey: HomePageDetailEnum.lottery,
  //         gameId: controller.gameId.value,
  //       );
  //       break;
  //     case HomeGameCategory.ELECTRONIC_KEY:
  //       pageWidget = NewHomeViewDetail(
  //         pageKey: HomePageDetailEnum.electronic,
  //         gameId: controller.gameId.value,
  //       );
  //       break;
  //     case HomeGameCategory.BLOCKCHAIN_KEY:
  //       pageWidget = NewHomeViewDetail(
  //         pageKey: HomePageDetailEnum.blockChain,
  //         gameId: controller.gameId.value,
  //       );
  //       break;
  //     case HomeGameCategory.FISHING_KEY:
  //       pageWidget = NewHomeViewDetail(
  //         pageKey: HomePageDetailEnum.fishing,
  //         gameId: controller.gameId.value,
  //       );
  //       break;
  //     case HomeGameCategory.LIVE_KEY:
  //       pageWidget = NewHomeViewDetail(
  //         pageKey: HomePageDetailEnum.live,
  //         gameId: controller.gameId.value,
  //       );
  //       break;
  //     case HomeGameCategory.SPORTS_KEY:
  //       pageWidget = NewHomeViewDetail(
  //         pageKey: HomePageDetailEnum.sports,
  //         gameId: controller.gameId.value,
  //       );
  //       break;
  //     case HomeGameCategory.COLLECT_KEY: //收藏
  //       pageWidget = NewHomeViewDetail(
  //         pageKey: HomePageDetailEnum.collect,
  //         gameId: controller.gameId.value,
  //       );
  //     case HomeGameCategory.RECENT_KEY: //最近
  //       pageWidget = NewHomeViewDetail(
  //         pageKey: HomePageDetailEnum.recent,
  //         gameId: controller.gameId.value,
  //       );
  //     case HomeGameCategory.RECOMMEND_KEY: //推荐
  //       pageWidget = SliverList(
  //         delegate: SliverChildListDelegate(
  //           _buildGameList(),
  //         ),
  //       );
  //     default:
  //       pageWidget = const SliverToBoxAdapter();
  //       break;
  //   }
  //   if (pageWidget is SliverToBoxAdapter || pageWidget is SliverList) {
  //     return pageWidget;
  //   } else {
  //     return SliverToBoxAdapter(
  //       child: pageWidget,
  //     );
  //   }
  // }

  ///构建游戏列表
  List<Widget> _buildGameList() {
    Map<String, NewCommonGameList> gameWidgetMap = {
      GameTypeConstants.live: NewCommonGameList(
        title: "真人视讯",
        icon: Assets.theme1.images.home.iconGameRealPerson,
        gameItemType: GameItemType.itemType3,
        gameType: GameTypeConstants.live,
        clickAll: () {
          AppManager.instance.tapVibrate();
          controller.clickAll(GameTypeConstants.live);
        },
      ),
      GameTypeConstants.electronic: NewCommonGameList(
        title: "电子",
        icon: Assets.theme1.images.home.iconGameElectronic,
        gameItemType: GameItemType.itemType4,
        gameType: GameTypeConstants.electronic,
        clickAll: () {
          AppManager.instance.tapVibrate();
          controller.clickAll(GameTypeConstants.electronic);
        },
      ),
      GameTypeConstants.blockchain: NewCommonGameList(
        title: "区块链",
        icon: Assets.theme1.images.home.iconGameBlockchain,
        gameItemType: GameItemType.itemType4,
        gameType: GameTypeConstants.blockchain,
        clickAll: () {
          AppManager.instance.tapVibrate();
          controller.clickAll(GameTypeConstants.blockchain);
        },
      ),
      GameTypeConstants.fishing: NewCommonGameList(
        title: "捕鱼",
        icon: Assets.theme1.images.home.iconGameFishing,
        gameItemType: GameItemType.itemType4,
        gameType: GameTypeConstants.fishing,
        clickAll: () {
          AppManager.instance.tapVibrate();
          controller.clickAll(GameTypeConstants.fishing);
        },
      ),
      GameTypeConstants.chess: NewCommonGameList(
        title: "棋牌",
        icon: Assets.theme1.images.home.iconGameChessAndCards,
        gameItemType: GameItemType.itemType4,
        gameType: GameTypeConstants.chess,
        clickAll: () {
          AppManager.instance.tapVibrate();
          controller.clickAll(GameTypeConstants.chess);
        },
      ),
      GameTypeConstants.sports: NewCommonGameList(
        title: "体育",
        icon: Assets.theme1.images.home.iconGameSport,
        gameItemType: GameItemType.itemType4,
        gameType: GameTypeConstants.sports,
        clickAll: () {
          AppManager.instance.tapVibrate();
          controller.clickAll(GameTypeConstants.sports);
        },
      ),
      GameTypeConstants.lottery: NewCommonGameList(
        gameItemType: GameItemType.itemType5,
        title: "彩票",
        clickAll: () {
          AppManager.instance.tapVibrate();
          controller.clickAll(GameTypeConstants.lottery);
        },
        icon: Assets.theme1.images.home.iconGameLottery,
      ),
    };

    return [
      NewCommonGameList(
        gameItemType: GameItemType.itemType1,
        title: "热门游戏",
        icon: Assets.theme1.images.home.iconGameHot,
        isShowAll: true,
        clickAll: () {
          AppManager.instance.tapVibrate();
          Get.to(const HotGameDetailView());
        },
      ),
      Obx(() {
        List<Widget> resultList = [];
        if (controller.menuList.isNotEmpty) {
          for (int i = 0; i < controller.menuList.length; i++) {
            var widgetKey = controller.menuList[i];
            var child = gameWidgetMap[widgetKey];
            if (child != null) {
              resultList.add(child);
            }
          }
        }
        return Column(
          children: resultList,
        );
      }),
      // NewCommonGameList(
      //     gameItemType: GameItemType.itemType6,
      //     title: "赌神排行榜",
      //     icon: Assets.theme1.images.home.iconGameRankingList),
    ];
  }

  ///构建底部信息栏
  Widget _buildBottomView() {
    return Container(
      key: controller.bottomViewKey,
      margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 60.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("资质认证"),
                      SizedBox(height: 40.h),
                      SizedBox(
                        height: 125.h,
                        width: 510.w,
                        child:
                            Image.asset(Assets.theme1.images.home.footer1.path),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("合作伙伴"),
                      SizedBox(height: 40.h),
                      SizedBox(
                        height: 125.h,
                        width: 510.w,
                        child:
                            Image.asset(Assets.theme1.images.home.footer2.path),
                      ),
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 60.h,
          ),
          // Obx(() => SizedBox(
          //       width: 325.w,
          //       height: 78.h,
          //       child: controller.iconPath.value.isNotEmpty
          //           ? Image.network(controller.iconPath.value)
          //           : const SizedBox(),
          //     )),
          // SizedBox(
          //   height: 38.h,
          // ),
//           Text(
//             """本站提供包括风险在内的在线赌场体验。
// 我们网站的用户必须是18+。
// 对于违反您当地与IGaming相关的法律，我们概不负责。
// 负责地玩，在${controller.appName.value}中玩得开心。
//           """,
//             style: TextStyle(fontSize: 36.sp),
//           ),
          Wrap(
            spacing: 20.w,
            runSpacing: 20.w,
            children: [
              SizedBox(
                height: 66.h,
                width: 310.w,
                child: Image.asset(Assets.theme1.images.home.footer3.path),
              ),
            ],
          ),
          // SizedBox(
          //   height: 60.h,
          // ),
          // Text("Copyright(C)${DateTime.now().year} All Rights Reserved.",
          //     style: TextStyle(fontSize: 36.sp)),
          SizedBox(
            height: 100.h,
          ),
        ],
      ),
    );
  }
}

class _TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final bool isFixed;

  _TabBarHeaderDelegate({required this.isFixed});

  @override
  double get minExtent => 170.h; // Minimum height of TabBar
  @override
  double get maxExtent => 170.h; // Maximum height of TabBar

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const NewHomeGameTab();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
