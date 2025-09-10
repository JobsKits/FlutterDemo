import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/notifis/announcement.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import 'index.dart';

/// 公告/跑马灯 详情
class AnnouncementPage extends GetView<AnnouncementController> {
  AnnouncementPage(this.title, this.model, {Key? key}) : super(key: key);

  final String title;
  final AnnouncementModel model;

  // 主视图
  Widget _buildView() {

    final titleStyle   = ThemeService().theme.textTheme.titleLarge?.
    copyWith(fontWeight: FontWeight.w600);
    final contentStyle = ThemeService().theme.textTheme.bodyMedium?.
    copyWith(fontWeight: FontWeight.w500, color: CustomTextColorStyle.secondary.value);

    return <Widget>[
      _buildTransactionsTitle(),
      const SizedBox(height: AppValues.defaultPadding),
      <Widget>[
        CustomText(model.title, style: titleStyle, maxLines: 3),
        const SizedBox(height: AppValues.defaultPadding),
        CustomText(model.content, style: contentStyle, maxLines: 100).width(double.infinity),
        const SizedBox(height: AppValues.defaultPadding).visibility(model.lgImageUrl != null),
      ].toColumn(mainAxisSize: MainAxisSize.min).visibility(!model.isImgType),
      Image.network(
        model.imgUrl,
        width: double.infinity,
      ).visibility(model.isImgType),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min);
  }


  /// 构建title
  Widget _buildTransactionsTitle() {

    final iconPath = (title == S.current.notifs_site_message)
        ? 'assets/images/notice/email_e.webp' : 'assets/images/notice/announcement_e.webp';

    return <Widget>[
      Image.asset(iconPath, width: AppValues.iconSize_18, height: AppValues.iconSize_18,),
      const SizedBox(width: AppValues.extraSmallMargin),
      CustomText(
          title,
          style: ThemeService().theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)
      ),
      const Spacer(),
      const CustomIcon(
          asset: 'assets/images/normal/ic_normal_close.png'
      ).onTap(() {RouteUtil.popView();})
    ].toRow();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnnouncementController>(
        init: AnnouncementController(),
        id: "announcement",
        builder: (_) {
          return Container(
              constraints: BoxConstraints(
                minHeight: Get.height / 2.3,
              ),
              child: _buildView()
          ).marginAll(AppValues.defaultMargin)
              .backgroundColor(ThemeService().theme.scaffoldBackgroundColor)
              .clipRRect(all: AppValues.smallRadius);
        }
    );
  }
}


const kCustomAnnouncementPage = 'CustomAnnouncementPage';

Future<void> showCustomAnnouncementPage({
  required BuildContext context,
  required String title,
  required AnnouncementModel model,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show(
      context: context,
      tag: kCustomAnnouncementPage,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
          child: AnnouncementPage(title, model).onTap(() { }),
        ).onTap(() {
          RouteUtil.popView();
        });
      });
}