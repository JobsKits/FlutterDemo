import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tabbar_covered.dart';

class ChatRoomUserInfoTabBarWidget extends StatefulWidget {
  final List<Tab> tabs;
  final List<Widget> children;
  final void Function(int)? onTap;

  const ChatRoomUserInfoTabBarWidget(
      {super.key, required this.tabs, required this.children,this.onTap});

  @override
  State<StatefulWidget> createState() => _ChatRoomUserInfoTabBarWidget();
}

class _ChatRoomUserInfoTabBarWidget extends State<ChatRoomUserInfoTabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        Future.delayed(const Duration(milliseconds: 250),(){
          if (pageIndex == _tabController.index) return;
          if (widget.onTap != null) widget.onTap!(_tabController.index);
          pageIndex = _tabController.index;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
                color: ThemeService().colorScheme.surface, // 设置背景色
                borderRadius: BorderRadius.circular(27)),
            child: CustomTabBarCoveredIcon(
              tabController: _tabController,
              // 将TabController与TabBar关联
              tabs: widget.tabs,
              labeStyle: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
              backgroundColor: ThemeService().theme.colorScheme.tertiary,
              radius: 27,
              height: 54,
              buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6,right: 6),
              contentPadding:const EdgeInsets.symmetric(horizontal: 6),
              sideMargin:const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          CustomAutoLayoutTabBarView(
              physics: const NeverScrollableScrollPhysics(), //禁止滑动
              controller: _tabController, // 将TabController与TabBarView关联
              children: widget.children),
        ],
      ),
    );
  }
}
