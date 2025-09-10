import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/controllers/agent_center_profit_record_controller.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/我的业绩/ProfitRecordPage.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/JobsSegmentTabs.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgentCenterProfitRecordView(),
    ));

// 我的业绩
class AgentCenterProfitRecordView extends GetView<AgentCenterProfitRecordController>  {
  const AgentCenterProfitRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    const titles = [
      '今天',
      '昨天',
      '7日内',
      '本月',
      '自定义',
    ];

    var pages = [
      const ProfitRecordPage(),
      const ProfitRecordPage(),
      const ProfitRecordPage(),
      const ProfitRecordPage(),
      const ProfitRecordPage(),
    ];

    return SegmentTabsScaffold(
      title: '我的业绩',
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
