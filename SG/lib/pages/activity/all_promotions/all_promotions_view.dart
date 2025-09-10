import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_view.dart';
import '../../../routes/routes.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/scroller/custom_nested_scroll_tab_view.dart';
import '../../../widget/status/custom_load_state_view.dart';
import '../../../widget/tab_bar/custom_expand_tab_bar_with_icon.dart';
import '../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../../../widget/tab_bar/custom_tabbar_covered.dart';
import '../a_model/activity_common_params.dart';
import '../activity_promotion/activity_promotion_view.dart';
import '../single_promontions/single_promotions_logic.dart';
import '../single_promontions/single_promotions_view.dart';
import 'all_promotions_logic.dart';
import '../a_widget/all_single_promotions_view_item.dart';

///促销活动 查看全部
class AllPromotionsPage extends BaseView<AllPromotionsLogic> {
  AllPromotionsPage({Key? key}) : super(key: key);

  //git测试

  // final logic = Get.put(HomeAllPromotionsLogic());

  ///打开页面
  static openPage(
      {bool refresh = false, ActivityListTypeEnum refreshPage = ActivityListTypeEnum.casino}) {
    SinglePromotionsLogic? pageLogic = SinglePromotionsLogic.of(refreshPage);
    RouteUtil.pushToView(Routes.homeAllPromotions, onBack: (value) {
      log("接收上个页面参数：$value");
    });
    if (refresh && pageLogic != null) {
      pageLogic.doRefreshPage(true);
    }
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
        isShowLogo: true,
      ),
      showLeading: false,
    );
    // return CustomAppBar(appBarTitleText: S.current.random_text_883, showLeading: true);
  }

  @override
  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        // _buildTopView(),
        // _buildTabBarView(),
        SliverToBoxAdapter(child: _buildTopView()),
        SliverToBoxAdapter(child: _buildTabBarView()),
        SliverToBoxAdapter(child: Container(
          margin: EdgeInsets.only(bottom: AppValues.barBottomHeight),
          child: Obx(() {
            return logic.getTabBarView(logic.tabIndexObs.value);
          }),
        ))
      ],
    );
    return CustomNestedScrollTabView(
      headerViews: [
        _buildTopView(),
        _buildTabBarView(),
      ],
      tabPhysics: const NeverScrollableScrollPhysics(),
      tabChildViews: [
        SinglePromotionsPage(typeEnum: ActivityListTypeEnum.casino),
        SinglePromotionsPage(typeEnum: ActivityListTypeEnum.sport),
      ],
      tabController: controller.tabController,
    );
    return Scaffold(
      body: NestedScrollView(
        // controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(child: _buildTopView()),
            SliverToBoxAdapter(child: _buildTabBarView()),
          ];
        },
        body: Container(
          padding: EdgeInsets.only(bottom: AppValues.barBottomHeight),
          child: TabBarView(
            controller: controller.tabController,
            children: [
              SinglePromotionsPage(typeEnum: ActivityListTypeEnum.casino),
              SinglePromotionsPage(typeEnum: ActivityListTypeEnum.sport),
            ],
          ),
        ),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: Get.statusBarHeight - AppValues.defaultMargin),
        // SizedBox(height: AppValues.barTopHeightMargin),
        _buildTopView(),
        _buildTabBarView(),
        _buildTabBarListView(),
        // _buildCasinoView(),
        // _buildSportView(),
        // _buildListTitleView(),
        SizedBox(height: AppValues.barBottomHeight),
      ],
    );
    return CustomRefreshView(
      controller: logic.refreshController,
      // clipBehavior: Clip.none,
      refreshOnStart: false,
      isCanLoadMore: false,
      onRefreshAction: (refreshController) {
        logic.loadNetData(isRefresh: true, isShowLoad: false);
      },
      onLoadMoreAction: (refreshController) {
        logic.loadNetData(isRefresh: false, isShowLoad: false);
      },
      childHeader: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopView(),
          _buildCasinoView(),
          _buildSportView(),
          _buildListTitleView(),
        ],
      ),
      child: _buildListView(),
    );
  }

  _buildTopView() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/home/promotions/ic_all_promotions_bg.webp"),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: CustomText(
        S.current.promotions,
        style:
            ThemeService().textTheme.bodyLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  ///tab 行
  _buildTabBarView() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppValues.defaultPadding,
        vertical: AppValues.margin_12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(49),
        color: ThemeService().theme.colorScheme.surface, // 设置背景色
      ),
      //CustomTabBarCoveredIcon
      //CustomTabBarWithIcon
      //CustomExpandTabBarWithIcon
      child: Container(
        width: double.infinity,
        child: CustomTabBarCoveredIcon(
          // isLogin: true,
          tabController: controller.tabController,
          // controller: controller.tabController,
          // 将TabController与TabBar关联
          tabs: controller.tabList,
          backgroundColor: ThemeService().theme.colorScheme.tertiary,
          radius: 44,
          height: 54,
          buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          sideMargin: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  ///tab列表详情区域
  _buildTabBarListView() {
    return Expanded(
      child: Container(
        // color: ThemeService().colorScheme.surface, // 设置背景色
        // padding: EdgeInsets.zero,
        // margin: EdgeInsets.all(AppValues.margin_12),
        child: LayoutBuilder(builder: (context, constraints) {
          // log("TabBarView...constraints...$constraints");
          return CustomAutoLayoutTabBarView(
            physics: const NeverScrollableScrollPhysics(), //禁止滑动
            controller: controller.tabController, // 将TabController与TabBarView关联
            children: [
              ConstrainedBox(
                  constraints: constraints,
                  child: SinglePromotionsPage(typeEnum: ActivityListTypeEnum.casino)), //推广教程
              ConstrainedBox(
                  constraints: constraints,
                  child: SinglePromotionsPage(typeEnum: ActivityListTypeEnum.sport)), //我的推广
            ],
          );
        }),
      ),
    );
  }

  _buildCasinoView() {
    return CustomButton(
      padding: EdgeInsets.zero,
      onTap: () {
        log("AllPromotionsPage...娱乐城...点击了...");
        SinglePromotionsPage.openPageCasino();
      },
      child: Container(
        margin: EdgeInsets.only(left: 12, right: 12, top: 20),
        height: 96,
        decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.surfaceVariant, // 设置背景色
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            const CustomAssetIcon(
                name: "assets/images/home/promotions/ic_all_promotions_casino.webp", size: 96),
            SizedBox(width: AppValues.defaultMargin),
            CustomText(
              S.current.tab_bar_ent,
              style: ThemeService()
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            const CustomAssetIcon(
                name: "assets/images/common/ic_common_arrow_right.webp", size: 10),
            SizedBox(width: AppValues.margin_40),
          ],
        ),
      ),
    );
  }

  _buildSportView() {
    return CustomButton(
      padding: EdgeInsets.zero,
      onTap: () {
        log("AllPromotionsPage...体育博彩...点击了...");
        SinglePromotionsPage.openPageSport();
      },
      child: Container(
        margin: EdgeInsets.only(left: 12, right: 12, top: 20),
        height: 96,
        decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.surfaceVariant, // 设置背景色
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            const CustomAssetIcon(
                name: "assets/images/home/promotions/ic_all_promotions_sport.webp", size: 96),
            SizedBox(width: AppValues.defaultMargin),
            CustomText(
              S.current.random_text_826,
              style: ThemeService()
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            const CustomAssetIcon(
                name: "assets/images/common/ic_common_arrow_right.webp", size: 10),
            SizedBox(width: AppValues.margin_40),
          ],
        ),
      ),
    );
  }

  _buildListTitleView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: CustomText(
        S.current.random_text_827,
        style:
            ThemeService().textTheme.bodyLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  _buildListView() {
    return Container(
      child: Obx(() {
        return CustomLoadStateLayout(
          configState: logic.pageStateObs.value,
          configRetry: (pageState) =>
              logic.loadNetData(isRefresh: true, isShowLoad: true, isFirst: true),
          configSuccess: ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              // physics: const BouncingScrollPhysics(),
              physics: const NeverScrollableScrollPhysics(),
              // controller: ScrollController(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: logic.apiModelList.length,
              itemBuilder: (context, index) {
                var activityTypeEnum = ActivityTypeEnum.adaptor(logic.apiModelList[index].ty);
                return AllSinglePromotionsItemView(
                  index: index,
                  model: logic.apiModelList[index],
                  activityTypeEnum: activityTypeEnum,
                  onItemClick: (model) {
                    logic.onClickActivityItemMixin(model);
                  },
                );
              }),
        );
      }),
    );
  }
}
