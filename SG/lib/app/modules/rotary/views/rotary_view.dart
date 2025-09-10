import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/rotary/views/share_view.dart';
import 'package:flutter_bet/app/modules/rotary/views/withdrawal_view.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_small_mian_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../pages/activity/all_promotions/all_promotions_view.dart';
import '../../../../pages/alliance_plan/alliance_plan_view.dart';
import '../../../../pages/home/home_logic.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/common_util.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/custom_back_icon_button.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/custom_marquee.dart';
import '../../../../widget/custom_ovalends_progressbar.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/sport/custom_sport_banner.dart';
import '../../../../widget/tab_bar/custom_tabbar_covered.dart';
import '../controllers/rotary_controller.dart';
import 'lucky_wheel_view.dart';
import 'number_animation.dart';

class RotaryView extends GetView<RotaryController> {
  const RotaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackIconButton(
          style: CustomBackIconButtonStyle.normal,
          onTap: controller.back,
        ),
        title: Obx(() {
          return Text(controller.getTitle(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18));
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.isLoading.value && !controller.isError.value ? CommonUtil.buildLoadingView() : _bodyView(context);
      }),
    );
  }

  Widget _topContentView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(
        //   height: 8,
        // ),
        buildMarqueeWidget(),
        const SizedBox(
          height: 8,
        ),
        buildReportWidget(context),
      ],
    );
  }
  Widget buildMarqueeWidget() {
    return Row(
      children: [
        const SizedBox(
          width: 18,
        ),
        Obx(() {
          return CustomNetWorkImage(
            width: 18,
            height: 18,
            imageUrl:
                "${controller.coinIcDomain}${controller.recordData['currency_id'] ?? controller.currencyId.value}${controller.coinIcExtensionName}",
          );
        }),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeService().colorScheme.surface,
                  ),
                ),
              ),
              Marquee(
                speed: 550,
                child: Obx(() {
                  if(controller.coinSymbol.value != ""){
                    print(controller.coinSymbol.value);
                  }
                  return CustomText(
                    // "${controller.uidList.join(" ${S.current.random_text_867} ${controller.symbol.value}${controller.recordData['total_prize']}  ")}",
                    // "${controller.usernameList.join(" ${S.current.random_text_867} ${controller.symbol.value}${controller.recordData['total_prize']}  ")}",
                    controller.usernameList.join(" ${S.current.random_text_867} ${controller.symbol.value}${
                        controller.recordData['total_prize'] ?? "${controller.coinSymbol.value}100"
                    }  "),
                    style: const TextStyle(
                        color: AppThemes.widgetColorWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 18,
        ),
      ],
    );
  }
  Widget buildReportWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppThemes.rotaryReportColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2, // 阴影模糊程度
            offset: const Offset(0, 3), // 阴影偏移量
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomAssetIcon(
                name: 'assets/images/rotary/bill_icon.png',
                size: 37,
              ),
              const SizedBox(
                width: 9,
              ),
              SizedBox(
                width: 90,
                child: Obx(() {
                  return NumberAnimation(
                    startNumber: double.parse(controller.recordData['achieved_prize'] ?? "0.0") / 10,
                    targetNumber: controller.bonus.value,
                  );
                }),
              ),
              const SizedBox(
                width: 10,
              ),
              Obx(() {
                return CustomNetWorkImage(
                  imageUrl:
                      "${controller.coinIcDomain}${controller.recordData['currency_id'] ?? controller.currencyId.value}${controller.coinIcExtensionName}",
                  width: 32,
                  height: 32,
                );
              }),
              const SizedBox(
                width: 9,
              ),
              Obx(() {
                return Visibility(
                  visible: btnTitleVisibility(),
                  child: CustomSmallMainButton(
                    backgroundColor: controller.recordData['state'] == 4
                        ? AppThemes.activityReceivingState
                        : ThemeService().colorScheme.primary,
                    /// 已领取
                    /// "feedback_transfer_received": MessageLookupByLibrary.simpleMessage("已领取"),
                    title: btnTitle () ?? "",
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    width: LangUtil().isZhCn()?60:80,
                    onTap: () {
                      if(controller.recordData.isEmpty){
                        showCustomWithDrawalWidget(
                            context: context,
                            achievedPrize: 0.00,
                            totalPrize: 0.00,
                            state: 1,
                            withdrawType: 222);
                      }else{
                        int state = controller.recordData['state'];
                        if (state == 3 || state == 4) {
                          return;
                        }
                        showCustomWithDrawalWidget(
                            context: context,
                            achievedPrize: controller.bonus.value,
                            totalPrize: double.parse(controller.recordData['total_prize'] ?? "0.0"),
                            state: controller.recordData['state'],
                            withdrawType: controller.recordData['withdraw_type']);
                      }
                    },
                  ),
                );
              })
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Obx(() {
            return Align(
              alignment: Alignment.centerRight,
              child: CustomText(
                "${controller.bonus.value.toStringAsFixed(2)}%\t\t\t",
                style: const TextStyle(
                    color: AppThemes.widgetColorWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            );
          }),
          Container(
            width: double.infinity,
            height: 8,
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Obx(() {
              return CustomPaint(
                painter: OvalEndsProgressBar(
                    progress: controller.bonus.value / 100 > 1 ? 1 : controller.bonus.value / 100,
                    bgColor: AppThemes.deepBlue), // 传入进度值
              );
            }),
          ),
          const SizedBox(
            height: 12,
          ),
          Obx(() => controller.recordData['state'] == 1
              ? undesirable()
              : controller.recordData['state'] == 4
                  ? done()
                  : progressAndDesirable()),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
  Widget undesirable() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          print("AAA"+controller.getShortfallAmount().toString());
          return CustomText(
            /// 您还需要_才能提现到钱包
            "${S.current.random_text_843}${(double.tryParse(controller.getShortfallAmount()) ?? 0) == 0 ? 100.00.toStringAsFixed(2) : controller.getShortfallAmount()} ",/// 您还需要
            style: const TextStyle(
                color: AppThemes.onTertiaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          );
        }),
        CustomNetWorkImage(
          imageUrl:
              "${controller.coinIcDomain}${controller.recordData['currency_id'] ?? controller.currencyId.value}${controller.coinIcExtensionName}",
          width: 14,
          height: 14,
        ),
        CustomText(
          S.current.random_text_844,
          style: const TextStyle(
              color: AppThemes.onTertiaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }
  Widget progressAndDesirable() {
    return Obx(() {
      return controller.recordData['state'] == 2
          ? const CustomText(
              "已满足要求，可提现到钱包",
              style: TextStyle(
                  color: AppThemes.onTertiaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            )
          : controller.recordData['state'] == 5
              ? const CustomText(
                  "当前奖金已提交到系统审核",
                  style: TextStyle(
                      color: AppThemes.onTertiaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
              : undesirable();
    });
  }
  Widget done() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          "获得更多奖金前往",
          style: TextStyle(
              color: AppThemes.onTertiaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 2,
        ),
        InkWell(
          onTap: () {
            AlliancePlanPage.openPage();
          },
          child: const CustomText(
            "联盟计划",
            style: TextStyle(
                color: AppThemes.onTertiaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
  Widget _buildShareView(BuildContext context) {
    return InkWell(
      onTap: () {
        showCustomShareWidget(context: context);
      },
      child: Flex(
        direction: Axis.horizontal,
        children: [
          const SizedBox(
            width: 18,
          ),
          Expanded(
            flex: 2,
            child: Container(
                alignment: Alignment.center,
                height: 39,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2, // 阴影模糊程度
                      offset: const Offset(0, 3), // 阴影偏移量
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4)),
                  color: AppThemes.chatRoomButtonColor,
                ),
                child: CustomText(
                  S.current.random_text_834,
                  textColorStyle:CustomTextColorStyle.dark,
                  style:const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
            ),/// 邀请好友帮忙提款 Colors.black
          ),
          Container(
              height: 39,
              padding: const EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2, // 阴影模糊程度
                    offset: const Offset(0, 3), // 阴影偏移量
                  ),
                ],
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4)),
                color: AppThemes.walletRecommend,
              ),
              child: const CustomAssetIcon(
                name: 'assets/images/rotary/share_icon.png',
                size: 20,
                color: Colors.black,
              )),
          const SizedBox(
            width: 18,
          ),
        ],
      ),
    );
  }
  Widget _tabBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 12, right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: ThemeService().theme.colorScheme.surface, // 设置背景色
      ),
      child: CustomTabBarCoveredIcon(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        sideMargin: const EdgeInsets.symmetric(horizontal: 12),
        tabController: controller.tabController,
        // 将TabController与TabBar关联
        tabs: controller.tab,
        backgroundColor: ThemeService().colorScheme.tertiary,
        radius: 40,
        height: 54,
        buttonMargin: const EdgeInsets.all(AppValues.margin_6),
      ),
    );
  }
  Widget _bodyView(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      primary: false,
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppValues.largePadding,
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    RouteUtil.popView();
                    if (!Get.previousRoute.contains('promotions')) {
                      AllPromotionsPage.openPage();
                    }
                  },
                  child: const CustomIcon(
                    asset: 'assets/images/normal/ic_normal_close.png',
                    size: 16,
                  )),
              const SizedBox(
                width: AppValues.defaultMargin,
              )
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppValues.largePadding,
          ),
        ),
        SliverToBoxAdapter(
          child: _topContentView(context),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 11,
          ),
        ),
        // SliverToBoxAdapter(
        //   child: Obx(() {
        //     return Visibility(
        //       visible: GlobalStateController.of().isLogin.value,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           CustomText(
        //             controller.getTimeOutText(),
        //             style: const TextStyle(
        //                 color: AppThemes.onTertiaryColor, fontSize: 14, fontWeight: FontWeight.w600),
        //             textAlign: TextAlign.center,
        //           ),
        //           const SizedBox(
        //             width: 4,
        //           ),
        //           CustomNetWorkImage(
        //             imageUrl:
        //                 "${controller.coinIcDomain}${controller.recordData['currency_id'] ?? controller.currencyId.value}${controller.coinIcExtensionName}",
        //             width: 14,
        //             height: 14,
        //           ),
        //         ],
        //       )
        //     );
        //   }),
        // ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 4,
          ),
        ),
        /// 轮盘UI
        SliverToBoxAdapter(
          child: Obx(() => LuckyWheelWidget(
                id: controller.id,
                currencyId: controller.currencyId.value,
                isFull: controller.isFull.value,
                times: controller.recordData['left_roll'] ?? HomeLogic.of().state.rollTimes.value,
                onTap: (bonus) => controller.refreshBonus(bonus),
              )),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 4,
          ),
        ),
        SliverToBoxAdapter(
          child: Obx(() {
            return Visibility(
              /// KKK
              visible: controller.recordData['period'] != 0 &&
                  controller.recordData['state'] != 4 &&
                  (controller.recordData['left_roll'] ?? HomeLogic.of().state.rollTimes.value) < 3 &&
                  GlobalStateController.of().isLogin.value,
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    /// 邀请
                    TextSpan(
                      text: S.current.random_text_1089,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ThemeService().theme.colorScheme.onTertiary),
                    ),
                     TextSpan(
                      text: controller.roll_condition.value.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppThemes.widgetColorWhite),
                    ),
                    TextSpan(
                      text: S.current.random_text_1090,/// 个好友
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ThemeService().theme.colorScheme.onTertiary),
                    ),
                    TextSpan(
                      text: "，",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ThemeService().theme.colorScheme.onTertiary),
                    ),
                    TextSpan(
                      text: S.current.random_text_1108,/// 奖励
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ThemeService().theme.colorScheme.onTertiary),
                    ),
                     TextSpan(
                      text: controller.roll_times.value.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          // color: ThemeService().theme.colorScheme.onTertiary
                          color: AppThemes.widgetColorWhite
                      ),
                    ),
                    TextSpan(
                      text: "次抽奖",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ThemeService().theme.colorScheme.onTertiary),
                    ),
                  ])),
            );
          }),
        ),
        SliverToBoxAdapter(
          child: Obx(() {
            return Visibility(
              /// KKK
              visible: controller.recordData['period'] != 0 &&
                  controller.recordData['state'] != 4 &&
                  (controller.recordData['left_roll'] ?? HomeLogic.of().state.rollTimes.value) < 3 &&
                  // GlobalState.instance.isClickLuckyWheel.value &&
                  GlobalStateController.of().isLogin.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // 使两个组件居中对齐
                children: [
                  Visibility(
                    visible: controller.recordData['period'] != 0 &&
                        controller.recordData['state'] != 4 &&
                        GlobalStateController.of().isLogin.value &&
                        controller.day.value > 0,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: S.current.random_text_845(controller.day.value),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ThemeService().theme.colorScheme.onTertiary),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 10), // 添加一个 SizedBox 以便于两个组件之间有间距
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const WidgetSpan(
                        child: SizedBox(
                          width: 4,
                        ),
                      ),
                      TextSpan(
                        text: controller.time.value,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppThemes.widgetColorWhite),
                      ),
                    ]),
                  ),
                ],
              ),
            );
          }),
        ),
        SliverToBoxAdapter(
          child: Obx(() {
            return Visibility(
                visible: controller.recordData['state'] == 4,
                child: CustomText(
                  S.current.random_text_685,/// 已完成
                  textColorStyle: CustomTextColorStyle.normal,
                  textAlign: TextAlign.center,
                ));
          }),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 11,
          ),
        ),
        SliverToBoxAdapter(
          child: _buildShareView(context),
        ),
        SliverToBoxAdapter(
          child: _tabBar(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 15,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            // height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight,
            height: 460,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(), //禁止滑动
                    controller: controller.tabController, // 将TabController与TabBarView关联
                    children: [
                      Obx(() {
                        return _listView(controller.reportList, controller.scrollController);
                      }),
                      // Obx(() {
                      //   return _listView(controller.prizeList, controller.prizeScrollController);
                      // }),
                      Obx(() {
                        return Container(
                            margin: const EdgeInsets.only(left: 12, right: 12),
                            child: SingleChildScrollView(
                                child: Text(
                                  controller.detail.value,
                                  style: const TextStyle(fontSize: 16.0),
                                )
                              // child: Text(
                              //   controller.detail.value,
                              //   style: TextStyle(fontSize: 16.0),
                              // ),
                                // child:Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //     children: <Widget>[
                                //       Text(
                                //           "•",
                                //           style: TextStyle(fontSize: 16.0)
                                //       ),
                                //       Text(
                                //         controller.detail.value,
                                //         style: TextStyle(fontSize: 16.0),
                                //       ),
                                //     ],
                                // ),
                            ));
                      })
                      // EventRulesView()
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Visibility(
            // visible: false,
            child: Container(
                margin: const EdgeInsets.only(left: 40, right: 40,top: 12),
                child: Obx(() => CustomBigMainButton(
                  title: controller.model.value.buttonText,
                  onTap: (btn) {
                    CustomSportBannerState().customSportBanner_onTap(controller.model.value.buttonType!, controller.model.value.buttonRedirect!,true);
                  },
                ))),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100,),
        )
      ],
    );
  }
  Widget _listView(List<dynamic> list, ScrollController? scrollController) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      // 禁止手动滑动
      controller: scrollController,
      itemCount: list.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return _listItem(index, list[index]);
      },
    );
  }
  Widget _listItem(int index, var item) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.symmetric(
          vertical: AppValues.largePadding,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.smallRadius),
          color: index % 2 == 0
              ? ThemeService().colorScheme.surfaceVariant
              : ThemeService().theme.scaffoldBackgroundColor,
        ),
        alignment: Alignment.center,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                // color: Colors.amber,
                alignment: Alignment.center,
                child: CustomText(
                  // controller.maskSensitiveData(item['uid']),
                  controller.maskSensitiveData(item['username']),
                  style: const TextStyle(
                      color: AppThemes.onTertiaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: CustomText(
                  /// 创建时间
                  CommonUtil.getLocalRecentTime(item['created_at']),
                  textColorStyle: CustomTextColorStyle.normal,
                  style: ThemeService().textTheme.bodyMedium,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CustomText(
                      //暂定2位 下周有需要再调整
                      item.containsKey('amount') ? double.parse(item['amount']).toStringAsFixed(2) : double.parse(item['prize']).toStringAsFixed(2),
                      style: ThemeService().textTheme.bodyMedium,
                      textColorStyle: CustomTextColorStyle.normal,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  CustomNetWorkImage(
                    width: 14,
                    height: 14,
                    imageUrl: "${controller.coinIcDomain}${controller.currencyId.value}${controller.coinIcExtensionName}",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? btnTitle(){
    if(controller.recordData['data'] == null){
      return S.current.vault_take_out;/// 取出
    }else{
      if(controller.recordData['state'] == 4){
        return S.current.feedback_transfer_received;
      }else if(controller.recordData['state'] == 5){
        return "审核中";
      }else{
        return S.current.vault_take_out;
      }
    }
  }
  bool btnTitleVisibility(){
    if(controller.recordData['data'] == null){
      return true;
    }else{
      return controller.recordData['automatic'] == 2 || !controller.globalController.isLogin.value;
    }
  }
}
