import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadController.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadList.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/FinanceCommonMixin.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';

// 入口
void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgentPage(),
    ));

class AgentPage extends StatefulWidget {
  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage>
    with FinanceCommonToolsMixin, FinanceCommonWidgetMixin {
  // ✅ 分页控制器
  late final JobsRefreshLoadController<CommissionItem> _rl;

  @override
  void initState() {
    super.initState();
    // ✅ 初始化分页（把 fetchPage 换成你的真实 API）
    _rl = JobsRefreshLoadController<CommissionItem>(
      pageSize: 20,
      fetchPage: (page, size) async {
        // TODO: 接后端时替换为真实请求
        await Future.delayed(const Duration(milliseconds: 300));
        final all = List<CommissionItem>.from(_items); // 模拟全量数据源
        final start = (page - 1) * size;
        final end = (start + size).clamp(0, all.length);
        if (start >= all.length) return [];
        return all.sublist(start, end);
      },
    );
  }

  @override
  void dispose() {
    _rl.dispose();
    super.dispose();
  }

  // ====== 模拟数据 ======
  List<CommissionItem> get _items => [
        CommissionItem(
            total: 884.35,
            direct: 912.37,
            others: 997.36,
            settledAt: DateTime(2025, 4, 2, 16, 12, 41)),
        CommissionItem(
            total: 866.83,
            direct: 1136.45,
            others: 1454.56,
            settledAt: DateTime(2025, 4, 2, 16, 12, 41)),
        CommissionItem(
            total: 1480.78,
            direct: 664.63,
            others: 783.85,
            settledAt: DateTime(2025, 4, 2, 16, 12, 41)),
        CommissionItem(
            total: 1454.20,
            direct: 792.85,
            others: 567.62,
            settledAt: DateTime(2025, 4, 2, 16, 12, 41)),
        CommissionItem(
            total: 1163.37,
            direct: 981.99,
            others: 1350.91,
            settledAt: DateTime(2025, 4, 2, 16, 12, 41)),
        CommissionItem(
            total: 964.48,
            direct: 954.90,
            others: 1287.29,
            settledAt: DateTime(2025, 4, 2, 16, 12, 41)),
        CommissionItem(
            total: 779.88,
            direct: 956.78,
            others: 1177.21,
            settledAt: DateTime(2025, 4, 2, 16, 12, 41)),
        CommissionItem(
            total: 1442.12,
            direct: 1331.88,
            others: 756.75,
            settledAt: DateTime(2025, 4, 2, 16, 12, 41)),
        CommissionItem(
            total: 601.81,
            direct: 1384.06,
            others: 1156.86,
            settledAt: DateTime(2025, 4, 2, 16, 12, 41)),
        CommissionItem(
            total: 1144.27,
            direct: 1090.66,
            others: 1388.41,
            settledAt: DateTime(2025, 4, 2, 16, 12, 41)),
      ];

  @override
  Widget build(BuildContext context) {
    // 汇总（基于“当前已加载的数据”；真正项目建议后端返回全量汇总字段）
    final totalSum = _rl.items.fold<double>(0, (a, b) => a + b.total);
    final directSum = _rl.items.fold<double>(0, (a, b) => a + b.direct);
    final othersSum = _rl.items.fold<double>(0, (a, b) => a + b.others);

    return [
      // ====== 顶部汇总条 ======
      darkPanel(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: [
          summaryCell(label: '总佣金', value: fmtMoney(totalSum)),
          vDivider(),
          summaryCell(label: '直属佣金', value: fmtMoney(directSum)),
          vDivider(),
          summaryCell(label: '其他佣金', value: fmtMoney(othersSum)),
        ].row(),
      ),
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
                financeCell('总佣金',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    )),
                financeCell('直属佣金',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    )),
                financeCell('其他佣金',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    )),
                financeCell('结算时间',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ))
              ].row(),
            ),

            // ✅ 下拉刷新 + 上拉加载（内置斑马纹 / 分割线）
            Expanded(
              child: JobsRefreshLoadList<CommissionItem>(
                controller: _rl,
                refreshColor: const Color(0xFFFED49C),
                zebra: true,
                zebraOddColor: const Color(0xFF262C39),
                zebraEvenColor: const Color(0xFF1E232F),
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFF2B3140)),
                // 空态
                emptyBuilder: (_) => JobsEmptyView(),
                // 底部：加载中
                footerLoadingBuilder: (_) => JobsLoadingView(),
                // 底部：没有更多
                footerNoMoreBuilder: (_) => JobsNoMoreView(),
                itemBuilder: (_, e, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: [
                      financeCell(fmtMoney(e.total),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(fmtMoney(e.direct),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(fmtMoney(e.others),
                          style: const TextStyle(
                            color: Color(0xFFFED49C),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          )),
                      // 两行显示可用：'${e.settledAt.ymd}\n${e.settledAt.hms}'
                      financeCell(fmtDate(e.settledAt),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          )),
                    ].row(),
                  );
                },
              ),
            ),
          ].column(),
        ),
      ),
    ].column();
  }
}
