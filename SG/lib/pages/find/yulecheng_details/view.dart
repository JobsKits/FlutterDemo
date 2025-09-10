import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/pages/account/register/register_widget.dart';
import 'package:flutter_bet/pages/account/register/view.dart';
import 'package:flutter_bet/pages/find/logic.dart';
import 'package:flutter_bet/pages/find/widget/casino_changguan_flip_list.dart';
import 'package:flutter_bet/pages/find/widget/casino_tabbar.dart';
import 'package:flutter_bet/pages/find/yulecheng_details/widgets/big_lucky_wins.dart';
import 'package:flutter_bet/pages/front/widget/front_casino_competition_view.dart';
import 'package:flutter_bet/pages/front/widget/front_competition_view.dart';
import 'package:flutter_bet/pages/front/widget/front_sport_competition_view.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/custom_top_appbar_logo_title_view.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../widget/casino_page_flip_list.dart';
import 'index.dart';
import 'widgets/tab_info.dart';

final GlobalKey globalKey = GlobalKey();

class YulechenggamedetailsPage extends BaseView<YulechenggamedetailsController> {
  //  YulechenggamedetailsPage({Key? key}) : super(key: key);

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<ScalingTextState> _scalingKey = GlobalKey<ScalingTextState>();

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
        // titleView: Obx(() => Text(controller.currentPageTitle.value,
        //     style: ThemeService()
        //         .theme
        //         .appBarTheme
        //         .titleTextStyle
        //         ?.copyWith(fontWeight: FontWeight.w600))),
        titleSpacing: 12.0,
        showLeading: false,
        onBackTap: () {
          RouteUtil.popToFirst(Routes.mainPage);
          return;
        },
        titleView: CustomTopAppBarLogoTitleView(
          title: controller.currentPageTitle.value,
          logoTap: () {
            RouteUtil.popToFirst(Routes.mainPage);
            return;
          },
        ));
  }

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  void _startScaleAnimation(GlobalKey<ScalingTextState> key) {
    key.currentState?.startAnimation();
  }

  @override
  Widget buildBody(BuildContext context) {
    controller.context = context;
    return GetBuilder<YulechenggamedetailsController>(
        id: "yulechenggamedetails",
        builder: (context1) {
          return controller.isInitialized == false
              ? buildLoding()
              : SingleChildScrollView(
                  controller: controller.scrollController,
                  child: <Widget>[
                    const SizedBox(height: AppValues.defaultMargin),
                    buildTopView(context),
                    const SizedBox(height: AppValues.defaultMargin),
                    buildMiddleWidget(),
                    if (controller.hotDataArray.length > 0) buildBottomHotGame(),
                    buildProviders(),
                    // buildBottomRankListTab(),
                    SizedBox(
                      height: AppValues.barBottomHeight,
                    ),
                  ].toColumn(),
                );
        });
  }

  // 加载中
  Widget buildLoding() {
    return Container(
      alignment: Alignment.topCenter,
      height: 150,
      child: CustomNetWorkImagePlaceholder(
        color: AppThemes.surfaceVariant.withOpacity(0),
        placeholderType: NetWorkImagePlaceholderType.loading,
      ).center(),
    );
  }

  // 创建顶部
  Widget buildTopView(context) {
    return <Widget>[
      const SizedBox(height: AppValues.defaultPadding),
      <Widget>[
        // 左侧游戏Icon
        CustomNetWorkImage(
          imageUrl: BranchService.instance.current.asset_url + controller.items.gameImgUrl,
          width: 136,
          height: 170,
          fit: BoxFit.cover,
          placeholder: CustomNetWorkImage(
              imageUrl: BranchService.instance.current.asset_url +
                  controller.items.gameImgUrl.replaceAll(".webp", ".s.webp")),
        ).borderRadius(all: 8.0),
        const SizedBox(width: AppValues.defaultPadding),
        // 左侧游戏名称内容
        <Widget>[
          CustomText(
            controller.items.name,
            maxLines: 2,
            style:
                ThemeService().theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppValues.smallPadding),
          GestureDetector(
            onTap: () {
              RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
                "title": controller.items.platformName,
                "platformId": controller.items.platformId,
                "fromChangguanPage": 41
              });
            },
            child: CustomText(
              controller.items.platformName ?? "",
              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                  color: CustomTextColorStyle.secondary.value, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: AppValues.defaultPadding),
          if (controller.globalController.isLogin.value == true)
            <Widget>[
              Obx(() => CustomIcon(
                      asset:
                          'assets/images/game/ic_game_collect${controller.isCollect.value ? '_pre.webp' : '.webp'}',
                      size: AppValues.iconDefaultSize)
                  .onTap(controller.onCollectTap)),
              const SizedBox(width: AppValues.defaultPadding),
              // const CustomIcon(
              //         asset: 'assets/images/game/ic_game_statistics.webp',
              //         size: AppValues.iconDefaultSize)
              //     .onTap(() {}),
            ].toRow()
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).expanded(),
      ].toRow(),

      const SizedBox(height: AppValues.largePadding),

      // 余额栏目
      CustomText(
        S.current.yulecheng_selectShowBalance,
        style: ThemeService().theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: AppValues.smallPadding),
      _currencyWidget(),
      const SizedBox(height: AppValues.largePadding),

      // 开始 / 试玩游戏
      <Widget>[
        CustomIconButton(
          backgroundColor: ThemeService().theme.colorScheme.primaryContainer,
          iconWidget: SvgPicture.asset("assets/svg/yulecheng_play_arrow.svg"),
          iconHeight: AppValues.iconDefaultSize,
          iconWidth: AppValues.iconDefaultSize,
          direction: Direction.left,
          widgetHeight: AppValues.defaultButtonHeight,
          name: controller.globalController.isLogin.value == false
              ? S.current.top_register
              : S.current.start_game_text,
          style: ThemeService().theme.textTheme.bodyMedium!.copyWith(
              color: ThemeService().colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600),
          onTap: () {
            if (controller.globalController.isLogin.value == false) {
              // showCustomLoginWidget(context: context);
              // RouteUtil.pushToView(Routes.registerPage);
              showCustomRegisterWidget(context: context);
              return;
            }
            controller.onplayGame();
          },
        ).clipRRect(all: AppValues.smallRadius).expanded(),
        const SizedBox(width: 15),
        CustomIconButton(
          backgroundColor: ThemeService().colorScheme.tertiary,
          /*globalController.isLogin.value == true
              ? ThemeService().colorScheme.tertiary
              : 
              Color(0xff2f4553),*/
          name: S.current.yulecheng_trygame,
          style: ThemeService()
              .textTheme
              .bodyMedium!
              .copyWith(color: Color(0xff636E7F), fontWeight: FontWeight.w600),
          iconWidget: SvgPicture.asset(
            "assets/svg/yulecheng_shiwan_arrow.svg",
            color: Color(0xff636E7F),
          ),
          iconHeight: AppValues.iconDefaultSize,
          iconWidth: AppValues.iconDefaultSize,
          direction: Direction.left,
          widgetHeight: AppValues.defaultButtonHeight - 2,
          onTap: () {
            // if (globalController.isLogin.value == true) {
            //   controller.onplayGame();
            // } else {
            // showCustomRegisterWidget(context: context);
            // return;
            // }
          },
        ).clipRRect(all: AppValues.smallRadius).expanded(),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceEvenly),
      const SizedBox(height: 18.0),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingHorizontal(AppValues.defaultMargin)
        .backgroundColor(ThemeService().theme.colorScheme.surface)
        .borderRadius(all: AppValues.smallRadius);
  }

  //货币
  Widget _currencyWidget() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(S.current.game_detail_yue,
              style:
                  ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
              textColorStyle: CustomTextColorStyle.secondary),
          GestureDetector(
            onTap: () {
              _startAnimation(_rotatingArrowKey);
              _startScaleAnimation(_scalingKey);
              DialogUtils.showCustomBubbleDialog(
                Get.context!,
                _viewBubbleChild(),
                78,
                height: 230,
                widgetKey: globalKey,
                globalKey: _rotatingArrowKey,
                globalKeyScaling: _scalingKey,
                backgroundColor: ThemeService().colorScheme.tertiary,
              );
            },
            child: Container(
              key: globalKey,
              decoration: BoxDecoration(
                  color: ThemeService().colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2), bottomLeft: Radius.circular(2))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: AppValues.halfMargin,
                  ),
                  CustomNetWorkImage(
                    imageUrl: controller.getCoinUrlWithCoinName(controller.currency),
                    width: AppValues.iconSmallSize,
                    height: AppValues.iconSmallSize,
                  ),
                  const SizedBox(
                    width: AppValues.halfMargin,
                  ),
                  // CustomText(controller.currency,
                  //     style: ThemeService()
                  //         .theme
                  //         .textTheme
                  //         .bodyMedium
                  //         ?.copyWith(fontWeight: FontWeight.w400)),
                  ScalingText(
                    key: _scalingKey,
                    text: controller.currency,
                    textStyle: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    width: AppValues.margin_2,
                  ),
                  RotatingArrow(
                    key: _rotatingArrowKey,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 弹窗出来的币种选择
  _viewBubbleChild() {
    final coinList =
        controller.items.currencys!; //controller.getCurrencyList(controller.items.currency);
    return ListView(
      padding: EdgeInsets.zero,
      children: List.generate(coinList.length, (index) {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Get.back();
                controller.onCurrentChanged(
                    coinList[index]); // controller.state.chooseType.value= betSlipTypeList[index];
              },
              child: Row(
                children: [
                  const SizedBox(
                    width: AppValues.halfMargin,
                  ),
                  CustomNetWorkImage(
                    imageUrl: controller.getCoinUrlWithCoinName(coinList[index]),
                    width: AppValues.iconSmallSize,
                    height: AppValues.iconSmallSize,
                  ),
                  const SizedBox(
                    width: AppValues.halfMargin,
                  ),
                  CustomText(coinList[index],
                      style: ThemeService()
                          .theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      }),
    );
  }

  //创建游戏挑战描述内容
  Widget buildMiddleWidget() {
    final isShowGameInfo = controller.isShowDescription;

    return <Widget>[
      <Widget>[
        CustomText(
          controller.items.name,
          maxLines: 2,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: AppValues.smallPadding),
        GestureDetector(
          onTap: () {
            RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
              "title": controller.items.platformName,
              "platformId": controller.items.platformId,
              "fromChangguanPage": 41
            });
          },
          child: CustomText(
            controller.items.platformName ?? "",
            style: ThemeService()
                .theme
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppThemes.onTertiaryColor, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox().expanded(),
        Transform.rotate(
          angle: isShowGameInfo ? 0 : pi / 2,
          child: const CustomAssetIcon(name: "assets/images/top_drop_down arrow.png")
              .tightSize(AppValues.iconSize_28),
        ).marginOnly(left: AppValues.defaultMargin).onTap(controller.openValueDidChange),
      ].toRow(),
      const SizedBox(height: AppValues.defaultPadding).visibility(isShowGameInfo),
      buildTabController().visibility(isShowGameInfo),
      const SizedBox(height: AppValues.defaultPadding).visibility(isShowGameInfo),
      BigLuckyWins(bigWinsInfos: controller.bigWinsInfos[controller.bigWinsSelIndex])
          .visibility(isShowGameInfo),
    ]
        .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .padding(all: AppValues.defaultMargin)
        .backgroundColor(ThemeService().theme.colorScheme.surface)
        .borderRadius(all: AppValues.smallRadius);
  }

  Widget buildTabController() {
    final titleStyle =
        ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

    final titles = [S.current.random_text_273, S.current.random_text_274];
    return <Widget>[
      for (int index = 0; index < titles.length; index++)
        CustomText(titles[index], style: titleStyle)
            .paddingSymmetric(horizontal: AppValues.largePadding, vertical: AppValues.halfPadding)
            .center()
            .backgroundColor(index == controller.bigWinsSelIndex
                ? ThemeService().theme.colorScheme.tertiary
                : Colors.transparent)
            .clipRRect(all: 40)
            .scale(all: controller.bigWinsSelIndex == index ? controller.scale : 1.0)
            .onTap(() {
          if (index != controller.bigWinsSelIndex) {
            controller.bigWinsSelIndex = index;
            controller.reqBigWins(index);
            controller.scale = 0.96;
            controller.update(['yulechenggamedetails']);
            Future.delayed(const Duration(milliseconds: 60), () {
              controller.scale = 1;
              controller.update(['yulechenggamedetails']);
            });
          }
        })
    ]
        .toRow(mainAxisSize: MainAxisSize.min)
        .marginAll(AppValues.extraSmallMargin)
        .backgroundColor(const Color(0xff1A2C38))
        .height(54)
        .clipRRect(all: 40);

    // final tabsNoIcons = [
    //   Tab(text: S.current.random_text_273),
    //   Tab(
    //     text: S.current.random_text_274,
    //   )
    // ];
    // return CustomTabBarWithIcon(
    //   tabController: controller.bigWinsTabC,
    //   tabs: tabsNoIcons,
    //   contentColor: const Color(0xff1A2C38),
    //   unselectedBackgroundColor: Colors.transparent,
    //   backgroundColor: ThemeService().theme.colorScheme.tertiary,
    //   labelStyle: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
    //   unselectedLabelStyle:
    //       ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
    //   height: 50,
    //   radius: 21,
    // ).paddingHorizontal(AppValues.smallPadding).paddingVertical(AppValues.smallPadding);
  }

  //创建底部热门推荐
  Widget buildBottomHotGame() {
    return CasinoPageFlipList(
      currentIndex: -1,
      onTitleTap: controller.gotoShowFullList,
      onTap: controller.updateCurretGame,
      itemsList: [controller.hotDataArray],
      title: S.current.yulecheng_hot_recoment,
      icon: 'assets/images/yulecheng/ic_hot.webp',
      needshowChaKanGengDuo: true,
      needShowPlayer: true,
      showStatus: [],
      showType: 0,
    );
  }

  // 游戏服务商
  Widget buildProviders() {
    return controller.changguanDataArray.length > 0
        ? CasinoChangguanFlipList(
            onTap: controller.goToPlatDetail,
            items: controller.changguanDataArray,
            title: S.current.game_supplier,
            icon: 'assets/images/home/ic_game_provider.webp',
          ).paddingBottom(AppValues.defaultPadding * 2)
        : SizedBox();
  }

  //创建底部切换排行榜
  Widget buildBottomRankListTab() {
    return <Widget>[
      CasinoTabBar(
        tabs: controller.bottomTabs,
        tabController: controller.bottomTabController,
      ).paddingTop(AppValues.defaultPadding * 2),
      CustomAutoLayoutTabBarView(controller: controller.bottomTabController, children: [
        FrontSportCompetitionView(
          listData: controller.betSportList,
        ),
        FrontSportCompetitionView(
          listData: controller.betSportList,
        ),
        FrontCompetitionView(
          listData: controller.competitonList,
        ),
      ]).paddingTop(AppValues.defaultPadding)
    ].toColumn();
    // return ;
  }
}
