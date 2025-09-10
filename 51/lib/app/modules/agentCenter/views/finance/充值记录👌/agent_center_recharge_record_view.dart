import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/controllers/agent_center_recharge_record_controller.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E5%85%85%E5%80%BC%E8%AE%B0%E5%BD%95%F0%9F%91%8C/RechargeRecord.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/JobsSegmentTabs.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgentCenterRechargeRecordView(),
    ));

// 充值记录
class AgentCenterRechargeRecordView extends GetView<AgentCenterRechargeRecordController> {
  const AgentCenterRechargeRecordView({super.key});

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
      const RechargeRecord(),
      const RechargeRecord(),
      const RechargeRecord(),
      const RechargeRecord(),
      const RechargeRecord(),
    ];

    return SegmentTabsScaffold(
      title: '充值记录',
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
