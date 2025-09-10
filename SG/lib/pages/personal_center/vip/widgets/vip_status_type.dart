import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

/// 通知/站内信/公告... Tabbar 选择器
class VipTypeTab extends StatelessWidget {
  VipTypeTab(
      {super.key,
      required this.titles,
      required this.selIndex,
      this.callback,
      required this.icons});

  final List<String> titles;
  final List<String> icons;

  final int selIndex;

  /// 选中回调
  final Function(int)? callback;

  final colorScheme = ThemeService().colorScheme;
  final titleStyle =
      ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    // 顺序铺样式
    return <Widget>[
      for (int index = 0; index < titles.length; index++)
        <Widget>[
          Container(padding: EdgeInsets.zero, width: 14, height: 7)
              .paddingZero
              .backgroundColor(index == selIndex
                  ? ThemeService().colorScheme.secondaryContainer
                  : Colors.transparent)
              .clipRRect(bottomLeft: 3, bottomRight: 3),
          <Widget>[
            SvgPicture.asset(
              index == selIndex
                  ? "assets/svg/" + icons[index] + "_selected.svg"
                  : "assets/svg/" + icons[index] + "_unselected.svg",
              color: index == selIndex ? Colors.white : ThemeService().colorScheme.onTertiary,
            ).tightSize(15),
            CustomText(
              titles[index],
              style: ThemeService().textTheme.bodySmall!.copyWith(
                  color: index == selIndex ? Colors.white : ThemeService().colorScheme.onTertiary),
            ),
          ].toColumn().paddingTop(AppValues.halfPadding / 2).paddingBottom(AppValues.halfPadding)
        ]
            .toColumn(mainAxisAlignment: MainAxisAlignment.spaceEvenly)
            .onTap(() {
              index == selIndex ? null : callback?.call(index);
            })
            .paddingHorizontal(AppValues.defaultPadding)
            .constrained(
                minWidth: titles.length > 4
                    ? (Get.width - AppValues.defaultPadding * 2) / titles.length
                    : 414 / 5,
                maxWidth: LangUtil().getLangType() != "vi_VN" &&
                        LangUtil().getLangType() != "pt_BR" &&
                        !LangUtil().isEnIn()
                    ? 414 / 4
                    : 230)
    ]
        .toListView(scrollDirection: Axis.horizontal)
        .backgroundColor(AppThemes.oddBackColor)
        .height(50)
        .clipRRect(all: 4);
  }

  Widget _buildItem(index) {
    return CustomText(titles[index], style: titleStyle)
        .onTap(() {
          index == selIndex ? null : callback?.call(index);
        })
        .paddingSymmetric(horizontal: AppValues.largePadding, vertical: AppValues.halfPadding)
        .center()
        .backgroundColor(index == selIndex ? colorScheme.tertiary : Colors.transparent)
        .clipRRect(all: 40);
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
* */