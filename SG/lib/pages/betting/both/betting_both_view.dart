import 'package:flutter/material.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_view.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../routes/routes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/app_bar/custom_app_bar_h5.dart';
import '../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../../../widget/tab_bar/custom_tabbar_covered.dart';
import '../../alliance_plan/widget/custom_select_widget.dart';
import '../../bet_list/widget/bet_list_bar.dart';
import '../../bet_list/widget/sport_my_bet_activity.dart';
import '../../bet_list/widget/sport_my_bet_done.dart';
import '../../find/widget/casino_tabbar.dart';
import '../../front/widget/front_competition_view.dart';
import '../../front/widget/front_sport_competition_view.dart';
import '../casino/betting_casino_mybet_list_view.dart';
import '../common_widget/custom_casino_sport_rank_widget.dart';
import '../common_model/betting_common_params.dart';
import '../sport/bet_mine/betting_sport_mybet_view.dart';
import '../sport/widget/sport_bet_slip_tabbar.dart';
import 'betting_both_logic.dart';

///首页菜单页，[我的投注]，里面包括两种：娱乐城我的投注 和 体育我的投注
class BettingBothPage extends BaseView<BettingBothLogic> {
  BettingBothPage({Key? key}) : super(key: key);

  final logic = Get.find<BettingBothLogic>();
  final selectIndexObs = 0.obs; //体育我的投注， 未结算 和 已结算

  ///打开页面
  static openPage() {
    RouteUtil.pushToView(Routes.browseMenuMyBetting);
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
    // return CustomAppBar(
    //   titleView: const BetListBar(),
    //   actions: [
    //     Obx(() {
    //       return Visibility(
    //         visible: logic.isShowSelectWidget.value,
    //         child: UnconstrainedBox(
    //             child: CustomSelectWidget(
    //           width: LangService().isChinese ? 90 : 100,
    //           height: 36,
    //           backgroundColor: Colors.white,
    //           selectColor: AppThemes.secondaryColor,
    //           unselectColor: ThemeService().colorScheme.tertiary,
    //           initSelected: 0,
    //           panelRatio: LangService().isChinese ? 1.0 : 1.2,
    //           modelList: logic.selectModelList,
    //           onSelected: (index, selectModel) {
    //             selectIndexObs.value = selectModel.type;
    //           },
    //         )),
    //       );
    //     }),
    //     const SizedBox(width: 20),
    //   ],
    //   showLeading: true,
    // );
  }

  @override
  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      // physics: ClampingScrollPhysics(),
      controller: logic.rankListScrollCtrl,
      primary: false,
      slivers: [
        // SliverToBoxAdapter(child: _buildTabBarView()),
        // SliverToBoxAdapter(child: _buildTabBarViewNew()),
        const SliverToBoxAdapter(child: SizedBox(height: AppValues.defaultMargin)),
        SliverToBoxAdapter(
            child: CustomAppBarH5(
          icon: "assets/images/bet_slip/ic_betting_order_title.webp",
          title: S.current.sport_tabbar_mybet,
        )),
        SliverToBoxAdapter(child: _buildTabBarView1()),
        SliverToBoxAdapter(child: _buildTabBarListView()),
        SliverFillRemaining(
          child: CustomCasinoSportRankWidget(
            fromPageType: getFromPageType(),
          ),
        ),
      ],
    );
  }

  ///投注单类型0:娱乐城 1:体育
  BettingFromPageType? getFromPageType() {
    var tabIndex = GlobalStateController.of().menuSelectType.value;
    if (tabIndex == 0) {
      return BettingFromPageType.browseMenuBettingCasinoType;
    } else if (tabIndex == 1) {
      return BettingFromPageType.browseMenuBettingSportType;
    } else {
      return null;
    }
  }

  ///tab 行
  _buildTabBarViewNew() {
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
        // width: double.infinity,
        child: CustomTabBarWithIcon(
          // isLogin: true,
          tabController: controller.myBetTabController,
          // controller: controller.tabController,
          // 将TabController与TabBar关联
          tabs: controller.myBetTabs,
          backgroundColor: ThemeService().theme.colorScheme.tertiary,
          radius: 44,
          height: 54,
          buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
          // contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          // sideMargin: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildTabBarView1() {
    return Container(
      margin: EdgeInsets.only(top: 12, right: 12),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SportBetSlipTabbar(
            tabController: controller.myBetTabController,
            tabs: controller.myBetTabs,
          ),
          Spacer(),
          Obx(() {
            return Visibility(
              visible: logic.isShowSelectWidget.value,
              child: UnconstrainedBox(
                  child: CustomSelectWidget(
                width: LangService().isChinese ? 90 : 100,
                height: 36,
                borderShow: false,
                backgroundColor: Colors.white,
                selectColor: AppThemes.secondaryColor,
                unselectColor: ThemeService().colorScheme.tertiary,
                initSelected: 0,
                panelRatio: LangService().isChinese ? 1.0 : 1.2,
                modelList: logic.selectModelList,
                onSelected: (index, selectModel) {
                  selectIndexObs.value = selectModel.type;
                },
              )),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTabBarListView() {
    return Container(
      height: 540 + 54 + 40,
      // padding: EdgeInsets.only(bottom: AppValues.barBottomHeight),
      child: TabBarView(
        controller: controller.myBetTabController,
        physics: const NeverScrollableScrollPhysics(),
        // viewportFraction:0.5,
        children: [
          // Text('dksljds'),
          // SportMyBetActivity(),
          BettingCasinoMyBetListView(
            chooseType: BettingTypeEnum.myBet,
            fromPage: BettingFromPageType.sideMenuBettingCasinoType,
            isNeverScrollable: true,
          ),
          BettingSportMyBetView(
            fromPage: BettingFromPageType.sideMenuBettingSportType,
            isShowTab: false,
            tabIndex: selectIndexObs.value,
            padding: EdgeInsets.only(bottom: AppValues.barBottomHeight),
          ),
          // Container(),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Container(
      //54*10(每页最大条数)+54(标题)
      height: 540 + 54 + 20,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.centerLeft,
            child: SportBetSlipTabbar(
              tabController: controller.myBetTabController,
              tabs: controller.myBetTabs,
            ),
          ),
          _buildLine(),
          Expanded(
            child: TabBarView(
              controller: controller.myBetTabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Text('dksljds'),
                // SportMyBetActivity(),
                Container(
                  child: BettingCasinoMyBetListView(
                    chooseType: BettingTypeEnum.myBet,
                    fromPage: BettingFromPageType.sideMenuBettingCasinoType,
                    isNeverScrollable: false,
                  ),
                ),
                BettingSportMyBetView(
                  fromPage: BettingFromPageType.sideMenuBettingSportType,
                  // isShowTab: false,
                  isShowTab: false,
                  tabIndex: selectIndexObs.value,
                ),
                // Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: double.infinity,
      height: 2,
      color: ThemeService().theme.colorScheme.tertiary,
    );
  }
}

class PersistentHeaderBuilder extends SliverPersistentHeaderDelegate {
  final double max;
  final double min;
  final Widget Function(BuildContext context, double offset) builder;

  PersistentHeaderBuilder({this.max = 120, this.min = 80, required this.builder})
      : assert(max >= min && builder != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset);
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant PersistentHeaderBuilder oldDelegate) =>
      max != oldDelegate.max || min != oldDelegate.min || builder != oldDelegate.builder;
}
