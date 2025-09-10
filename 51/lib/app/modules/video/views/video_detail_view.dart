import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../data/home_main_info_bean.dart';
import '../../../routes/app_pages.dart';
import '../../../widget/common_gradient.dart';
import '../controllers/video_detail_controller.dart';

///视频详情页面
class VideoDetailView extends GetView<VideoDetailController> {
  const VideoDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, _) {
          controller.disposePlayer();
          Get.delete<VideoDetailController>();
        },
        child: Scaffold(
          backgroundColor: Color(colorF4F4F4),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("视频"),
            centerTitle: true,
            leading: BackButton(
              onPressed: () {
                Get.back();
                controller.disposePlayer();
                Get.delete<VideoDetailController>();
              },
            ),
            // actions: [
            //   HorizontalMargin(
            //     left: 0.w,
            //     right: 45.w,
            //     child: SvgPicture.asset(
            //       Assets.theme1.images.video.detail.iconShare,
            //       width: 60.w,
            //       height: 60.h,
            //     ),
            //   )
            // ],
          ),
          body: _buildBody(context),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVideoPlayWidget(context),
        _buildVideoInfoWidget(context),
        Expanded(
          child: _buildBottomList(context),
        )
      ],
    );
  }

  Widget _buildVideoList() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 56.h, left: 34.w, right: 34.w),
      child: Obx(() => GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.likeList.length, //数据后期从controller拿，现在暂时写死
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 32.w,
            mainAxisSpacing: 30.w,
            childAspectRatio: 1.15,
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
                      // Container(
                      //   height: 287.h,
                      //   decoration: BoxDecoration(
                      //       color: Colors.black26,
                      //       borderRadius: BorderRadius.circular(30.r),
                      //       image: DecorationImage(
                      //           image: NetworkImage(
                      //               "${controller.likeList[index].uploadThumb}"),
                      //           fit: BoxFit.cover)),
                      // ),
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
                  SizedBox(
                    height: 18.h,
                  ),
                  Text(
                    "${controller.likeList[index].title}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 38.sp, color: const Color(color525252)),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                ],
              ),
            );
          })),
    );
  }

  Widget _buildBottomList(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 22.h),
          width: double.infinity,
          child: DefaultTabController(
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
                    labelStyle: TextStyle(fontSize: 51.sp, color: Colors.black),
                    unselectedLabelStyle:
                        TextStyle(fontSize: 51.sp, color: Color(color747474)),
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

  //视频信息的view
  Widget _buildVideoInfoWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(34.h),
      color: Colors.white,
      child: Obx(() => controller.videoDetailInfo.value == null
          ? Center(
              child: CircularProgressIndicator(
                color: context.theme.primaryColor,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${controller.videoDetailInfo.value?.title}",
                  style: TextStyle(fontSize: 54.sp),
                ),
                SizedBox(
                  height: 34.h,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //         "${DateTimeUtils.formatDateTime(controller.videoDetailInfo.value!.createDate!)} / ${controller.videoDetailInfo.value!.watchtimes}次观看"),
                //     // Container(
                //     //   width: 170.w,
                //     //   height: 62.h,
                //     //   alignment: Alignment.center,
                //     //   decoration: BoxDecoration(
                //     //       color: Color(theme01MainColor),
                //     //       borderRadius: BorderRadius.circular(31.r)),
                //     //   child: Row(
                //     //     mainAxisAlignment: MainAxisAlignment.center,
                //     //     children: [
                //     //       SvgPicture.asset(
                //     //         Assets.theme1.images.video.iconCollect,
                //     //         width: 32.w,
                //     //         height: 32.h,
                //     //         color: Colors.white,
                //     //       ),
                //     //       SizedBox(
                //     //         width: 11.w,
                //     //       ),
                //     //       Text(
                //     //         "收藏",
                //     //         style:
                //     //             TextStyle(fontSize: 36.sp, color: Colors.white),
                //     //       )
                //     //     ],
                //     //   ),
                //     // )
                //   ],
                // ),
                // SizedBox(
                //   height: 55.h,
                // ),
                _buildVideoCategory(),
                // SizedBox(
                //   height: 40.h,
                // ),
              ],
            )),
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

  Widget _buildCurrentSelectView() {
    Widget tempWidget;
    switch (controller.currentTabIndex.value) {
      case 1:
        tempWidget = _buildHotGameList();
        break;
      case 2:
        tempWidget = Container(
          color: Colors.transparent,
          height: 300,
        );
        break;
      default:
        tempWidget = _buildVideoList();
        break;
    }
    return tempWidget;
  }

  Widget _buildHotGameList() {
    return Container(
      margin: EdgeInsets.only(left: 56.w, right: 56.w, top: 26.h),
      child: Obx(() => GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
                  controller.homeController.collectGame(gameIem: hotDataItem);
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
}
