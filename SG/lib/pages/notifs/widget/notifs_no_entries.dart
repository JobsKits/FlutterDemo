import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

/// 列表无数据
class NotifsNoEntries extends StatelessWidget {
  const NotifsNoEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return  _buildNoEntries();
  }

  /// 列表无数据
  Widget _buildNoEntries() {
    return <Widget>[
      const CustomAssetIcon(
          name: "assets/images/status/ic_status_view_noti_available.webp",
          size: AppValues.marginBelowVerticalLine
      ),
      const SizedBox(height: AppValues.defaultMargin),
      CustomText(
        S.current.notifs_available,
        style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: AppValues.padding_2),
      CustomText(
          S.current.notifs_available_tip,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          textColorStyle: CustomTextColorStyle.secondary
      )
    ].toColumn(mainAxisAlignment: MainAxisAlignment.center).expanded();
  }
}
