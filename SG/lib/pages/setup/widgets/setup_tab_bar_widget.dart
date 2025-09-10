import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';

class SetupTabBarWidget extends StatefulWidget {
  final List<Tab> tabs;
  final List<Widget> children;
  final int pageIndex;
  final TabController? tabController;

  const SetupTabBarWidget(
      {super.key, required this.tabs, required this.children, this.pageIndex = 0,this.tabController});

  @override
  State<StatefulWidget> createState() => _SetupTabBarWidget();
}

class _SetupTabBarWidget extends State<SetupTabBarWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageIndex = widget.pageIndex;
    _tabController = widget.tabController??TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(() {
      KeyboardUtils.hideKeyboard(context);
      setState(() {
        pageIndex = _tabController.index;
      });
    });
    if (pageIndex != 0) {
      Future.delayed(const Duration(milliseconds: 20), () {
        _tabController.animateTo(pageIndex);
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppValues.defaultPadding,),
        Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
              color: ThemeService().colorScheme.surface, // 设置背景色
              borderRadius: const BorderRadius.all(Radius.circular(27))),
          child: CustomTabBarWithIcon(
            tabController: _tabController,
            tabs: widget.tabs,
            backgroundColor: ThemeService().theme.colorScheme.tertiary,
            radius: 27,
            height: 54,
            isShowScrollBar: true,
            buttonMargin: const EdgeInsets.all(6),
          ),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Expanded(
          child: TabBarView(
              physics: const NeverScrollableScrollPhysics(), //禁止滑动
              controller: _tabController, // 将TabController与TabBarView关联
              children: widget.children),
        ),
      ],
    );
  }
}
