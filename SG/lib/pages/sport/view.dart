import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter/material.dart';
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
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:flutter_bet/widget/sport/custom_sport_banner.dart';
import 'package:flutter_bet/widget/sport/custom_sport_odd_type.dart';
import 'package:flutter_bet/widget/sport/custom_sport_tabbar.dart';
import 'package:get/get.dart';
import '../../controllers/global_state_controller.dart';
import '../../routes/routes.dart';
import '../../services/theme/theme_service.dart';
import '../../utils/route_util.dart';
import '../../widget/app_bar/custom_app_bar.dart';
import '../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../widget/custom_app_life_cycle_listen_widget.dart';
import '../../widget/custom_asset_icon.dart';
import '../../widget/custom_marquee.dart';
import '../../widget/custom_top_appbar_view.dart';
import '../../widget/sport/custom_sport_hot.dart';
import '../find/widget/casino_tabbar.dart';
import 'logic.dart';
import 'sport_event/bottom_rank/view.dart';

///体育界面
class MessagePage extends BaseView<MessageLogic> {
  final logic = Get.find<MessageLogic>();
  final state = Get.find<MessageLogic>().state;
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  MessagePage({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    state.context =context;
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
        onTap: () => globalController.onArticleCollect(),
        onTapLogo: () => controller.top(),
        isShowLogo: true,
      ),
      showLeading: false,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    state.buildData();
    return Container(
      // margin: EdgeInsets.only(bottom: AppValues.barBottomHeight),
      child: CustomAppLifeCycleListenWidget(
        /// Switch to entertainment betting when switching to the bet slip page
        didChangeDependencies: () {
          globalController.betSlipType.value = 1;
          globalController.menuSelectType.value = 1;
          globalController.showMenuImage.value = false;
        },
        child: state.firstLoad.value
            ? SizedBox(
                height: 150,
                child: CustomNetWorkImagePlaceholder(
                  color: AppThemes.surfaceVariant.withOpacity(0),
                  placeholderType: NetWorkImagePlaceholderType.loading,
                  // borderRadius: borderRadius,
                  // border: border,
                ))
            : state.isNormal.value ? ListView(controller: state.sc, children: [
                if (state.bannnerList.isNotEmpty) CustomSportBanner(state.bannnerList),
                // if (state.topHotList.isNotEmpty) CustomSportHot(state.topHotList),
                if (state.bannnerList.isEmpty) const SizedBox(height: AppValues.defaultMargin,),
                // if (controller.state.marqueeText.value.isNotEmpty) buildMarqueeWidget(),
                Obx(
                  () => CustomSportTabbar(
                    state.topTabs,
                    textColor: Colors.white,
                    (index) => logic.changeCategoryIndex(index),
                    state.cagetoryTabbarInitIndex.value,
                    state.globalController.isLogin.value,
                    tabController: state.tabController,
                    true,
                  ),
                ),
                Obx(() => _page(state.sportCategotyType.value)),
                // buildBottomRankListTab(),
                const BottomRankPage(),
              ]) : maintainView(),
      ),
    );
  }

