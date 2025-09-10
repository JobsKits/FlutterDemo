//游戏试玩页面
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../kernel/utils/game_utils.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../../../data/home_main_info_bean.dart';
import '../../../widget/common_gradient.dart';
import 'game_try_controller.dart';

class GameTryView extends GetView<GameTryController> {
  const GameTryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(colorF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("试玩"),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          Container(
            height: 100.h,
            margin: EdgeInsets.symmetric(vertical: 33.h),
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(colorEDEDED)),
                borderRadius: BorderRadius.circular(45.r)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.theme1.images.video.iconSearch,
                  width: 46.w,
                  height: 46.h,
                ),
                Expanded(
                    child: TextField(
                  controller: controller.searchNameController,
                  focusNode: controller.searchFocusNode,
                  cursorColor: context.theme.primaryColor,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "搜索",
                    contentPadding: EdgeInsets.only(left: 10.w),
                    hintStyle: TextStyle(
                        fontSize: 33.sp, color: const Color(colorBCBCBC)),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none, // 去除边框线
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none, // 去除边框线
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none, // 去除边框线
                    ),
                  ),
                )),
                Obx(() => Visibility(
                    visible: controller.isSearch.value,
                    child: CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        Get.focusScope?.unfocus();
                        controller.searchNameController.text = "";
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: 26.w,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 40.w,
                        ),
                      ),
                    )))
              ],
            ),
          ),
          Obx(() => Expanded(
              child: controller.isEmpty.value
                  ? _buildEmptyView()
                  : _buildContent())),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Text(
        "暂无数据",
        style: TextStyle(fontSize: 46.sp),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLeftMenu(),
        SizedBox(
          width: 27.w,
        ),
        Expanded(child: _buildRightContent()),
      ],
    );
  }

  Widget _buildLeftMenu() {
    return SizedBox(
      width: 170.w,
      height: double.infinity,
      child: Obx(() => ListView.builder(
          itemCount: controller.leftList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return CommonRipple(
              onTap: () {
                if (controller.leftMenuIndex.value != index) {
                  AppManager.instance.tapVibrate();
                }
                controller.changeLeftMenuIndex(index);
              },
              child: Obx(() {
                // var defaultIcon = GameUtils.getHomeTabDefaultIcon(gameType: GameUtils.determineTypeConst2(controller.leftList[index]?.play_id?.toInt() ??0), playId: controller.leftList[index]?.play_id?.toInt() ??0);
                // var activeIcon = GameUtils.getHomeTabActiveIcon(gameType: GameUtils.determineTypeConst2(controller.leftList[index]?.play_id?.toInt() ??0), playId: controller.leftList[index]?.play_id?.toInt() ??0);
                var gameItem = controller.leftList[index];
                var colorIcon = GameUtils.getHomeTabDefaultColorIcon(
                    gameType: GameUtils.determineTypeConst2(
                        controller.leftList[index]?.play_id?.toInt() ?? 0),
                    playId: controller.leftList[index]?.play_id?.toInt() ?? 0);
                var gitUrl = GameUtils.getGitColorIcon(
                    playId: gameItem.play_id, bigType: gameItem.big_type);
                if (gitUrl.isNotEmpty) {
                  colorIcon = gitUrl;
                }
                return Container(
                  width: 170.w,
                  margin: EdgeInsets.only(bottom: 18.h),
                  height: 150.h,
                  decoration: BoxDecoration(
                      color: controller.leftMenuIndex == index
                          ? context.theme.primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //GameUtils.determineTypeConst2(controller.leftList[index]?.play_id?.toInt() ??0)
                      CachedNetworkImage(
                        imageUrl: colorIcon,
                        width: 52.w,
                        height: 52.h,
                        errorListener: (_) {
                          TenantManager.instance.errorImgCount += 1;
                        },
                      ),
                      // Image.asset(
                      //   colorIcon,
                      //   width: 52.w,
                      //   height: 52.h,
                      // ),
                      SizedBox(width: 15.h),
                      Text(
                        "${controller.leftList[index].play_id == 1380 ? 'PG' : controller.leftList[index].play_cname}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 38.sp,
                            color: controller.leftMenuIndex.value == index
                                ? Colors.white
                                : Color(color6B6B6B)),
                      )
                    ],
                  ),
                );
              }),
            );
          })),
    );
  }

  Widget _buildRightContent() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r)),
      child: Obx(() => GridView.builder(
          itemCount: controller.rightList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.15,
              crossAxisCount: 2,
              crossAxisSpacing: 24.h,
              mainAxisSpacing: 30.w),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final gameItem = controller.rightList[index];
            String imgUrl = GameUtils.getHotGameImageUrl(
                playName: gameItem.play_name ?? "",
                upperPlayId: gameItem.upper_play_id ?? 0,
                bigType: gameItem.big_type ?? 0,
                playId: gameItem.play_id?.toInt() ?? 0);
            // bool isMaintain = hotDataItem.state!.toInt() == 2;
            return CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.openGame(gameItem);
              },
              child: Container(
                width: 366.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    gradient: CommonGradient.getRadialGradient(index: index)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    imgUrl.contains("http")
                        ? Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              CachedNetworkImage(
                                imageUrl: imgUrl,
                                width: 240.w,
                                errorWidget: (context, url, error) =>
                                    Image.asset(Assets
                                        .theme1.images.home.errorImg.path),
                              ),
                            ],
                          )
                        : Expanded(
                            child: Image.asset(
                            imgUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )),
                    imgUrl.contains("http") ? Spacer() : SizedBox.shrink(),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25.r),
                              bottomRight: Radius.circular(25.r))),
                      height: 100.h,
                      child: Text(
                        "${gameItem.play_cname}",
                        style: TextStyle(fontSize: 36.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }

  Widget _buildHotGameContainer({
    required DecorationImage image,
    required GamesTryItemBean hotDataItem,
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
            color: Colors.blue,
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
        ],
      ),
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
}
