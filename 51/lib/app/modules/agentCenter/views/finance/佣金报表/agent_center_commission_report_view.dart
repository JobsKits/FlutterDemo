import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/controllers/agent_center_commission_report_controller.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/佣金报表/AgentPage.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/JobsSegmentTabs.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

/// 佣金报表 ✅
void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgentCenterCommissionReportView(),
    ));

class AgentCenterCommissionReportView extends GetView<AgentCenterCommissionReportController> {
  const AgentCenterCommissionReportView({super.key});

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
      const AgentPage(),
      const AgentPage(),
      const AgentPage(),
      const AgentPage(),
      const AgentPage(),
    ];

    return SegmentTabsScaffold(
      title: '佣金报表',
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
