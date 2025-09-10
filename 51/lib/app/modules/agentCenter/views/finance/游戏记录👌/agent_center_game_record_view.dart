import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/controllers/agent_center_game_record_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/JobsSegmentTabs.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E6%B8%B8%E6%88%8F%E8%AE%B0%E5%BD%95%F0%9F%91%8C/GameRecordsPage.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

// 游戏记录 ✅
void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgentCenterGameRecordView(),
    ));

class AgentCenterGameRecordView
    extends GetView<AgentCenterGameRecordController> {
  const AgentCenterGameRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    const titles = [
      '今天',
      '昨天',
      '7日内',
      '本月',
      '自定义',
    ];

    // print(
    // 'reqDataList====> ${data[0]} ${data.length} ${response.data['count']}');

    print(controller.dataList);

    var pages = [
      GameRecordsPage(title: titles[0]),
      GameRecordsPage(title: titles[1]),
      GameRecordsPage(title: titles[2]),
      GameRecordsPage(title: titles[3]),
      GameRecordsPage(title: titles[4]),
    ];

    return SegmentTabsScaffold(
      title: '游戏记录',
      tabs: titles,
      pages: pages,
      bodyBuilder: (context, index, onTap, tabs, pages) {
        return [
          SegmentBar(
            items: tabs,
            currentIndex: index,
            onTap: onTap,
          ),
          const SizedBox(height: 8),
          Expanded(child: IndexedStack(index: index, children: pages)),
        ].column();
      },
    );
  }
}
