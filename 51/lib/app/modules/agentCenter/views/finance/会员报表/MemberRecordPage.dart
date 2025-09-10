import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadController.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadList.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/FinanceCommonMixin.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onText.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onWidgets.dart';

class MemberRecordPage extends StatefulWidget {
  const MemberRecordPage({super.key});
  @override
  State<MemberRecordPage> createState() => _MemberRecordPageState();
}

class _MemberRecordPageState extends State<MemberRecordPage>
    with FinanceCommonToolsMixin, FinanceCommonWidgetMixin {
  late List<DayGroup> groups;

  // ✅ 新增：下拉刷新 + 上拉加载控制器
  late final JobsRefreshLoadController<MemberRecordItem> _rl;

  @override
  void initState() {
    super.initState();
    groups = _mock();

    // ✅ 初始化分页控制器（把 fetchPage 换成你的真实 API 即可）
    _rl = JobsRefreshLoadController<MemberRecordItem>(
      pageSize: 20,
      fetchPage: (page, size) async {
        // TODO: 接后端时替换为真实请求；这里用本地 _items 做分页示例
        await Future.delayed(const Duration(milliseconds: 300));
        final all = List<MemberRecordItem>.from(_items);
        final start = (page - 1) * size;
        final end = (start + size).clamp(0, all.length);
        if (start >= all.length) return [];
        return all.sublist(start, end);
      },
    );
  }

  @override
  void dispose() {
    _rl.dispose(); // ✅ 释放控制器
    super.dispose();
  }

  // ====== 模拟数据 ======
  List<MemberRecordItem> get _items => [
        MemberRecordItem(
          usrID: 884.35,
          profitAndLoss: 884.35,
          amount: 912.37,
          totalCommission: 11.2,
          registerTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        MemberRecordItem(
          usrID: 884.35,
          profitAndLoss: 884.35,
          amount: 912.37,
          totalCommission: 11.2,
          registerTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        MemberRecordItem(
          usrID: 884.35,
          profitAndLoss: 884.35,
          amount: 912.37,
          totalCommission: 11.2,
          registerTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        MemberRecordItem(
          usrID: 884.35,
          profitAndLoss: 884.35,
          amount: 912.37,
          totalCommission: 11.2,
          registerTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        MemberRecordItem(
          usrID: 884.35,
          profitAndLoss: 884.35,
          amount: 912.37,
          totalCommission: 11.2,
          registerTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        MemberRecordItem(
          usrID: 884.35,
          profitAndLoss: 884.35,
          amount: 912.37,
          totalCommission: 11.2,
          registerTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        MemberRecordItem(
          usrID: 884.35,
          profitAndLoss: 884.35,
          amount: 912.37,
          totalCommission: 11.2,
          registerTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        MemberRecordItem(
          usrID: 884.35,
          profitAndLoss: 884.35,
          amount: 912.37,
          totalCommission: 11.2,
          registerTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
      ];

  num get total => groups.fold<num>(0, (a, g) => a + g.subtotal);

  @override
  Widget build(BuildContext context) {
    return [
      // ===== 顶部搜索栏（保持你的风格） =====
      [
        darkTextField(
          height: 26,
          controller: TextEditingController(),
          hint: memberHint,
          leading: const Icon(Icons.search, size: 18, color: Color(0xFF9AA3B2)),
        ).expanded(), // ← 给 Row 一个有限宽度
        const SizedBox(width: 12),
        Text(searchButtonText)
            .sizeBy(w: 57, h: 26)
            .radiusBy(4)
            .bgCorByInt(0xFFFED49C)
            .onTap(() {
          // ✅ 点搜索后触发刷新（把你的筛选条件带进 fetchPage 即可）
          _rl.refresh();
        }),
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
                financeCell('投注赢亏',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('下注流水',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('累计提成',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('注册时间',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
              ].row(),
            ),

            // ✅ 下拉刷新 + 上拉加载（内置行条纹）
            Expanded(
              child: JobsRefreshLoadList<MemberRecordItem>(
                controller: _rl,
                refreshColor: const Color(0xFFFED49C),
                zebra: true,
                zebraOddColor: const Color(0xFF262C39),
                zebraEvenColor: const Color(0xFF1E232F),
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFF2B3140)),
                itemBuilder: (_, e, i) {
                  // 行内容
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: [
                      financeCell(fmtMoney(e.usrID),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(fmtMoney(e.profitAndLoss),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(fmtMoney(e.amount),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(fmtMoney(e.totalCommission),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(fmtDate(e.registerTime),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 11,
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
    final items = List.generate(
      3,
      (_) => AgentRecord(relation: '(直属) 7848121', delta: 2312.00, time: t),
    );
    return [
      DayGroup(DateTime(2025, 6, 17), items),
      DayGroup(DateTime(2025, 6, 17), items), // 仅为演示重复分组
    ];
  }
}
