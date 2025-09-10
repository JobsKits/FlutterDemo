import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/model/yulecheng/yulecheng_changguan_model.dart';
import 'package:flutter_bet/pages/find/state.dart';
import 'package:flutter_bet/pages/find/YulechengCategoryPage/widgets/casino_game_list.dart';
import 'package:flutter_bet/pages/find/widget/casino_page_flip_list.dart';
import 'package:flutter_bet/pages/find/widget/casino_tabbar.dart';
import 'package:flutter_bet/pages/find/yulechengtouzhurank/index.dart';
import 'package:flutter_bet/pages/front/widget/front_competition_view.dart';
import 'package:flutter_bet/pages/front/widget/front_sport_competition_view.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_marquee.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../widget/button/custom_small_mian_button.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import '../../../widget/sport/custom_sport_banner.dart';
import '../../front/widget/front_casino_competition_view.dart';
import '../../front/widget/front_casino_page_view_one.dart';
import '../../front/widget/front_virtual_currency.dart';
import '../logic.dart';
import 'casino_banner.dart';
import 'casino_changguan_flip_list.dart';
import 'casino_function.dart';

final GlobalStateController globalController = Get.find<GlobalStateController>();

///娱乐城大厅
class CasinoMainView extends GetView<FindLogic> {
  final CasinoState data;
  const CasinoMainView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(child: buildBody(context));
  }

  /// 区分加载哪部分页面
  ///
  Widget buildBody(context) {
    if (!controller.state.isLoadingFinished && controller.isInitialized == false) {
      return SizedBox(
          height: 150,
          child: CustomNetWorkImagePlaceholder(
            color: AppThemes.surfaceVariant.withOpacity(0),
            placeholderType: NetWorkImagePlaceholderType.loading,
            // borderRadius: borderRadius,
            // border: border,
          ));
    } else if (controller.state.isLoadingFinished && controller.isInitialized == false) {
      return <Widget>[
        const CustomEmptyWidget(),
        CustomText(S.current.random_text_890,
                style: TextStyle(
                    color: ThemeService().theme.colorScheme.onTertiary,
                    fontWeight: FontWeight.w600,
                    fontSize: AppValues.fontBodyMediumSize))
            .paddingTop(40),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center).onTap(() {
        controller.onInit();
        controller.getBanner();
        controller.getMarquee();
        controller.initData();
        // controller.onReady();
      });
    } else {
      return buildMainYulecheng(context);
    }
  }

  /// 加载娱乐城主界面
  ///
  Widget buildMainYulecheng(context) {
    // 是否为娱乐城-Tab-“大厅”
    final isLabby = controller.isGameLobbby == true;

    return casinoBuildMainBg(controller: controller, children: [
      ///banner
      data.bannnerList.isNotEmpty
          ? CustomSportBanner(data.bannnerList).sliverToBoxAdapter()
          : SizedBox(
              height: controller.state.isLoadingFinished ? 0 : AppValues.defaultMargin,
            ).sliverToBoxAdapter(),
      CasinoTabBar(
        tabs: data.tabs,
        tabController: controller.tabController,
      ).sliverToBoxAdapter(),

      // 游戏列表Title
      if (!isLabby && controller.state.dataArray.length < 1)
        _buildGamesNavTitle()
            .visibility(!isLabby && data.isLoadingFinished == true)
            .sliverToBoxAdapter(),

      // 游戏列表
      buildDetialView(),

      // if (!isLabby && controller.state.dataArray.length < 1)
      //   (data.ty2DataArray.length < 1 && data.dataArray.length < 1 && data.cgDataArray.length < 1)
      //       ? (data.isLoadingFinished == true
      //           ? const CustomEmptyWidget().sliverToBoxAdapter()
      //           : SizedBox(
      //               height: 150,
      //               child: CustomNetWorkImagePlaceholder(
      //                 color: AppThemes.surfaceVariant.withOpacity(0),
      //                 placeholderType: NetWorkImagePlaceholderType.loading,
      //               )).sliverToBoxAdapter())
      //       : buildBottomview().sliverToBoxAdapter(),
      if (!controller.isGameLobbby && data.dataArray.length < 1)
        buildBottomview().sliverToBoxAdapter(),
      // 风云榜/竞赛类排行榜
      RankingListWidget("home", context).sliverToBoxAdapter(),

      // 创建游戏说明
      if (globalController.isLogin.value == false)
        buildRules().paddingHorizontal(AppValues.defaultPadding).sliverToBoxAdapter(),
    ]);
  }

  Widget buildMarqueeWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: ShapeDecoration(
        color: ThemeService().theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Colors.white.withOpacity(0.10000000149011612),
          ),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Row(
        children: [
          const CustomIcon(asset: 'assets/images/home/ic_front_notice.webp'),
          const SizedBox(
            width: 14,
          ),
          Expanded(
              child: Marquee(
            speed: 30,
            child: CustomText(
              controller.state.marqueeText.value,
              style: const TextStyle(color: AppThemes.iconColor, fontSize: 14),
            ),
          ))
        ],
      ),
    );
  }

  Widget buildDetialView() {
    // “游戏提供商”拦截

    if (controller.yulechengModel?.navs?[controller.tabIndex].cid == "5") {
      return buildCgGridView(data.cgDataArray);
    }
    if (controller.yulechengModel?.navs?[controller.tabIndex].cid == "1") {
      return buildDaTingView();
    }
    return controller.yulechengModel?.navs![controller.tabIndex].ty == 2
        ? buildTy2GridView(data.ty2DataArray)
        : data.dataArray.length < 1
            ? buildGridView(controller.state.dataArrayNoLitems)
            : buildSameDaTingView(data.dataArray);
    // return controller.yulechengModel.navs![controller.tabIndex].ty == 2
    //     ? buildTy2GridView(data.ty2DataArray)
    //     : buildGridView(data.dataArray);
  }

  // 大厅
  buildDaTingView() {
    return <Widget>[
      controller.yulechengModel?.items == null
          ? const SizedBox()
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.yulechengModel?.items?.length,
              itemBuilder: (context, index) {
                // 数据为空不显示列表
                if ((controller.yulechengModel?.items![index].navGames! ?? []).isEmpty &&
                    (controller.yulechengModel?.items![index].games! ?? []).isEmpty) {
                  return const SizedBox();
                }

                // cid == "5" 为游戏平台
                if (controller.yulechengModel?.items![index].cid == "5") {
                  return CasinoChangguanFlipList(
                      onTap: controller.goToPlatDetail,
                      items: controller.changguanDataArray,
                      title: controller.yulechengModel?.items![index].name ?? '',
                      icon: controller.yulechengModel?.items![index].icon ?? '',
                      showType: controller.getShowArrowStatus(index),
                      currentIndex: index,
                      statusCallback: controller.changeArrowShowStatus);
                }

                return CasinoPageFlipList(
                  onTap: controller.goToDetail,
                  onTitleTap: controller.goToshowAll,
                  itemsList: controller.yulechengModel?.items![index].navGames! ?? [],
                  title: controller.yulechengModel?.items![index].name ?? '',
                  icon: controller.yulechengModel?.items![index].icon ?? '',
                  currentIndex: index,
                  currentAnimatedIndex: controller.state.animationIndex,
                  needshowChaKanGengDuo: true,
                  needShowPlayer: !(controller.yulechengModel?.items![index].name ?? '')
                          .contains(S.current.game_live)
                      ? true
                      : false,
                  showStatus: controller.getShowStatus(
                      index, controller.yulechengModel?.items![index].navGames!.length),
                  statusCallback: controller.changeShowStatus,
                  animationedCallback: controller.putAnimationIndex,
                  showType: controller.getShowArrowStatus(index),
                );
              }),

      // buildBuyCryptoCurrency(),
      // CasinoCompetitionView(
      //   listData: [],
      // ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).sliverToBoxAdapter();
  }

  // 右侧修改成喝大厅一样排列
  buildSameDaTingView(List<Litem> itemsList) {
    return <Widget>[
      itemsList.length == null
          ? const SizedBox()
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemsList.length,
              itemBuilder: (context, index) {
                // 数据为空不显示列表
                if (itemsList[index].navGames!.isEmpty) {
                  return const SizedBox();
                }

                // cid == "5" 为游戏平台
                if (itemsList[index].cid == "5") {
                  return CasinoChangguanFlipList(
                      onTap: controller.goToPlatDetail,
                      items: controller.changguanDataArray,
                      title: controller.yulechengModel?.items![index].name ?? '',
                      icon: controller.yulechengModel?.items![index].icon ?? '');
                }

                return CasinoPageFlipList(
                  onTap: controller.goToDetail,
                  onTitleTap: controller.goToshowAll,
                  itemsList: itemsList[index].navGames!,
                  title: itemsList[index].name,
                  icon: itemsList[index].icon,
                  currentIndex: index,
                  currentAnimatedIndex: controller.state.animationIndex,
                  needshowChaKanGengDuo: true,
                  needShowPlayer:
                      itemsList[index].name.contains(S.current.game_live) ? false : true,
                  showStatus: controller.getShowStatus(index, itemsList[index].navGames!.length),
                  statusCallback: controller.changeShowStatus,
                  animationedCallback: controller.putAnimationIndex,
                  showType: controller.getShowArrowStatus(index),
                );
              }),

      // buildBuyCryptoCurrency(),
      // CasinoCompetitionView(
      //   listData: [],
      // ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).sliverToBoxAdapter();
  }

  Widget buildBottomview() {
    return data.totalGame < 21
        ? const SizedBox()
        : <Widget>[
            CupertinoButton(
              padding: const EdgeInsets.fromLTRB(
                  AppValues.defaultPadding, 0, AppValues.defaultPadding, 0),
              color: ThemeService().theme.colorScheme.tertiary, // 设置按钮颜色
              alignment: Alignment.centerRight,
              pressedOpacity: 0.5, // 设置按钮按下时的不透明度
              child: Text(
                  S.current.homeChaKanQuanBu(data.totalGame,
                      controller.yulechengModel?.navs![controller.tabIndex].name ?? ''),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              onPressed: () {
                // 按钮点击时的处理逻辑
                Future.delayed(const Duration(milliseconds: 300), () {
                  controller.goToShowQuanBu(controller.tabIndex);
                });
              },
            ).tight(height: 44).paddingTop(AppValues.defaultPadding),
            // CustomSmallMainButton(
            //   onTap: () {
            //     controller.goToShowQuanBu(controller.tabIndex);
            //   },
            //   title: S.current.homeChaKanQuanBu(
            //       data.totalGame, controller.yulechengModel?.navs![controller.tabIndex].name ?? ''),
            //   // S.current.chaKanQuanBu +
            //   // "${data.totalGame} ${controller.yulechengModel.navs![controller.tabIndex - 1].name}",
            //   backgroundColor: ThemeService().theme.colorScheme.tertiary,
            // ).tight(height: 44).paddingTop(AppValues.defaultPadding),
          ].toColumn();
  }

  Widget buildBuyCryptoCurrency() {
    return const FrontVirtualCurrency().paddingTop(AppValues.defaultPadding);
  }

  // 创建单独游戏列表
  buildGridView(dataItems) {
    return SliverPadding(
      padding: const EdgeInsets.only(
          bottom: AppValues.defaultPadding,
          left: AppValues.defaultPadding,
          right: AppValues.defaultPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          mainAxisSpacing: AppValues.defaultPadding, // Spacing between rows
          crossAxisSpacing: AppValues.defaultPadding, // Spacing between columns
          childAspectRatio:
              controller.isZhenRen ? 110 / 150 : 110 / 180, // Width to height ratio of grid items
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  if (dataItems[index].maintained == "2") {
                    CustomSnackBar.show("text", Get.context!, preIcon: null);
                    return;
                  }
                  if (dataItems[index] is GameLobbyModel) {
                    GameListModel model = GameListModel(
                        id: dataItems[index].id,
                        platformId: dataItems[index].platformId,
                        name: dataItems[index].name,
                        gameType: "",
                        gameId: dataItems[index].gameId,
                        img: dataItems[index].img,
                        sorting: 0,
                        createdAt: 0,
                        isHot: 0,
                        isNew: 0,
                        isFav: 0);
                    controller.goToDetail(model, false, 0);
                    return;
                  }
                  controller.goToDetail(dataItems[index], false, 0);
                },
                child: <Widget>[
                  Stack(
                    children: <Widget>[
                      CustomNetWorkImage(
                        imageUrl: dataItems[index].gameType == "8"
                            ? BranchService.instance.current.asset_url +
                                dataItems[index].img.replaceAll(
                                    "%lang%/",
                                    LangUtil().getLangType() +
                                        "/${AppValues.defaultBranch.ws_prefix}_")
                            : BranchService.instance.current.asset_url +
                                dataItems[index].img.replaceAll("%lang%", LangUtil().getLangType()),
                        placeholder: CustomNetWorkImage(
                          imageUrl: BranchService.instance.current.asset_url +
                              dataItems[index]
                                  .img
                                  .replaceAll(".webp", ".s.webp")
                                  .replaceAll("%lang%", LangUtil().getLangType()),
                          errorWidget: const SizedBox(),
                        ),
                      ),
                      if (dataItems[index].maintained == "2")
                        // 半透明蒙版
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppValues.smallPadding),
                            ),
                          ),
                          // 使用Color.fromRGBO来设置半透明颜色
                        ),
                      if (dataItems[index].maintained == "2")
                        // 上层内容
                        <Widget>[
                          // SvgPicture.asset("assets/svg/icon _yulecheng_maintanance.svg").center(),
                          Image.network(BranchService.instance.current.asset_url +
                                  "/images/common/%lang%/maintained.webp"
                                      .replaceAll("%lang%", LangUtil().getLangType()))
                              .center(),
                          // Text(
                          //   S.current.game_category_repair,
                          //   style: ThemeService().theme.textTheme.bodyMedium,
                          // )
                          //     .alignBottom()
                          //     .center()
                          //     .paddingHorizontal(AppValues.halfPadding)
                          //     .paddingTop(AppValues.defaultPadding),
                        ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                    ],
                  ).expanded(),
                  if (controller.isZhenRen == false)
                    <Widget>[
                      // Container(
                      //   decoration: const BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(4)),
                      //     color: AppThemes.chatRoomOnlineGreenColor,
                      //   ),
                      // ).tight(width: 8, height: 8),
                      Image.asset(
                        "assets/svg/green_pot.webp",
                        width: 20,
                        height: 20,
                      ),
                      CustomText(dataItems[index].playerAmount! + S.current.random_text_578,
                          style: const TextStyle(fontSize: AppValues.fontBodySmallSize))
                    ].toRow().tight(height: 30).alignBottom()
                ].toColumn());
          },
          childCount: dataItems.length, // Total number of grid items
        ),
      ),
    );
  }

  // 创建单独游戏列表
  buildTy2GridView(dataItems) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppValues.defaultPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          mainAxisSpacing: AppValues.defaultPadding, // Spacing between rows
          crossAxisSpacing: AppValues.defaultPadding, // Spacing between columns
          childAspectRatio:
              controller.isZhenRen ? 110 / 150 : 110 / 180, // Width to height ratio of grid items
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  if (dataItems[index].zkOnline == "2") {
                    return;
                  }
                  controller.ty2GoToDetail(dataItems[index]);
                },
                child: <Widget>[
                  Stack(
                    children: <Widget>[
                      CustomNetWorkImage(
                        imageUrl:
                            BranchService.instance.current.asset_url + dataItems[index].gameImgUrl,
                        placeholder: CustomNetWorkImage(
                          imageUrl: BranchService.instance.current.asset_url +
                              dataItems[index]
                                  .img
                                  .replaceAll(".webp", ".s.webp")
                                  .replaceAll("%lang%", LangUtil().getLangType()),
                          errorWidget: const SizedBox(),
                        ),
                      ),
                      if (dataItems[index].zkOnline == "2")
                        // 半透明蒙版
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppValues.smallPadding),
                            ),
                          ),
                          // 使用Color.fromRGBO来设置半透明颜色
                        ),
                      if (dataItems[index].zkOnline == "2")
                        // 上层内容
                        <Widget>[
                          // SvgPicture.asset("assets/svg/icon _yulecheng_maintanance.svg").center(),
                          Image.network(BranchService.instance.current.asset_url +
                                  "/images/common/%lang%/maintained.webp"
                                      .replaceAll("%lang%", LangUtil().getLangType()))
                              .center(),
                          // Text(
                          //   S.current.game_category_repair,
                          //   style: ThemeService().theme.textTheme.bodyMedium,
                          // )
                          //     .alignBottom()
                          //     .center()
                          //     .paddingHorizontal(AppValues.halfPadding)
                          //     .paddingTop(AppValues.defaultPadding),
                        ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                    ],
                  ).expanded(),
                  if (controller.isZhenRen == false)
                    <Widget>[
                      // Container(
                      //   decoration: const BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(4)),
                      //     color: AppThemes.chatRoomOnlineGreenColor,
                      //   ),
                      // ).tight(width: 8, height: 8),
                      Image.asset(
                        "assets/svg/green_pot.webp",
                        width: 20,
                        height: 20,
                      ),
                      CustomText(dataItems[index].playerAmount! + S.current.random_text_578,
                          style: const TextStyle(fontSize: AppValues.fontBodySmallSize))
                    ].toRow().tight(height: 30).alignBottom()
                ].toColumn());
          },
          childCount: dataItems.length, // Total number of grid items
        ),
      ),
    );
  }

  // 创建单独游戏列表
  SliverPadding buildCgGridView(List<YuLeChengChangGuanModel> dataItems) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppValues.defaultPadding),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          mainAxisSpacing: 5.0, // Spacing between rows
          crossAxisSpacing: 5.0, // Spacing between columns
          childAspectRatio: 800 / 320, // Width to height ratio of grid items
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  if (dataItems[index].maintained == "2") {
                    CustomSnackBar.show("text", Get.context!, preIcon: null);
                    return;
                  }
                  controller.goToPlatDetail(dataItems[index]);
                },
                child: <Widget>[
                  Stack(
                    children: <Widget>[
                      CustomNetWorkImage(
                        imageUrl: BranchService.instance.current.asset_url +
                            dataItems[index].icon.replaceAll("%lang%", LangUtil().getLangType()),
                        placeholder: CustomNetWorkImage(
                          imageUrl: BranchService.instance.current.asset_url +
                              dataItems[index]
                                  .icon
                                  .replaceAll(".webp", ".s.webp")
                                  .replaceAll("%lang%", LangUtil().getLangType()),
                          errorWidget: const SizedBox(),
                        ),
                      ),
                      if (dataItems[index].maintained == "2")
                        // 半透明蒙版
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppValues.smallPadding),
                            ),
                          ),
                          // 使用Color.fromRGBO来设置半透明颜色
                        ),
                      if (dataItems[index].maintained == "2")
                        // 上层内容
                        <Widget>[
                          // SvgPicture.asset("assets/svg/icon _yulecheng_maintanance.svg").center(),
                          Image.network(BranchService.instance.current.asset_url +
                                  "/images/common/%lang%/maintained.webp"
                                      .replaceAll("%lang%", LangUtil().getLangType()))
                              .center(),
                          // Text(
                          //   S.current.game_category_repair,
                          //   style: ThemeService().theme.textTheme.bodyMedium,
                          // )
                          //     .alignBottom()
                          //     .center()
                          //     .paddingHorizontal(AppValues.halfPadding)
                          //     .paddingTop(AppValues.defaultPadding),
                        ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                    ],
                  ).expanded(),
                ].toColumn());
          },
          childCount: dataItems.length, // Total number of grid items
        ),
      ),
    );
  }

  // 真人娱乐/游戏节目/电子等游戏板块title
  // TODO:待修改
  Widget _buildGamesNavTitle() {
    final navInfo = controller.yulechengModel?.navs?[controller.tabIndex];

    return Container(
      margin: const EdgeInsets.only(left: AppValues.margin_12, top: AppValues.margin_12),
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            child: CustomNetWorkImage(
              width: 20,
              height: 20,
              imageUrl: '${BranchService.instance.current.asset_url}${navInfo?.icon ?? ''}',
              errorWidget: const SizedBox(),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {
              // cid == "5" 为游戏平台
              // if (navInfo.cid == "5") {
              //   RouteUtil.pushToView(Routes.yulechengCategoryPage,
              //       arguments: {"title": navInfo.name, "fromChangguanPage": 3});
              // } else {
              //   controller.goToShowQuanBu(controller.tabIndex);
              // }
            },
            child: CupertinoButton(
              // color: Colors.blue, // 设置按钮颜色
              alignment: Alignment.centerRight,
              pressedOpacity: 0.5, // 设置按钮按下时的不透明度
              child: Text(navInfo?.name ?? '',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              onPressed: () {
                // 按钮点击时的处理逻辑
                if (navInfo?.cid == "5") {
                  RouteUtil.pushToView(Routes.yulechengCategoryPage,
                      arguments: {"title": navInfo?.name, "fromChangguanPage": 3});
                } else {
                  controller.goToShowQuanBu(controller.tabIndex);
                }
              },
            ), /*CustomText(
              navInfo!.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),*/
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  // VIP规则说明
  Widget buildRules() {
    return GetBuilder<FindLogic>(
        id: 'yulecheng_miaoshu_page',
        builder: (context) {
          String title1 = S.current.random_text_1224;
          String title2 = S.current.random_text_1225;
          String title3 = S.current.random_text_1226;
          String title4 = S.current.random_text_279;
          String title5 = S.current.random_text_1227;
          String title6 = S.current.random_text_1228;
          String title7 = S.current.random_text_1229;
          String title8 = S.current.random_text_1230;
          String title9 = S.current.random_text_1231;
          String title10 = S.current.yulecheng_slot;
          String title11 = S.current.random_text_1232;
          String title12 = S.current.random_text_1233;
          String title13 = S.current.random_text_1234;
          String title14 = S.current.random_text_1235;
          String title15 = S.current.random_text_1236;
          String title16 = S.current.random_text_1237;
          String title17 = S.current.random_text_1238;

          String desc1 = S.current.random_text_1239;
          String desc2 = S.current.random_text_1240;
          String desc3 = S.current.random_text_1241;
          String desc4 = S.current.random_text_1242;
          String desc5 = S.current.random_text_1243;
          String desc6 = S.current.random_text_1244;
          String desc7 = S.current.random_text_1245;
          String desc8 = S.current.random_text_1246;
          String desc9 = S.current.random_text_1247;
          String desc10 = S.current.random_text_1248;
          String desc11 = S.current.random_text_1249;
          String desc111 = S.current.random_text_1250;
          String desc12 = S.current.random_text_1251;
          String desc13 = S.current.random_text_1252;
          String desc14 = S.current.random_text_1253;
          String desc15 = S.current.random_text_1254;
          String desc16 = S.current.random_text_1255;
          String desc17 = S.current.random_text_1256;
          String desc18 = S.current.random_text_1257;
          String desc19 = S.current.random_text_1258;
          String desc20 = S.current.random_text_1259;
          String desc21 = S.current.random_text_1260;
          String desc22 = S.current.random_text_1261;
          String desc23 = S.current.random_text_1262;
          String desc24 = S.current.random_text_1263;
          String desc25 = S.current.random_text_1264;
          String desc26 = S.current.random_text_1265;
          String desc27 = S.current.random_text_1266;
          String desc28 = S.current.random_text_1267;
          String desc29 = S.current.random_text_1268;
          String desc30 = S.current.random_text_1269;
          String desc31 = S.current.random_text_1270;
          String desc32 = S.current.random_text_1271;
          String desc33 = S.current.random_text_1272;
          String desc34 = S.current.random_text_1273;
          String desc35 = S.current.random_text_1274;
          String desc36 = S.current.random_text_1275;
          String desc37 = S.current.random_text_1276;
          String desc38 = S.current.random_text_1277;
          String desc39 = S.current.random_text_1278;
          String desc40 = S.current.random_text_1279;
          String desc41 = S.current.random_text_1280;
          String desc42 = S.current.random_text_1281;
          String desc43 = S.current.random_text_1282;

          String htmlData = !controller.miaoshuOpen
              ? "<head><meta charset=\"UTF-8\"></head><div data-v-e3b781e7=\"\" class=\"introduction-content h5-mobile\"><h2 data-v-e3b781e7=\"\">${title1}</h2><div data-v-e3b781e7=\"\" class=\"p\">${desc1}<span data-v-e3b781e7=\"\" class=\"white-txt\">MEIBO</span>${desc2} </div><h2 data-v-e3b781e7=\"\">${title2}</h2>"
              : "<head><meta charset=\"UTF-8\"></head><div data-v-e3b781e7=\"\" class=\"introduction-content h5-mobile\"><h2 data-v-e3b781e7=\"\">${title1}</h2><div data-v-e3b781e7=\"\" class=\"p\">${desc1} <span data-v-e3b781e7=\"\" class=\"white-txt\">MEIBO</span>${desc2}</div><h2 data-v-e3b781e7=\"\">${title2}</h2><div data-v-e3b781e7=\"\" class=\"p\">${desc3}</div><div data-v-e3b781e7=\"\" class=\"p\">${desc4}</div><h2 data-v-e3b781e7=\"\">${title3}</h2><div data-v-e3b781e7=\"\" class=\"p\">${desc5}<h3 data-v-e3b781e7=\"\">${title4}</h3></div><div data-v-e3b781e7=\"\" class=\"p\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">${title4}</span> ${desc6}</div><h3 data-v-e3b781e7=\"\">${title5}</h3><div data-v-e3b781e7=\"\" class=\"p\">${desc7}</div><div data-v-e3b781e7=\"\" class=\"p\">${desc8}</div><h3 data-v-e3b781e7=\"\">${title6}</h3><div data-v-e3b781e7=\"\" class=\"p\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">${title6}</span> ${desc9}</div><div data-v-e3b781e7=\"\" class=\"p\">${desc10}</div><h3 data-v-e3b781e7=\"\">${title7}</h3><div data-v-e3b781e7=\"\" class=\"p\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">${title8}</span> ${desc11}</div><h3 data-v-e3b781e7=\"\">${title9}</h3><div data-v-e3b781e7=\"\" class=\"p\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">${title10}</span> ${desc111}</div><div data-v-e3b781e7=\"\" class=\"p\">${desc12}</div><div data-v-e3b781e7=\"\" class=\"p\">${desc13}</div><h2 data-v-e3b781e7=\"\">${title11}</h2><div data-v-e3b781e7=\"\" class=\"p\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">MEIBO Original</span> ${desc14}</div><ul data-v-e3b781e7=\"\"><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">Plinko</span>${desc15}</li><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">${title12}</span>${desc16}</li><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">Limbo</span>： ${desc17}</li><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">Mines</span>： ${desc18}</li><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">Crash</span>${desc19}</li><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">${title13}</span>${desc20}</li><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">Hilo</span>${desc21}</li><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">${title14}</span>${desc22}</li><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">${title15}</span>${desc23}</li><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">${title16}</span>${desc24}</li><li data-v-e3b781e7=\"\"><span data-v-e3b781e7=\"\" class=\"bold-txt\">Diamonds</span>${desc25}</li></ul><h2 data-v-e3b781e7=\"\">${title17}</h2><div data-v-e3b781e7=\"\" class=\"p\">${desc26}</div><ul data-v-e3b781e7=\"\"><li data-v-e3b781e7=\"\">${desc27}</li><li data-v-e3b781e7=\"\">${desc28}</li><li data-v-e3b781e7=\"\">${desc29}</li><li data-v-e3b781e7=\"\">${desc30}</li></ul><h2 data-v-e3b781e7=\"\">${desc31}</h2><div data-v-e3b781e7=\"\" class=\"p\">${desc32}</div><h2 data-v-e3b781e7=\"\">${desc33}</h2><div data-v-e3b781e7=\"\" class=\"p\">${desc34}</div><h2 data-v-e3b781e7=\"\">${desc35}</h2><div data-v-e3b781e7=\"\" class=\"p\">${desc36}</div><ul data-v-e3b781e7=\"\"><li data-v-e3b781e7=\"\">${desc37}</li><li data-v-e3b781e7=\"\">${desc38}</li><li data-v-e3b781e7=\"\">${desc39} </li><li data-v-e3b781e7=\"\"> ${desc40} </li><li data-v-e3b781e7=\"\"> ${desc41} </li><li data-v-e3b781e7=\"\">${desc42} </li><li data-v-e3b781e7=\"\">${desc43} </li></ul></div>";

          return <Widget>[
            <Widget>[
              // CustomText(S.current.vip_rule_title,
              //     style: ThemeService().theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              // for (int i = 0; i < controller.ruleTitles.length; i++)
              //   _buildRule(i)
              //       .paddingVertical(AppValues.defaultPadding)
              //       .paddingHorizontal(AppValues.defaultPadding)
              Html(
                data: htmlData,
                style: {
                  "h2": Style(
                      color: Colors.white,
                      fontSize: FontSize.xLarge,
                      lineHeight: LineHeight.number(1.5)),
                  "h3": Style(
                      color: Colors.white,
                      fontSize: FontSize.large,
                      lineHeight: LineHeight.number(1.5)),
                  ".p": Style(
                      color: Color(0xffb1bad3),
                      fontSize: FontSize.large,
                      lineHeight: LineHeight.number(1.2)),
                  "li": Style(
                    color: Color(0xffb1bad3),
                    fontSize: FontSize.large,
                    lineHeight: LineHeight.number(1.2),
                    textAlign: TextAlign.left,
                  ),
                  ".white-txt": Style(color: Colors.white, fontSize: FontSize.large),
                },
              ),

              Visibility(
                visible: controller.miaoshuOpen,
                child: Center(
                  child: CustomSmallMainButton(
                    onTap: controller.updateMiaoshu,
                    title: S.current.random_text_1283,
                    fontWeight: FontWeight.w600,
                    backgroundColor: ThemeService().theme.colorScheme.tertiary,
                  ).tight(height: 40).paddingVertical(AppValues.defaultPadding),
                ),
              )
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
            Visibility(
              visible: !controller.miaoshuOpen,
              child: Image.asset(
                "assets/images/yulecheng/icon_cover_home.png",
              ).tight(width: double.infinity),
            ),
            Visibility(
              visible: !controller.miaoshuOpen,
              child: Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                // height: 40,
                child: Container(
                  // color: Colors.black.withOpacity(0.1),
                  child: Center(
                    child: CustomSmallMainButton(
                      onTap: controller.updateMiaoshu,
                      title: S.current.random_text_1284,
                      fontWeight: FontWeight.w600,
                      backgroundColor: ThemeService().theme.colorScheme.tertiary,
                    ).tight(height: 40).paddingVertical(AppValues.defaultPadding),
                  ),
                ),
              ),
            )
          ]
              .toStack()
              .backgroundColor(ThemeService().theme.colorScheme.surface)
              .clipRRect(all: 8.0);
        });
  }
}
