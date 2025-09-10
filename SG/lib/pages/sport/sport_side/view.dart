import 'package:flutter/material.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/pages/find/widget/casino_tabbar.dart';
import 'package:flutter_bet/pages/front/widget/front_casino_competition_view.dart';
import 'package:flutter_bet/pages/sport/model.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_app_life_cycle_listen_widget.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/front/widget/front_competition_view.dart';
import 'package:flutter_bet/pages/front/widget/front_sport_competition_view.dart';
import 'package:flutter_bet/pages/sport/sport_bet/view.dart';
import 'package:flutter_bet/pages/sport/sport_detail/model.dart';
import 'package:flutter_bet/pages/sport/sport_hall/sport_hall_section.dart';
import 'package:flutter_bet/pages/sport/tabmodel.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:flutter_bet/widget/sport/custom_sport_banner.dart';
import 'package:flutter_bet/widget/sport/custom_sport_odd_type.dart';
import 'package:flutter_bet/widget/sport/custom_sport_tabbar.dart';
import '../sport_event/bottom_rank/index.dart';
import 'logic.dart';

class SportSidePage extends BaseView<SportSideLogic> {
  final logic = Get.find<SportSideLogic>();
  final state = Get.find<SportSideLogic>().state;
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  SportSidePage({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
        isShowLogo: false,
        onTap: () => globalController.onArticleCollect(),
      ),
      showLeading: true,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return CustomAppLifeCycleListenWidget(
      /// Switch to entertainment betting when switching to the bet slip page
      didChangeDependencies: () {
        globalController.betSlipType.value = 1;
        globalController.menuSelectType.value = 1;
        globalController.showMenuImage.value = false;
      },
      child: ListView(children: [
        // CustomSportBanner(),
        // Obx(() => CustomSportTabbar(
        //     [
        //       {
        //         "icon": 'assets/images/sport/sport_hall.webp',
        //         "name": S.current.sport_tabbar_hall,
        //         // "tgn": S.current.sport_tabbar_hall,
        //         // "tgi": 0,
        //       },
        //       {
        //         "icon": 'assets/images/sport/sport_bet.webp',
        //         "name": S.current.sport_tabbar_mybet,
        //         // "tgn": S.current.sport_tabbar_mybet,
        //         // "tgi": 0,
        //       },
        //       {
        //         "icon": 'assets/images/sport/sport_collection.webp',
        //         "name": S.current.sport_tabbar_favorites,
        //         // "tgn": S.current.sport_tabbar_favorites,
        //         // "tgi": 0,
        //       },
        //       {
        //         "icon": 'assets/images/sport/sport_rolling.webp',
        //         "name": S.current.sport_tabbar_rolling,
        //         // "tgn": S.current.sport_tabbar_rolling,
        //         // "tgi": 0,
        //       },
        //       {
        //         "icon": 'assets/images/sport/sport_coming.webp',
        //         "name": S.current.sport_tabbar_coming,
        //         // "tgn": S.current.sport_tabbar_coming,
        //         // "tgi": 0,
        //       }
        //     ].map((e) => SportTabModel.fromJson(e)).toList(),
        //         (index) => logic.changeCategoryIndex(index),
        //     state.cagetoryTabbarInitIndex.value)),
        // _buildTopTitle(),
        // Obx(() => _page(state.sportCategotyType.value)),
        if (state.tabs.value.isNotEmpty)
          state.m == 3
              ? buildSection(
                  state.hall_hall_index.value,
                  S.current.sport_tabbar_rolling,
                  state.tabs.value ?? [],
                  state.rollingMatchList.value,
                  (value) => {
                    state.isShimmerView.value = true,
                    logic.refreshRolling(value, S.current.sport_tabbar_rolling)
                  },
                  state.rollingShowMore,
                  state.sit,
                  state.isShimmerView.value,
                )
              : buildSection(
                  state.comming_index.value,
                  S.current.sport_tabbar_coming,
                  (state.commingTabs.value ?? []),
                  state.comingMatchList.value,
                  (value) => {
                    state.isShimmerView.value = true,
                    logic.refreshRolling(value, S.current.sport_tabbar_coming)
                  },
                  state.commingShowMore,
                  state.commingSit,state.isShimmerView.value,
                ),
        // buildBottomRankListTab(),
        state.tabs.isNotEmpty ? const BottomRankPage() : Container(),
      ]),
    );
  }

