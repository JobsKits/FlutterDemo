import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/controllers/agent_center_recharge_record_controller.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E5%85%85%E5%80%BC%E8%AE%B0%E5%BD%95%F0%9F%91%8C/RechargeRecordQueryController.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadController.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadList.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/FinanceCommonMixin.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onText.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onWidgets.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class RechargeRecord extends StatefulWidget {
  const RechargeRecord({super.key});
  @override
  State<RechargeRecord> createState() => _RechargeRecordState();
}

class _RechargeRecordState extends State<RechargeRecord>
    with FinanceCommonToolsMixin, FinanceCommonWidgetMixin {
  late List<DayGroup> groups;
  num get total => groups.fold<num>(0, (a, g) => a + g.subtotal);
  // 下拉刷新 + 上拉加载控制器
  late final JobsRefreshLoadController<RechargeRecordItem> _rl;
  late final RechargeRecordQueryController q;
  late final AgentCenterRechargeRecordController s;

  @override
  void initState() {
    super.initState();
    groups = _mock();
    q = Get.put(RechargeRecordQueryController());
    s = Get.find();

    _rl = JobsRefreshLoadController(
      pageSize: 10,
      fetchPage: (page, size) async {
        return await s.reqDataList(page: page, size: size);
      },
    );
  }

  @override
  void dispose() {
    _rl.dispose(); // ✅ 释放
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return [
      // ===== 顶部搜索栏（保持你的风格） =====
      [
        darkTextField(
          height: 26,
          controller: q.memberCtrl,
          hint: memberHint,
          leading: const Icon(Icons.search, size: 18, color: Color(0xFF9AA3B2)),
        ).expanded(),
        const SizedBox(width: 12),
        Text(searchButtonText)
            .sizeBy(w: 57, h: 26)
            .radiusBy(4)
            .bgCorByInt(0xFFFED49C)
            .onTap(() async {
          // ✅ 点搜索后触发刷新（可携带你的查询条件到 fetchPage）
          String? rQuery = q.buildQuery();
          if (rQuery == null || rQuery.isEmpty) {
            showToast("请输入会员ID");
            return;
          } else {
            s.username.value = rQuery;
            s.reqDataList(page: 1,size: 10);
            await _rl.refresh();
          }
        })
      ]
          .row(crossAxisAlignment: CrossAxisAlignment.center)
          .style
          .radiusBy(10)
          .paddingBy(const EdgeInsets.symmetric(vertical: 12, horizontal: 10))
          .bgCorByInt(0xFF252837)
          .sizeBy(height: 48),
      const SizedBox(height: 12),
      // ====== 列表面板 ======
      Expanded(
        child: darkPanel(
          child: [
            // 表头
            Container(
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFF262C39),
                borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                border: Border(bottom: BorderSide(color: Color(0xFF2B3140))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: [
                financeCell('会员ID',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('充值方式',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('充值金额',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('充值时间',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
              ].row(),
            ),
            // ✅ 下拉刷新 + 上拉加载（行条纹已内置）
            Expanded(
              child: JobsRefreshLoadList<RechargeRecordItem>(
                controller: _rl,
                refreshColor: const Color(0xFFFED49C),
                zebra: true,
                zebraOddColor: const Color(0xFF262C39),
                zebraEvenColor: const Color(0xFF1E232F),
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFF2B3140)),
                itemBuilder: (_, e, i) {
                  return Padding(
                    key: ValueKey('$i-${e.usrID}-${e.rechargeTime}'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: [
                      financeCell(e.usrID.toString(),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(e.rechargeStyle,
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(e.rechargeValue,
                          style: const TextStyle(
                            color: Color(0xFFFED49C),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          )),
                      // ✅ 支持带 \n 的两行时间
                      financeCell(e.rechargeTime,
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          )),
                    ].row(),
                  );
                },
                // 空态
                emptyBuilder: (_) => JobsEmptyView(),
                // 底部：加载中
                footerLoadingBuilder: (_) => JobsLoadingView(),
                // 底部：没有更多
                footerNoMoreBuilder: (_) => JobsNoMoreView(),
              ),
            ),
          ].column(),
        ),
      ),
    ].column();
  }

  // ======= 演示数据 =======
  List<DayGroup> _mock() {
    final t = DateTime(2025, 4, 2, 16, 12, 41);
    final items = List.generate(3,
        (_) => AgentRecord(relation: '(直属) 7848121', delta: 2312.00, time: t));
    return [
      DayGroup(DateTime(2025, 6, 17), items),
      DayGroup(DateTime(2025, 6, 17), items), // 仅为演示重复分组
    ];
  }
}
