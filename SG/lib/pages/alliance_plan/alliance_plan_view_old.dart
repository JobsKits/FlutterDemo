import 'package:flutter_bet/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/widget/cell/custom_tooltip_cell_widget.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';
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
import '../main/code.dart';
import '../main/logic.dart';
import 'alliance_plan_logic.dart';
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
        return AlliancePlanPageOld();
      });
}

const kAlliancePlanPage = 'AlliancePlanPage';

///新版联盟计划1021-view
///yuyu/YDv2j3t7
class AlliancePlanPageOld extends BaseView<AlliancePlanLogic> {
  AlliancePlanPageOld({super.key});

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

  _buildBody(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        // SliverToBoxAdapter(child: SizedBox(height: AppValues.barTopHeight)),
        SliverToBoxAdapter(
          child: CustomAppBarH5(
            icon: "assets/images/alliance/ic_alliance_title.webp",
            title: S.current.alliance_program_copy,
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.defaultPadding,
              vertical: AppValues.largePadding,
            ),
            onTap: () {
              RouteUtil.popView();
              MainLogic.of().onMenuSelected(MenuCode.GAME);
            },
          ),
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
            return Offstage(offstage: !logic.isLogin, child: _buildSubInfoView());
          }),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppValues.defaultMargin)),
        SliverFillRemaining(child: _buildSubTabBarView()),
        // const SliverToBoxAdapter(child: SizedBox(height: AppValues.defaultMargin)),
      ],
    );
  }

  ///个人信息区域
  _buildSubInfoView() {
    return Container(
      // color: ThemeService().colorScheme.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.defaultPadding,
        // vertical: AppValues.halfPadding,
      ),
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
    );
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
    // IntrinsicWidth;
    // IntrinsicColumnWidth;
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
          ),
        ],
      ),
    );
  }

  /// tab 切换区域
  _buildSubTabBarView() {
    return SubTabBarView(isLogin: GlobalStateController.of().isLogin.value);
  }
}
