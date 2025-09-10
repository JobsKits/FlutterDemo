// 会员报表
import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/controllers/agent_center_member_report_controller.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/会员报表/MemberRecordPage.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/JobsSegmentTabs.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgentCenterMemberReportView(),
    ));

class AgentCenterMemberReportView extends GetView<AgentCenterMemberReportController> {
  const AgentCenterMemberReportView({super.key});

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
      const MemberRecordPage(),
      const MemberRecordPage(),
      const MemberRecordPage(),
      const MemberRecordPage(),
      const MemberRecordPage(),
    ];

    return SegmentTabsScaffold(
      title: '会员报表',
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
