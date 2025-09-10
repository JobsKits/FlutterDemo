import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_bet/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/widget/cell/custom_tooltip_cell_widget.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';
import 'package:flutter_bet/widget/scroller/custom_nested_scroll_tab_view.dart';
import 'package:get/get.dart';

import '../../constant/app_values.dart';
import '../../controllers/global_state_controller.dart';
import '../../routes/routes.dart';
import '../../services/theme/theme_service.dart';
import '../../utils/route_util.dart';
import '../../widget/app_bar/custom_app_bar.dart';
import '../../widget/app_bar/custom_app_bar_h5.dart';
import '../../widget/button/custom_button.dart';
import '../../widget/custom_asset_icon.dart';
import '../../widget/custom_text.dart';
import '../../widget/dialog/custom_safe_dialog.dart';
import '../../widget/scroller/custom_nested_scroll_view.dart';
import '../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../main/code.dart';
import '../main/logic.dart';
import 'all_data/all_data_view.dart';
import 'alliance_plan_logic.dart';
import 'commission_rate/commission_rate_view.dart';
import 'direct_betting/direct_betting_view.dart';
import 'direct_finance/direct_finance_view.dart';
import 'direct_user/direct_user_view.dart';
import 'my_commission/my_commission_view.dart';
import 'my_performance/my_performance_view.dart';
import 'my_promotion/my_promotion_view.dart';
import 'study/promotion_study_view.dart';
import 'sub_tab_bar_view.dart';
import 'wmodel/alliance_common_params.dart';

///对外显示页面方法-打开 新版联盟计划 对话框
Future<void> showAlliancePlanDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kAlliancePlanPage,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return AlliancePlanPage();
      });
}

const kAlliancePlanPage = 'AlliancePlanPage';

///新版联盟计划1021-view
///yuyu/YDv2j3t7
class AlliancePlanPage extends BaseView<AlliancePlanLogic> {
  AlliancePlanPage({super.key});

  ///打开页面，没登陆 也可以进来
  static openPage({AlliancePageEnum? pageEnum}) {
    // //打开之前判断是否有登陆
    // if (GlobalStateController.of().isLogin.value) {
    //   //打开页面
    //   RouteUtil.pushToView(Routes.personalAlliancePlan);
    // } else {
    //   //注册页面
    //   RegisterPage.openPage();
    // }
    //打开页面
    int index = GlobalStateController.of().buttonSelectIndex.value;
    GlobalStateController.of().buttonSelectIndex.value = -1;
    RouteUtil.pushToView(Routes.personalAlliancePlan, arguments: {"pageEnum": pageEnum},
        onBack: (d) {
      GlobalStateController.of().buttonSelectIndex.value = index;
    });
  }

  // final logic = Get.find<AlliancePlanLogic>();
  // final state = Get.find<AlliancePlanLogic>().state;

  @override
  bool resizeToAvoidBottomInset() {
    return false;
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
    //   // appBarTitleText: S.current.alliance_program,
    //   // showLeading: true,
    //   height: AppValues.barTopHeight - MediaQuery.of(context).padding.top-12,
    //   // height: 0,
    // );
  }

  @override
  Widget buildBody(BuildContext context) {
    return _buildBody(context);
  }

  // KeyboardDismissOnTap
  // Scaffold
  // backgroundColor: Colors.transparent,
  // resizeToAvoidBottomInset: false, //禁止重绘
  // color: ThemeService().colorScheme.background,
  // color: ThemeService().colorScheme.surface,
  final ScrollController _scrollController = ScrollController();

