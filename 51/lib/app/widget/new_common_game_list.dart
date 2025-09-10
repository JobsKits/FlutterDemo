import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/new_home_const.dart';
import 'package:flutter_tiyu_app/app/widget/common_gradient.dart';
import 'package:flutter_tiyu_app/constants/game_constants.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../gen/assets.gen.dart';
import '../../utils/CommonRipple.dart';
import '../../utils/game_manager.dart';
import '../modules/home/controllers/new_home_controller.dart';

enum GameItemType {
  itemType1, //热门游戏样式
  itemType2, //高爆奖游戏样式
  itemType3, //真人样式
  itemType4, //电子、捕鱼、棋牌、体育样式
  itemType5, //彩票样式
  itemType6, //排行榜样式
}

///首页游戏列表，可配置多个item样式
class NewCommonGameList extends StatefulWidget {
  final String title; //标题
  final String icon; //icon
  final GameItemType gameItemType; //样式
  final VoidCallback? clickAll; //是否点击全部
  final bool isShowAll; //是否显示全部
  final String? gameType; // 游戏类型
  const NewCommonGameList(
      {super.key,
      required this.gameItemType,
      required this.title,
      required this.icon,
      this.gameType,
      this.clickAll,
      this.isShowAll = true});

  @override
  State<NewCommonGameList> createState() => _NewCommonGameListState();
}

