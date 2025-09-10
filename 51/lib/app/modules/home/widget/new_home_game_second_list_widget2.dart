import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/home_view_const.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/app/widget/common_gradient.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/game_manager.dart';
import '../controllers/new_home_controller.dart';
import '../controllers/new_home_controller.detail.dart';

//首页二级游戏界面的第一种列表布局 简单处理一下，二级游戏界面有问题，后续有时间全部重构
class NewHomeGameSecondListWidget2 extends StatefulWidget {
  /// 数据类型 （场馆图片资源目前取本地， 子游戏图片资源取数据返回）
  final List<ThirdGamesItem>? dataList; // 用于彩票子游戏， 彩票

  final GameTypeEnum gameType; // 游戏类型， 与dataList映射
  final AssetsTypeEnum imageType; // 图片类型
  final ValueChanged<int>? clickItem;
  final ValueChanged<int>? clickCollect;
  final String? tag;
  const NewHomeGameSecondListWidget2({
    super.key,
    this.dataList,
    this.clickItem,
    this.clickCollect,
    required this.gameType,
    required this.imageType,
    this.tag,
  });

  @override
  State<NewHomeGameSecondListWidget2> createState() =>
      _HomeGameSecondListWidget2State();
}

class _HomeGameSecondListWidget2State
    extends State<NewHomeGameSecondListWidget2> {
  late NewHomeController homeController = Get.find();
  late NewHomeControllerDetail detailController;
  NetworkService networkService = NetworkService();
  @override
  void initState() {
    super.initState();
    detailController = Get.find();
  }

  @override
  void didUpdateWidget(covariant NewHomeGameSecondListWidget2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    homeController.updateHeight();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.dataList == null || widget.dataList!.isEmpty)
        ? JobsEmptyWhiteView()
        : GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 30.h,
              mainAxisSpacing: 30.w,
              childAspectRatio: 1.15,
            ),
            itemCount: widget.dataList!.length,
            itemBuilder: (context, index) {
              var imageUrl = "";
              var playCollection = 1;
              var item = (widget.dataList ?? [])[index];
              playCollection = item.play_collection!.toInt();

              imageUrl = GameUtils.getLotteryImg(
                  playId: widget.dataList![index].play_id!);
              if (item.thumbnail_img_url != null &&
                  item.thumbnail_img_url != "null" &&
                  item.thumbnail_img_url!.isNotEmpty) {
                imageUrl = item.thumbnail_img_url!;
              }
              var gameName = '';
              gameName = (widget.dataList ?? [])[index].play_cname!;

              return _buildCommonWidget(context,
                  index: index,
                  imageUrl: imageUrl,
                  gameName: gameName,
                  playCollection: playCollection,
                  isNetWorkImage: widget.imageType == AssetsTypeEnum.netWork,
                  isLocalImg: detailController.currentLotteryTabIndex.value ==
                      0 //0就都加载本地图片
                  );
            },
          );
  }

  Widget _buildAssetsImageContainer({
    required String imageUrl,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
        image: DecorationImage(
          image: AssetImage(imageUrl.replaceAll('/m_', '/g_')),
          fit: BoxFit.contain,
        ),
        gradient: CommonGradient.getRadialGradient(index: index),
      ),
    );
  }

  Widget _buildNetworkImageContainer({
    required String imageUrl,
    required int index,
  }) {
    return imageUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r)),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: imageProvider,
                ),
                gradient: CommonGradient.getRadialGradient(index: index),
              ),
            ),
            // placeholder: (context, url) => const Center(
            //   child: CircularProgressIndicator(),
            // ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r)),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(Assets.theme1.images.home.errorImg.path),
                ),
                gradient: CommonGradient.getRadialGradient(index: index),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r)),
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(Assets.theme1.images.home.errorImg.path),
              ),
              gradient: CommonGradient.getRadialGradient(index: index),
            ),
          );
  }

  Widget _buildCommonWidget(
    BuildContext context, {
    required int index,
    required String imageUrl,
    required String gameName,
    required num playCollection,
    required bool isNetWorkImage,
    required bool isLocalImg,
  }) {
    bool isNet = imageUrl.contains("http");
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        widget.clickItem?.call(index);
      },
      child: Stack(
        children: [
          Container(
            height: 451.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: Colors.black26),
            child: Column(
              children: [
                Expanded(
                  child: isLocalImg
                      ? isNet
                          ? _buildNetworkImageContainer(
                              imageUrl: imageUrl, index: index)
                          : Image.asset(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.r),
                                        topRight: Radius.circular(30.r)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(Assets
                                          .theme1.images.home.errorImg.path),
                                    ),
                                    gradient: CommonGradient.getRadialGradient(
                                        index: index),
                                  ),
                                ); // 显示一个错误图标
                              },
                            )
                      : _buildNetworkImageContainer(
                          imageUrl: imageUrl, index: index),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 36.w),
                  height: 121.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.r),
                          bottomRight: Radius.circular(30.r)),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          gameName,
                          style: TextStyle(
                            fontSize: 45.sp,
                            color: const Color(color2E2E2E),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            AppManager.instance.tapVibrate();
                            widget.clickCollect?.call(index);
                          },
                          child: SvgPicture.asset(
                            playCollection == 1
                                ? Assets.theme1.images.home.iconCollectUncheck
                                : Assets.theme1.images.home.iconCollectChecked,
                            width: 50.w,
                            height: 50.h,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          _buildMaintainContainer(
            index: index,
            width: double.infinity,
            height: 330.h,
          ),
        ],
      ),
    );
  }

  Widget _buildMaintainContainer({
    required int index,
    required double height,
    required double width,
    EdgeInsetsGeometry? margin,
  }) {
    // 判断游戏状态
    var gameState = GameManager.instance.gameState;
    int? state = gameState[widget.dataList![index].play_id];
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
}
