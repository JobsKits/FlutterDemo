import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/nightHome/real_time_prizes.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/string_utils.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/game_constants.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../kernel/utils/game_utils.dart';
import '../../../../utils/app_manager.dart';
import '../../../../utils/banner_jump_utils.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/login_manager.dart';
import '../../../../utils/public_util.dart';
import '../../../../utils/tenant_manager.dart';
import '../../../data/home_main_info_bean.dart';
import '../../../routes/app_pages.dart';
import '../../../widget/common_gradient.dart';
import '../../../widget/common_marquee.dart';
import '../../../widget/system_announcement_dialog.dart';
import '../model/announcement_bean.dart';
import '../new_home_const.dart';
import 'common_game_search_view.dart';

//夜间主题首页推荐页面
class NightRecommendPage extends StatefulWidget {
  const NightRecommendPage({super.key});

  @override
  State<NightRecommendPage> createState() => _NightRecommendPageState();
}

class _NightRecommendPageState extends State<NightRecommendPage> {
  NewHomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller.scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: _buildBanner(),
        ),
        SliverToBoxAdapter(
          child: _buildAnnouncement(context),
        ),
        if (TenantManager
                .instance.tenantBean?.sysOptions?.bigWinGameRecommend ==
            "1") //是否开启实时爆奖 0 关闭 1 开启
          SliverToBoxAdapter(
            child: RealTimePrizes(),
          ),
        SliverPersistentHeader(
          pinned: true, // 使该组件固定在顶部
          delegate: _SliverHeaderDelegate(
              child: CommonGameSearchView(
                search: (str) {
                  if (str.isEmpty) {
                    controller.hotGameList.value = controller.oldHotGameList;
                    return;
                  }
                  controller.hotGameList.value = controller.hotGameList
                      .where((item) => (item.play_cname ?? "").contains(str))
                      .toList();
                },
                clickHot: () {
                  controller.hotGameList.value = controller.oldHotGameList;
                },
                clickCollect: () {
                  controller.hotGameList.value = controller.hotGameList
                      .where((item) => item.play_collection == 2)
                      .toList();
                },
              ),
              minHeight: 140.h,
              maxHeight: 140.h),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
            height: 400.h,
            child: GestureDetector(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.openHotGame(controller.gameBeanItem.value!);
              },
              child: CachedNetworkImage(
                imageUrl: controller.gameBeanItem.value!.logo1_img_url ?? "",
                imageBuilder: (context, imageProvider) =>
                    _buildHotGameContainer2(
                  hotDataItem: controller.gameBeanItem.value!,
                  image: DecorationImage(
                      alignment: Alignment.centerRight,
                      image: imageProvider,
                      fit: BoxFit.cover),
                  index: 0,
                ),
                errorWidget: (context, url, error) => _buildHotGameContainer2(
                  hotDataItem: controller.gameBeanItem.value!,
                  image: DecorationImage(
                    alignment: Alignment.centerRight,
                    image: AssetImage(Assets.theme1.images.home.errorImg.path),
                  ),
                  index: 0,
                ),
              ),
            ),
          ),
        ),
        Obx(() => controller.hotGameList.isNotEmpty
            ? SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final hotDataItem = controller.hotGameList[index];
                    bool isMaintain = hotDataItem.state!.toInt() == 2;
                    String test = GameUtils.determineTypeConst2(
                        hotDataItem.upper_play_id?.toInt() ?? 0);
                    String smallIconPath = GameUtils.getHomeTabDefaultColorIcon(
                        gameType: test, playId: hotDataItem.upper_play_id!);
                    bool isBigType =
                        hotDataItem.play_id == hotDataItem.upper_play_id;
                    String imageUrl = hotDataItem.gameImgUrl!;
                    if (hotDataItem.thumbnail_img_url != null &&
                        hotDataItem.thumbnail_img_url != "null" &&
                        hotDataItem.thumbnail_img_url != "") {
                      imageUrl = hotDataItem.thumbnail_img_url!;
                    }

                    if (isBigType) {
                      if (hotDataItem.logo1_img_url != null &&
                          hotDataItem.logo1_img_url != "null" &&
                          hotDataItem.logo1_img_url != "") {
                        imageUrl = hotDataItem.logo1_img_url!;
                      }
                    }
                    return Stack(
                      children: [
                        SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              jumpGame(hotDataItem, isMaintain, index);
                            },
                            child: Container(
                              width: 1.sw,
                              height: 1.sh,
                              padding: EdgeInsets.only(bottom: 20.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36.r),
                                color: Colors.red,
                                gradient: CommonGradient.getRadialGradient(
                                    index: index),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                      child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: const Color(
                                                        colorF4F4F4),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30.r))),
                                                child:
                                                    CircularProgressIndicator(
                                                  color: context
                                                      .theme.primaryColor,
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(Assets.theme1.images
                                                  .home.errorImg.path),
                                          imageUrl: imageUrl)),
                                  Text(
                                    '${hotDataItem.play_cname}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 42.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(colorFFFFFF),
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            left: 20.w,
                            top: 20.h,
                            child: Image.asset(
                              smallIconPath,
                              width: 80.w,
                              height: 80.h,
                              errorBuilder: (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) {
                                return const SizedBox();
                              },
                            )),
                        Positioned(
                          top: 20.h,
                          right: 30.w,
                          child: CircleAvatar(
                            radius: 26.r,
                            backgroundColor: Colors.transparent,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                AppManager.instance.tapVibrate();
                                controller.collectGame(gameIem: hotDataItem);
                              },
                              icon: SvgPicture.asset(
                                hotDataItem.play_collection! == 1
                                    ? Assets
                                        .theme1.images.home.iconCollectUncheck
                                    : Assets
                                        .theme1.images.home.iconCollectChecked,
                                width: 52.w,
                                height: 52.h,
                              ),
                            ),
                          ),
                        ),
                        if (isMaintain)
                          Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: const Color.fromARGB(178, 0, 0, 0),
                              ),
                              child: Center(
                                  child: SizedBox(
                                height: 230.h,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      Assets.theme1.images.home.systemMaintain
                                          .path,
                                      width: 152.w,
                                      height: 152.h,
                                    ),
                                    Text(
                                      '维护中...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40.sp,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                            ),
                          ),
                      ],
                    );
                  },
                  childCount: controller.hotGameList.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 每行 3 个
                  mainAxisSpacing: 20.w,
                  crossAxisSpacing: 20.h,
                  childAspectRatio: 0.82, // 宽高比
                ),
              )
            : SliverToBoxAdapter()),
      ],
    );
  }

  Widget _buildHotGameContainer2({
    required DecorationImage image,
    required GameBeanItem hotDataItem,
    required int index,
  }) {
    return Container(
      width: 500.w,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        image: image,
        gradient: CommonGradient.getRadialGradient(index: index),
      ),
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
                        return GestureDetector(
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
  Widget _buildAnnouncement(BuildContext context) {
    return InkWell(
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
        color: context.customTheme?.pageTwoBg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(Assets.theme1.images.home.iconAnnouncement,
                width: 40.w,
                height: 40.h,
                colorFilter: ColorFilter.mode(
                    context.theme.primaryColor, BlendMode.srcIn)),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
                child: Obx(() => controller.marqueeTitle.value.isNotEmpty
                    ? CommonMarquee(
                        text: controller.marqueeTitle.value,
                        blankSpace: 300,
                        style:
                            TextStyle(color: context.customTheme?.titleColor),
                      )
                    : const SizedBox())),
            Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: context.theme.primaryColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.r),
                        )),
                    height: 50.h,
                    width: 124.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UnconstrainedBox(
                            child: SvgPicture.asset(
                          Assets.theme1.images.home.iconNightHomeMsg,
                          width: 30.w,
                          height: 30.h,
                          colorFilter: ColorFilter.mode(
                              context.theme.primaryColor, BlendMode.srcIn),
                        )),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text("消息",
                            style: TextStyle(
                                fontSize: 30.sp,
                                color: context.theme.primaryColor))
                      ],
                    ),
                  ),
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    if (LoginManager.instance.isLogin.value) {
                      //登录了才跳转
                      Get.toNamed(Routes.MESSAGE_NOTIFY)?.then((_) {
                        // controller.reqMessage();
                      });
                    } else {
                      showLoginDialog();
                    }
                  },
                ),
                Obx(() => Visibility(
                    visible: (controller.unReadCount.value > 0),
                    child: Positioned(
                        right: -10.w,
                        top: -30.h,
                        child: Container(
                          width:
                              controller.unReadCount.value > 99 ? 60.w : 40.w,
                          height: 40.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20.r)),
                          child: Text(
                            "${controller.unReadCount.value > 99 ? '99+' : controller.unReadCount.value}",
                            style:
                                TextStyle(fontSize: 26.sp, color: Colors.white),
                          ),
                        )))),
              ],
            ),
            SizedBox(
              width: 20.w,
            ),
            GestureDetector(
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
                    border: Border.all(color: context.theme.primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(8.r))),
                height: 50.h,
                width: 124.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UnconstrainedBox(
                      child: Image.asset(
                        Assets.theme1.images.home.iconNightHomeCoustom.path,
                        width: 30.w,
                        height: 30.h,
                        color: context.theme.primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "客服",
                      style: TextStyle(
                          fontSize: 30.sp, color: context.theme.primaryColor),
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

  jumpGame(GameBeanItem hotDataItem, bool isMaintain, index) {
    AppManager.instance.tapVibrate();
    if (!isMaintain) {
      bool isBigClass =
          hotDataItem.play_id == hotDataItem.upper_play_id; //这两个相等，判断为大类，切换tab;

      if (isBigClass && hotDataItem.big_type != HomeGameCategory.LOTTERY) {
        //不是彩票的大类，才走这里
        var gameType = controller.switchGameType(hotDataItem.big_type);

        controller.handleGameBanner(
          gameType: gameType ?? "",
          index: index,
          playId: hotDataItem.play_id,
        );
      } else {
        controller.openHotGame(hotDataItem);
        controller.addGameRecord(HomeCollectionListItemBean(
          collectionId: hotDataItem.play_collection == 2
              ? hotDataItem.play_id?.toInt()
              : null,
          play_id: hotDataItem.play_id?.toInt(),
          upper_play_id: hotDataItem.upper_play_id?.toInt(),
          playName: hotDataItem.play_name,
          playCname: hotDataItem.play_cname,
          play_cat: hotDataItem.play_cat?.toInt(),
          play_state: hotDataItem.state?.toInt(),
          play_big_type: hotDataItem.big_type?.toInt(),
          gameImgUrl: hotDataItem.thumbnail_img_url ?? hotDataItem.gameImgUrl,
          gtype: hotDataItem.gtype,
          isRecord: false,
        ));
      }
    }
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return oldDelegate.maxHeight != maxHeight ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.child != child;
  }
}
