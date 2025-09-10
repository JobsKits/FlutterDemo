import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/controllers/agent_center_commission_record_controller.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/提成记录/CommissionRecordPage.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/JobsSegmentTabs.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onWidgets.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgentCenterCommissionRecordView(),
    ));

/// 提成记录 ✅
class AgentCenterCommissionRecordView extends GetView<AgentCenterCommissionRecordController> {
  const AgentCenterCommissionRecordView({super.key});

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
      const CommissionRecordPage(),
      const CommissionRecordPage(),
      const CommissionRecordPage(),
      const CommissionRecordPage(),
      const CommissionRecordPage(),
    ];

    return SegmentTabsScaffold(
      title: '提成记录',
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
          IndexedStack(index: index, children: pages).expanded(),
        ].column();
      },
    );
  }
}
