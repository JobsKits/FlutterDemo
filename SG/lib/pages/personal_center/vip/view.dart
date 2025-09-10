import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/viplevel/viplevel_config_model.dart';
import 'package:flutter_bet/pages/notifs/widget/notifs_type.dart';
import 'package:flutter_bet/pages/personal_center/vip/widgets/vip_club_header_view.dart';
import 'package:flutter_bet/pages/personal_center/vip/widgets/vip_jinji_guize.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/num_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/string_uril.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:flutter_bet/widget/row/custom_row_expanded_widget.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'logic.dart';
import 'package:get/get.dart';

import 'vipdetails/logic.dart';
import 'vipdetails/view.dart';
import 'widgets/vip_status_type.dart';

final GlobalKey globalKey = GlobalKey();

class VipHomePage extends BaseView<VipHomeLogic> {
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<ScalingTextState> _scalingKey = GlobalKey<ScalingTextState>();

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // return CustomAppBar(
    //   appBarTitleText: controller.pageType == "vipRank" ? 'VIP' : S.current.vip_club,
    // );
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
          // onTap: () => globaController.onArticleCollect(),
          // logoTap: () {
          //   controller.scrollcontroller
          //       .animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          // },
          ),
      showLeading: false,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // return Text('VIP1').center();

    return GetBuilder<VipHomeLogic>(
        id: "vip_home",
        builder: (controller) {
          return controller.dataList.length == 0
              ? controller.isLoading == true
                  ? SizedBox(
                      height: 150,
                      child: CustomNetWorkImagePlaceholder(
                        color: AppThemes.surfaceVariant.withOpacity(0),
                        placeholderType: NetWorkImagePlaceholderType.loading,
                        // borderRadius: borderRadius,
                        // border: border,
                      ))
                  : const CustomEmptyWidget().paddingTop(AppValues.largePadding * 5)
              : SliverViewObserver(
                  controller: controller.observerController,
                  sliverContexts: () {
                    return [
                      if (controller.sliverListContext != null) controller.sliverListContext!,
                    ];
                  },
                  child: CustomScrollView(
                    controller: controller.pageScrollController,
                    slivers: [
                      // const SizedBox(height: AppValues.defaultMargin).sliverToBoxAdapter(),
                      // controller.pageType == "vipRank"
                      //     ? userVipInfo(context).sliverToBoxAdapter()
                      //     : VipClubHeaderView(logic: controller).sliverToBoxAdapter(),
                      // const SizedBox(height: AppValues.margin_24).sliverToBoxAdapter(),
                      // middleSwitcher().sliverToBoxAdapter(),
                      _buildSliverListView(context),
                      buildeDetails(context),
                      SizedBox(
                        height: AppValues.barBottomHeight,
                      ).sliverToBoxAdapter(),
                    ],
                  ),
                );
        });
  }

  //todo:0125.为了做定位组件滑动
  Widget _buildSliverListView(BuildContext context) {
    // controller.contextTabView ??= context;
    // return SliverList(
    //   delegate: SliverChildListDelegate(
    //     [
    //       const SizedBox(height: AppValues.defaultMargin),
    //       controller.pageType == "vipRank"
    //           ? userVipInfo(context)
    //           : VipClubHeaderView(logic: controller),
    //       const SizedBox(height: AppValues.margin_24),
    //       middleSwitcher(),
    //     ],
    //     addAutomaticKeepAlives: true,
    //   ),
    // );

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 4,
        (ctx, index) {
          print("");
          controller.sliverListContext = ctx;
          switch (index) {
            case 0:
              return const SizedBox(height: AppValues.defaultMargin);
            case 1:
              return controller.pageType == "vipRank"
                  ? controller.globalController.isLogin.value == true
                      ? shadowUserInfo(context)
                      : SizedBox()
                  : VipClubHeaderView(logic: controller);
            case 2:
              return const SizedBox(height: AppValues.margin_24);
            // case 0:
            //   return Column(
            //     children: [
            //       const SizedBox(height: AppValues.defaultMargin),
            //       controller.pageType == "vipRank"
            //           ? userVipInfo(context)
            //           : VipClubHeaderView(logic: controller),
            //       const SizedBox(height: AppValues.margin_24),
            //     ],
            //   );
            case 3:
              return middleSwitcher();
          }
        },
      ),
    );
  }

  // shadowuserinfo
  Widget shadowUserInfo(context) {
    return <Widget>[
      <Widget>[
        SvgPicture.asset("assets/svg/vip_header_icon.svg").tightSize(AppValues.iconSize_18),
        const SizedBox(width: AppValues.defaultPadding),
        CustomText("VIP",
            style: ThemeService()
                .theme
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: AppValues.fontBodyLargeSize)),
        const Spacer(),
        const CustomIcon(
                asset: 'assets/images/normal/ic_normal_close.png', size: AppValues.iconSize_18)
            .marginOnly(left: AppValues.defaultMargin)
            .center()
            .onTap(() {
          controller.globalController
              .showOverlayView(isShowTopBarView: true, isShowBottomBarView: true);
          RouteUtil.popView();
        })
      ]
          .toRow()
          .height(25.2)
          .paddingBottom(AppValues.defaultPadding)
          .paddingHorizontal(AppValues.defaultPadding),
      Container(
        decoration: BoxDecoration(
          color: const Color(0xff213743),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: userVipInfo(context),
      ).marginOnly(left: AppValues.defaultPadding, right: AppValues.defaultPadding)
    ].toColumn();
  }

  // 用户信息
  Widget userVipInfo(context) {
    final titleStyle =
        ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);

    final vipLevelPath =
        "${BranchService().current.asset_url}/images/vip/${controller.currentUser.vip!}.webp";

    double currentScore = double.parse(controller.currentUser.score!);

    double rate = controller.getVipProcessRate() >= 1
        ? 1
        : controller.getVipProcessRate() <= 0
            ? 0
            : controller.getVipProcessRate();

    double levelImageSize = 82.w;
    VipLevelModel model = controller.dataList[int.parse(controller.currentUser.vip!)];
    // rate = 1;
    return <Widget>[
      <Widget>[
        Image.network(vipLevelPath, width: levelImageSize, height: levelImageSize).paddingLeft(2),

        // const SizedBox(width: AppValues.halfMargin),
        <Widget>[
          <Widget>[
            <Widget>[
              controller.vipLevel == controller.dataList.last.level.toString()
                  ? CustomText(S.current.random_text_1076,
                          maxLines: 2,
                          style: TextStyle(
                              color: ThemeService().theme.colorScheme.onTertiary,
                              fontWeight: FontWeight.w600,
                              fontSize: AppValues.fontBodyMediumSize))
                      .constrained(maxWidth: 150.w, maxHeight: 40)
                  : RichText(
                      maxLines: 2,
                      text: TextSpan(
                        text: controller.vipLevel == controller.dataList.last.level.toString()
                            ? S.current.random_text_1076
                            : S.current.random_text_885,
                        style: TextStyle(
                            color: ThemeService().theme.colorScheme.onTertiary,
                            fontWeight: FontWeight.w600,
                            fontSize: AppValues.fontBodyMediumSize),
                        children: <TextSpan>[
                          TextSpan(
                            text: "${currentScore.toInt()}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: AppValues.fontBodyMediumSize),
                          ),
                        ],
                      ),
                    ).constrained(maxHeight: 40, maxWidth: 130.w),
            ].toRow().constrained(maxWidth: 130.w),
            Visibility(
              visible: controller.vipLevel != controller.dataList.last.level.toString(),
              child: CustomText("${S.current.random_text_886} ${NumUtil.getValue((rate * 100))}%",
                  maxLines: 2,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: ThemeService().theme.colorScheme.onTertiary,
                      fontWeight: FontWeight.w600,
                      fontSize: AppValues.fontBodyMediumSize)),
            ).constrained(maxWidth: 130.w, maxHeight: 40),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .tight(width: Get.width - levelImageSize - AppValues.defaultPadding * 3),
          <Widget>[
            Container(
              height: 6,
              width: Get.width - levelImageSize - AppValues.defaultPadding * 3,
              decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9).withAlpha(38),
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
            ),
            Container(
              height: 6,
              width: rate == 0
                  ? 0
                  : (Get.width - levelImageSize - AppValues.defaultPadding * 3.0) * rate,
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
            )
          ].toStack().paddingVertical(AppValues.smallPadding + 1),
          <Widget>[
            <Widget>[
              CustomText(
                      "${controller.vipRateModel.value.split(",").first} ${controller.getCurName(controller.vipRateModel.key) == "VND" ? "K" + controller.getCurName(controller.vipRateModel.key) : controller.getCurName(controller.vipRateModel.key)} = ${controller.vipRateModel.value.split(",").last} " +
                          S.current.random_text_619,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      style: TextStyle(
                          color: ThemeService().theme.colorScheme.onTertiary,
                          fontWeight: FontWeight.w600,
                          fontSize: AppValues.fontBodyMediumSize))
                  .height(40),
              Spacer(),
            ]
                .toColumn(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start)
                .tight(width: 150),
            Visibility(
              visible: controller.tabIndex == 0 ||
                      controller.tabIndex == 1 ||
                      (controller.tabIndex == 2 && controller.showRebeatButton == true)
                  ? true
                  : false,
              child: CustomButton(
                padding: EdgeInsets.zero,
                backgroundColor: ThemeService().theme.colorScheme.primaryContainer,
                title: controller.tabIndex == 2
                    ? " " + S.current.random_text_939 + " "
                    : " " + S.current.feedback_receive_title + " ",
                textStyle: ThemeService().theme.textTheme.bodyMedium!.copyWith(
                    color: ThemeService().colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600),
                alignment: const Alignment(0, 0),
                onTap: () {
                  if (controller.tabIndex == 0) {
                    controller.showDengJiLingQuView(context);
                  }
                  if (controller.tabIndex == 1) {
                    controller.showlingQuTanchuang(context);
                  }
                  if (controller.tabIndex == 2) {
                    controller.receiveFanshui(context);

                    // controller.showCustomVipFanshuiViewWidget(context: context);
                  }
                },
              ).clipRRect(all: AppValues.smallRadius).height(30).constrained(minWidth: 80),
            ),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .tight(width: Get.width - levelImageSize - AppValues.defaultPadding * 3)
              .constrained(minHeight: 30, maxHeight: 40),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
      ].toRow(mainAxisAlignment: MainAxisAlignment.start).paddingVertical(AppValues.halfPadding),
      Visibility(
        visible: model.retain == "" ||
                double.parse(model.retain) == 0 ||
                controller.vipLevel == controller.dataList.last.level.toString()
            ? false
            : true,
        child: <Widget>[
          SvgPicture.asset(
            "assets/svg/vip_seperate_line.svg",
            fit: BoxFit.fitWidth,
          ).tight(height: 1, width: double.infinity),
          Center(
            child: CustomText(
              S.current.random_text_1077 + "${model.retain}" + S.current.random_text_619,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                  color: ThemeService().theme.colorScheme.onTertiary,
                  fontWeight: FontWeight.w600,
                  fontSize: AppValues.fontBodyMediumSize),
            ),
          ).tight(height: 30),
        ].toColumn(),
      ).paddingTop(AppValues.halfPadding),
    ].toColumn();
  }

  // 晋级奖金/返水/日份绿.... Tab
  Widget middleSwitcher() {
    controller.tabsNoIcons = [
      Tab(
        text: S.current.vip_tab_bouns,
      ),
      Tab(
        text: S.current.random_text_1120,
      ),
      Tab(
        text: S.current.random_text_403,
      ),
      Tab(
        text: S.current.receive,
      ),
    ];
    return DefaultTabController(
            length: controller.tabsNoIcons.length,
            child: LangUtil().getLangType != "zh_CN"
                ? CustomTabBarWithIcon(
                    tabController: controller.tabController,
                    tabs: controller.tabsNoIcons,
                    backgroundColor: ThemeService().theme.colorScheme.tertiary,
                    labelStyle: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                    unselectedLabelStyle: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                    height: 54,
                    radius: 27,
                    isShowScrollBar: true)
                : NotifsTypeTab(
                    bgColor: AppThemes.oddBackColor,
                    titles: [
                      S.current.vip_tab_bouns,
                      S.current.random_text_1120,
                      S.current.random_text_403,
                      S.current.receive
                    ],
                    tabController: controller.tabController,
                    selIndex: controller.tabIndex,
                    callback: (p0) {
                      controller.tabbarClicked(p0);
                    },
                  ))
        .backgroundColor(ThemeService().theme.colorScheme.surface)
        .clipRRect(
            topLeft: 30,
            topRight: controller.tabIndex == 3 || controller.tabIndex == 4 ? 30 : 30,
            bottomLeft: 30,
            bottomRight: controller.tabIndex == 3 || controller.tabIndex == 4 ? 30 : 30)
        .paddingHorizontal(AppValues.defaultPadding);
  }

  // 晋级奖金/返水/日份绿..... 内容
  Widget buildeDetails(context) {
    switch (controller.tabIndex) {
      case 0:
        return Column(
          children: [
            buildDetailsLevel(context).paddingHorizontal(AppValues.defaultPadding),
            buildRules()
                .paddingHorizontal(AppValues.defaultPadding)
                .paddingTop(AppValues.defaultPadding),
          ],
        ).sliverToBoxAdapter();

      case 1:
        return Column(
          children: [
            buildFengLuLevel(context).paddingHorizontal(AppValues.defaultPadding),
            buildRules()
                .paddingHorizontal(AppValues.defaultPadding)
                .paddingTop(AppValues.defaultPadding),
          ],
        ).sliverToBoxAdapter();

      case 2:
        return Container(
          // color: ThemeService().theme.colorScheme.background,
          child: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  // color: ThemeService().theme.colorScheme.surface,
                  borderRadius: BorderRadius.all(Radius.circular(AppValues.defaultPadding))),
              child: controller.isVipFanShuiLoading == true
                  ? const SizedBox()
                  : <Widget>[
                      buildFanshuiTitle(),
                      buildFanShuiDetails(controller.selectedFanshuiIndex, context),
                    ].toColumn(),
            ),
            Visibility(
                visible: !controller.isVipFanShuiLoading,
                child: buildRules().paddingTop(AppValues.defaultPadding)),
          ].toColumn().paddingHorizontal(AppValues.defaultPadding),
        ).paddingTop(AppValues.defaultPadding).sliverToBoxAdapter();

      default:
        return VipLingQuRecordPage().sliverToBoxAdapter();
    }
  }

  // 内容-晋级奖金
  Widget buildDetailsLevel(context0) {
    double width = Get.width > 348 ? Get.width : 348;
    return <Widget>[
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.fengLudataList.length >= controller.dataList.length
                ? controller.dataList.length
                : controller.fengLudataList.length,
            itemBuilder: (context, index) {
              final bgColor = index % 2 == 1
                  ? ThemeService().theme.colorScheme.surfaceVariant
                  : ThemeService().theme.scaffoldBackgroundColor;
              if (index == 0) {
                var vip_text1 = "VIP${S.current.vip_tab_level}";
                if (LangUtil().isEnIn()) {
                  vip_text1 = "VIP ${S.current.vip_tab_level}";
                }
                if (LangUtil().isTh()) {
                  vip_text1 = "${S.current.vip_tab_level} VIP";
                }
                if (LangUtil().isPtBr()) {
                  vip_text1 = "${S.current.vip_tab_level} VIP";
                }
                return Container(
                  color: bgColor,
                  child: CustomRowExpandedWidget(
                    expanded: LangUtil().isViVn() ? const [3, 4, 6] : const [3, 4, 4],
                    children: [
                      CustomText(vip_text1,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ThemeService().theme.colorScheme.onTertiary,
                              fontWeight: FontWeight.w600,
                              fontSize: AppValues.fontBodyMediumSize)),
                      <Widget>[
                        const Spacer(),
                        CustomText(S.current.random_text_619,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                                color: ThemeService().theme.colorScheme.onTertiary,
                                fontWeight: FontWeight.w600,
                                fontSize: AppValues.fontBodyMediumSize)),
                        const Spacer(),
                      ].toRow(),
                      CustomText(S.current.vip_tab_bouns,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                              color: ThemeService().theme.colorScheme.onTertiary,
                              fontWeight: FontWeight.w600,
                              fontSize: AppValues.fontBodyMediumSize)),
                    ],
                  ),
                ).constrained(minHeight: 54);
              }

              final vipLevelPath =
                  "${BranchService().current.asset_url}/images/vip/${controller.dataList[index].level}.webp";

              int lingQutatus = controller.getVipLingQuStatus(index - 1);
              return Container(
                color: bgColor,
                child: CustomRowExpandedWidget(
                    expanded: LangUtil().isViVn() ? const [3, 4, 6] : const [3, 4, 4],
                    children: [
                      Image.network(vipLevelPath, width: 40, height: 40),
                      CustomIconButton(
                        backgroundColor: bgColor,
                        iconHeight: controller.dataList[index].upgrade == "0" ? 0 : 0,
                        iconWidth: controller.dataList[index].upgrade == "0" ? 0 : 0,
                        direction: Direction.right,
                        widgetHeight: AppValues.iconSmallSize,
                        name: controller.dataList[index].upgrade == "0"
                            ? "-"
                            : double.parse(controller.dataList[index].upgrade).toStringAsFixed(0),
                        style: TextStyle(
                            fontFamily: LangUtil().isZhCn() ? "Akrobat-Bold" : null,
                            color: ThemeService().theme.colorScheme.onTertiary,
                            fontSize: AppValues.fontBodyMediumSize,
                            fontWeight: LangUtil().isZhCn() ? FontWeight.w600 : FontWeight.w500),
                      ),
                      getJiFenColum(index, bgColor, 1),
                    ]).height(54),
              );
            }).tight(width: width - AppValues.defaultPadding * 2),
      ),
    ].toColumn();
  }

  // 晋级奖金获取积分列
  Widget getJiFenColum(index, bgColor, splitIndex) {
    return CustomIconButton(
      backgroundColor: bgColor,
      iconHeight: double.parse(controller.fengLudataList.length < index
                      ? "0"
                      : controller.fengLudataList[index][0].amount)
                  .toStringAsFixed(2) ==
              "0"
          ? 0
          : 12,
      //AppValues.iconDefaultSize,
      iconWidth: double.parse(controller.fengLudataList.length < index
                      ? "0"
                      : controller.fengLudataList[index][0].amount)
                  .toStringAsFixed(2) ==
              "0"
          ? 0
          : 12,
      //AppValues.iconDefaultSize,
      iconWidget: Image.network(controller.fengLudataList.length < index
          ? "${AppValues.defaultBranch.asset_url}/currency/${controller.globalController.coinCur}.webp"
          : "${AppValues.defaultBranch.asset_url}/currency/${controller.fengLudataList[index][0].currencyId}.webp"),
      direction: Direction.right,
      widgetHeight: AppValues.iconSmallSize,
      name: double.parse(controller.fengLudataList.length < index
                      ? "0"
                      : controller.fengLudataList[index][0].amount)
                  .toStringAsFixed(2) ==
              "0"
          ? "-"
          : double.parse(controller.fengLudataList[index][0].amount).toStringAsFixed(2),
      style: TextStyle(
          fontFamily: LangUtil().isZhCn() ? "Akrobat-Bold" : null,
          color: ThemeService().theme.colorScheme.onTertiary,
          fontSize: AppValues.fontBodyMediumSize,
          fontWeight: LangUtil().isZhCn() ? FontWeight.w600 : FontWeight.w500),
    );
  }

  /// 返水title
  Widget buildFanshuiTitle() {
    return <Widget>[
      <Widget>[
        CustomText(S.current.random_text_522,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ThemeService().theme.colorScheme.onTertiary,
                    fontSize: AppValues.fontBodyMediumSize,
                    fontWeight: FontWeight.w500))
            .paddingBottom(AppValues.halfPadding),
        VipTypeTab(
          titles: controller.getFanshuiTitle(controller.rebateConfigModle.menu),
          icons: controller.getFanshuiIcon(controller.rebateConfigModle.menu),
          selIndex: controller.selectedFanshuiIndex,
          callback: (p0) {
            controller.selectFanshuiIndex(p0);
          },
        )
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).expanded(),
    ].toRow().paddingVertical(AppValues.halfPadding);
    // return CustomSportCategoryBar(controller.fanshuiTitleList, (value) {});/
  }

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  void _startScaleAnimation(GlobalKey<ScalingTextState> key) {
    key.currentState?.startAnimation();
  }

