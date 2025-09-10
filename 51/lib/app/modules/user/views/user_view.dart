import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/webview/widget/common_dialog.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/banner_jump_utils.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/clipboard_util.dart';
import '../../../../utils/tenant_manager.dart';
import '../../../routes/app_pages.dart';
import '../controllers/user_controller.dart';
import '../widget/vip_power_widget.dart';

///我的页面
class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late UserController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return CommonRipple(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
          floatingActionButton: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: context.theme.primaryColor),
            child: IconButton(
                iconSize: 30,
                color: Colors.white,
                onPressed: () {
                  Get.toNamed(Routes.MINE_SETTING);
                },
                icon: const Icon(Icons.settings)),
          ),
          backgroundColor: context.customTheme?.pageBg,
          body: RefreshIndicator(
            onRefresh: () {
              return controller.initUserInfo(isRefresh: true);
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                margin: EdgeInsets.only(bottom: 100.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        context.theme.primaryColor.withOpacity(0.5),
                        Colors.white.withOpacity(0.1),
                      ],
                      stops: const [
                        0.1,
                        0.2,
                      ]),
                ),
                child: Column(
                  children: [_buildHeader(context), _buildBody(context)],
                ),
              ),
            ),
          )),
    );
  }

  //构建头部信息
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 290.h,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        children: [
          Positioned(
            top: 30.h,
            right: 30.w,
            child: Row(
              children: [
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    if (TenantManager.instance.isCanOpenCustomerService) {
                      Get.toNamed(Routes.CUSTOMER_SERVICE);
                    } else {
                      String? onlineAddr =
                          TenantManager.instance.tenantBean?.tenant?.onlineAddr;
                      if (onlineAddr != null) {
                        String? type = TenantManager.instance.tenantBean
                            ?.sysOptions?.customerServiceSkipType;
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
                  child: SvgPicture.asset(
                    Assets.theme1.images.user.iconCustomServiceSvg,
                    width: 60.w,
                    height: 60.h,
                  ),
                ),
                SizedBox(
                  width: 60.w,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        if (LoginManager.instance.isLogin.value) {
                          //登录了才跳转
                          Get.toNamed(Routes.MESSAGE_NOTIFY);
                        } else {
                          showLoginDialog();
                        }
                      },
                      child: SvgPicture.asset(
                        Assets.theme1.images.user.iconNotifySvg,
                        width: 60.w,
                        height: 60.h,
                      ),
                    ),
                    Obx(() => Visibility(
                        visible:
                            (controller.tabsController.unreadCount.value > 0),
                        child: Positioned(
                            right: -10.w,
                            top: -10.h,
                            child: Container(
                              width:
                                  controller.tabsController.unreadCount.value >
                                          99
                                      ? 60.w
                                      : 40.w,
                              height: 40.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.r)),
                              child: Text(
                                "${controller.tabsController.unreadCount.value > 99 ? '99+' : controller.tabsController.unreadCount.value}",
                                style: TextStyle(
                                    fontSize: 26.sp, color: Colors.white),
                              ),
                            )))),
                  ],
                ),
                SizedBox(
                  width: 60.w,
                ),
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    if (LoginManager.instance.isLogin.value) {
                      //登录了才跳转
                      Get.toNamed(Routes.SETTINGS)!.then((value) {
                        //当从设置界面回来，不管是否更新了数据，都刷新一次界面
                        controller.initUserInfo(isRefresh: true);
                      });
                    } else {
                      showLoginDialog();
                    }
                  },
                  child: SvgPicture.asset(
                    Assets.theme1.images.user.iconSetting,
                    width: 60.w,
                    height: 60.h,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 110.h,
            left: 0,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() => CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        if (LoginManager.instance.isLogin.value) {
                          Get.toNamed(Routes.CHANGE_AVATAR)?.then((_) {
                            controller.initUserInfo();
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 61.w,
                        backgroundColor: context.theme.primaryColor,
                        backgroundImage: controller.userHead.value.isNotEmpty
                            ? NetworkImage(
                                controller.userHead.value,
                              )
                            : AssetImage(Assets.theme1.images.home
                                .rankListHeader1.path) as ImageProvider,
                      ),
                    )),
                SizedBox(width: 40.w),
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CommonRipple(
                                child: Text(
                                  controller.userName.value,
                                  style: TextStyle(
                                      color: context.customTheme?.titleColor,
                                      fontSize: 60.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  AppManager.instance.tapVibrate();
                                  if (!LoginManager.instance.isLogin.value) {
                                    showLoginDialog();
                                  }
                                }),
                            SizedBox(
                              width: 20.w,
                            ),
                            CircleAvatar(
                              backgroundColor: const Color(0x4DDBDBD4),
                              radius: 24.w,
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: const Color(0xff8E9FA1),
                                size: 40.w,
                              ),
                            )
                          ],
                        ),
                        Visibility(
                            visible: controller.userId.isNotEmpty,
                            child: Row(
                              children: [
                                Text(
                                  "ID:${controller.userId}",
                                  style: TextStyle(
                                      fontSize: 42.sp,
                                      color: context.customTheme?.title2Color),
                                ),
                                SizedBox(width: 30.w),
                                CommonRipple(
                                    onTap: () {
                                      AppManager.instance.tapVibrate();
                                      ClipboardUtil.copy(
                                          controller.userId.value);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          10.w, 10.h, 0, 10.h),
                                      child: SvgPicture.asset(
                                        Assets.theme1.images.user.iconCopy,
                                        width: 42.w,
                                        colorFilter: const ColorFilter.mode(
                                          Color(color979797),
                                          BlendMode.srcIn,
                                        ),
                                        height: 42.h,
                                      ),
                                    ))
                              ],
                            ))
                      ],
                    )),
                const Spacer(),
                Container(
                  margin: EdgeInsets.only(top: 30.h, right: 30.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 30.w),
                  decoration: BoxDecoration(
                    color: context.customTheme?.pageTwoBg,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.theme1.images.user.iconSign.path,
                        fit: BoxFit.contain,
                        width: 44.w,
                        height: 44.h,
                        color: context.theme.primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '签到',
                        style: TextStyle(
                          color: context.customTheme?.titleColor,
                          fontSize: 36.sp,
                        ),
                      ),
                    ],
                  ),
                ).onTap(() {
                  AppManager.instance.tapVibrate();
                  if (LoginManager.instance.isLogin.value) {
                    controller.pushToActivity('签到');
                  } else {
                    showLoginDialog(callback: () {
                      Get.toNamed(Routes.RECHARGE);
                    });
                  }
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildVipAndWallet(context), //构建Vip和钱包
        _buildFunctions(context), //构建功能区
        _buildBanner(), //轮播图
        _buildBottomList(context), //构建底部列表item
        // _buildBottomList2(), //构建底部列表item
        Obx(() => Visibility(
            visible: LoginManager.instance.isLogin.value,
            child: _buildLoginOutButton())), //构建退出登录按钮
        _buildVersionInfo(),
        SizedBox(
          height: 200.h,
        )
      ],
    );
  }

  ///构建Banner
  Widget _buildBanner() {
    return Obx(() => controller.bannerList.isNotEmpty
        ? Container(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(30.r),
            //   color: Colors.white,
            // ),
            margin: EdgeInsets.only(bottom: 25.h),
            height: controller.bannerHeight.value.h,
            child: Stack(
              children: [
                Center(
                  child: CarouselSlider(
                    carouselController: controller.buttonCarouselController,
                    options: CarouselOptions(
                        height: controller.bannerHeight.value.h,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll:
                            (controller.bannerList.length > 1) ? true : false,
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
                    items: controller.bannerList.map((value) {
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.r),
                                child: CachedNetworkImage(
                                  imageUrl: "${value.subject}",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                Obx(() => (controller.bannerList.length > 1)
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 15.h,
                        child: Container(
                          alignment: Alignment.center,
                          child: Obx(() => AnimatedSmoothIndicator(
                                activeIndex:
                                    controller.currentBannerIndex.value,
                                count: controller.bannerList.length,
                                onDotClicked: (index) {
                                  controller.buttonCarouselController
                                      .jumpToPage(index);
                                },
                                effect: ExpandingDotsEffect(
                                    dotWidth: 22.w,
                                    dotHeight: 22.w,
                                    activeDotColor: Colors.white,
                                    dotColor: Colors.black26),
                              )),
                        ))
                    : const SizedBox())
              ],
            ))
        : const SizedBox());
  }

  Widget _buildLoginOutButton() {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        Get.dialog(Obx(
          () => CommonDialog(
            title: "退出登录？",
            isLoading: controller.isLogoutLoading.value,
            clickOk: () {
              AppManager.instance.tapVibrate();
              Get.back();
              controller.logout();
            },
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.only(top: 100.h),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(70.r)),
        height: 140.h,
        child: Text(
          "退出登录",
          style: TextStyle(fontSize: 42.sp, color: Colors.white),
        ),
      ),
    );
  }

  ///构建Vip和钱包
  Widget _buildVipAndWallet(BuildContext context) {
    return SizedBox(
      height: 430.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 300.h,
              child: CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  if (LoginManager.instance.isLogin.value) {
                    Get.toNamed(Routes.VIP)?.then((_) {
                      controller.reqVipData();
                    });
                  } else {
                    showLoginDialog(callback: () {
                      Get.toNamed(Routes.VIP)?.then((_) {
                        controller.reqVipData();
                      });
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  padding:
                      EdgeInsets.only(left: 30.w, right: 30.w, bottom: 36.h),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            ThemeService.to.currentTheme.value?.model ==
                                    'blackGold'
                                ? Assets.theme1.images.user.vipBgBlackGold.path
                                : Assets.theme1.images.user.vipBg.path),
                        fit: BoxFit.fitWidth,
                        alignment: const Alignment(0, -1), // 将图像对齐到顶部
                      ),
                      color: Colors.black12,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.r),
                          bottomRight: Radius.circular(50.r))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() => LoginManager.instance.isLogin.value
                          ? Row(
                              children: [
                                Image.asset(
                                  Assets.theme1.images.user.iconVip1.path,
                                  width: 102.w,
                                  height: 40.h,
                                ),
                                Obx(() => Text(
                                    "${LoginManager.instance.vipLevel.value}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 58.sp,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold))),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Obx(() => Expanded(
                                        child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          top: -50.h,
                                          left: 0,
                                          right: 0,
                                          child: Obx(() => Text(
                                                textAlign: TextAlign.center,
                                                "${controller.showStr}",
                                                style: TextStyle(
                                                    fontSize: 33.sp,
                                                    color: const Color(
                                                        0xffDFFBFF)),
                                              )),
                                        ),
                                        progressBar(
                                            paddingTop: 6,
                                            color: context.theme.primaryColor,
                                            progress:
                                                (controller.allProgress.value)),
                                      ],
                                    ))),
                                SizedBox(
                                  width: 10.w,
                                ),
                                if (!controller.isMaxLevel.value) ...[
                                  Image.asset(
                                    Assets.theme1.images.user.iconVip2.path,
                                    width: 102.w,
                                    height: 40.h,
                                  ),
                                  Obx(() => Text(
                                      "${LoginManager.instance.vipLevel.value + 1}",
                                      style: TextStyle(
                                          color: const Color(0xff8ED8E3),
                                          fontSize: 58.sp,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold)))
                                ],
                                if (controller.isMaxLevel.value)
                                  SizedBox(
                                    width: 170.w,
                                  ),
                              ],
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 47.h, bottom: 10.h),
                              child: Text(
                                "加入VIP专享豪礼>",
                                style: TextStyle(
                                    fontSize: 36.sp, color: Colors.white),
                              ),
                            )),
                      Obx(
                        () => Row(
                          children: [
                            VipPowerWidget(
                              title: '周俸禄',
                              power: controller.isWeekPower.value,
                            ),
                            SizedBox(
                              width: 37.w,
                            ),
                            VipPowerWidget(
                              title: '月俸禄',
                              power: controller.isMonthPower.value,
                            ),
                            SizedBox(
                              width: 37.w,
                            ),
                            VipPowerWidget(
                              title: '晋级礼金',
                              power: controller.isLevelPower.value,
                            ),
                            SizedBox(
                              width: 37.w,
                            ),
                            VipPowerWidget(
                              title: '自助返水',
                              power: controller.isRebetePower.value,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              left: 0, right: 0, top: 0, child: _buildWalletWidget(context)),
        ],
      ),
    );
  }

  Widget progressBar(
      {required int paddingTop,
      required Color color,
      required double progress}) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop.h),
      child: Stack(
        children: [
          // 背景灰色进度条
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 18.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color(0xff012E34),
                  border:
                      Border.all(color: const Color(0xff074E58), width: 2.w)),
            ),
          ),

          // 渐变色进度条
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.white, color], // 进度条颜色（红色 -> 蓝色）
            ).createShader(bounds),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 18.h,
                    width: constraints.maxWidth * progress, // 进度 60%
                    color: Colors.white, // 必须加个白色，否则 ShaderMask 无效
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///构建钱包
  Widget _buildWalletWidget(BuildContext context) {
    return Container(
      height: 220.h,
      decoration: BoxDecoration(
          color: context.customTheme?.pageTwoBg,
          borderRadius: BorderRadius.all(Radius.circular(60.r))),
      child: Container(
        margin: EdgeInsets.only(left: 45.w, right: 60.w),
        child: Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    if (LoginManager.instance.isLogin.value) {
                      Get.toNamed(Routes.FIND_BALANCE)
                          ?.then((_) => controller.reqMoney()); //找回余额
                    } else {
                      showLoginDialog(callback: () {
                        Get.toNamed(Routes.FIND_BALANCE)
                            ?.then((_) => controller.reqMoney()); //找回余额
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        "钱包余额",
                        style: TextStyle(
                            color: context.customTheme?.titleColor,
                            fontSize: 39.sp),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      CircleAvatar(
                        backgroundColor: const Color(0x4DDBDBD4),
                        radius: 24.w,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: const Color(0xff8E9FA1),
                          size: 40.w,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 38.h,
                ),
                Obx(() => LoginManager.instance.isLogin.value
                    ? Row(
                        children: [
                          Image.asset(
                            Assets.theme1.images.user.iconMoney.path,
                            width: 45.w,
                            height: 45.h,
                            color: context.theme.primaryColor,
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Obx(() => Text(
                                "${LoginManager.instance.balanceStr.value}",
                                style: TextStyle(
                                    color: context.customTheme?.titleColor,
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                          CommonRipple(
                            onTap: () {
                              AppManager.instance.tapVibrate();
                              controller.reqMoney();
                            },
                            // child: SvgPicture.asset(
                            //   Assets.theme1.images.user.iconRefresh,
                            //   colorFilter: ColorFilter.mode(
                            //       Color(0xffC6C7CC), BlendMode.srcIn),
                            //   width: 40.w,
                            //   height: 40.h,
                            // ),
                            child: AnimatedBuilder(
                              animation: controller.animationController,
                              child: SvgPicture.asset(
                                Assets.theme1.images.user.iconRefresh,
                                width: 40.w,
                                colorFilter: ColorFilter.mode(
                                    context.customTheme?.titleColor ??
                                        Colors.transparent,
                                    BlendMode.srcIn),
                              ),
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: controller.animationController.value *
                                      2.0 *
                                      pi, // 旋转角度
                                  child: child,
                                );
                              },
                            ),
                          )
                        ],
                      )
                    : CommonRipple(
                        child: Text(
                          "登录/注册后查看",
                          style: TextStyle(
                              fontSize: 42.sp,
                              color: context.customTheme?.titleColor),
                        ),
                        onTap: () {
                          AppManager.instance.tapVibrate();
                          if (!LoginManager.instance.isLogin.value) {
                            showLoginDialog();
                          }
                        },
                      ))
              ],
            )),
            Obx(() => Visibility(
                visible: LoginManager.instance.isLogin.value,
                child: CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    controller.pushToActivity('利息宝');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.theme1.images.user.homeMenuYeb.path,
                        width: 105.w,
                        height: 89.h,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text("利息宝",
                          style: TextStyle(
                              color: context.customTheme?.titleColor,
                              fontSize: 39.sp))
                    ],
                  ),
                ))),
            SizedBox(
              width: 80.w,
            ),
            CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                DebounceThrottle.debounce(controller.handleRecharge)();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.theme1.images.user.iconRecharge2.path,
                    width: 105.w,
                    height: 89.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text("充值",
                      style: TextStyle(
                          color: context.customTheme?.titleColor,
                          fontSize: 39.sp))
                ],
              ),
            ),
            SizedBox(
              width: 80.w,
            ),
            CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  DebounceThrottle.debounce(controller.handleWithdraw)();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.theme1.images.user.iconPayouts2.path,
                      width: 105.w,
                      height: 89.h,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "提现",
                      style: TextStyle(color: context.customTheme?.titleColor, fontSize: 39.sp),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  ///构建金刚区、功能区
  Widget _buildFunctions(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 25.h),
      padding: EdgeInsets.symmetric(vertical: 26.h, horizontal: 70.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: Get.context?.customTheme?.pageTwoBg),
      child: Center(
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: controller.functionsList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemBuilder: (context, index) {
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.clickFunctions(index);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGridItemIcon(index),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      controller.functionsList[index],
                      style: TextStyle(
                          color: context.customTheme?.titleColor,
                          fontSize: 39.sp),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _buildGridItemIcon(int index) {
    Widget image;
    switch (index) {
      case 1:
        image = Image.asset(
          Assets.theme1.images.user.iconDaili1.path,
          width: 72.w,
          height: 76.h,
        );
        break;
      case 2:
        image = Image.asset(
          Assets.theme1.images.user.iconAccount1.path,
          width: 72.w,
          height: 76.h,
        );
        break;
      case 3:
        image = Image.asset(
          Assets.theme1.images.user.iconTrade1.path,
          width: 72.w,
          height: 76.h,
        );
        break;
      default:
        image = Image.asset(
          Assets.theme1.images.user.iconBet1.path,
          width: 72.w,
          height: 76.h,
        );
        break;
    }
    return image;
  }

  ///构建底部item列表
  Widget _buildBottomList(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: context.customTheme?.pageTwoBg),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.bottomItemList.length,
            itemBuilder: (context, index) {
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.clickItemList1(index);
                },
                child: Container(
                    height: 150.h,
                    margin: EdgeInsets.only(left: 40.w, right: 40.w),
                    decoration: (index != controller.bottomItemList.length - 1)
                        ? const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey, width: 0.2), // 添加下划线
                            ),
                          )
                        : BoxDecoration(color: context.customTheme?.pageTwoBg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildListItemIcon1(index),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          controller.bottomItemList[index],
                          style: TextStyle(
                              color: context.customTheme?.titleColor,
                              fontSize: 42.sp),
                        ),
                        const Spacer(),
                        if (controller.bottomItemList[index] == '福利中心') ...[
                          Obx(() {
                            bool showRedDot = controller
                                .tabsController.collections.isNotEmpty;
                            if (!showRedDot) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: EdgeInsets.only(top: 5.h, right: 20.w),
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                constraints: BoxConstraints(
                                  minWidth: 40.w,
                                  minHeight: 40.h,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    controller.tabsController.collections.length
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 30.w,
                          color: context.customTheme?.title2Color,
                        ),
                      ],
                    )),
              );
            }));
  }

  ///构建底部item列表2
  Widget _buildBottomList2() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 30.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.r), color: Colors.white),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.bottomItemList2.length,
            itemBuilder: (context, index) {
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.clickItemList2(index);
                },
                child: Container(
                    height: 150.h,
                    margin: EdgeInsets.only(left: 40.w, right: 40.w),
                    decoration: (index != controller.bottomItemList2.length - 1)
                        ? const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey, width: 0.2), // 添加下划线
                            ),
                          )
                        : const BoxDecoration(color: Colors.white),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildListItemIcon2(index),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          controller.bottomItemList2[index],
                          style: TextStyle(fontSize: 42.sp),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 30.w,
                        ),
                      ],
                    )),
              );
            }));
  }

  Widget _buildListItemIcon1(int index) {
    Widget image;
    switch (index) {
      case 0:
        image = Image.asset(
          Assets.theme1.images.user.iconBonus.path,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
        break;
      case 1:
        image = Image.asset(
          Assets.theme1.images.user.iconRebates.path,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
        break;
      case 2:
        image = Image.asset(
          Assets.theme1.images.user.iconFindMoney.path,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
        break;
      case 3:
        image = Image.asset(
          Assets.theme1.images.user.iconPersonalStatements.path,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
        break;
      case 4:
        image = Image.asset(
          Assets.theme1.images.user.iconNet.path,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
        break;
      default:
        image = Image.asset(
          Assets.theme1.images.user.iconCustom.path,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
        break;
    }
    return image;
  }

  Widget _buildListItemIcon2(int index) {
    Widget image;
    switch (index) {
      case 1:
        image = Image.asset(
          Assets.theme1.images.user.iconAbout.path,
          width: 50.w,
          height: 50.h,
        );
        break;
      case 2:
        image = Image.asset(
          Assets.theme1.images.user.iconCustom.path,
          width: 50.w,
          height: 50.h,
        );
        break;
      default:
        image = Image.asset(
          Assets.theme1.images.user.iconHelp.path,
          width: 50.w,
          height: 50.h,
        );
        break;
    }
    return image;
  }

  Widget _buildVersionInfo() {
    return Container(
      padding: EdgeInsets.only(top: 30.h),
      child: Obx(
        () => Text(
          controller.versionStr.value,
          style: TextStyle(color: Colors.grey, fontSize: 30.sp),
        ),
      ),
    );
  }
}
