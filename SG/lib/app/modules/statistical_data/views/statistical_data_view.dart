import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/statisical_data/StatisicalDataBean.dart';
import '../../../../routes/routes.dart';
import '../../../../services/account_service.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/app_bar/custom_app_bar.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_ovalends_progressbar.dart';
import '../../../../widget/network_image/custom_network_image_placeholder.dart';
import '../../../../widget/tab_bar/custom_tabbar_covered.dart';
import '../controllers/statistical_data_controller.dart';

class StatisticalDataView extends GetView<StatisticalDataController> {
  static openPage() {
    RouteUtil.pushToView(Routes.STATISTICAL_DATA);
    // RouteUtil.pushToView(Routes.testIndexPage);
  }

  const StatisticalDataView(
      {super.key, this.showAppBar = true, this.username = '', this.itemH = 54});

  final bool? showAppBar;
  final String? username;
  final double? itemH;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => StatisticalDataController());
    return showAppBar == true
        ? Scaffold(
            appBar: CustomAppBar(
              appBarTitleText: S.current.data_count_datacopy2,
            ),
            body: _buildView(context),
          )
        : _dialogView();
  }

  Widget _dialogView() {
    // return Obx(() {
    controller.username = username ?? "";
    controller.showAppBar = showAppBar ?? true;
    return Column(
      children: [
        _tabBar(),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(), //禁止滑动
            controller: controller.tabController, // 将TabController与TabBarView关联
            children: [
              _dataView(),
              _dataView(),
              _dataView(),
              // _tabbarView()
            ],
          ),
        ),
        // _tabbar(),
        // _tabbarView(),
      ],
    );
    // });
  }

  Widget _buildView(BuildContext context) {
    return Obx(() {
      return !controller.isLoadComplete.value
          ? SizedBox(
              height: 150,
              child: CustomNetWorkImagePlaceholder(
                color: AppThemes.surfaceVariant.withOpacity(0),
                placeholderType: NetWorkImagePlaceholderType.loading,
              ))
          : _body(context);
    });
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        _buildTop(),
        _tabBar(),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(), //禁止滑动
            controller: controller.tabController, // 将TabController与TabBarView关联
            children: [
              _dataView(),
              _dataView(),
              _dataView(),
            ],
          ),
        ),
        // Container(padding: EdgeInsets.only(left: 10,right: 10),child: _tabbar()),
        // _tabbarView(),
      ],
    );
  }

  Widget _tabBar() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: ThemeService().theme.colorScheme.surface, // 设置背景色
      ),
      child: CustomTabBarCoveredIcon(
        tabController: controller.tabController,
        // 将TabController与TabBar关联
        tabs: controller.tabs,
        backgroundColor: ThemeService().theme.colorScheme.tertiary,
        radius: 49,
        height: 54,
        buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      ),
    );
  }

  Widget _tabbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.only(left: 6, right: 6),
        margin:
            const EdgeInsets.only(top: AppValues.defaultPadding, bottom: AppValues.defaultPadding),
        height: 54,
        decoration: BoxDecoration(
          color: ThemeService().colorScheme.surface,
          borderRadius: BorderRadius.circular(27),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: controller.tabs
              .asMap()
              .keys
              .map(
                (index) => GestureDetector(
                  onTap: () => controller.onTap(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: index == controller.pageIndex.value
                          ? ThemeService().theme.colorScheme.tertiary
                          : Colors.transparent,
                    ),
                    child: controller.tabs[index],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _tabbarView() {
    return Expanded(
        child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      // controller: controller.scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: controller.tabs.length,
      itemBuilder: (context, index) {
        return _dataView();
      },
    ));
  }

  Widget _dataView() {
    return SizedBox(
        width: Get.width,
        // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        child: Obx(() => controller.loadingData.value
            ? Center(
                child: SizedBox(
                    height: 150,
                    child: CustomNetWorkImagePlaceholder(
                      color: AppThemes.surfaceVariant.withOpacity(0),
                      placeholderType: NetWorkImagePlaceholderType.loading,
                    )))
            : _listView()));
  }

  Widget _listView() {
    return Obx(() => controller.statisticalData.isEmpty
        ? CustomEmptyWidget(
            imgPath: "assets/images/data_empty_1.png",
            text: S.current.random_text_1206,
          )
        : Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    // color: ThemeService().colorScheme.surface, //v3已下架
                  ),
                  child: mainView(),
                ),
              ),
              if (showAppBar!)
                const SizedBox(
                  height: 24,
                ),
            ],
          ));
  }

  Widget _buildTop() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: <Widget>[
        // Image.asset(
        //     "assets/images/personal_center_icon/vip_level/svg-vip-back.webp"),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: CustomText(
                '${AccountService.sharedInstance.currentUser?.username}',
                style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                textColorStyle: CustomTextColorStyle.normal,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            CustomText(
              '${S.current.random_text_357copy2}${controller.getJoinTime()}',
              style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
              textColorStyle: CustomTextColorStyle.normal,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.animate();
                    GlobalState.instance.index = 3;
                    DialogUtils.goToPage(Routes.personalVip);
                  },
                  child: Obx(() {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      transform:
                          Matrix4.translationValues(controller.state.xOffset.value, 0.0, 0.0),
                      child: Row(
                        children: [
                          CustomText(S.current.vip_your_progress,
                              style: ThemeService()
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 8,
                          ),
                          const CustomAssetIcon(
                              name: "assets/images/personal_center_icon/ic_vip_next.webp"),
                        ],
                      ),
                    );
                  }),
                ),
                CustomText("${(controller.completeRate).toInt()}%",
                    style:
                        ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            Container(
              width: double.infinity,
              height: 16,
              margin: const EdgeInsets.only(top: 12),
              // child: CustomVipProgressIndicator(
              //   value: controller.completeRate.value==0?0.5:0,
              // ),
              child: Obx(() {
                log("进度 ${controller.completeRate.value}");
                return CustomPaint(
                  painter: OvalEndsProgressBar(
                      progress: controller.completeRate.value / 100 > 1
                          ? 1
                          : controller.completeRate.value / 100), // 传入进度值
                );
              }),
            ),
            const SizedBox(
              height: 12,
            ),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.network(
                          "${BranchService().current.asset_url}/images/vip/${controller.currentUser.vip!}.webp",
                          width: 27,
                          height: 24),
                      // SvgPicture.asset("assets/svg/vip_level/viplevel_${controller.currentUser.vip!}.svg", width: 27, height: 24),
                      const SizedBox(
                        width: 6,
                      ),
                      CustomText(
                        controller.currentAlias.value,
                        // 'VIP${AccountService.sharedInstance.getUserInfo().vip}' ??
                        //     S.current.vip_level,
                        textColorStyle: CustomTextColorStyle.normal,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: AppValues.fontTileSmallSize),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: controller.currentLevel.value == "50" ? false : true,
                        child: Image.network(
                            "${BranchService().current.asset_url}/images/vip/${controller.vipLevel}.webp",
                            width: 27,
                            height: 24),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Visibility(
                        visible: controller.currentLevel.value == "50" ? false : true,
                        child: CustomText(
                          controller.nextAlias.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: AppValues.fontTileSmallSize),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
            // const SizedBox(
            //   height: AppValues.margin_20,
            // ),
          ],
        ),
      ].toStack(),
    );
  }

  Widget mainView() {
    return Obx(() => Column(
          children: [
            betView(),
            if (controller.showDetail.value)
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: CustomBigMainButton(
                  title: S.current.random_text_766,
                  colorStyle: CustomButtonColorStyle.tertiary,
                  onTap: (btr) {
                    controller.showDetail.value = !controller.showDetail.value;
                  },
                ),
              )
          ],
        ));
  }

  Widget betView() {
    return Scrollbar(
        child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() => SizedBox(
            width: controller.allWidth.value,
            height: showAppBar!
                ? (controller.showDetail.value
                    ? 300
                    : (GetPlatform.isIOS ? Get.height - 342 - 38 : Get.height - 342))
                : (controller.showDetail.value ? 188 : 240), //225
            child: Column(
              children: [
                Container(
                    // margin: const EdgeInsets.only(left: 12, right: 12),
                    padding: const EdgeInsets.symmetric(
                      // horizontal: AppValues.defaultPadding,
                      vertical: AppValues.largePadding,
                    ),
                    // color: ThemeService().colorScheme.surfaceVariant,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.center,
                          width: controller.currencyWidth.value,
                          child: Obx(() => CustomText(
                                controller.showDetail.value
                                    ? S.current.random_text_358
                                    : S.current.random_text_560,
                                textAlign: TextAlign.center,
                                textColorStyle: CustomTextColorStyle.normal,
                              )),
                        ),
                        Container(
                            // color: Colors.amber,
                            alignment: Alignment.center,
                            width: controller.countWidth.value,
                            child: CustomText(
                              S.current.random_text_561,
                              textAlign: TextAlign.center,
                              textColorStyle: CustomTextColorStyle.normal,
                            )),
                        Obx(() => Container(
                            // color: Colors.red,
                            alignment: Alignment.center,
                            width: controller.betWidth.value,
                            child: CustomText(
                              S.current.random_text_51,
                              textAlign: TextAlign.center,
                              textColorStyle: CustomTextColorStyle.normal,
                            ))),
                        Obx(() => Container(
                            // color: Colors.amber,
                            alignment: Alignment.center,
                            width: controller.winWidth.value,
                            child: CustomText(S.current.random_text_562,
                                textAlign: TextAlign.center,
                                textColorStyle: CustomTextColorStyle.normal))),
                      ],
                    )),
                _buildList(),
              ],
            ),
          )),
    ));
  }

  _buildList() {
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          itemCount: !controller.showDetail.value
              ? controller.statisticalData.length
              : controller.detailList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            if (controller.showDetail.value) {
              // 其他情况返回 _listItem
              return _listItem(index, controller.detailList[index]);
            }
            // showDetail 为 false 时返回 _listItem
            return _listItem(index, controller.statisticalData[index]);
          },
        ),
      );
    });
  }

  Widget _listItem(int index, StatisicalDataBean model) {
    return InkWell(
      onTap: () {
        if (controller.showDetail.value) {
          return;
        }
        controller.showDetail.value = !controller.showDetail.value;
        if (controller.showDetail.value) {
          List<StatisicalDataBean> data =
              (model.detail as List<dynamic>).map<StatisicalDataBean>((dynamic item) {
            return StatisicalDataBean.fromJson(item);
          }).toList();
          controller.detailList.assignAll(data);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          // horizontal: AppValues.defaultPadding,
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
            Container(
              // color: Colors.red,
              alignment: Alignment.center,
              width: controller.currencyWidth.value,
              child: controller.showDetail.value
                  ? CustomText(
                      controller.getTime(model.betTime),
                      textColorStyle: CustomTextColorStyle.normal,
                    )
                  : CustomNetWorkImage(
                      imageUrl:
                          "${controller.coinIcDomain}${model.currencyId}${controller.coinIcExtensionName}",
                      width: 18,
                      height: 18,
                    ),
            ),
            Container(
              // color: Colors.amber,
              alignment: Alignment.center,
              width: controller.countWidth.value,
              child: CustomText(
                '${model.betCount}',
                style: const TextStyle(
                    color: AppThemes.sportBetOddColor, fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            Obx(() => Container(
                  // color: Colors.red,
                  alignment: Alignment.center,
                  width: controller.betWidth.value,
                  child: CustomText(
                    '${model.validBetAmount}',
                    style: ThemeService().textTheme.bodyMedium,
                  ),
                )),
            Obx(() => Container(
                  // color: Colors.amber,
                  alignment: Alignment.center,
                  width: controller.winWidth.value,
                  child: CustomText(
                    '${model.netAmount}',
                    style: ThemeService().textTheme.bodyMedium,
                    textColorStyle: (model.netAmount ?? "0").contains("-")
                        ? CustomTextColorStyle.error
                        : CustomTextColorStyle.green,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
