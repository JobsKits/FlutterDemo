import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';

@Deprecated("测试TabBarView 高度")
class AllianceTabBarViewTest extends StatefulWidget {
  const AllianceTabBarViewTest({Key? key}) : super(key: key);

  @override
  _AllianceTabBarViewTestState createState() => _AllianceTabBarViewTestState();
}

class _AllianceTabBarViewTestState extends State<AllianceTabBarViewTest>
    with SingleTickerProviderStateMixin {
  final List<String> tabs = [
    S.current.random_text_77,
    S.current.random_text_78,
    S.current.random_text_79,
    S.current.random_text_80,
    S.current.random_text_81,
    S.current.random_text_82,
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Column(
          children: <Widget>[
            _buildTabBar(),
            // Container(
            //     color: Colors.purple,
            //     width: MediaQuery.of(context).size.width,
            //     ///一定要给固定高度，可不可以 是动态的呢？
            //     height: 200,
            //     child: _buildTableBarView()),
            Expanded(child: _buildTableBarView()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() => TabBar(
        onTap: (tab) => print(tab),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 16),
        isScrollable: true,
        controller: _tabController,
        labelColor: Colors.blue,
        indicatorWeight: 3,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.orangeAccent,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
      );

  Widget _buildTableBarView() => TabBarView(
      controller: _tabController,
      children: tabs
          .map((e) => Center(
                  child: Text(
                e,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )))
          .toList());
}
