import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_detail/view.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_home/widgets/feedback_item.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_home/widgets/feedback_tab.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_insert/view.dart';
import 'package:flutter_bet/pages/notifs/widget/notifs_loding.dart';
import 'package:flutter_bet/pages/notifs/widget/notifs_no_entries.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import 'index.dart';

/// 意见反馈首页
class FeedbackHomePage extends GetView<FeedbackHomeController> {
  FeedbackHomePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(context) {
    final isNoEntries = controller.notifsInfos.isEmpty;
    /// 反馈详情页面
    bool isFeedBackDetail = (controller.selIndex.value != 10000);
    if (isFeedBackDetail) {
      return FeedbackDetailPage(controller.feedbackDetailBack);
    }

    return <Widget>[

      const SizedBox(height: AppValues.defaultMargin),

      // 创建反馈 / 我的反馈 选择器
      NotifsFeedBackTab(
        titles: controller.feedbackTitles,
        selIndex: controller.feedbackSelIndex,
        bonus: controller.bonus,
        callback: controller.feedbackDidSelIndex,
        callbackPopBonus: controller.popFeedbackBonusWidget,
      ),

      const SizedBox(height: AppValues.defaultMargin),

      // 创建反馈
      FeedbackInsertPage().visibility(controller.feedbackSelIndex == 0),

      // 无数据
      _buildNoEntries()
          .visibility(isNoEntries)
          .visibility(controller.feedbackSelIndex != 0)
          .visibility(!controller.isInitLoding),

      NotifsLoding()
          .center().expanded()
          .visibility(controller.feedbackSelIndex == 1)
          .visibility(controller.isInitLoding),
      buildNotifsList().visibility(controller.feedbackSelIndex == 1),
    ].toColumn().expanded();
  }
  /// 构建 消息列表
  Widget buildNotifsList() {
    return ListView.builder(
        itemCount: controller.notifsInfos.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (ctx, index) {
          final info = controller.notifsInfos[index];
          return NotifsFeedbackItem(feedbackInfo: controller.notifsInfos[index]).onTap(() {
            controller.feedbackDetail(index);
          });
        }).expanded();
  }

  /// 列表无数据
  Widget _buildNoEntries() {

    final titleStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: AppThemes.textColorSecondary);

    return <Widget>[
      const CustomAssetIcon(
          name: "assets/images/status/ic_status_view_feedback_available.webp",
          size: 84
      ),
      const SizedBox(height: AppValues.defaultMargin),
      CustomText(
          "暂无内容",
          style: titleStyle,
      )
    ].toColumn(mainAxisAlignment: MainAxisAlignment.center).height(Get.height * 0.35);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedbackHomeController>(
      init: FeedbackHomeController(),
      id: "feedback_home",
      builder: (_) {
        controller.ctx = context;
        return _buildView(context);
      },
    );
  }
}