// 弹窗出来的币种选择

  // 弹窗出来的币种选择
  _viewBubbleChild1() {
    // final coinList =
    // controller.items.currencys!; //controller.getCurrencyList(controller.items.currency);
    return Container(
      height: 150,
      child: Column(
        children: List.generate(controller.coinInfos.length, (index) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                  // controller.onCurrentChanged(
                  //     coinList[index]); // controller.state.chooseType.value= betSlipTypeList[index];
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: AppValues.halfMargin,
                    ),
                    CustomNetWorkImage(
                      imageUrl:
                          controller.getCoinUrlWithCoinName(controller.coinInfos[index].name!),
                      width: AppValues.iconSmallSize,
                      height: AppValues.iconSmallSize,
                    ),
                    const SizedBox(
                      width: AppValues.halfMargin,
                    ),
                    CustomText(controller.coinInfos[index].name!,
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
      ),
    );
  }

  /// 返水详情
  Widget buildFanShuiDetails(selectedIndex, context0) {
    double width = Get.width < 375 ? 375 : Get.width;
    return controller.isVipFanShuiLoading == true
        ? SizedBox(
            height: 150,
            child: CustomNetWorkImagePlaceholder(
              color: AppThemes.surfaceVariant.withOpacity(0),
              placeholderType: NetWorkImagePlaceholderType.loading,
              // borderRadius: borderRadius,
              // border: border,
            ))
        : controller.rebateConfigModle == null
            ? const CustomEmptyWidget().paddingTop(AppValues.largePadding * 5)
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: AppValues.defaultPadding),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.rebateConfigModle.data.length + 1,
                  itemBuilder: (context, index) {
                    final bgColor = index % 2 != 0
                        ? ThemeService().theme.colorScheme.surfaceVariant
                        : ThemeService().theme.scaffoldBackgroundColor;
                    if (index == 0) {
                      var vip_text1 = "VIP${S.current.vip_tab_level}";
                      if (LangUtil().isEnIn()) {
                        vip_text1 = "VIP ${S.current.vip_tab_level}";
                      }
                      if (LangUtil().isTh()) {
                        vip_text1 = "${S.current.vip_tab_level} VIP";
                      }
                      if (LangUtil().isPtBr()) {
                        vip_text1 = "${S.current.vip_tab_level} VIP";
                      }
                      return Container(
                          color: bgColor,
                          child: <Widget>[
                            CustomText(vip_text1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ThemeService().theme.colorScheme.onTertiary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: AppValues.fontBodyMediumSize))
                                .tight(width: 100),
                            for (int i = 0; i < controller.rebateConfigModle.name.length; i++)
                              CustomText(controller.rebateConfigModle.name[i] ?? "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ThemeService().theme.colorScheme.onTertiary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: AppValues.fontBodyMediumSize))
                                  .tight(width: 100),
                          ]
                              .toRow(mainAxisAlignment: MainAxisAlignment.spaceEvenly)
                              .tight(height: 48));
                    }

                    // final vipLevelPath = "assets/images/personal_center_icon/vip_level/level_" +
                    //     controller.dataList[index - 1].level +
                    //     ".webp";
                    final vipLevelPath =
                        "${BranchService().current.asset_url}/images/vip/${controller.dataList[index - 1].level}.webp";

                    return Container(
                      color: bgColor,
                      // decoration: ShapeDecoration(
                      //     color: bgColor,
                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      child: <Widget>[
                        // CustomAssetIcon(name: vipLevelPath, size: 28).tight(width: 100),
                        Image.network(vipLevelPath, width: 40, height: 40).tight(width: 100),

                        for (int i = 0;
                            i < controller.rebateConfigModle.data[index - 1].r.length;
                            i++)
                          CustomText(
                                  controller.rebateConfigModle.data[index - 1].r[i].toString() ==
                                          "0"
                                      ? "-"
                                      : controller.rebateConfigModle.data[index - 1].r[i]
                                              .toString() +
                                          "%",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: AppValues.fontBodySmallSize,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFB1BAD3)))
                              .tight(width: 100)
                      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceEvenly).tight(
                            height: index == 1 ? 0 : 54,
                          ),
                    );
                  },
                ).tight(
                    width: (controller.rebateConfigModle.name.length + 1) * 100 > width
                        ? (controller.rebateConfigModle.name.length + 1) * 100
                        : width - AppValues.defaultPadding * 2),
              );
  }

  Widget buildFengLuLevel(context0) {
    double widthRate = LangUtil().isViVn() ? 1.5 : 1;
    bool showDailyBonusColumn = controller.shouldDayilyBonusVisibility("819");
    double width = Get.width; // < 375 ? 375 : Get.width;

    return <Widget>[
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.builder(
                padding: const EdgeInsets.only(bottom: AppValues.defaultPadding),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.fengLudataList.length,
                itemBuilder: (context, index) {
                  final bgColor = index % 2 != 0
                      ? ThemeService().theme.colorScheme.surfaceVariant
                      : ThemeService().theme.scaffoldBackgroundColor;
                  if (index == 0) {
                    var vip_text1 = "VIP${S.current.vip_tab_level}";
                    if (LangUtil().isEnIn()) {
                      vip_text1 = "VIP ${S.current.vip_tab_level}";
                    }
                    if (LangUtil().isTh()) {
                      vip_text1 = "${S.current.vip_tab_level} VIP";
                    }
                    if (LangUtil().isPtBr()) {
                      vip_text1 = "${S.current.vip_tab_level} VIP";
                    }
                    return Container(
                      color: bgColor,
                      child: CustomRowExpandedWidget(
                          expanded:
                              showDailyBonusColumn == true ? const [3, 4, 4, 4] : const [3, 4, 4],
                          children: [
                            CustomText(vip_text1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ThemeService().colorScheme.onTertiary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: AppValues.fontBodyMediumSize))
                                .tight(width: 85),
                            if (showDailyBonusColumn == true)
                              CustomText(S.current.random_text_603,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ThemeService().colorScheme.onTertiary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: AppValues.fontBodyMediumSize))
                                  .tight(width: 85 * widthRate),
                            CustomText(S.current.random_text_604,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ThemeService().colorScheme.onTertiary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: AppValues.fontBodyMediumSize))
                                .tight(width: 85 * widthRate),
                            CustomText(S.current.random_text_605,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ThemeService().colorScheme.onTertiary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: AppValues.fontBodyMediumSize))
                                .tight(width: 100 * widthRate),
                          ]),
                    ).constrained(minHeight: 54);
                  }
                  final vipLevelPath =
                      "${BranchService().current.asset_url}/images/vip/${controller.fengLudataList[index][0].level}.webp";

                  return Container(
                    color: bgColor,
                    child: CustomRowExpandedWidget(
                        expanded:
                            showDailyBonusColumn == true ? const [3, 4, 4, 4] : const [3, 4, 4],
                        children: [
                          Image.network(vipLevelPath, width: 40, height: 40).tight(width: 85),
                          if (showDailyBonusColumn == true)
                            CustomIconButton(
                                backgroundColor: bgColor,
                                iconHeight: index == controller.dataList.length ? 12 : 12,
                                iconWidth: index == controller.dataList.length ? 12 : 12,
                                iconWidget: Image.network(controller.fengLudataList[index].length >
                                        1
                                    ? "${AppValues.defaultBranch.asset_url}/currency/${controller.fengLudataList[index][1].currencyId}.webp"
                                    : ""),
                                direction: Direction.right,
                                widgetHeight: AppValues.iconSmallSize,
                                name: controller.fengLudataList[index].length > 1
                                    ? controller.fengLudataList[index][1].amount != "0.00"
                                        ? controller.fengLudataList[index][1].amount
                                        : "-"
                                    : "-",
                                style: TextStyle(
                                    fontFamily: LangUtil().isZhCn() ? "Akrobat-Bold" : null,
                                    color: ThemeService().colorScheme.onTertiary,
                                    fontWeight:
                                        LangUtil().isZhCn() ? FontWeight.w600 : FontWeight.w500,
                                    fontSize: AppValues.fontBodyMediumSize)),
                          CustomIconButton(
                                  backgroundColor: bgColor,
                                  iconHeight: controller.fengLudataList[index].length > 2
                                      ? controller.fengLudataList[index][2].amount != "0.00"
                                          ? 12
                                          : 0
                                      : 0,
                                  iconWidth: 12,
                                  iconWidget: Image.network(controller
                                              .fengLudataList[index].length >
                                          2
                                      ? "${AppValues.defaultBranch.asset_url}/currency/${controller.fengLudataList[index][2].currencyId}.webp"
                                      : ""),
                                  direction: Direction.right,
                                  widgetHeight: AppValues.iconSmallSize,
                                  name: controller.fengLudataList[index].length > 2
                                      ? controller.fengLudataList[index][2].amount != "0.00"
                                          ? controller.fengLudataList[index][2].amount
                                          : "-"
                                      : "-",
                                  style: TextStyle(
                                      fontFamily: LangUtil().isZhCn() ? "Akrobat-Bold" : null,
                                      color: ThemeService().colorScheme.onTertiary,
                                      fontWeight:
                                          LangUtil().isZhCn() ? FontWeight.w600 : FontWeight.w500,
                                      fontSize: AppValues.fontBodyMediumSize))
                              .tight(width: 85 * widthRate),
                          CustomIconButton(
                                  backgroundColor: bgColor,
                                  iconHeight: 12,
                                  iconWidth: controller.fengLudataList[index].length > 3
                                      ? controller.fengLudataList[index][3].amount != "0.00"
                                          ? 12
                                          : 0
                                      : 0,
                                  iconWidget: Image.network(controller
                                              .fengLudataList[index].length >
                                          3
                                      ? "${AppValues.defaultBranch.asset_url}/currency/${controller.fengLudataList[index][3].currencyId}.webp"
                                      : ""),
                                  direction: Direction.right,
                                  widgetHeight: AppValues.iconSmallSize,
                                  name: controller.fengLudataList[index].length > 3
                                      ? controller.fengLudataList[index][3].amount != "0.00"
                                          ? controller.fengLudataList[index][3].amount
                                          : "-"
                                      : "-",
                                  style: TextStyle(
                                      fontFamily: LangUtil().isZhCn() ? "Akrobat-Bold" : null,
                                      color: ThemeService().colorScheme.onTertiary,
                                      fontWeight:
                                          LangUtil().isZhCn() ? FontWeight.w600 : FontWeight.w500,
                                      fontSize: AppValues.fontBodyMediumSize))
                              .tight(width: 100 * widthRate),
                        ]).tight(height: 54),
                  );
                })
            .tight(
                width: showDailyBonusColumn == true
                    ? (width - AppValues.defaultPadding * 2) * 1.4
                    : (width - AppValues.defaultPadding * 2)),
      ),
    ].toColumn();
  }

  // VIP规则说明
  Widget buildRules() {
    return controller.pageType! == "vipClub"
        ? const SizedBox()
        : <Widget>[
            CustomText(S.current.vip_rule_title,
                style: ThemeService()
                    .theme
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            for (int i = 0; i < controller.ruleTitles.length; i++)
              _buildRule(i).paddingTop(AppValues.margin_24)
          ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .paddingAll(AppValues.margin_24)
            .backgroundColor(ThemeService().theme.colorScheme.surface)
            .clipRRect(all: 8.0)
            .constrained()
            .paddingBottom(30);
  }

  // 规则条目
  Widget _buildRule(index) {
    final titleStyle =
        ThemeService().theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600);
    final desStyle = ThemeService().theme.textTheme.titleSmall?.copyWith(
          fontSize: AppValues.fontTileSmallSize,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFB1BAD3),
        );
    return <Widget>[
      CustomText(controller.ruleTitles[index], style: titleStyle),
      const SizedBox(height: AppValues.halfPadding),
      CustomText(controller.ruleContents[index], style: desStyle),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }
}

// class VipInfoRowWidget extends StatelessWidget {
//   const VipInfoRowWidget({super.key});
//   final VipLevelModel model;
//   @override
//   Widget build(BuildContext context) {
//     return <Widget>[CustomText(data)].toRow();
//   }
// }
