import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_route_listen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/app_themes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/button/custom_small_mian_button.dart';
import '../../../widget/button/custom_small_outline_button.dart';
import '../../../widget/dialog/dialog_utils.dart';
import 'logic.dart';

class AlliancePage extends BaseView<AllianceLogic> {
  final GlobalKey _widgetKey = GlobalKey(); // 创建一个GlobalKey

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return CustomAppBar(
      titleView: Text(S.current.alliance_program), //CustomTopAppBarView(),
      showLeading: false,
    );
    ;
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return GetBuilder<AllianceLogic>(
        id: "alliance_page",
        builder: (context1) {
          return <Widget>[
            buildTitle(context),
            buildContent(),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
        });
  }

  Widget buildContent() {
    if (controller.selectedString == S.current.alliance_summary) {
      return buildGaiShu();
    } else if (controller.selectedString == S.current.alliance_plan) {
      return buildBaoLiuJiHua();
    } else if (controller.selectedString == S.current.alliance_recommendation) {
      return buildTuiJianYongHu();
    } else if (controller.selectedString == S.current.alliance_activity) {
      return buildGaiShu();
    } else {
      return const SizedBox();
    }
  }

  Widget buildTitle(context) {
    return CustomSmallMainButton(
      onTap: () {
        DialogUtils.showCustomBubbleDialog(context, _viewBubbleChild(), 98,
            widgetKey: _widgetKey, height: 156);
      },
      key: _widgetKey,
      title: controller.selectedString,
    ).paddingLeft(50).paddingTop(20);
  }

  _viewBubbleChild() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              RouteUtil.popView();
              controller.selectedChanged(S.current.alliance_summary);
            },
            child: Text(
              S.current.alliance_summary,
              style: ThemeService().theme.textTheme.bodySmall?.copyWith(
                  color: AppThemes.textColorDark, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              RouteUtil.popView();
              controller.selectedChanged(S.current.alliance_plan);
            },
            child: Text(
              S.current.alliance_plan,
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              RouteUtil.popView();
              controller.selectedChanged(S.current.alliance_recommendation);
            },
            child: Text(
              S.current.alliance_recommendation,
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              RouteUtil.popView();
              controller.selectedChanged(S.current.alliance_activity);
            },
            child: Text(
              S.current.alliance_activity,
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // build 概述
  Widget buildGaiShu() {
    return <Widget>[
      Text(
        S.current.random_text_28,
        style: ThemeService().theme.textTheme.bodyMedium,
      ),
      Text(
        S.current.random_text_29,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(20),
      Text(
        S.current.random_text_30,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(20),
      <Widget>[
        const CustomSmallMainButton(
          title: 'stake.com/?c=67799d424b',
          textColor: Colors.blue,
          fontSize: 14,
        ).paddingTop(10),
        CustomButton(
          title: S.current.random_text_31,
        ).randomBackgroundColor().paddingTop(10),
      ].toRow(),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30).paddingTop(10);
  }

  // build 保留计划
  Widget buildBaoLiuJiHua() {
    return <Widget>[
      Text(
        S.current.random_text_32,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(20),
      Text(
        S.current.random_text_33,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(20),
      Text(
        S.current.random_text_34,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(20),
      Text(
        S.current.random_text_35,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(10),
      Text(
        S.current.random_text_36,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(10),
      Text(
        S.current.random_text_37,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(10),
      Text(
        S.current.random_text_38,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(10),
      Text(
        S.current.random_text_39,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(10),
      Text(
        S.current.random_text_39,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(10),
      Text(
        S.current.random_text_40,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(10),
      Text(
        S.current.random_text_41,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(20),
      Text(
        S.current.random_text_42,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(20),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).paddingHorizontal(30).paddingTop(20);
  }

  // build 推荐用户
  Widget buildTuiJianYongHu() {
    return <Widget>[
      Text(
        S.current.alliance_activity_name,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(10),
      CustomSmallOutlineButton(
              title: AccountService.sharedInstance.currentUser?.username ?? "" + S.current.random_text_44)
          .paddingTop(10),
      Text(
        S.current.alliance_sort,
        style: ThemeService().theme.textTheme.bodyMedium,
      ).paddingTop(10),
      CustomSmallOutlineButton(title: S.current.random_text_46).paddingTop(10),
    ].toColumn().paddingHorizontal(30);
  }
}