class _NewCommonGameListState extends State<NewCommonGameList>
    with SingleTickerProviderStateMixin {
  late ScrollController typeController;
  double currentPosition = 0.0;
  late TabController tabController;
  late double itemScrollPosition; //item的翻页偏移量

  late double itemWidth; //item的宽度

  late double itemLeftRightMargin; //item的左右margin
  late CarouselSliderController buttonCarouselController =
      CarouselSliderController();
  int bannerCurrentPage = 0;
  int currentIndex = 0;
  late NewHomeController controller = Get.find<NewHomeController>();
  @override
  void initState() {
    super.initState();
    switch (widget.gameItemType) {
      //根据传递过来的itemType来判断使用哪个item的各种数据
      case GameItemType.itemType1:
        itemWidth = 477.w;
        itemLeftRightMargin = 22.w;
        itemScrollPosition = (itemWidth + itemLeftRightMargin) * 2;
        break;
      case GameItemType.itemType2:
        itemWidth = 276.w;
        itemLeftRightMargin = 20.w;
        itemScrollPosition = (itemWidth + itemLeftRightMargin) * 3;
        break;
      case GameItemType.itemType3:
        itemWidth = 310.w;
        itemLeftRightMargin = 15.w;
        itemScrollPosition = (itemWidth + itemLeftRightMargin) * 3;
        break;
      case GameItemType.itemType4:
        itemWidth = 320.w;
        itemLeftRightMargin = 14.w;
        itemScrollPosition = (itemWidth + itemLeftRightMargin) * 3;
        break;
      case GameItemType.itemType5: //暂时把banner类型也留在这里，后续看数据格式再决定是否抽离
        itemWidth = 276.w;
        itemLeftRightMargin = 14.w;
        itemScrollPosition = (itemWidth + itemLeftRightMargin) * 3;
      case GameItemType.itemType6:
        break;
    }
    typeController = ScrollController();
    tabController = TabController(length: 10, vsync: this);
  }

  @override
  void dispose() {
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget layout;
    switch (widget.gameItemType) {
      //根据传递过来的itemType来判断生成哪个布局
      case GameItemType.itemType1:
        layout = _buildItemView1();
        break;
      case GameItemType.itemType2:
        layout = _buildItemView2();
        break;
      case GameItemType.itemType3:
        layout = _buildItemView3();
        break;
      case GameItemType.itemType4:
        layout = _buildItemView4();
        break;
      case GameItemType.itemType5:
        layout = _buildItemView5();
        break;
      case GameItemType.itemType6:
        layout = _buildItemView6();
        break;
    }
    return layout;
  }

  Widget _buildHotGameContainer({
    required DecorationImage image,
    required GameBeanItem hotDataItem,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36.r),
        image: image,
        gradient: CommonGradient.getRadialGradient(index: index),
      ),
      child: Stack(
        children: [
          Container(
            width: 180.w,
            margin: EdgeInsets.only(top: 30.h, left: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${hotDataItem.play_cname}',
                  textAlign: TextAlign.left,
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
          Positioned(
            top: 10.h,
            right: 10.w,
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
                      ? Assets.theme1.images.home.iconCollectUncheck
                      : Assets.theme1.images.home.iconCollectChecked,
                  width: 52.w,
                  height: 52.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotGameContainer2({
    required DecorationImage image,
    required GameBeanItem hotDataItem,
    required int index,
  }) {
    return Container(
      width: 500.w,
      margin: EdgeInsets.only(right: 20.w),
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36.r),
        image: image,
        gradient: CommonGradient.getRadialGradient(index: index),
      ),
    );
  }

  //第一个样式
  Widget _buildItemView1() {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      padding: EdgeInsets.only(left: 33.w),
      height: 767.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Get.context?.customTheme?.pageTwoBg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommonTitle(),
          SizedBox(
            height: 38.h,
          ),
          SizedBox(
            height: 580.h,
            child: Obx(() => controller.hotGameList.isNotEmpty
                ? SingleChildScrollView(
                    controller: typeController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Obx(() => controller.gameBeanItem.value != null
                            ? Stack(
                                children: [
                                  CommonRipple(
                                    onTap: () {
                                      AppManager.instance.tapVibrate();
                                      controller.openHotGame(
                                          controller.gameBeanItem.value!);
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: controller.gameBeanItem.value
                                              ?.logo1_img_url ??
                                          "",
                                      imageBuilder: (context, imageProvider) =>
                                          _buildHotGameContainer2(
                                        hotDataItem:
                                            controller.gameBeanItem.value!,
                                        image: DecorationImage(
                                            alignment: Alignment.centerRight,
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                        index: 0,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          _buildHotGameContainer2(
                                        hotDataItem:
                                            controller.gameBeanItem.value!,
                                        image: DecorationImage(
                                          alignment: Alignment.centerRight,
                                          image: AssetImage(Assets.theme1.images
                                              .home.errorImg.path),
                                        ),
                                        index: 0,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10.h,
                                    right: 30.w,
                                    child: CircleAvatar(
                                      radius: 26.r,
                                      backgroundColor: Colors.transparent,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          AppManager.instance.tapVibrate();
                                          controller.collectGame(
                                              gameIem: controller
                                                  .gameBeanItem.value!);
                                        },
                                        icon: SvgPicture.asset(
                                          ((controller.gameBeanItem.value!.play_collection ??
                                                          1) ==
                                                      1 ||
                                                  (controller
                                                              .gameBeanItem
                                                              .value!
                                                              .play_collection ??
                                                          1) ==
                                                      0)
                                              ? Assets.theme1.images.home
                                                  .iconCollectUncheck
                                              : Assets.theme1.images.home
                                                  .iconCollectChecked,
                                          width: 52.w,
                                          height: 52.h,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : SizedBox()),
                        GridView.extent(
                          mainAxisSpacing: 22.w,
                          childAspectRatio: 0.57,
                          crossAxisSpacing: 22.h,
                          maxCrossAxisExtent: 477.w,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(controller.hotGameList.length,
                              (index) {
                            final hotDataItem = controller.hotGameList[index];
                            bool isMaintain = hotDataItem.state!.toInt() == 2;
                            String test = GameUtils.determineTypeConst2(
                                hotDataItem.upper_play_id?.toInt() ?? 0);
                            String smallIconPath =
                                GameUtils.getHomeTabDefaultColorIcon(
                                    gameType: test,
                                    playId: hotDataItem.upper_play_id!);
                            bool isBigType = hotDataItem.play_id ==
                                hotDataItem.upper_play_id;
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
                                  width: 477.w,
                                  child: CommonRipple(
                                    onTap: () {
                                      jumpGame(hotDataItem, isMaintain, index);
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      imageBuilder: (context, imageProvider) =>
                                          _buildHotGameContainer(
                                        hotDataItem: hotDataItem,
                                        image: DecorationImage(
                                          alignment: Alignment.centerRight,
                                          image: imageProvider,
                                        ),
                                        index: index,
                                      ),
                                      placeholder: (context, url) => Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: const Color(colorF4F4F4),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.r))),
                                        child: CircularProgressIndicator(
                                          color: context.theme.primaryColor,
                                        ),
                                      ),
                                      // placeholder: (context, url) => const Center(
                                      //   child: CircularProgressIndicator(),
                                      // ),
                                      errorWidget: (context, url, error) {
                                        TenantManager.instance.errorImgCount +=
                                            1;
                                        return _buildHotGameContainer(
                                          hotDataItem: hotDataItem,
                                          image: DecorationImage(
                                            alignment: Alignment.centerRight,
                                            image: AssetImage(Assets.theme1
                                                .images.home.errorImg.path),
                                          ),
                                          index: index,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: 30.w,
                                    bottom: 10.h,
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
                                _buildMaintainContainer(
                                  isMaintain: isMaintain,
                                  margin: null,
                                  height: 272.h,
                                  width: 477.w,
                                )
                              ],
                            );
                          }),
                        )
                      ],
                    ),
                  )
                : const SizedBox.shrink()),
          )
          // SizedBox(
          //   height: 580.h,
          //   child: Obx(() => controller.hotGameList.isNotEmpty
          //       ? CustomScrollView(
          //           controller: typeController,
          //           scrollDirection: Axis.horizontal,
          //           slivers: [
          //             if (controller.gameBeanItem != null)
          //               SliverToBoxAdapter(
          //                 child: CommonRipple(
          //                   onTap: () {
          //                     AppManager.instance.tapVibrate();
          //                     controller.openHotGame(controller.gameBeanItem!);
          //                   },
          //                   child: CachedNetworkImage(
          //                     imageUrl:
          //                         controller.gameBeanItem!.logo3_img_url ??
          //                             controller.gameBeanItem!.logo1_img_url ??
          //                             "",
          //                     imageBuilder: (context, imageProvider) =>
          //                         _buildHotGameContainer2(
          //                       hotDataItem: controller.gameBeanItem!,
          //                       image: DecorationImage(
          //                           alignment: Alignment.centerRight,
          //                           image: imageProvider,
          //                           fit: BoxFit.cover),
          //                       index: 0,
          //                     ),
          //                     errorWidget: (context, url, error) =>
          //                         _buildHotGameContainer2(
          //                       hotDataItem: controller.gameBeanItem!,
          //                       image: DecorationImage(
          //                         alignment: Alignment.centerRight,
          //                         image: AssetImage(
          //                             Assets.theme1.images.home.errorImg.path),
          //                       ),
          //                       index: 0,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             SliverGrid(
          //               gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //                 mainAxisSpacing: 22.w,
          //                 childAspectRatio: 0.57,
          //                 crossAxisSpacing: 22.h,
          //                 maxCrossAxisExtent: 477.w,
          //               ),
          //               delegate: SliverChildBuilderDelegate(
          //                 (context, index) {
          //                   final hotDataItem = controller.hotGameList[index];
          //                   bool isMaintain = hotDataItem.state!.toInt() == 2;
          //                   String test = GameUtils.determineTypeConst2(
          //                       hotDataItem.upper_play_id?.toInt() ?? 0);
          //                   String smallIconPath =
          //                       GameUtils.getHomeTabDefaultColorIcon(
          //                           gameType: test,
          //                           playId: hotDataItem.upper_play_id!);
          //                   bool isBigType = hotDataItem.play_id ==
          //                       hotDataItem.upper_play_id;
          //                   String imageUrl = hotDataItem.gameImgUrl!;
          //                   if (hotDataItem.thumbnail_img_url != null &&
          //                       hotDataItem.thumbnail_img_url != "null" &&
          //                       hotDataItem.thumbnail_img_url != "") {
          //                     imageUrl = hotDataItem.thumbnail_img_url!;
          //                   }
          //
          //                   if (isBigType) {
          //                     if (hotDataItem.logo1_img_url != null &&
          //                         hotDataItem.logo1_img_url != "null" &&
          //                         hotDataItem.logo1_img_url != "") {
          //                       imageUrl = hotDataItem.logo1_img_url!;
          //                     }
          //                   }
          //
          //                   return Stack(
          //                     children: [
          //                       SizedBox(
          //                         width: 477.w,
          //                         child: CommonRipple(
          //                           onTap: () {
          //                             jumpGame(hotDataItem, isMaintain, index);
          //                           },
          //                           child: CachedNetworkImage(
          //                             imageUrl: imageUrl,
          //                             imageBuilder: (context, imageProvider) =>
          //                                 _buildHotGameContainer(
          //                               hotDataItem: hotDataItem,
          //                               image: DecorationImage(
          //                                 alignment: Alignment.centerRight,
          //                                 image: imageProvider,
          //                               ),
          //                               index: index,
          //                             ),
          //                             placeholder: (context, url) => Container(
          //                               alignment: Alignment.center,
          //                               decoration: BoxDecoration(
          //                                   color: const Color(colorF4F4F4),
          //                                   borderRadius: BorderRadius.all(
          //                                       Radius.circular(30.r))),
          //                               child: const CircularProgressIndicator(
          //                                 color: Color(theme01MainColor),
          //                               ),
          //                             ),
          //                             // placeholder: (context, url) => const Center(
          //                             //   child: CircularProgressIndicator(),
          //                             // ),
          //                             errorWidget: (context, url, error) =>
          //                                 _buildHotGameContainer(
          //                               hotDataItem: hotDataItem,
          //                               image: DecorationImage(
          //                                 alignment: Alignment.centerRight,
          //                                 image: AssetImage(Assets.theme1.images
          //                                     .home.errorImg.path),
          //                               ),
          //                               index: index,
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       Positioned(
          //                           left: 30.w,
          //                           bottom: 10.h,
          //                           child: Image.asset(
          //                             smallIconPath,
          //                             width: 80.w,
          //                             height: 80.h,
          //                             errorBuilder: (
          //                               BuildContext context,
          //                               Object error,
          //                               StackTrace? stackTrace,
          //                             ) {
          //                               return const SizedBox();
          //                             },
          //                           )),
          //                       _buildMaintainContainer(
          //                         isMaintain: isMaintain,
          //                         margin: null,
          //                         height: 272.h,
          //                         width: 477.w,
          //                       )
          //                     ],
          //                   );
          //                 },
          //                 childCount: controller.hotGameList.length, // 网格项的数量
          //               ),
          //             ),
          //           ],
          //         )
          //       : const SizedBox.shrink()),
          // ),
        ],
      ),
    );
  }

  //第二个样式
  Widget _buildItemView2() {
    return Container(
      height: 579.h,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.only(left: 33.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Get.context?.customTheme?.pageTwoBg),
      child: Column(
        children: [_buildCommonTitle(), _buildListType2()],
      ),
    );
  }

  //第三个样式
  Widget _buildItemView3() {
    return Container(
      height: 647.h,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.only(left: 33.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Get.context?.customTheme?.pageTwoBg),
      child: Column(
        children: [_buildCommonTitle(), _buildCommonListType(448.h)],
      ),
    );
  }

  //第四个样式
  Widget _buildItemView4() {
    return Container(
      height: 599.h,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.only(left: 33.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Get.context?.customTheme?.pageTwoBg),
      child: Column(
        children: [_buildCommonTitle(), _buildCommonListType(400.h)],
      ),
    );
  }

  //彩票banner
  Widget _buildItemView5() {
    return Container(
      height: 620.h,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.only(left: 33.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Get.context?.customTheme?.pageTwoBg),
      child: Column(
        children: [_buildCommonTitle(), _buildLotteryListType()],
      ),
    );
  }

  //赌神排行榜的样式，可能只显示一张图片，现在先用banner实现
  Widget _buildItemView6() {
    return Container(
      height: 900.h,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.only(left: 33.w, right: 33.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Get.context?.customTheme?.pageTwoBg),
      child: Column(
        children: [
          _buildCommonTitle(showRight: false),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r)),
                gradient: const LinearGradient(
                  colors: [
                    Color(colorD19C61), // 起始颜色
                    Colors.white, // 结束颜色
                  ],
                  begin: Alignment.topCenter, // 渐变的起始位置
                  end: Alignment.bottomCenter, // 渐变的结束位置
                  stops: [0.2, 0.8], // 调整渐变范围，使上方颜色更集中
                ),
              ),
              margin: EdgeInsets.only(top: 36.h, bottom: 50.h),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 50.w,
                      vertical: 10.h,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFCE955D),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      '今日盈利排名',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 46.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(
                    () {
                      if (controller.rankList.isNotEmpty) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(width: 56.w),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 50.h,
                                  bottom: 180.h,
                                ),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        alignment: Alignment.bottomCenter,
                                        image: AssetImage(Assets.theme1.images
                                            .home.rankListBg2.path))),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Positioned(
                                            bottom: 20.h,
                                            left: 15.w,
                                            child: Image.asset(
                                              Assets.theme1.images.home
                                                  .rankListHeader2.path,
                                              width: 100.w,
                                            )),
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 66.w,
                                          backgroundImage: AssetImage(Assets
                                              .theme1
                                              .images
                                              .home
                                              .rankListHeaderBorder2
                                              .path),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${formatString(controller.rankList[1].cust_name ?? "")}",
                                      style: TextStyle(
                                          fontSize: 33.sp,
                                          color: const Color(color666291)),
                                    ),
                                    Text(
                                      "￥${formatAmount(controller.rankList[1].amount ?? 0)}",
                                      style: TextStyle(
                                          fontSize: 33.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 45.w),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(
                                top: 50.h,
                                bottom: 210.h,
                              ),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      alignment: Alignment.bottomCenter,
                                      image: AssetImage(Assets.theme1.images
                                          .home.rankListBg1.path))),
                              child: Column(
                                children: [
                                  Stack(children: [
                                    Positioned(
                                        bottom: 20.h,
                                        left: 20.w,
                                        child: Image.asset(
                                          Assets.theme1.images.home
                                              .rankListHeader1.path,
                                          width: 150.w,
                                        )),
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 96.w,
                                      backgroundImage: AssetImage(Assets
                                          .theme1
                                          .images
                                          .home
                                          .rankListHeaderBorder1
                                          .path),
                                    ),
                                  ]),
                                  Text(
                                    "${formatString(controller.rankList[0].cust_name ?? "")}",
                                    style: TextStyle(
                                        fontSize: 33.sp,
                                        color: const Color(color9B7203)),
                                  ),
                                  Text(
                                    "￥${formatAmount(controller.rankList[0].amount ?? 0)}",
                                    style: TextStyle(
                                        fontSize: 33.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                            SizedBox(width: 45.w),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(
                                top: 50.h,
                                bottom: 160.h,
                              ),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      alignment: Alignment.bottomCenter,
                                      image: AssetImage(Assets.theme1.images
                                          .home.rankListBg3.path))),
                              child: Column(
                                children: [
                                  Stack(children: [
                                    Positioned(
                                        bottom: 20.h,
                                        left: 15.w,
                                        child: Image.asset(
                                          Assets.theme1.images.home
                                              .rankListHeader1.path,
                                          width: 100.w,
                                        )),
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 66.w,
                                      backgroundImage: AssetImage(Assets
                                          .theme1
                                          .images
                                          .home
                                          .rankListHeaderBorder3
                                          .path),
                                    ),
                                  ]),
                                  Text(
                                    "${formatString(controller.rankList[2].cust_name ?? "")}",
                                    style: TextStyle(
                                        fontSize: 33.sp,
                                        color: const Color(colorBD8D58)),
                                  ),
                                  Text(
                                    "￥${formatAmount(controller.rankList[2].amount ?? 0)}",
                                    style: TextStyle(
                                        fontSize: 33.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                            SizedBox(width: 56.w),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //构建几个列表样式通用的标题栏
  Widget _buildCommonTitle({bool showRight = true}) {
    return Container(
        margin: EdgeInsets.only(top: 50.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  widget.icon,
                  width: 52.w,
                  height: 52.h,
                  colorFilter: ColorFilter.mode(
                      context.theme.primaryColor, BlendMode.srcIn),
                ),
                SizedBox(width: 23.w),
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 51.sp,
                      fontWeight: FontWeight.bold,
                      color: context.customTheme?.titleColor),
                )
              ],
            ),
            showRight ? titleRightMenu() : const SizedBox(),
          ],
        ));
  }

  //通用title的右侧按钮组
  Widget titleRightMenu() {
    return Row(
      children: [
        widget.isShowAll
            ? SizedBox(
                width: 126.w,
                height: 63.h,
                child: CommonRipple(
                  onTap: widget.clickAll,
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: const Color(colorF6F6F7),
                      ),
                      child: Text(
                        "全部",
                        style: TextStyle(
                            fontSize: 36.sp, color: const Color(colorA7A7A7)),
                      )),
                ))
            : const SizedBox(),
        SizedBox(
          width: 30.w,
        ),
        CommonRipple(
            onTap: () => isBannerType()
                ? _changePage(false)
                : _changePosition(-itemScrollPosition),
            child: SvgPicture.asset(Assets.theme1.images.home.iconGameLeftArrow,
                width: 61.w, height: 63.h)),
        SizedBox(
          width: 30.w,
        ),
        CommonRipple(
            onTap: () => isBannerType()
                ? _changePage(true)
                : _changePosition(itemScrollPosition),
            child: SvgPicture.asset(
                Assets.theme1.images.home.iconGameRightArrow,
                width: 61.w,
                height: 63.h)),
        SizedBox(
          width: 33.w,
        )
      ],
    );
  }

  //判断是否是banner类型
  bool isBannerType() {
    bool isBanner = false;
    if (widget.gameItemType == GameItemType.itemType6) {
      isBanner = true;
    }
    return isBanner;
  }

  //改变列表位置
  void _changePosition(double delta) {
    AppManager.instance.tapVibrate();
    double newPosition = currentPosition + delta;

    // 矫正 currentPosition
    if (newPosition < typeController.position.minScrollExtent) {
      newPosition = typeController.position.minScrollExtent;
    } else if (newPosition > typeController.position.maxScrollExtent) {
      newPosition = typeController.position.maxScrollExtent;
    }

    // 仅在位置发生变化时才进行滚动
    if (newPosition != currentPosition) {
      currentPosition = newPosition;
      typeController.animateTo(
        currentPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  //banner切换页面
  void _changePage(bool isAdd) {
    AppManager.instance.tapVibrate();
    if (isAdd) {
      if (bannerCurrentPage < controller.hotGameList.length - 1) {
        buttonCarouselController.animateToPage(bannerCurrentPage + 1);
      }
    } else {
      if (bannerCurrentPage > 0) {
        buttonCarouselController.animateToPage(bannerCurrentPage - 1);
      }
    }
  }

  //构建第二种类型的listView
  Widget _buildListType2() {
    return Expanded(
        child: Obx(() => ListView(
              controller: typeController,
              scrollDirection: Axis.horizontal,
              children: List.generate(controller.hotGameList.length, (index) {
                return CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      controller.openHotGame(controller.hotGameList[index]);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: (index == 0) ? 0 : itemLeftRightMargin,
                              right:
                                  (index == controller.hotGameList.length - 1)
                                      ? 0
                                      : itemLeftRightMargin),
                          width: itemWidth,
                          height: 276.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              image: DecorationImage(
                                  image: NetworkImage(controller
                                      .hotGameList[index].gameImgUrl!)),
                              color: const Color(colorF4F4F4)),
                        ),
                        Text(
                          "${controller.hotGameList[index].play_cname}",
                          style: TextStyle(
                              fontSize: 42.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "89887人已中奖",
                          style: TextStyle(fontSize: 30.sp),
                        ),
                      ],
                    ));
              }),
            )));
  }

  //构建通用的列表类型
  Widget _buildCommonListType(double height) {
    var gameData = [];
    if (widget.gameType == GameTypeConstants.electronic) {
      gameData = controller.gameElectronic;
    } else if (widget.gameType == GameTypeConstants.fishing) {
      gameData = controller.gameFishing;
    } else if (widget.gameType == GameTypeConstants.sports) {
      gameData = controller.gameSports;
    } else if (widget.gameType == GameTypeConstants.live) {
      gameData = controller.gameLive;
    } else if (widget.gameType == GameTypeConstants.chess) {
      gameData = controller.gameChess;
    } else if (widget.gameType == GameTypeConstants.blockchain) {
      gameData = controller.gameBlockchain;
    }

    return Expanded(
        child: Obx(() => SingleChildScrollView(
            controller: typeController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(gameData.length, (index) {
                ThirdGamesItem gameItem = gameData[index];
                var isMaintain = gameItem.state!.toString() == '2';
                String imgUrl = (gameItem.bg_img_url == null ||
                        gameItem.bg_img_url == "null" ||
                        gameItem.bg_img_url!.isEmpty)
                    // ? (gameItem.gameImgUrl ?? "")
                    ? GameUtils.getHotGameImageUrl(
                        playName: gameItem.play_name!,
                        upperPlayId: gameItem.play_id!,
                        playId: gameItem.play_id!,
                        bigType: gameItem.big_type!,
                        isHomeBig: true)
                    : gameItem.bg_img_url!;
                return CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      if (!isMaintain) {
                        controller.handleGameBanner(
                            gameType: widget.gameType!,
                            index: index,
                            playId: gameItem.play_id);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: (index == 0) ? 0 : itemLeftRightMargin,
                                right: itemLeftRightMargin,
                              ),
                              width: itemWidth,
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                // image: DecorationImage(
                                //     fit: BoxFit.contain,
                                //     image: CachedNetworkImageProvider(
                                //       imgUrl,
                                //     ),
                                //     onError: (exception, stackTrace) {
                                //       setState(() {
                                //         gameItem.isLoadImgError = true;
                                //       });
                                //     }),
                                color: Colors.transparent,
                              ),
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: imgUrl,
                                    placeholder: (context, url) => Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: const Color(colorF4F4F4),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.r))),
                                      child: CircularProgressIndicator(
                                        color: context.theme.primaryColor,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: const Color(colorF4F4F4),
                                        image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(Assets.theme1.images
                                              .home.errorImg.path),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.r)),
                                      ),
                                    ),
                                  ),
                                  // Image.network(
                                  //   imgUrl,
                                  //   errorBuilder: (context, error, stackTrace) =>
                                  //       Image.asset(gameItem.gameImgUrl ?? "",
                                  //           errorBuilder:
                                  //               (context, error, stackTrace) {
                                  //     return Container(
                                  //       decoration: BoxDecoration(
                                  //         color: Color(colorF4F4F4),
                                  //         borderRadius:
                                  //             BorderRadius.circular(30.r),
                                  //       ),
                                  //       width: 1.sw,
                                  //       height: 1.sh,
                                  //     );
                                  //   }),
                                  // ),
                                  Positioned(
                                    width: itemWidth,
                                    bottom: 20.h,
                                    child: Text(gameItem.play_cname!,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 46.sp,
                                          fontWeight: FontWeight.w600,
                                          height: 1,
                                        )),
                                  )
                                ],
                              ),
                            ),
                            _buildMaintainContainer(
                              isMaintain: isMaintain,
                              margin: EdgeInsets.only(
                                left: (index == 0) ? 0 : itemLeftRightMargin,
                                right: itemLeftRightMargin,
                              ),
                              height: height,
                              width: itemWidth,
                            ),
                          ],
                        ),
                      ],
                    ));
              }),
            ))));
  }

  Widget _buildMaintainContainer({
    required bool isMaintain,
    required double height,
    required double width,
    EdgeInsetsGeometry? margin,
  }) {
    if (isMaintain) {
      return Positioned(
        right: 0,
        top: 0,
        left: 0,
        bottom: 0,
        child: Container(
          margin: margin,
          width: width,
          height: height,
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
                  Assets.theme1.images.home.systemMaintain.path,
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
      );
    }
    return const SizedBox();
  }

  Widget _buildLotteryMaintainContainer({
    required int index,
    required double height,
    required double width,
    EdgeInsetsGeometry? margin,
  }) {
    // 判断游戏状态
    var gameState = GameManager.instance.gameState;
    int? state = gameState[controller.gameLottery[index].play_id];
    bool isMaintain = false;
    if (state == 3 || state == 2) {
      isMaintain = true;
    }
    if (isMaintain) {
      return Positioned(
        right: 0,
        top: 0,
        left: 0,
        child: Container(
          margin: margin,
          width: width,
          height: height,
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
                  Assets.theme1.images.home.systemMaintain.path,
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
      );
    }
    return const SizedBox();
  }

  //构建通用的列表类型
  Widget _buildLotteryListType() {
    return Expanded(
      child: Obx(
        () => SingleChildScrollView(
          controller: typeController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(controller.gameLottery.length, (index) {
              final lotteryItem = controller.gameLottery[index];
              String imgUrl =
                  GameUtils.getLotteryImg2(playId: lotteryItem.play_id!);
              if (lotteryItem.bg_img_url != null &&
                  lotteryItem.bg_img_url != "null" &&
                  lotteryItem.bg_img_url!.isNotEmpty) {
                imgUrl = lotteryItem.bg_img_url!;
              }
              bool isNet = imgUrl.contains("http");
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.openLotteryGame(lotteryItem);
                },
                child: Container(
                    margin: EdgeInsets.only(top: 50.h, right: 40.w),
                    height: 425.h,
                    child: Stack(
                      children: [
                        isNet
                            ? Image.network(
                                height: 380.h,
                                imgUrl,
                              )
                            : Image.asset(
                                GameUtils.getLotteryImg2(
                                    playId: lotteryItem.play_id!),
                              ),
                        _buildLotteryMaintainContainer(
                          index: index,
                          width: double.infinity,
                          height: 425.h,
                        )
                      ],
                    )),
              );
            }),
          ),
        ),
      ),
    );
  }

  String formatString(String text) {
    if (text.length > 7) {
      // 取前4个字符和后3个字符，并在中间添加省略号
      return "${text.substring(0, 4)}...${text.substring(text.length - 3)}";
    } else if (text.length > 1 && text.length < 7) {
      // 取前4个字符和后3个字符，并在中间添加省略号
      return "${text.substring(0, 1)}...${text.substring(text.length - 1)}";
    } else {
      // 如果长度小于等于7，直接返回原字符串
      return text;
    }
  }

  String formatAmount(double amount) {
    final formatter = NumberFormat("#,####.00", "en_US");
    return formatter.format(amount);
  }

  jumpGame(GameBeanItem hotDataItem, bool isMaintain, index) {
    AppManager.instance.tapVibrate();
    if (!isMaintain) {
      bool isBigClass =
          hotDataItem.play_id == hotDataItem.upper_play_id; //这两个相等，判断为大类，切换tab;

      if (isBigClass && hotDataItem.big_type != HomeGameCategory.LOTTERY) {
        //不是彩票的大类，才走这里
        var gameType = switchGameType(hotDataItem.big_type);

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

  String? switchGameType(num? bigType) {
    String? type;
    switch (bigType) {
      case HomeGameCategory.CHESS:
        type = GameTypeConstants.chess;
        break;
      case HomeGameCategory.ELECTRONIC:
        type = GameTypeConstants.electronic;
        break;
      case HomeGameCategory.FISHING:
        type = GameTypeConstants.fishing;
        break;
      case HomeGameCategory.LIVE:
        type = GameTypeConstants.live;
        break;
      case HomeGameCategory.SPORTS:
        type = GameTypeConstants.sports;
        break;
      case HomeGameCategory.LOTTERY:
        type = GameTypeConstants.lottery;
        break;
      case HomeGameCategory.BLOCK_THIRD:
        type = GameTypeConstants.blockchain;
        break;
      default:
        type = null;
        break;
    }
    return type;
  }
}
