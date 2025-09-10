import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_list_item_widget.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/app_manager.dart';
import '../../../../utils/banner_jump_utils.dart';
import '../../../data/real_time_prizes_bean.dart';
import '../../../widget/common_gradient.dart';
import '../../user/controllers/change_avatar_controller.dart';
import '../new_home_const.dart';

///实时爆奖组件
class RealTimePrizes extends StatefulWidget {
  const RealTimePrizes({super.key});

  @override
  State<RealTimePrizes> createState() => _RealTimePrizesState();
}

class _RealTimePrizesState extends State<RealTimePrizes> {
  NewHomeController controller = Get.find();
  ChangeAvatarController avatarController = Get.put(ChangeAvatarController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.realTimePrizesList.isNotEmpty
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.theme1.images.home.iconHomeWin.path,
                        width: 80.w,
                        height: 80.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "实时爆奖",
                        style: TextStyle(fontSize: 60.sp, color: Colors.white),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        "万人在线 大奖频发",
                        style: TextStyle(
                            fontSize: 40.sp, color: Color(0xff6A6C82)),
                      ),
                    ],
                  ),
                ),
                CarouselSlider(
                  carouselController: controller.realTimePrizesController,
                  options: CarouselOptions(
                      height: 200.h,
                      viewportFraction: 0.5,
                      initialPage: 0,
                      enableInfiniteScroll:
                          (controller.mBannerList.length > 2) ? true : false,
                      // enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 300),
                      autoPlayCurve: Curves.linear,
                      enlargeCenterPage: false,
                      padEnds: false,
                      enlargeFactor: 0,
                      scrollDirection: Axis.horizontal,
                      onPageChanged:
                          (int index, CarouselPageChangedReason reason) {
                        //获取到需要执行动画的index
                        int realIndex = 0;
                        if (index == controller.realTimePrizesList.length - 1) {
                          realIndex = 0;
                        } else {
                          realIndex = index + 1;
                        }
                        // controller.changeBannerIndex(index);
                      }),
                  items: controller.realTimePrizesList
                      .asMap()
                      .entries
                      .map((entry) {
                    return Builder(
                      builder: (BuildContext context) {
                        return _buildGameItem(entry.key);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          )
        : SizedBox());
  }

  int getReqTypeId(int bigType) {
    int requestTypeId = 0;
    //对首页的typeId进行充新映射
    switch (bigType) {
      case 2: // 棋牌
        requestTypeId = 1;
        break;
      case HomeGameCategory.ELECTRONIC_KEY: // 电子
        requestTypeId = 2;
        break;
      case HomeGameCategory.FISHING_KEY: // 捕鱼
        requestTypeId = 3;
        break;
      case HomeGameCategory.LIVE_KEY: // 真人
        requestTypeId = 4;
        break;
      case HomeGameCategory.SPORTS_KEY: // 体育
        requestTypeId = 5;
        break;
      case 7: // 彩票
        requestTypeId = 7;
        break;
      case 10: // 区块链
        requestTypeId = 10; //暂定
        break;
    }
    return requestTypeId;
  }

  Widget _buildGameItem(int index) {
    var item = controller.realTimePrizesList[index];
    String imgUrl = GameUtils.getHotGameImageUrl(
        playName: item.playCname ?? '',
        upperPlayId: item.upperPlayId!,
        bigType: getReqTypeId(item.bigType ?? 0),
        playId: item.playId!.toInt());
    return GestureDetector(
      onTap: () {
        AppManager.instance.tapVibrate();
        Get.bottomSheet(gameBottomSheet(item, index), isScrollControlled: true);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 160.h,
                margin: EdgeInsets.only(left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                    color: Color(0xff1E212E),
                    borderRadius: BorderRadius.circular(20.r)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient:
                              CommonGradient.getRadialGradient(index: index),
                          borderRadius: BorderRadius.circular(20.r)),
                      width: 160.w,
                      height: 160.h,
                      child: UnconstrainedBox(
                        child: CachedNetworkImage(
                          imageUrl: item.thumbnailImgUrl ?? imgUrl,
                          width: 130.w,
                          height: 130.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "￥${((item.betAmount ?? 0) / 1000).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: context?.theme.primaryColor,
                              fontSize: 40.sp),
                        ),
                        Text(
                          "${item.playCname}",
                          style: TextStyle(
                              color:
                                  context?.customTheme?.rechargeTipsTxtColor),
                        ),
                        Text(
                          "${item.custName}",
                          style: TextStyle(
                              color: context
                                  .customTheme?.homeGameSearchHintTxtColor),
                        ),
                      ],
                    )
                  ],
                ),
              )),
          Positioned(
              right: 0,
              top: -10.h,
              child: Visibility(
                  visible: (item.odds != null && (item.odds ?? 0) > 0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            gradient: LinearGradient(colors: [
                              Color(
                                0xff882816,
                              ),
                              Color(0xff24222D)
                            ])),
                        child: Text(
                          "X${item.odds}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Image.asset(
                            width: 50.w,
                            Assets.theme1.images.home.iconFire.path),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  Widget gameBottomSheet(RealTimePrizesItemBean item, int index) {
    String imgUrl = GameUtils.getHotGameImageUrl(
        playName: item.playCname ?? '',
        upperPlayId: item.upperPlayId!,
        bigType: getReqTypeId(item.bigType ?? 0),
        playId: item.playId!.toInt());
    var tempIndex = index;
    if (index > avatarController.headerList.length - 1) {
      tempIndex = 0;
    }
    String tempHeaderUrl =
        "${avatarController.listImgDomain}/${avatarController.headerList[tempIndex]}";
    if (item.head?.isNotEmpty == true) {
      tempHeaderUrl = item.head!;
    }
    return Container(
      height: 0.63.sh,
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter, // 从上开始
          //   end: Alignment.bottomCenter, // 到下结束
          //   colors: [
          //     Color(
          //       0xff1F3A50,
          //     ),
          //     Color(0xff252837),
          //     Color(0xff252837),
          //   ],
          //   stops: [
          //     0.0, // 第一种颜色占 30%
          //     0.3, // 到 100% 渐变到第二种颜色
          //     1, // 到 100% 渐变到第二种颜色
          //   ],
          // ),
          gradient: RadialGradient(
            center: Alignment.topCenter, // 渐变中心
            radius: 0.8, // 渐变半径，0~1（相对于最短边）
            colors: [
              Color(
                0xff1F3A50,
              ),
              Color(0xff252837),
              Color(0xff252837),
            ],
            stops: [
              0.0, // 第一种颜色占 30%
              0.7, // 到 100% 渐变到第二种颜色
              1, // 到 100% 渐变到第二种颜色
            ],
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))),
      child: Stack(
        children: [
          Center(
              child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70.h,
              ),
              Text(
                "爆奖详情",
                style: TextStyle(color: Colors.white, fontSize: 48.sp),
              ),
              SizedBox(
                height: 20.h,
              ),
              Stack(
                children: [
                  Image.asset(
                    height: 280.h,
                    Assets.theme1.images.home.realTimeHeaderBg.path,
                    fit: BoxFit.fitHeight,
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: UnconstrainedBox(
                        child: CircleAvatar(
                          radius: 80.w,
                          backgroundColor: context.theme.primaryColor,
                          backgroundImage:
                              NetworkImage(tempHeaderUrl) as ImageProvider,
                        ),
                      ))
                ],
              ),
              Text(
                "${item.custName}",
                style: TextStyle(color: Colors.white, fontSize: 51.sp),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "${DateTimeUtils.formatTimestamp(item.creatTime!.toInt())}",
                style: TextStyle(
                    color: context.customTheme?.rechargeTipsTxtColor,
                    fontSize: 36.sp),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.h, left: 30.w, right: 30.w),
                height: 200.h,
                decoration: BoxDecoration(
                    color: Color(0xff1D202C),
                    borderRadius: BorderRadius.circular(30.r)),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Column(
                        children: [
                          Text(
                            "下注金额",
                            style: TextStyle(
                                fontSize: 36.sp, color: Color(0xff6A6C82)),
                          ),
                          Text(
                            "${((item.betAmount ?? 0) / 1000).toStringAsFixed(2)}元",
                            style:
                                TextStyle(fontSize: 36.sp, color: Colors.white),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                    )),
                    SizedBox(
                      height: 100.h,
                      child: VerticalDivider(
                        color: Color(0xff3B3E50),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("赔率倍数",
                                    style: TextStyle(
                                        fontSize: 36.sp,
                                        color: Color(0xff6A6C82))),
                                Text("X${item.odds}",
                                    style: TextStyle(
                                        fontSize: 36.sp, color: Colors.white)),
                              ],
                            ))),
                    SizedBox(
                        height: 100.h,
                        child: VerticalDivider(
                          color: Color(0xff3B3E50),
                        )),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("派彩金额",
                                    style: TextStyle(
                                        fontSize: 36.sp,
                                        color: Color(0xff6A6C82))),
                                Text(
                                    "${((item.payoutAmount ?? 0) / 1000).toStringAsFixed(2)}元",
                                    style: TextStyle(
                                        fontSize: 36.sp, color: Colors.white)),
                              ],
                            ))),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 100.w, right: 100.w, top: 40.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "爆奖游戏：",
                      style: TextStyle(color: Colors.white, fontSize: 48.sp),
                    ),
                    Container(
                      height: 260.h,
                      width: 260.w,
                      decoration: BoxDecoration(
                          gradient:
                              CommonGradient.getRadialGradient(index: index),
                          borderRadius: BorderRadius.circular(30.r)),
                      child: UnconstrainedBox(
                        child: CachedNetworkImage(
                          imageUrl: item.thumbnailImgUrl ?? imgUrl,
                          width: 220.w,
                          height: 220.h,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "${item.playCname}",
                          style:
                              TextStyle(color: Colors.white, fontSize: 48.sp),
                        ),
                        Text(
                          "${item.playUpName}",
                          style: TextStyle(
                              fontSize: 36.sp, color: Color(0xff6A6C82)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  Get.back();
                  controller.openGame(item,
                      playId: item.playId!.toInt(),
                      playName: item.playUpName ?? '',
                      playCName: item.playCname ?? '',
                      originState: 1);
                },
                child: Container(
                  width: 1.sw,
                  height: 130.h,
                  margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 70.h),
                  decoration: BoxDecoration(
                      color: context.customTheme?.primary,
                      borderRadius: BorderRadius.circular(30.r)),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          "跟投游戏",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 48.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          bottom: 0,
                          right: 20.w,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Color(0xff907755),
                          ))
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft, // 单独靠左
                  child: _recommendGameList()),
            ],
          )),
          Positioned(
              top: 20.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Icon(
                    Icons.close,
                    color: Color(0xff5A5A68),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  //推荐游戏列表
  _recommendGameList() {
    var tempWidth = (1.sw - (20.w * 7)) / 6; //拿到每个item应该的宽高
    return Container(
      margin: EdgeInsets.only(left: 20.w, top: 50.h),
      height: tempWidth,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: controller.realTimePrizesList.length,
          itemBuilder: (context, index) {
            var item = controller.realTimePrizesList[index];
            String imgUrl = GameUtils.getHotGameImageUrl(
                playName: item.playCname ?? '',
                upperPlayId: item.upperPlayId!,
                bigType: getReqTypeId(item.bigType ?? 0),
                playId: item.playId!.toInt());
            return GestureDetector(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  Get.back();
                  controller.openGame(item,
                      playId: item.playId!.toInt(),
                      playName: item.playUpName ?? '',
                      playCName: item.playCname ?? '',
                      originState: 1);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20.w),
                  width: tempWidth,
                  height: tempWidth,
                  decoration: BoxDecoration(
                      gradient: CommonGradient.getRadialGradient(index: index),
                      borderRadius: BorderRadius.circular(30.r)),
                  child: UnconstrainedBox(
                    child: CachedNetworkImage(
                      imageUrl: item.thumbnailImgUrl ?? imgUrl,
                      width: tempWidth - 20.w,
                      height: tempWidth - 20.w,
                    ),
                  ),
                ));
          }),
    );
  }
}
