import 'dart:developer';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/widget/cell/custom_tooltip_hint_widget.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/status/custom_load_state_view.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../controllers/global_state_controller.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/tab_bar/custom_tab_bar_point_view.dart';
import '../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../../../widget/share/custom_share_widget_item.dart';
import '../../../widget/share/custom_share_widget_list.dart';
import '../../../widget/measure/custom_measure_size_widget.dart';
import 'my_promotion_grid_item_widget.dart';
import 'my_promotion_logic.dart';
import 'my_promotion_view_card.dart';
import 'my_promotion_view_card_model.dart';

///联盟计划-tab-我的推广界面
class MyPromotionPage extends StatefulWidget {
  const MyPromotionPage({Key? key}) : super(key: key);

  @override
  State<MyPromotionPage> createState() => _MyPromotionPageState();
}

class _MyPromotionPageState extends State<MyPromotionPage> with AutomaticKeepAliveClientMixin {
  final logic = Get.put(MyPromotionLogic());

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<MyPromotionLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      return Container(
        height: logic.refreshCtrl.getMeasureHeight(500),
        child: CustomLoadStateLayout(
          configState: logic.pageStateObs.value,
          configRetry: (pageState) => logic.loadNetData(isRefresh: true, isFirst: true),
          showErrorRetry: false,
          showEmptyRetry: false,
          showNetErrorRetry: false,
          configSuccess: CustomRefreshView(
              controller: logic.refreshCtrl,
              // physics: const ClampingScrollPhysics(),
              physics: const NeverScrollableScrollPhysics(),
              refreshOnStart: false,
              isCanRefresh: false,
              isCanLoadMore: false,
              onRefreshAction: (refreshController) {
                logic.loadNetData(isRefresh: true, isFirst: false);
              },
              child: CustomMeasureSizeWidget(
                onChange: (size) {
                  logic.refreshCtrl.measureHeight = size.height;
                },
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.max,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    // const SizedBox(height: AppValues.defaultPadding),
                    _buildLinkInfoView(context),
                    SizedBox(height: AppValues.defaultMargin),
                    _buildTabView(),
                    SizedBox(height: AppValues.defaultMargin),
                    _buildTabBarGridView(),
                    // _buildCardInfo(),
                    // _buildCardListView(),
                  ],
                ),
              )),
        ),
      );
    });
  }

  ///推广信息- 新版
  _buildLinkInfoView(BuildContext context) {
    return Container(
      color: ThemeService().theme.colorScheme.surface, // 设置背景色
      padding: const EdgeInsets.only(left: 12, right: 16, top: 12, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //二维码
                _buildQrView(context),
                const SizedBox(width: AppValues.defaultPadding),
                //推广连接
                Expanded(child: _buildLinkView()),
              ],
            ),
          ),
          const SizedBox(height: 10),

          //分享
          CustomShareListWidget(shareLinkValue: logic.getLink()),
          // GridView(
          //   padding: EdgeInsets.zero,
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     // maxCrossAxisExtent: 54,
          //     crossAxisCount: 5,
          //     childAspectRatio: 1.0, //宽高比为2
          //     mainAxisSpacing: 6, //主轴方向的间距
          //     crossAxisSpacing: 6, //横轴方向子元素的间距
          //   ),
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   children: logic.shareModelList
          //       .map((model) => CustomShareWidget(
          //             model: model,
          //             onItemClick: (model) => logic.onClickShareLaunchLink(context, model.typeEnum),
          //           ))
          //       .toList(),
          // ),
        ],
      ),
    );
  }

  _buildQrView(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          const SizedBox(height: 2),
          CustomButton(
            padding: EdgeInsets.zero,
            onTap: () => logic.onClickSaveQr(context),
            child: RepaintBoundary(
              key: logic.qrGlobalKey,
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                // margin: const EdgeInsets.all(6),
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                child: QrImageView(
                  // size: 100,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  version: QrVersions.auto,
                  data: logic.getLink(),
                ),
                // CustomNetWorkImage(
                //     imageUrl:
                //         "https://support.content.office.net/zh-cn/media/0fe67add-a793-408e-ae9b-f98f80841480.png"),
              ),
            ),
          ),
          //点击保存 二维码。 为什么要在这里显示， 适配多语言，一行显示
          Container(
            // alignment: LangService().isChinese ? Alignment.center : null,
            // width: LangService().isChinese ? 100 : null,
            alignment: Alignment.bottomCenter,
            width: 100,
            margin: EdgeInsets.only(top: AppValues.margin_6),
            child: CustomButton(
              padding: EdgeInsets.zero,
              onTap: () => logic.onClickSaveQr(context),
              child: CustomText(
                S.current.random_text_154,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: ThemeService()
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      );
    });
  }

  _buildLinkView() {
    return Container(
      // height: 100,
      margin: const EdgeInsets.only(bottom: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomText(S.current.random_text_533, style: ThemeService().textTheme.labelLarge),
          const SizedBox(height: 1),
          Expanded(
            child: Container(
              //由复制按钮来撑开
              padding: const EdgeInsets.only(
                // horizontal: AppValues.halfPadding,
                // vertical: AppValues.defaultPadding,
                left: AppValues.halfPadding,
                top: AppValues.halfPadding,
              ),
              // color: ThemeService().colorScheme.tertiary,
              decoration: BoxDecoration(
                color: ThemeService().colorScheme.tertiary,
                // border: Border.all(color: const Color(0xFF557086), width: 1.0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomText(
                      logic.getLink(),
                      // '123',
                      style: ThemeService().textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CustomTooltipHintWidget(
                    contentWidget: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          // vertical: AppValues.halfPadding,
                          ),
                      child: CustomAssetIcon(
                        name: "assets/images/alliance/ic_alliance_copy.webp",
                        size: 12,
                      ),
                    ),
                    contentTip: S.current.random_text_1221,
                    contentBack: logic.getLink(),
                    onTriggered: (data) {
                      Clipboard.setData(ClipboardData(text: data));
                      // logic.onClickCopyLink(context, toast: false);
                    },
                  ),
                  // InkWell(
                  //   child: const Padding(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: AppValues.defaultPadding,
                  //       vertical: AppValues.halfPadding,
                  //     ),
                  //     child: CustomAssetIcon(
                  //       name: "assets/images/alliance/ic_alliance_copy.webp",
                  //       size: 12,
                  //     ),
                  //   ),
                  //   onTap: () => logic.onClickCopyLink(context),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildTabView() {
    // return  Container(
    //   width: Get.width,
    //   alignment: Alignment.center,
    //   margin: const EdgeInsets.symmetric(
    //     horizontal: AppValues.defaultPadding,
    //     // vertical: AppValues.defaultMargin,
    //   ),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(49),
    //     color: ThemeService().theme.colorScheme.surface, // 设置背景色
    //   ),
    //   child: CustomTabBarWithIcon(
    //      isLogin: true,
    //      tabController: logic.tabController,
    //      // controller: controller.tabController,
    //      // 将TabController与TabBar关联
    //      tabs: logic.tabList,
    //      backgroundColor: ThemeService().theme.colorScheme.tertiary,
    //      radius: 44,
    //      height: 54,
    //      buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
    //      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    //    ),
    // );
    return Container(
      // width: Get.width,
      alignment: Alignment.center,
      color: ThemeService().theme.colorScheme.surface, // 设置背景色
      child: CustomTabBarPointView(
        indicatorColor: ThemeService().theme.colorScheme.secondary,
        tabController: logic.tabController,
        tabs: logic.tabList,
        isScrollable: !GlobalStateController.of().isChinese(),
      ),
    );
  }

  _buildTabBarGridView() {
    return Obx(() {
      return _createGridView(logic.cardModelListObs[logic.tabIndexObs.value]);
    });
  }

  _createGridView(List<MyPromotionCardItemModel> modelList) {
    return GridView.builder(
      itemCount: modelList.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // maxCrossAxisExtent: 54,
        crossAxisCount: 2,
        childAspectRatio: LangService().isChinese ? 2.1 : 1.80, //宽高比为2
        // childAspectRatio: 2.0, //宽高比为2
        mainAxisSpacing: 10, //主轴方向的间距
        crossAxisSpacing: 10, //横轴方向子元素的间距
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => MyPromotionGridItemWidget(
        model: modelList[index],
        coinBean: logic.getUsdtCoin(),
      ),
    );
  }
}
