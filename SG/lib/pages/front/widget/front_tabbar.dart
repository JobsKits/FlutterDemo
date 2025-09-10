import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../services/theme/theme_service.dart';
import '../../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../../../widget/tab_bar/custom_expand_tab_bar_with_icon.dart';

class FrontTabbar extends StatelessWidget{
  final List<Tab> tabs;
  final TabController? tabController;

  const FrontTabbar({super.key,required this.tabs,this.tabController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.surface, // 设置背景色
          borderRadius: BorderRadius.circular(30.0), // 设置圆角的半径
        ),
          child: CustomTabBarWithIcon(
            tabs: tabs,
            tabController: tabController,
            backgroundColor: ThemeService().theme.colorScheme.tertiary,
            radius: 25,
            height: 50,
            buttonMargin:const EdgeInsets.all(5),
          ),
      ),
    );
  }

}