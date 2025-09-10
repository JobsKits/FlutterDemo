import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/notifis/announcement.dart';
import 'package:flutter_bet/pages/notifs/children/announcement/view.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_home/view.dart';
import 'package:flutter_bet/pages/notifs/widget/notifs_dismiss.dart';
import 'package:flutter_bet/pages/notifs/widget/notifs_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/notifs/widget/notifs_loding.dart';
import 'package:flutter_bet/pages/notifs/widget/notifs_no_entries.dart';
import 'package:flutter_bet/pages/notifs/widget/notifs_type.dart';
import 'package:flutter_bet/pages/personal_center/transactions/detail_wallet/binding.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/string_uril.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/refresh/custom_pull_to_refresh.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'logic.dart';
import 'package:get/get.dart';

/// 通知Page-消息列表
class NotifsPage extends BaseView<NotifsLogic> {
  NotifsPage({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    controller.ctx = context;
    return CustomAppBar(
      showLeading: false,
      titleView: _buildTransactionsTitle(),
      backgroundColor: ThemeService().theme.scaffoldBackgroundColor,
    );
  }

  @override
  bool resizeToAvoidBottomInset() {
    return false;
  }

  /// 构建title
  Widget _buildTransactionsTitle() {
    return <Widget>[
      const CustomIcon(asset: 'assets/images/top_notification.png', size: AppValues.iconSize_20),
      const SizedBox(width: AppValues.extraSmallMargin),
      CustomText(S.current.random_text_1170,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      const Spacer(),
      const CustomIcon(
              asset: 'assets/images/normal/ic_normal_close.png', size: AppValues.iconSize_20)
          .marginOnly(left: AppValues.defaultMargin)
          .center()
          .onTap(() {
        RouteUtil.popView();
      })
    ].toRow();
  }

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<NotifsLogic>(
        id: "notifs_index",
        builder: (controller) {
          // 无数据展示判断
          final isNoEntries = controller.notifsInfos.isEmpty;

          // 是否为有奖反馈
          final isFeedback = controller.typeSelIndex == controller.typeTitles.length - 1;

          return <Widget>[
            const SizedBox(height: AppValues.defaultPadding),
            // Tab选择器
            NotifsTypeTab(
              titles: controller.typeTitles,
              selIndex: controller.typeSelIndex,
              callback:controller.typeDidSelIndex,
              tabController: controller.tabController,
              bgColor: ThemeService().colorScheme.surface,
            ).paddingHorizontal(AppValues.defaultPadding),

            // 有奖反馈
            FeedbackHomePage().visibility(isFeedback),

            // 消息列表
            CustomPullToRefresh(
                onRefresh: () async {
                  controller.onRefresh();
                },
                onLoadMore: () async {
                  controller.onLoadMore();
                },
                controller: controller.pullToRefreshController,
                noMoreWidget: controller.notifsInfos.length > 10
                    ? CustomText(S.current.random_text_727, style: ThemeService().theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w400, color: CustomTextColorStyle.secondary.value))
                    : const SizedBox(),
                child: <Widget>[
                  const SizedBox(height: AppValues.defaultPadding),
                  // 全部已读(仅通知/站内信)
                  buildTextButtons()
                      .visibility(controller.typeSelIndex == 0 || controller.typeSelIndex == 1),
                  buildNotifsList()
                ].toColumn()
            ).expanded().visibility(!isNoEntries),

            // Loding
            NotifsLoding().visibility(controller.isInitLoding).visibility(!isFeedback),

            // 无数据
            const NotifsNoEntries()
                .visibility(isNoEntries)
                .visibility(!isFeedback)
                .visibility(!controller.isInitLoding),
            
            // 底部Tabbar高度
            SizedBox(height: AppValues.barBottomHeight),
          ].toColumn().backgroundColor(ThemeService().theme.scaffoldBackgroundColor);
        });
  }

  /// 构建 新推出/标记全部为已读
  Widget buildTextButtons() {

    final textStyle     = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
    final btnTitleWidth = StringUtil.textWidth(S.current.notifs_as_read, textStyle!);

    return <Widget>[
      CupertinoButton(
        padding: const EdgeInsets.all(0.0),
        child: CustomText(
            S.current.notifs_as_read,
            style: textStyle,
            textColorStyle: CustomTextColorStyle.secondary,
        ).width(200),
        onPressed: () {
          controller.notifsStateAllRead();
        },
      ).tight(width: btnTitleWidth, height: 22),
    ].toRow(mainAxisAlignment: MainAxisAlignment.end).paddingHorizontal(AppValues.defaultPadding);
  }

  /// 构建 消息列表
  Widget buildNotifsList() {
    return ListView.separated(
        itemCount: controller.notifsInfos.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        scrollDirection: Axis.vertical,
        separatorBuilder:  (context, index) => const SizedBox(height: AppValues.defaultPadding),
        itemBuilder: (ctx, index) {
          return _buildItem(index, controller.notifsInfos[index]);
        }).paddingTop(AppValues.defaultPadding);
  }

  /// 消息列表Item
  Widget _buildItem(index, info) {
    switch (controller.typeSelIndex) {
      case 0:
        final item = NotifsItem(model: info).onTap(() {
          controller.notifsState(info);
          // 通知-finance财务
          if(info.type == "finance") {
            final trModel = info.trWalletModel;
            showCustomTrWalletDetailsWidget(
                context: Get.context!,
                transactionsType: trModel.transactionsType,
                coinType: trModel.coinType,
                info: trModel);
          }
        });

        // 左滑删除
        final dismissItem = NotifsDismissWidget(
          child: item,
          callback: () {
            controller.notifsDelete(info);
          },
        );
        // 已读item/并且非进行中 有删除功能
        return !info.isUnread &&
            info.title != "withdraw_in_process" &&
            info.title != "deposit_in_process" ? dismissItem : item;
      case 1:
      case 2:
      final item = NotifsAnnouncementItem(model: info).onTap(() {
        showCustomAnnouncementPage(
            context: Get.context!,
            title: controller.typeTitles[controller.typeSelIndex],
            model: info as AnnouncementModel);
        controller.notifsState(info);
      });

      // 左滑删除
      final dismissItem = NotifsDismissWidget(
        child: item,
        callback: () {
          controller.notifsDelete(info);
        },
      );

      // 站内信并且已读有删除功能
      return (controller.typeSelIndex == 1) && !(info.isUnread)
          ? dismissItem : item;

      default:
        return const SizedBox();
    }
  }

  /// item 左滑删除动画相关
  void scrollToStartOrEnd(ScrollController scrollController) {
    // 判断当前滚动位置
    if (scrollController.offset == 0) {
      // 如果滚动到了顶部，则滚动到底部
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // 如果没有滚动到顶部，则滚动到顶部
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

}
