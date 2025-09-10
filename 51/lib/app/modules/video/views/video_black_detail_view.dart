import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/widget/common_gradient.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../routes/app_pages.dart';
import '../controllers/video_black_detail_controller.dart';

//视频黑料详情页面
class VideoBlackDetailView extends GetView<VideoBlackDetailController> {
  // final VideoSecondList detailBean;
  const VideoBlackDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, _) {
          controller.disposePlayer();
          Get.delete<VideoBlackDetailController>();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: BackButton(
              onPressed: () {
                Get.back();
              },
            ),
            title: Text("黑料详情"),
            centerTitle: true,
          ),
          body: Obx(() => controller.videoDetailInfo.value != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${controller.videoDetailInfo.value?.title}",
                          style: TextStyle(
                              fontSize: 60.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Text(
                            "${DateTimeUtils.formatDateTime(controller.videoDetailInfo.value!.createDate!)}",
                            style: TextStyle(
                                fontSize: 36.sp, color: Color(color8A8A8A))),
                        Text("${controller.videoDetailInfo.value?.classify}",
                            style: TextStyle(
                                fontSize: 36.sp, color: Color(color8A8A8A))),
                        SizedBox(
                          height: 30.h,
                        ),
                        HtmlWidget(
                          "${controller.videoDetailInfo.value?.desc}",
                          textStyle: const TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        _buildVideoPlayWidget(context),
                        _buildiNextAndPrev(),
                        _buildVideoCategory(),
                        _buildBottomList(context)
                      ],
                    ),
                  ),
                )
              : Center(
                  child: SizedBox(
                    width: 126.w,
                    height: 126.h,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballSpinFadeLoader,
                      colors: [context.theme.primaryColor],
                    ),
                  ),
                )),
        ));
  }

  Widget _buildiNextAndPrev() {
    print({
      'object===========${controller.videoDetailInfo.value?.prev.toString()}'
    });
    print({
      'object===========${controller.videoDetailInfo.value?.next.toString()}'
    });
    return Column(
      children: [
        //上一篇
        Obx(
          () => Visibility(
              visible: controller.videoDetailInfo.value?.prev != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      controller.disposePlayer(); //先进行一次资源释放，再跳转
                      Get.offNamed(Routes.VIDEO_BLACK_DETAIL,
                          arguments: {
                            "videoId":
                                controller.videoDetailInfo.value?.prev?.id,
                          },
                          preventDuplicates: false);
                    },
                    child: Container(
                      width: 230.w,
                      margin: EdgeInsets.symmetric(vertical: 30.h),
                      height: 78.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(39.r),
                          border: Border.all(color: Color(colorE1E1E1))),
                      child: Text(
                        "上一篇",
                        style: TextStyle(
                            fontSize: 39.sp, color: Color(color888888)),
                      ),
                    ),
                  ),
                  Text(
                    "${controller.videoDetailInfo.value?.prev?.title}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 60.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ),
        Obx(
          () => Visibility(
              visible: controller.videoDetailInfo.value?.next != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        controller.disposePlayer(); //先进行一次资源释放，再跳转
                        Get.offNamed(Routes.VIDEO_BLACK_DETAIL,
                            arguments: {
                              "videoId":
                                  controller.videoDetailInfo.value?.next?.id
                            },
                            preventDuplicates: false);
                      },
                      child: Container(
                        width: 230.w,
                        margin: EdgeInsets.symmetric(vertical: 30.h),
                        height: 78.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(39.r),
                            border: Border.all(color: Color(colorE1E1E1))),
                        child: Text(
                          "下一篇",
                          style: TextStyle(
                              fontSize: 39.sp, color: Color(color888888)),
                        ),
                      )),
                  Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    "${controller.videoDetailInfo.value?.next?.title}",
                    style:
                        TextStyle(fontSize: 60.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        )
      ],
    );
  }

  //构建视频分类按钮
  Widget _buildVideoCategory() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      height: 180.h,
      child: Obx(() => GridView.builder(
          itemCount: controller.videoController.categoryList.length,
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20.w,
              mainAxisSpacing: 20.w,
              childAspectRatio: 0.3),
          itemBuilder: (context, index) {
            return CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.videoController.goCategoryDetailView(index);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                height: 72.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(colorF4F4F4),
                    borderRadius: BorderRadius.circular(36.r)),
                child: Text(
                  "${controller.videoController.categoryList[index].classify}",
                  style: TextStyle(fontSize: 43.sp, color: Color(colorADADAD)),
                ),
              ),
            );
          })),
    );
  }

  Widget _buildVideoPlayWidget(BuildContext context) {
    return Container(
        height: 645.h,
        color: Colors.black26,
        child: Obx(() {
          final videoController = controller.videoPlayerController.value;
          // 确保 videoController 不为 null 且已初始化
          if (videoController != null && videoController.value.isInitialized) {
            return Chewie(
              controller: controller.chewieController!,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: context.theme.primaryColor,
              ),
            ); // 视频未初始化完成时显示进度条
          }
        }));
  }

  Widget _buildBottomList(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 22.h),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => controller.tabController.value == null
                ? SizedBox()
                : DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          onTap: (index) {
                            AppManager.instance.tapVibrate();
                            controller.setCurrentTabIndex(index);
                          },
                          tabs: const [
                            Tab(
                              text: "猜你喜欢",
                            ),
                            Tab(
                              text: "热门游戏",
                            ),
                            Tab(
                              text: "边看边玩",
                            ),
                          ],
                          labelStyle:
                              TextStyle(fontSize: 51.sp, color: Colors.black),
                          unselectedLabelStyle: TextStyle(
                              fontSize: 51.sp, color: Color(color747474)),
                          labelPadding: EdgeInsets.symmetric(horizontal: 33.w),
                          padding: EdgeInsets.zero,
                          tabAlignment: TabAlignment.start,
                          indicatorColor: context.theme.primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          dividerHeight: 0,
                          isScrollable: true,
                        ),
                        Obx(() => _buildCurrentSelectView())
                      ],
                    )),
          )
        ],
      ),
    );
  }

  Widget _buildCurrentSelectView() {
    Widget tempWidget;
    switch (controller.currentTabIndex.value) {
      case 0:
        tempWidget = _buildVideoList();
        break;
      case 1:
        tempWidget = _buildHotList();
        break;
      case 2:
        tempWidget = _buildHotList();
        break;
      default:
        tempWidget = Container(
          color: Colors.transparent,
          height: 300,
        );
        break;
    }
    return tempWidget;
  }

  Widget _buildVideoList() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(
        top: 56.h,
      ),
      child: Obx(() => GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.likeList.length, //数据后期从controller拿，现在暂时写死
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 32.w,
            mainAxisSpacing: 30.w,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            return CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.disposePlayer(); //先进行一次资源释放，再跳转
                Get.offNamed(Routes.VIDEO_DETAIL,
                    arguments: {"videoId": controller.likeList[index]?.id},
                    preventDuplicates: false);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: Container(
                          height: 287.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                          ),
                          child: CachedNetworkImage(
                              placeholder: (context, url) => Image.asset(
                                    Assets.theme1.images.video.defaultVideoImage
                                        .path,
                                    width: 274.w,
                                    height: 241.h,
                                  ),
                              errorWidget: (context, url, error) => Image.asset(
                                    Assets.theme1.images.video.defaultVideoImage
                                        .path,
                                    width: 274.w,
                                    height: 241.h,
                                  ),
                              imageUrl:
                                  "${controller.likeList[index].uploadThumb}"),
                        ),
                      )
                      // Positioned(
                      //     top: 18.h,
                      //     right: 20.w,
                      //     child: Container(
                      //       height: 52.h,
                      //       width: 52.w,
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(50),
                      //           color: Colors.black26),
                      //       child: UnconstrainedBox(
                      //           child: SvgPicture.asset(
                      //         Assets.theme1.images.video.iconCollect,
                      //         width: 30.w,
                      //         height: 30.h,
                      //         colorFilter: const ColorFilter.mode(
                      //             Colors.white, BlendMode.srcIn),
                      //       )),
                      //     ))
                    ],
                  ),
                  // SizedBox(
                  //   height: 18.h,
                  // ),
                  Text(
                    "${controller.likeList[index].title}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 38.sp, color: const Color(color525252)),
                  ),
                  // SizedBox(
                  //   height: 16.h,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //         "${DateTimeUtils.formatDateTime(controller.likeList[index].createDate!)}",
                  //         style: TextStyle(
                  //             fontSize: 32.sp,
                  //             color: const Color(color8C8C8C))),
                  //     Text("${controller.likeList[index].watchtimes}次观看",
                  //         style: TextStyle(
                  //             fontSize: 32.sp,
                  //             color: const Color(color8C8C8C))),
                  //   ],
                  // )
                ],
              ),
            );
          })),
    );
  }

  Widget _buildHotList() {
    return Container(
      margin: EdgeInsets.only(left: 56.w, right: 56.w, top: 26.h),
      child: Obx(() => GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: controller.homeController.hotGameList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.75,
                crossAxisCount: 2,
                crossAxisSpacing: 60.h,
                mainAxisSpacing: 30.w),
            itemBuilder: (context, index) {
              final hotDataItem = controller.homeController.hotGameList[index];
              bool isMaintain = hotDataItem.state!.toInt() == 2;
              return Stack(
                children: [
                  SizedBox(
                    width: 477.w,
                    child: CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        if (!isMaintain) {
                          controller.homeController.openHotGame(hotDataItem);
                        }
                      },
                      child: CachedNetworkImage(
                        imageUrl: hotDataItem.gameImgUrl!,
                        imageBuilder: (context, imageProvider) =>
                            _buildHotGameContainer(
                          hotDataItem: hotDataItem,
                          image: DecorationImage(
                            alignment: Alignment.centerRight,
                            image: imageProvider,
                          ),
                          index: index,
                        ),
                        // placeholder: (context, url) => const Center(
                        //   child: CircularProgressIndicator(),
                        // ),
                        errorWidget: (context, url, error) =>
                            _buildHotGameContainer(
                          hotDataItem: hotDataItem,
                          image: DecorationImage(
                            alignment: Alignment.centerRight,
                            image: AssetImage(
                                Assets.theme1.images.home.errorImg.path),
                          ),
                          index: index,
                        ),
                      ),
                    ),
                  ),
                  _buildMaintainContainer(
                    isMaintain: isMaintain,
                    margin: null,
                    height: 272.h,
                    width: 477.w,
                  )
                ],
              );
            },
          )),
    );
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
                // Text(
                //   'PLAY >',
                //   textAlign: TextAlign.left,
                //   style: TextStyle(
                //     fontSize: 36.sp,
                //     color: const Color(colorFFFFFF),
                //     height: 2,
                //   ),
                // ),
              ],
            ),
          ),
          // Positioned(
          //   top: 10.h,
          //   right: 10.w,
          //   child: CircleAvatar(
          //     radius: 26.r,
          //     backgroundColor: Colors.transparent,
          //     child: IconButton(
          //       padding: EdgeInsets.zero,
          //       onPressed: () {
          //         controller.collectGame(gameIem: hotDataItem);
          //       },
          //       icon: SvgPicture.asset(
          //         hotDataItem.play_collection! == 1
          //             ? Assets.theme1.images.home.iconCollectUncheck
          //             : Assets.theme1.images.home.iconCollectChecked,
          //         width: 52.w,
          //         height: 52.h,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