  _page(SportCategotyType type) {
    switch (type) {
      case SportCategotyType.sport_hall:
        return Obx(() => Column(
              children: [
                // if (state.rollingMatchList.value.isNotEmpty)
                state.indexMain != state.filterModel.listFilter!.length - 1 ?
                buildSection(
                  state.hall_hall_index.value,
                  S.current.sport_tabbar_rolling,
                  state.tabs.value,
                  state.rollingMatchList.value,
                  (value) => {
                    state.hall_hall_index.value = 0,
                    state.hall_hot_index.value = 0,
                    state.fav_hot_index.value = 0,
                    state.fav_comming_index.value = 0,
                    state.rolling_index.value = 0,
                    state.comming_index.value = 0,
                    state.isShimmerView.value = true,
                    logic.refreshRolling(value, S.current.sport_tabbar_rolling)
                  },
                  state.rollingShowMore,
                  state.sit,
                  state.isShimmerView.value,
                  state.chall_hall_isopen,
                )
                : buildSection(
                  state.hall_hall_index.value,
                  S.current.sport_tabbar_rolling,
                  state.tabs.value,
                  state.championMatchList.value,
                  (value) => {
                    state.hall_hall_index.value = 0,
                    state.hall_hot_index.value = 0,
                    state.fav_hot_index.value = 0,
                    state.fav_comming_index.value = 0,
                    state.rolling_index.value = 0,
                    state.comming_index.value = 0,
                    state.isShimmerView.value = true,
                    logic.refreshRolling(value, S.current.sport_tabbar_rolling)
                  },
                  state.rollingShowMore,
                  state.sit,
                  state.isShimmerView.value,
                  state.chall_hall_isopen,
                ),
                const SizedBox(height: AppValues.sportHeight_16),
                // if (state.hotMatchList.value.isNotEmpty)
                buildSection(
                  state.hall_hall_index.value,
                  S.current.sport_bet_hot,
                  state.tabs.value,
                  state.hotMatchList.value,
                  (value) {
                    state.hall_hall_index.value = 0;
                    state.hall_hot_index.value = 0;
                    state.fav_hot_index.value = 0;
                    state.fav_comming_index.value = 0;
                    state.rolling_index.value = 0;
                    state.comming_index.value = 0;
                    logic.refreshRolling(value, S.current.sport_bet_hot);
                  },
                  state.hotShowMore,
                  state.sit,
                  false,
                  state.chall_hot_isopen,
                )
              ],
            ));
      case SportCategotyType.sport_vr:
        return Obx(() => Column(
              children: [
                // if (state.rollingMatchList.value.isNotEmpty)
                buildSection(
                        state.hall_vr_index.value,
                        S.current.random_text_680,
                        state.tabs.value,
                        state.rollingMatchList.value,
                        (value) => {
                          state.hall_hall_index.value = 0,
                          state.hall_hot_index.value = 0,
                          state.fav_hot_index.value = 0,
                          state.fav_comming_index.value = 0,
                          state.rolling_index.value = 0,
                          state.comming_index.value = 0,
                          state.isShimmerView.value = true,
                          logic.refreshRolling(value, S.current.sport_tabbar_rolling)
                        },
                        state.rollingMatchList.isNotEmpty ? state.rollingShowMore : false,
                        state.sit,
                        state.isShimmerView.value,
                        state.chall_hall_isopen,
                      ),
              ],
            ));
      case SportCategotyType.sport_mybet:
        return AccountService.sharedInstance.isLogin()
            ? Obx(() {
                return SportBetWidget(index: state.cagetoryTabbarInitIndex.value);
              })
            : _buildNoDataView(S.current.sport_unlogin);
      case SportCategotyType.sport_fav:
        return Obx(() => Column(
              children: [
                state.favHotList.isNotEmpty
                    ? buildSection(
                        state.fav_hot_index.value,
                        S.current.sport_fav_hot_rolling,
                        state.favTabs.where((element) {
                              element.cc = state.favHotList
                                  .where((s) => s.si == element.si)
                                  .toList()
                                  .length;
                              return state.favHotList
                                  .map((e) => e.si)
                                  .toList()
                                  .contains(element.si);
                            }).toList(),
                        logic.filterFavSi(state.favHotList, state.favHotSit),
                        (value) {
                          state.hall_hall_index.value = 0;
                          state.hall_hot_index.value = 0;
                          state.fav_hot_index.value = 0;
                          state.fav_comming_index.value = 0;
                          state.rolling_index.value = 0;
                          state.comming_index.value = 0;
                          logic.refreshFav(value, 0);
                        },
                        false,
                        state.favHotSit,
                        false,
                        state.cfav_hot_isopen,
                      )
                    : _buildNoDataView(S.current.random_text_684)
                // SizedBox(height: AppValues.sportHeight_16),
                // buildSection(
                //   state.fav_comming_index.value,
                //   S.current.sport_fav_comming_rolling,
                //   state.favTabs.value ?? [],
                //   logic.filterFavSi(state.favCommingList.value, state.favComminghSit),
                //   (value) => logic.refreshFav(value, 1),
                //   false,
                //   state.favComminghSit,
                // ),
              ],
            ));
      case SportCategotyType.sport_rolling:
        return Obx(
          () => state.rollingMatchList.isNotEmpty
              ? buildSection(
                  state.hall_hall_index.value,
                  S.current.sport_tabbar_rolling,
                  state.tabs.value,
                  state.rollingMatchList.value,
                  (value) => {
                    state.hall_hall_index.value = 0,
                    state.hall_hot_index.value = 0,
                    state.fav_hot_index.value = 0,
                    state.fav_comming_index.value = 0,
                    state.rolling_index.value = 0,
                    state.comming_index.value = 0,
                    state.isShimmerView.value = true,
                    logic.refreshRolling(value, S.current.sport_tabbar_rolling),
                  },
                  state.rollingShowMore,
                  state.sit,
                  state.isShimmerView.value,
                  state.crolling_isopen,
                )
              : _buildNoDataView(S.current.sport_nodata),
        );
      case SportCategotyType.sport_coming:
        return Obx(() => state.comingMatchList.isNotEmpty
            ? buildSection(
                state.comming_index.value,
                S.current.sport_tabbar_coming,
                state.commingTabs,
                state.comingMatchList,
                (value) => {
                  state.hall_hall_index.value = 0,
                  state.hall_hot_index.value = 0,
                  state.fav_hot_index.value = 0,
                  state.fav_comming_index.value = 0,
                  state.rolling_index.value = 0,
                  state.comming_index.value = 0,
                  state.isShimmerView.value = true,
                  logic.refreshRolling(value, S.current.sport_tabbar_coming),
                },
                state.commingShowMore,
                state.commingSit,
                state.isShimmerView.value,
                state.ccomming_isopen,
              )
            : _buildNoDataView(S.current.sport_nodata));
      case SportCategotyType.sport_loading:
        return SizedBox(
            height: 150,
            child: CustomNetWorkImagePlaceholder(
              color: AppThemes.surfaceVariant.withOpacity(0),
              placeholderType: NetWorkImagePlaceholderType.loading,
              // borderRadius: borderRadius,
              // border: border,
            ));
      // return Container(
      //   height: 300,
      //   child: const Center(child: CircularProgressIndicator()),
      // );
    }
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
    bool isOpen,
  ) {
    return SportHallSection(
      index: filterIndex,
      title: title,
      tabs: tabs,
      competitionList: competitionList,
      onTapGame: (w) => onTapGame(w),
      m: m,
      cIndex: cindex,
      isShimmerView: isShimmerView,
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
            } else if (title == S.current.random_text_680) {
              state.hall_vr_index.value = section ?? 0;
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
          case SportClikType.change:
            logic.refreshRolling(state.sit, S.current.sport_tabbar_rolling);
            break;
          default:
            break;
        }
        // print('=====$type=====$section=====$row=====$colum');
      },
      isOpen: isOpen,
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

