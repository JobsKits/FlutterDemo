import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/string_uril.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

/// 通知/站内信/公告... Tabbar 选择器
class NotifsTypeTab extends StatelessWidget {
  final List<String> titles;
  final int selIndex;
  final TabController tabController;
  Color? bgColor;

  /// 选中回调
  final Function(int)? callback;

  NotifsTypeTab({
    super.key,
    required this.titles,
    required this.selIndex,
    required this.tabController,
    this.bgColor,
    this.callback,
  });

  final colorScheme = ThemeService().colorScheme;
  final titleStyle =
      ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    double minWidth = AppValues.extraSmallMargin * 2 + AppValues.largePadding * 2 * titles.length;
    for (var titleString in titles) {
      minWidth += StringUtil.textWidth(titleString, titleStyle!);
    }
    // 是否为滚动风格
    bool isScroll   = context.width <= minWidth + 10;

    // 滚动风格
    if (isScroll) {
      final tabs = titles
          .map((label) => Tab(child: Text(label, style: titleStyle)))
          .toList();

      return Container(
        width: double.infinity,
        height: 54,
        // padding: const EdgeInsets.symmetric(vertical: AppValues.extraSmallPadding,horizontal: 8.5),
        // clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: bgColor ?? colorScheme.background, // 设置背景色
            borderRadius: const BorderRadius.all(Radius.circular(27))),
        child: CustomTabBarWithIcon(
          tabController: tabController,
          // isShowScrollBar: true,
          tabs: tabs,
          backgroundColor: ThemeService().theme.colorScheme.tertiary,
          onTap: (index){
            index == selIndex ? null : callback?.call(index);
          },
          radius: 27,
          height: 54,
          buttonMargin: const EdgeInsets.all(AppValues.extraSmallPadding),
        ),
      );
    }

    /// 间隔器均衡风格
    return <Widget>[
      for (int index = 0; index < titles.length; index++) ...[
        _buildItem(index),
        if (index < titles.length - 1) const Spacer(),
      ]
    ]
        .toRow()
        .marginAll(AppValues.extraSmallMargin)
        .backgroundColor(bgColor ?? colorScheme.background)
        .height(54)
        .clipRRect(all: 40);
  }


  Widget _buildItem(index) {
    return CustomText(titles[index], style: titleStyle)
        .paddingSymmetric(horizontal: AppValues.largePadding, vertical: AppValues.halfPadding)
        .center()
        .backgroundColor(index == selIndex ? colorScheme.tertiary : Colors.transparent)
        .onTap(() {
      index == selIndex ? null : callback?.call(index);
    }).clipRRect(all: 40);
  }
}


/*  顺序铺风格
    var tabs = titles
        .map((label) => Tab(child: Text(label, style: ThemeService().theme.textTheme.bodyMedium)))
        .toList();

    return DefaultTabController(
      length: titles.length,
      initialIndex: selIndex,
      child: CustomTabBarWithIcon(
        unselectedLabelStyle:
        ThemeService().theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        labelStyle:
        ThemeService().theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        tabs: tabs,
        backgroundColor: ThemeService().theme.colorScheme.tertiary,
        radius: AppValues.sportRadius_23,
        height: 44,
        buttonMargin: const EdgeInsets.all(5),
        onTap: ((index){index == selIndex ? null : callback?.call(index);}),
      ),
    ).backgroundColor(ThemeService().colorScheme.surface)
        .height(54)
        .clipRRect(all: 40);


    return ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        for (int index = 0; index < titles.length; index++) ...[
          _buildItem(index),
        ]
      ])
          .marginAll(AppValues.extraSmallMargin)
          .backgroundColor(bgColor ?? colorScheme.background)
          .height(54)
          .clipRRect(all: 40);


* */

