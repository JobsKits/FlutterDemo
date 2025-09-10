import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../constants/game_constants.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../kernel/utils/game_utils.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../../../data/home_main_info_bean.dart';
import '../../../widget/common_gradient.dart';
import '../new_home_const.dart';

//热门游戏详情列表
class HotGameDetailView extends StatefulWidget {
  const HotGameDetailView({super.key});

  @override
  State<HotGameDetailView> createState() => _HotGameDetailViewState();
}

class _HotGameDetailViewState extends State<HotGameDetailView> {
  NewHomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        leading: BackButton(
          color: context.customTheme?.titleColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "热门游戏",
          style: TextStyle(color: context.customTheme?.titleColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 56.w, right: 56.w, top: 26.h),
        child: Obx(() => GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: controller.hotGameList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.75,
                  crossAxisCount: 2,
                  crossAxisSpacing: 60.h,
                  mainAxisSpacing: 30.w),
              itemBuilder: (context, index) {
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

  jumpGame(GameBeanItem hotDataItem, bool isMaintain, index) {
    AppManager.instance.tapVibrate();
    if (!isMaintain) {
      bool isBigClass =
          hotDataItem.play_id == hotDataItem.upper_play_id; //这两个相等，判断为大类，切换tab;

      if (isBigClass) {
        var gameType = switchGameType(hotDataItem.big_type);

        controller.handleGameBanner(
          gameType: gameType ?? "",
          index: index,
          playId: hotDataItem.play_id,
        );
        Get.back();
      } else {
        controller.openHotGame(hotDataItem);
        controller.addGameRecord(HomeCollectionListItemBean(
          collectionId: hotDataItem.play_collection == 2
              ? hotDataItem.play_id?.toInt()
              : null,
          play_id: hotDataItem.play_id?.toInt(),
          playName: hotDataItem.play_name,
          upper_play_id: hotDataItem.upper_play_id?.toInt(),
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