  Widget _buildNoDataView(String title) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: AppValues.sportHeight_153),
            Image.asset(
              'assets/images/status/ic_status_view_empty.webp',
              height: AppValues.sportIcon_112,
              width: AppValues.sportIcon_112,
            ),
            const SizedBox(height: AppValues.sportHeight_16),
            CustomText(title, textColorStyle: CustomTextColorStyle.secondary)
          ],
        ),
      ),
    );
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
            child: Obx(() {
              return Marquee(
                speed: 30,
                child: CustomText(
                  controller.state.marqueeText.value,
                  style: const TextStyle(color: AppThemes.iconColor, fontSize: 14),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  /// 维护中
  Widget maintainView() {
    return SingleChildScrollView(
      controller: state.sc,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppValues.largePadding),
          child: Column(
            children: [
              const SizedBox(height: 200,),
              const CustomAssetIcon(
                name: 'assets/images/status/ic_status_view_error.webp',
                size: 125,
              ),
              const SizedBox(height: 24,),
              CustomText(
                S.current.random_text_717,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18,color: AppThemes.onSurfaceVariant,fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: AppValues.height_16,),
              CustomText(S.current.random_text_718,style: const TextStyle(color: Color(0xff536f84)),),
              CustomText('${state.maintainedStartTime} ${S.current.random_text_719} ${state.maintainedEndTime}',style: const TextStyle(color: Color(0xff536f84)),),
              const SizedBox(height: AppValues.height_16,),
              CustomButton(
                title: S.current.random_text_720,
                textStyle: const TextStyle(color: AppThemes.textColorWhite,fontWeight: FontWeight.w600),
                backgroundColor: AppThemes.lineGreen,
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                borderRadius: BorderRadius.circular(AppValues.smallRadius),
                onTap: controller.backHome,
              )
            ],
          ),
        )
      )
    );
  }
}
