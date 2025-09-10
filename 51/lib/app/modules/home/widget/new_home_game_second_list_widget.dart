import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/home_view_const.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/app/widget/common_gradient.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../kernel/utils/game_utils.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/tenant_manager.dart';
import '../../login/data/contact_config_bean.dart';
import '../controllers/new_home_controller.detail.dart';

//首页二级游戏界面的第一种列表布局
class NewHomeGameSecondListWidget1 extends StatefulWidget {
  /// 数据类型 （场馆图片资源目前取本地， 子游戏图片资源取数据返回）
  final List<ThirdGamesItem>? dataList1; // 用于场馆图片显示， 体育/真人
  final List<GameBeanItem>? dataList2; // 用于数据返回子游戏， 捕鱼/电子/棋牌
  final List<GameLotteryItemBean>? dataList3; // 用于彩票子游戏， 彩票
  final List<HomeCollectionListItemBean>? dataList4; // 用于彩票子游戏， 彩票

  final GameTypeEnum gameType; // 游戏类型， 与dataList映射
  final AssetsTypeEnum imageType; // 图片类型
  final bool? isRecord; // 图片类型
  final ValueChanged<int>? clickItem;
  final ValueChanged<int>? clickCollect;
  final HomePageDetailEnum tag;
  final int? tabIndex;
  final int? thirdTabIndex;
  NewHomeGameSecondListWidget1({
    super.key,
    this.dataList1,
    this.dataList2,
    this.dataList3,
    this.dataList4,
    this.clickItem,
    this.clickCollect,
    this.isRecord,
    required this.gameType,
    required this.imageType,
    required this.tag,
    this.tabIndex,
    this.thirdTabIndex,
  });

  @override
  State<NewHomeGameSecondListWidget1> createState() =>
      _NewHomeGameSecondListWidget1State();
}