  SportHallSection buildSection(
    int filterIndex,
    String title,
    List<SportHallCountModel>? tabs,
    List<SportMatchModel> competitionList,
    ValueChanged<int> onTapGame,
    bool m,
    int cindex,
      bool isShimmerView,
  ) {
    return SportHallSection(
      index: filterIndex,
      title: title,
      tabs: tabs,
      competitionList: competitionList,
      onTapGame: (w) => onTapGame(w),
      m: m,
      cIndex: cindex,
      isShimmerView:isShimmerView,
      isSide: true,
      sportBetClick: (type, section, row, colum, int si, String eid) {
        switch (type) {
          case SportClikType.detail:
            // RouteUtil.pushToView(Routes.sport_sport_detail);
            RouteUtil.pushToView(Routes.sport_detail, arguments: {'si': si, 'eid': eid});
            break;
          case SportClikType.odd:
            if (title == S.current.sport_tabbar_rolling || title == S.current.sport_bet_hot) {
              state.rollingMatchList.refresh();
            } else if (title == S.current.sport_fav_hot_rolling) {
              state.favHotList.refresh();
            } else if (title == S.current.sport_fav_comming_rolling) {
              state.favCommingList.refresh();
            } else {
              state.comingMatchList.refresh();
            }
            break;
          case SportClikType.filter:
            // 1:让分盘
            // 2:总分盘
            // 3:获胜盘 (胜平负)
            // 4:获胜盘 (胜负)

            // 43 1 2 的逻辑
            if (title == S.current.sport_tabbar_rolling) {
              state.hall_hall_index.value = section ?? 0;
              state.rolling_index.value = section ?? 0;
            } else if (title == S.current.sport_bet_hot) {
              state.hall_hot_index.value = section ?? 0;
            } else if (title == S.current.sport_fav_hot_rolling) {
              state.fav_hot_index.value = section ?? 0;
            } else if (title == S.current.sport_fav_comming_rolling) {
              state.fav_comming_index.value = section ?? 0;
            } else if (title == S.current.sport_tabbar_coming) {
              state.comming_index.value = section ?? 0;
            } else {
              state.rolling_index.value = section ?? 0;
            }
            break;
          case SportClikType.fav:
            logic.getSportAddFav(si, [eid], '701', title);
            break;
          case SportClikType.more:
            logic.more(title);
            break;
          default:
            break;
        }
        // print('=====$type=====$section=====$row=====$colum');
      }, isOpen: false,
    );
  }

  //创建底部切换排行榜
  Widget buildBottomRankListTab() {
    return <Widget>[
      CasinoTabBar(
        tabs: state.bottomTabs,
        tabController: state.bottomTabController,
      ).paddingTop(AppValues.defaultPadding * 2),
      CustomAutoLayoutTabBarView(controller: state.bottomTabController, children: [
        FrontSportCompetitionView(
          listData: state.betSportList,
        ),
        FrontSportCompetitionView(
          listData: state.betSportList,
        ),
        FrontCompetitionView(
          listData: state.competitonList,
        ),
      ]).paddingTop(AppValues.defaultPadding)
    ].toColumn();
    // return ;
  }

  _buildTopTitle() {
    return LayoutBuilder(builder: (context, constraints) {
      // log("体育标题...constraints...$constraints");
      return ConstrainedBox(
        constraints: BoxConstraints.loose(Size.fromWidth(constraints.maxWidth)),
        child: Container(
          // width: constraints.maxWidth,
          padding: EdgeInsets.only(
            top: AppValues.sportHeight_20.h,
            left: AppValues.sportPadding_12.w,
            right: AppValues.sportPadding_12.w,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // CustomIconButton(
              //   borderRadius: AppValues.sportRadius_4,
              //   backgroundColor: ThemeService().colorScheme.surface,
              //   onTap: () {
              //     RouteUtil.popView();
              //   },
              //   widgetWidth: AppValues.sportWidth_54.w,
              //   widgetHeight: AppValues.sportHeight_44.h,
              //   iconWidget: SvgPicture.asset(
              //     'assets/svg/ic_normal_back.svg',
              //     width: 18,
              //     height: 18,
              //     color: ThemeService().colorScheme.inverseSurface,
              //   ),
              //   // iconThemeData: themeData,
              // ),
              // SizedBox(
              //   width: AppValues.sportPadding_12,
              // ),
              Expanded(
                child: Container(
                  // width: constraints.maxWidth,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                      left: AppValues.sportPadding_28, right: AppValues.sportPadding_28),
                  constraints: BoxConstraints(
                    minHeight: AppValues.sportHeight_44.h,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeService().colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(AppValues.sportRadius_4)),
                  ),
                  // backgroundColor: ThemeService().colorScheme.surface,
                  // borderRadius: const BorderRadius.all(Radius.circular(AppValues.sportRadius_4)),
                  child: CustomText(
                    state.m == 3 ? S.current.sport_tabbar_rolling : S.current.sport_tabbar_coming,
                    // "logic.sportTitle.valuelogic.sportTitle.value12312312312",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: ThemeService().textTheme.bodyMedium!.copyWith(
                        color: ThemeService().colorScheme.inverseSurface,
                        fontSize: AppValues.fontBodyMediumSize,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              // ConstrainedBox(
              //   constraints: BoxConstraints.loose(Size.fromWidth(200)),
              //   child: SizedBox(width:100),
              // ),
              // Spacer(),
              // SizedBox(width: 1),
              ///收藏星星✨
              // CustomIconButton(
              //   onTap: () {},
              //   widgetWidth: AppValues.sportWidth_54.w,
              //   widgetHeight: AppValues.sportHeight_44.h,
              //   iconWidget: Image.asset(
              //     'assets/images/sport/sport_collection.webp',
              //     width: AppValues.sportIcon_18.w,
              //     height: AppValues.sportIcon_18.h,
              //   ),
              //   // iconThemeData: themeData,
              // ),
            ],
          ),
        ),
      );
    });
  }
}
