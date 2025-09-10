import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'package:get/get.dart';

enum TabbarType {transactionsType, coinType, otherType}

class TransactionsTabbar extends StatelessWidget {
  final TabbarType type;
  final List<String> titles;
  final int selIndex;
  /// 选中回调
  final Function(int)? callback;

  /// otherType TabController
  final TabController? tabController;

  TransactionsTabbar({
    super.key,
    required this.type,
    required this.titles,
    required this.selIndex,
    this.callback,
    this.tabController
  });

  final colorScheme = ThemeService().colorScheme;
  final titleStyle  = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TabbarType.transactionsType:
        return _buildtransactions();
      case TabbarType.coinType:
        return _buildCoin();
      case TabbarType.otherType:
        return _buildOtherType();
    }
  }

  Widget _buildtransactions() {
    /// 平分样式
    return <Widget>[
      for(int index = 0; index < titles.length; index++)
        CustomText(titles[index], style: titleStyle)
            .paddingSymmetric(horizontal: AppValues.largePadding, vertical: AppValues.halfPadding)
            .center()
            .backgroundColor(index == selIndex ?  colorScheme.tertiary : Colors.transparent)
            .onTap((){index == selIndex ? null : callback?.call(index);})
            .clipRRect(all: 40).expanded()
    ].toRow()
        .marginAll(AppValues.extraSmallMargin)
        .backgroundColor(colorScheme.surface)
        .height(54)
        .clipRRect(all: 40);
  }

  // 虚拟币/法币
  Widget _buildCoin() {
    return <Widget>[
      for(int index = 0; index < titles.length; index++)
        CustomText(titles[index], style: titleStyle)
            .onTap((){index == selIndex ? null : callback?.call(index);})
            .paddingSymmetric(horizontal: AppValues.largePadding, vertical: AppValues.halfPadding)
            .center()
            .backgroundColor(index == selIndex ?  colorScheme.tertiary : Colors.transparent)
            .clipRRect(all: 40)
    ].toRow(mainAxisSize: MainAxisSize.min)
        .marginAll(AppValues.extraSmallMargin)
        // .backgroundColor(colorScheme.surface)
        .backgroundColor(const Color(0xff1A2C38))
        .height(54)
        .clipRRect(all: 40);
  }


  // 其它-类型选择
  Widget _buildOtherType() {

    final titleStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    var tabs = titles
        .map((label) => Tab(child: Text(label, style: titleStyle)))
        .toList();


    return Container(
        decoration: BoxDecoration(
          color: const Color(0xff1A2C38),
          borderRadius: BorderRadius.circular(AppValues.radius_12 * 2),
        ),
        child: DefaultTabController(
          length: tabs.length,
          child: CustomTabBarWithIcon(
            unselectedLabelStyle: ThemeService()
                .theme
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
            labelStyle: ThemeService()
                .theme
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
            tabController: tabController,
            tabs: tabs,
            backgroundColor: ThemeService().theme.colorScheme.tertiary,
            radius: AppValues.sportRadius_23,
            contentColor: const Color(0xff1A2C38),
            height: 54,
            buttonMargin: const EdgeInsets.all(6),
            isShowScrollBar: true,
            onTap: ((index){
              index == selIndex ? null : callback?.call(index);
            }),
          ),
        ));


    // return <Widget>[
    //   for(int index = 0; index < titles.length; index++)
    //     CustomText(titles[index], style: titleStyle)
    //         .onTap((){index == selIndex ? null : callback?.call(index);})
    //         .paddingSymmetric(horizontal: AppValues.largePadding, vertical: AppValues.halfPadding)
    //         .center()
    //         .backgroundColor(index == selIndex ?  colorScheme.tertiary : Colors.transparent)
    //         .clipRRect(all: 40)
    // ].toListView(scrollDirection: Axis.horizontal)
    //     .marginAll(AppValues.extraSmallMargin)
    //     .backgroundColor(const Color(0xff1A2C38))
    //     // .backgroundColor(colorScheme.surface)
    //     .height(54)
    //     .clipRRect(all: 40);
  }

}



/*


/// 其它-类型选择 底部线条顺序铺样式

    return <Widget>[
      const SizedBox(width: 20).border(bottom: 1, color:colorScheme.tertiary),

      for(int index = 0; index < titles.length; index++)
        CustomText(titles[index],
            style: titleStyle,
            textColorStyle: index == selIndex ? CustomTextColorStyle.white : CustomTextColorStyle.secondary
        ).paddingSymmetric(horizontal: AppValues.padding_16, vertical: AppValues.halfPadding)
            .constrained()
            .onTap((){index == selIndex ? null : callback?.call(index);}).center()
            .border(bottom: 1, color: index == selIndex ? colorScheme.primary : colorScheme.tertiary),

      const SizedBox(width: 20).border(bottom: 1, color:colorScheme.tertiary),
    ].toListView(scrollDirection: Axis.horizontal)
        .height(33)
        .clipRRect(all: AppValues.smallRadius);

    /// 加密货币/法定货币 底部线条平分样式
    // return <Widget>[
    //   for(int index = 0; index < titles.length; index++)
    //     CustomText(titles[index],
    //         style: titleStyle,
    //         textColorStyle: index == selIndex ? CustomTextColorStyle.white : CustomTextColorStyle.secondary
    //     ).paddingSymmetric(horizontal: AppValues.defaultPadding, vertical: AppValues.halfPadding)
    //         .constrained()
    //         .onTap((){index == selIndex ? null : callback?.call(index);}).center()
    //         .clipRRect(all: AppValues.smallRadius)
    //         .border(bottom: 1, color: index == selIndex ? colorScheme.primary : colorScheme.tertiary)
    //         .expanded()
    // ].toRow()
    //     .height(33)
    //     .clipRRect(all: AppValues.smallRadius);


    /// 顺序铺样式
    return <Widget>[
      for(int index = 0; index < titles.length; index++)
        CustomText(titles[index], style: titleStyle)
            .onTap((){index == selIndex ? null : callback?.call(index);})
            .paddingSymmetric(horizontal: AppValues.largePadding, vertical: AppValues.halfPadding)
            .center()
            .backgroundColor(index == selIndex ?  colorScheme.tertiary : Colors.transparent)
            .clipRRect(all: 40)
    ].toListView(scrollDirection: Axis.horizontal)
        .marginAll(AppValues.extraSmallMargin)
        .backgroundColor(colorScheme.surface)
        .height(54)
        .clipRRect(all: 40);


    // var tabs = titles
    //     .map((label) => Tab(child: Text(label, style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))))
    //     .toList();

    // return DefaultTabController(
    //   length: titles.length,
    //   initialIndex: selIndex,
    //   child: CustomTabBarWithIcon(
    //     unselectedLabelStyle:
    //     ThemeService().theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
    //     labeStyle:
    //     ThemeService().theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
    //     tabs: tabs,
    //     backgroundColor: ThemeService().theme.colorScheme.tertiary,
    //     radius: AppValues.sportRadius_23,
    //     height: 44,
    //     buttonMargin: const EdgeInsets.all(5),
    //     onTap: ((index){index == selIndex ? null : callback?.call(index);}),
    //   ),
    // ).backgroundColor(ThemeService().colorScheme.surface)
    //     .height(54)
    //     .clipRRect(all: 40);

 */