class _NewHomeGameSecondListWidget1State
    extends State<NewHomeGameSecondListWidget1> {
  late NewHomeControllerDetail controller = Get.find();
  late NewHomeController homeController = Get.find();

  List<dynamic> allItems = []; // 存储从接口获取的所有数据
  List<dynamic> displayedItems = []; // 存储已显示的数据，分页使用
  int page = 1; // 当前页码
  final int pageSize = 10; // 每页显示的数据条数
  String keyWords = "";

  void _loadNextPage() {
    setState(() {
      isShowLoadMore = page * pageSize < allItems.length;
    });
    List<dynamic> newItems = allItems.sublist(
        (page - 1) * pageSize,
        (page * pageSize) > allItems.length
            ? allItems.length
            : (page * pageSize));

    if (page > 1) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          displayedItems.addAll(newItems); // 将新数据添加到显示的数据中
          page++; // 增加页码
          isLoading = !isShowLoadMore;
          isShowLoading = isShowLoadMore;
          controller.homeController.updateHeight();
        });
      });
    } else {
      setState(() {
        displayedItems.addAll(newItems); // 将新数据添加到显示的数据中
        page++; // 增加页码
        isLoading = !isShowLoadMore;
        isShowLoading = isShowLoadMore;
        controller.homeController.updateHeight();
      });
    }
  }

  bool isShowLoadMore = true;
  bool isLoading = false;
  bool isShowLoading = false;
  bool isChangeIndex = false;
  @override
  void initState() {
    super.initState();
    final List<dynamic>? dataList;
    if (widget.gameType == GameTypeEnum.gameType1) {
      dataList = widget.dataList1;
    } else if (widget.gameType == GameTypeEnum.gameType2) {
      dataList = widget.dataList2;
    } else if (widget.gameType == GameTypeEnum.gameType3) {
      dataList = widget.dataList3;
    } else {
      dataList = widget.dataList4;
    }
    switch (widget.tag) {
      case HomePageDetailEnum.fishing:
        ever(controller.currentFishTabIndex, (index) {
          isChangeIndex = true;
        });
        break;
      case HomePageDetailEnum.electronic:
        ever(controller.currentElectronicTabIndex, (index) {
          isChangeIndex = true;
        });
        break;
      case HomePageDetailEnum.chess:
        ever(controller.currentChessTabIndex, (index) {
          isChangeIndex = true;
        });
        break;
      case HomePageDetailEnum.blockChain:
        ever(controller.currentBlockChainTabIndex, (index) {
          isChangeIndex = true;
        });
        break;
      case HomePageDetailEnum.sports:
      case HomePageDetailEnum.lottery:
      case HomePageDetailEnum.collect:
      case HomePageDetailEnum.recent:
      case HomePageDetailEnum.live:
    }
    allItems = dataList ?? [];
    _loadNextPage();
    tempIndex = widget.tabIndex ?? 0;
    tempThirdIndex = widget.thirdTabIndex ?? 0;
    keyWords = controller.searchName.value;
    homeController.scrollController.addListener(() {
      if (homeController.scrollController.position.pixels >=
              homeController.scrollController.position.maxScrollExtent -
                  _height -
                  200.h &&
          !isLoading) {
        isLoading = true;
        _loadNextPage();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeight());
  }

  double _height = 0.0;
  void _getHeight() {
    final RenderBox renderBox = homeController.bottomViewKey.currentContext!
        .findRenderObject() as RenderBox;
    setState(() {
      _height = renderBox.size.height;
    });
  }

  int tempIndex = 0;
  int tempThirdIndex = 0;
  @override
  void didUpdateWidget(covariant NewHomeGameSecondListWidget1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 只有在 tabIndex 或 gameType 发生变化时才重新计算数据
    if (oldWidget.tabIndex != widget.tabIndex ||
        oldWidget.gameType != widget.gameType ||
        oldWidget.thirdTabIndex != widget.thirdTabIndex ||
        controller.loadFinish ||
        keyWords != controller.searchName.value ||
        isChangeIndex) {
      _initializeData();
    }
  }

  _initializeData() {
    if (tempIndex != widget.tabIndex ||
        tempThirdIndex != widget.thirdTabIndex ||
        controller.loadFinish ||
        keyWords != controller.searchName.value ||
        isChangeIndex) {
      if (controller.loadFinish) {
        controller.loadFinish = false;
      }
      if (keyWords != controller.searchName.value) {
        keyWords = controller.searchName.value;
      }
      if (isChangeIndex) {
        isChangeIndex = false;
      }
      final List<dynamic>? dataList;
      if (widget.gameType == GameTypeEnum.gameType1) {
        dataList = widget.dataList1;
      } else if (widget.gameType == GameTypeEnum.gameType2) {
        dataList = widget.dataList2;
      } else if (widget.gameType == GameTypeEnum.gameType3) {
        dataList = widget.dataList3;
      } else {
        dataList = widget.dataList4;
      }
      allItems = dataList ?? [];
      page = 1;
      displayedItems.clear();
      _loadNextPage();
      tempIndex = widget.tabIndex ?? 0;
      tempThirdIndex = widget.thirdTabIndex ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final List<dynamic>? dataList;
    // if (widget.gameType == GameTypeEnum.gameType1) {
    //   dataList = widget.dataList1;
    // } else if (widget.gameType == GameTypeEnum.gameType2) {
    //   dataList = widget.dataList2;
    // } else if (widget.gameType == GameTypeEnum.gameType3) {
    //   dataList = widget.dataList3;
    // } else {
    //   dataList = widget.dataList4;
    // }
    // if (dataList != null && dataList.isEmpty) {
    //   return _buildEmptyView();
    // }

    if (!controller.isSubPageLoading.value && displayedItems.isEmpty) {
      return _buildLoadingView();
    }
    if ( displayedItems.isEmpty) {
      return _buildEmptyView();
    }
    return Column(
      children: [
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30.h,
            mainAxisSpacing: 30.w,
            childAspectRatio: 1.15,
          ),
          // itemCount: displayedItems!.length,
          itemCount: displayedItems!.length,
          itemBuilder: (context, index) {
            var imageUrl = '';
            var gameName = '';
            var playCollection = 1;
            var state = -1;
            if (widget.gameType == GameTypeEnum.gameType1) {
              var gitUrl = GameUtils.getColorIconImageUrl(
                  bigType: (widget.dataList1 ?? [])[index].big_type ?? 0,
                  playId: (widget.dataList1 ?? [])[index].play_id!);
              imageUrl =
                  ((widget.dataList1 ?? [])[index].thumbnail_img_url == null ||
                          (widget.dataList1 ?? [])[index]
                              .thumbnail_img_url!
                              .isEmpty ||
                          (widget.dataList1 ?? [])[index].thumbnail_img_url ==
                              "null")
                      ? gitUrl ?? ""
                      : (widget.dataList1 ?? [])[index].thumbnail_img_url!;

              gameName = (widget.dataList1 ?? [])[index].play_cname!;

              playCollection =
                  (widget.dataList1 ?? [])[index].play_collection!.toInt();
              state = (widget.dataList1 ?? [])[index].state!.toInt();
            } else if (widget.gameType == GameTypeEnum.gameType2) {
              if ((widget.dataList2 ?? [])[index].gameImgUrl?.isNotEmpty ==
                  true) {
                imageUrl = (widget.dataList2 ?? [])[index].gameImgUrl!;
              }
              if ((widget.dataList2 ?? [])[index]
                      .thumbnail_img_url
                      ?.isNotEmpty ==
                  true) {
                imageUrl = (widget.dataList2 ?? [])[index].thumbnail_img_url!;
              }
              gameName = (widget.dataList2 ?? [])[index].play_cname!;
              playCollection =
                  (widget.dataList2 ?? [])[index].play_collection!.toInt();
              state = (widget.dataList2 ?? [])[index].state!.toInt();
            } else if (widget.gameType == GameTypeEnum.gameType3) {
              if ((widget.dataList3 ?? [])[index].img_url?.isNotEmpty == true) {
                imageUrl = (widget.dataList3 ?? [])[index].img_url!;
              }
              if ((widget.dataList3 ?? [])[index]
                      .thumbnail_img_url
                      ?.isNotEmpty ==
                  true) {
                imageUrl = (widget.dataList3 ?? [])[index].thumbnail_img_url!;
              }
              gameName = (widget.dataList3 ?? [])[index].play_cname!;
              playCollection =
                  (widget.dataList3 ?? [])[index].play_collection!.toInt();
              state = (widget.dataList3 ?? [])[index].play_state!.toInt();
            } else {
              String? tempStr1 = parseJson(
                  (widget.dataList4 ?? [])[index].msg)['thumbnail_img_url'];
              String? tempStr2 =
                  parseJson((widget.dataList4 ?? [])[index].msg)['gameImgUrl'];
              if (tempStr1 != null &&
                  tempStr1.isNotEmpty &&
                  tempStr1 != "null") {
                imageUrl = tempStr1;
              } else if (tempStr2 != null &&
                  tempStr2.isNotEmpty &&
                  tempStr2 != "null") {
                imageUrl = tempStr2;
              } else {
                imageUrl = (widget.dataList4 ?? [])[index].thumbnail_img_url ??
                    (widget.dataList4 ?? [])[index].gameImgUrl ??
                    "";
              }
              gameName = (widget.dataList4 ?? [])[index].playCname!;
              state = (widget.dataList4 ?? [])[index].play_state!;

              playCollection = !widget.isRecord!
                  ? 2
                  : (widget.dataList4 ?? [])[index].collectionId != null
                      ? 2
                      : 1;
            }
            return _buildCommonWidget(
              context,
              index: index,
              imageUrl: imageUrl,
              gameName: gameName,
              playCollection: playCollection,
              isNetWorkImage: widget.imageType == AssetsTypeEnum.netWork,
              isMaintain: state == 2,
            );
          },
        ),
        Visibility(
            visible: isShowLoading,
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
              child: Column(
                children: [
                  SizedBox(
                    width: 126.w,
                    height: 126.h,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballSpinFadeLoader,
                      colors: [context.theme.primaryColor],
                    ),
                  ),
                  Text("加载中,请稍后")
                ],
              ),
            ))
      ],
    );
  }

  Widget _buildLoadingView() {
    return Container(
      height: 500.h,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 200.w,
              height: 200.h,
              child: LoadingIndicator(
                indicatorType: Indicator.ballSpinFadeLoader,
                colors: [context.theme.primaryColor],
              ),
            ),
          ),
          SizedBox(height: 50.h),
          Text(
            '加载中，请稍后',
            style: TextStyle(fontSize: 40.sp),
          ),
        ],
      ),
    );
  }

  // 构建空的图片占位符
  Widget _buildEmptyView() {
    return Obx(() => controller.searchName.isEmpty
        ? Container(
            height: 500.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.customTheme?.pageTwoBg,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: JobsBuildEmptyView(),
          )
        : Padding(
            padding: EdgeInsets.only(top: 100.h),
            child: Text(
              '无结果',
              style: TextStyle(fontSize: 40.sp, color: Color(color99999)),
            ),
          ));
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
          fit: BoxFit.cover,
        ),
        gradient: CommonGradient.getRadialGradient(index: index),
      ),
    );
  }

  Widget _buildNetworkImageContainer({
    required String imageUrl,
    required int index,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
          image: DecorationImage(
            fit: widget.gameType == GameTypeEnum.gameType1
                ? BoxFit.fill
                : BoxFit.contain,
            image: imageProvider,
          ),
          gradient: CommonGradient.getRadialGradient(index: index),
        ),
      ),
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          color: context.theme.primaryColor,
        ),
      ),
      errorWidget: (context, url, error) {
        TenantManager.instance.errorImgCount += 1;
        return Container(
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
      },
    );
  }

  Widget _buildCommonWidget(
    BuildContext context, {
    required int index,
    required String imageUrl,
    required String gameName,
    required num playCollection,
    required bool isNetWorkImage,
    required bool isMaintain,
  }) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        if (!isMaintain) {
          widget.clickItem?.call(index);
        }
      },
      child: Stack(
        children: [
          Container(
              height: 451.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: context.customTheme?.pageTwoBg),
              child: Column(
                children: [
                  Expanded(
                    child: imageUrl.contains('http')
                        ? _buildNetworkImageContainer(
                            imageUrl: imageUrl, index: index)
                        : SizedBox(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 36.w),
                    height: 121.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.r),
                            bottomRight: Radius.circular(30.r)),
                        color: context.customTheme?.pageTwoBg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            gameName,
                            style: TextStyle(
                              fontSize: 45.sp,
                              color: context.customTheme?.titleColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        CommonRipple(
                            onTap: () {
                              AppManager.instance.tapVibrate();
                              widget.clickCollect?.call(index);
                            },
                            child: SvgPicture.asset(
                              playCollection == 1
                                  ? Assets.theme1.images.home.iconCollectUncheck
                                  : Assets
                                      .theme1.images.home.iconCollectChecked,
                              width: 50.w,
                              height: 50.h,
                            ))
                      ],
                    ),
                  )
                ],
              )),
          _buildMaintainContainer(
            isMaintain: isMaintain,
            width: double.infinity,
            height: 330.h,
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