  _buildBody(BuildContext context) {
    // return Container(
    //   height: 500,
    //   child: ListView(
    //     physics: BouncingScrollPhysics(),
    //     shrinkWrap: true,
    //     children: [
    //       _buildTitleH5View(),
    //       _buildPersonInfoView(),
    //       _buildTabView(),
    //       AllDataPage(),
    //     ],
    //   ),
    // );
    return Scaffold(
      body: CustomScrollView(
        // physics: const AlwaysScrollableScrollPhysics(),
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          // _buildTitleH5View(),
          // _buildPersonInfoView(),
          // _buildTabView(),
          SliverToBoxAdapter(child: _buildTitleH5View()),
          SliverToBoxAdapter(child: _buildPersonInfoView()),
          SliverToBoxAdapter(child: _buildTabView()),
          // SliverFillRemaining(child: AllDataPage()),
          //  SliverToBoxAdapter
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding,vertical: AppValues.defaultPadding),
              margin: EdgeInsets.only(bottom: AppValues.barBottomHeight),
              child: Obx(() {
                return logic.getTabBarView(logic.tabIndex.value);
              }),
            ),
          ),
        ],
      ),
    );

    // return ExtendedNestedScrollView(
    //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //     return [
    //       // _buildTitleH5View(),
    //       // _buildPersonInfoView(),
    //       // _buildTabView(),
    //       SliverToBoxAdapter(child: _buildTitleH5View()),
    //       SliverToBoxAdapter(child: _buildPersonInfoView()),
    //       SliverToBoxAdapter(child: _buildTabView()),
    //     ];
    //   },
    //   body: TabBarView(
    //     controller: controller.tabController,
    //     children: [
    //       //1 推广教程
    //       PromotionStudyPage(),
    //       //我的推广
    //       MyPromotionPage(),
    //       //我的佣金
    //       MyCommissionPage(),
    //       //我的业绩
    //       MyPerformancePage(),
    //       //所有数据
    //       AllDataPage(),
    //       //直属财务
    //       DirectFinancePage(),
    //       //直属投注
    //       DirectBettingPage(),
    //       //直属用户
    //       DirectUserPage(),
    //       // ConstrainedBox(constraints: constraints, child: DirectReceivePage()), //直属领取//【0228】联盟计划 隐藏直属领取模块
    //       //佣金比例
    //       CommissionRatePage(),
    //       //11 0124.联盟计划 把注册子代理给删除【老板反馈】
    //       // ConstrainedBox(
    //       //
    //     ],
    //   ),
    // );
    return CustomNestedScrollTabView(
      scrollController: controller.scrollController,
      tabController: controller.tabController,
      // physics: const BouncingScrollPhysics(),
      // tabPhysics: const NeverScrollableScrollPhysics(),
      physics: const ClampingScrollPhysics(),
      // tabPhysics: const ClampingScrollPhysics(),
      tabViewMargin: const EdgeInsets.only(
        left: AppValues.margin_12,
        right: AppValues.margin_12,
        top: AppValues.margin_12,
      ),
      headerViews: [
        _buildTitleH5View(),
        _buildPersonInfoView(),
        _buildTabView(),
      ],
      tabChildViews: [
        //1 推广教程
        PromotionStudyPage(),
        //我的推广
        MyPromotionPage(),
        //我的佣金
        MyCommissionPage(),
        //我的业绩
        MyPerformancePage(),
        //所有数据
        AllDataPage(),
        //直属财务
        DirectFinancePage(),
        //直属投注
        DirectBettingPage(),
        //直属用户
        DirectUserPage(),
        //直属领取//【0228】联盟计划 隐藏直属领取模块
        //DirectReceivePage(),
        //11 0124.联盟计划 把注册子代理给删除【老板反馈】
        //佣金比例
        CommissionRatePage(),
      ],
    );
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        // SliverToBoxAdapter(child: SizedBox(height: AppValues.barTopHeight)),
        SliverToBoxAdapter(
          child: _buildTitleH5View(),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
          //   child: Row(
          //     children: [
          //       CustomAssetIcon(name: "assets/images/alliance/ic_alliance_title.webp", size: 16),
          //       SizedBox(width: AppValues.margin_12),
          //       CustomText(S.current.alliance_program,
          //           style: ThemeService()
          //               .textTheme
          //               .bodyLarge
          //               ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18)),
          //       Spacer(),
          //       CustomCloseButton(
          //         onTap: () {
          //           RouteUtil.popView();
          //           MainLogic.of().onMenuSelected(MenuCode.GAME);
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ),
        //没有登陆隐藏
        // SliverToBoxAdapter(
        //   child: Obx(() {
        //     return Offstage(
        //         offstage: !logic.isLogin, child: SizedBox(height: AppValues.defaultMargin));
        //   }),
        // ),
        SliverToBoxAdapter(
          child: Obx(() {
            return Offstage(offstage: !logic.isLogin, child: _buildPersonInfoView());
          }),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppValues.defaultMargin)),
        SliverFillRemaining(child: _buildSubTabBarView()),
        // const SliverToBoxAdapter(child: SizedBox(height: AppValues.defaultMargin)),
      ],
    );
  }

  ///头部
  _buildTitleH5View() {
    return CustomAppBarH5(
      icon: "assets/images/alliance/ic_alliance_title.webp",
      title: S.current.alliance_program_copy,
      padding: const EdgeInsets.only(
        left: AppValues.defaultPadding,
        right: AppValues.defaultPadding,
        top: AppValues.largePadding,
        // bottom: AppValues.smallPadding,
      ),
      onTap: () {
        RouteUtil.popView();
        MainLogic.of().onMenuSelected(MenuCode.GAME);
      },
    );
  }

  ///个人信息区域
  _buildPersonInfoView() {
    return Obx(() {
      return Offstage(
        offstage: !logic.isLogin,
        child: Container(
          // color: ThemeService().colorScheme.surface,
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.defaultPadding,
            // vertical: AppValues.halfPadding,
          ),
          margin: const EdgeInsets.only(top: AppValues.defaultMargin),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const CustomAssetIcon(
                name: 'assets/images/alliance/ic_alliance_ranking_new.webp',
                // name: 'assets/images/alliance/level/ic_alliance_commission_level_4.webp',
                // name: AllianceBizHelper.getCommissionLevelAsset(logic.apiModelObs.value.level),
                // name: "",
                size: 50,
              ),
              // InkWell(
              //   child: CustomAssetIcon(
              //     name: 'assets/images/alliance/ic_alliance_ranking_new.webp',
              //     // name: 'assets/images/alliance/level/ic_alliance_commission_level_4.webp',
              //     // name: AllianceBizHelper.getCommissionLevelAsset(logic.apiModelObs.value.level),
              //     // name: "",
              //     size: 50,
              //   ),
              //   onTap: () => logic.onClickAvatar(),
              // ),
              SizedBox(width: AppValues.halfMargin),
              _buildAccountRow(),
              Spacer(),
              _buildActionRow(),
            ],
          ),
        ),
      );
    });
  }

  _buildAccountRow() {
    return Obx(() {
      return Visibility(
        visible: logic.isShowAgencyObs.value != null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            //上级
            Visibility(
              visible: logic.isShowAgencyObs.value ?? false,
              child: Row(
                children: [
                  CustomText(
                    S.current.random_text_515,
                    style: ThemeService().textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  CustomTooltipCellWidget(
                    content: logic.apiModelObs.value.parentName,
                    // content: "是肯德基啦大事萨科的健身卡",
                    maxLength: LangService().isChinese ? 10 : 8,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    style: ThemeService().textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppValues.smallMargin),
            //账号
            Row(
              children: [
                CustomText(
                  S.current.random_text_71,
                  style: ThemeService().textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                CustomTooltipCellWidget(
                  content: logic.apiModelObs.value.username ?? "",
                  // content:  "1234567890",
                  maxLength: LangService().isChinese ? 10 : 8,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  style: ThemeService().textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  ///钱包 和 记录
  _buildActionRow() {
    // IntrinsicWidth; todo:临时去掉
    return IntrinsicWidth(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            width: double.infinity,
            title: S.current.random_text_516,
            alignment: Alignment.center,
            // textColor:Colors.white,
            textStyle: ThemeService().textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.padding_16,
              vertical: AppValues.padding_3,
            ),
            decoration: ShapeDecoration(
              color: Color(0xFF1475E1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            // child: CustomText("123213"),

            onTap: () => logic.onClickCommissionReceive(buildContext!),
          ),
          SizedBox(height: AppValues.margin_6),
          // Container(width: 300),
          CustomButton(
            width: double.infinity,
            title: S.current.random_text_517,
            alignment: Alignment.center,
            // textColor:Colors.white,
            textStyle: ThemeService()
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.padding_16,
              vertical: AppValues.padding_3,
            ),
            decoration: BoxDecoration(
              color: ThemeService().colorScheme.tertiary,
              // border: Border.all(color: Color(0xFF1475E1), width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            onTap: () => logic.onClickCommissionHistory(buildContext!),
            // child: CustomText("123213"),
          ),
        ],
      ),
    );
  }

  _buildTabView() {
    return Container(
      margin: const EdgeInsets.only(
        left: AppValues.defaultPadding,
        right: AppValues.defaultPadding,
        top: AppValues.defaultPadding + AppValues.smallPadding,
        // bottom: AppValues.defaultPadding,
        // vertical: AppValues.defaultMargin,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(49),
        color: ThemeService().theme.colorScheme.surface, // 设置背景色
      ),
      //CustomTabBarCoveredIcon
      //CustomTabBarWithIcon
      child: CustomTabBarWithIcon(
        isLogin: true,
        tabController: controller.tabController,
        // controller: controller.tabController,
        // 将TabController与TabBar关联
        tabs: controller.tabList,
        backgroundColor: ThemeService().theme.colorScheme.tertiary,
        radius: 44,
        height: 54,
        buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        isShowScrollBar: true,
      ),
    );
  }

  /// tab 切换区域
  _buildSubTabBarView() {
    return SubTabBarView(isLogin: GlobalStateController.of().isLogin.value);
  }
}
