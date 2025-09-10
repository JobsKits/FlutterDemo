import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadController.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadList.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/FinanceCommonMixin.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';

class ProfitRecordPage extends StatefulWidget {
  const ProfitRecordPage({super.key});
  @override
  State<ProfitRecordPage> createState() => _ProfitRecordState();
}

class _ProfitRecordState extends State<ProfitRecordPage>
    with FinanceCommonToolsMixin, FinanceCommonWidgetMixin {
  // ✅ 新增：分页控制器
  late final JobsRefreshLoadController<ProfitRecordItem> _rl;

  @override
  void initState() {
    super.initState();
    // ✅ 初始化分页控制器（把 fetchPage 换成你的真实 API）
    _rl = JobsRefreshLoadController<ProfitRecordItem>(
      pageSize: 20,
      fetchPage: (page, size) async {
        // TODO: 接后端时替换为真实请求；这里用本地 _items 做分页示例
        await Future.delayed(const Duration(milliseconds: 300));
        final all = List<ProfitRecordItem>.from(_items);
        final start = (page - 1) * size;
        final end = (start + size).clamp(0, all.length);
        if (start >= all.length) return [];
        return all.sublist(start, end);
      },
    );
  }

  @override
  void dispose() {
    _rl.dispose(); // ✅ 释放
    super.dispose();
  }

  // ====== 模拟数据 ======
  List<ProfitRecordItem> get _items => [
        ProfitRecordItem(
          totalPerformance: 222,
          directPerformance: 333,
          otherPerformance: 444.37,
          calculationTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        ProfitRecordItem(
          totalPerformance: 222,
          directPerformance: 333,
          otherPerformance: 444.37,
          calculationTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        ProfitRecordItem(
          totalPerformance: 222,
          directPerformance: 333,
          otherPerformance: 444.37,
          calculationTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        ProfitRecordItem(
          totalPerformance: 222,
          directPerformance: 333,
          otherPerformance: 444.37,
          calculationTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        ProfitRecordItem(
          totalPerformance: 222,
          directPerformance: 333,
          otherPerformance: 444.37,
          calculationTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
        ProfitRecordItem(
          totalPerformance: 222,
          directPerformance: 333,
          otherPerformance: 444.37,
          calculationTime: DateTime(2025, 4, 2, 16, 12, 41),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return [
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
                financeCell('总业绩',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('直属业绩',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('其他业绩',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('计算时间',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
              ].row(),
            ),

            // ✅ 下拉刷新 + 上拉加载（内置斑马纹 / 分割线）
            Expanded(
              child: JobsRefreshLoadList<ProfitRecordItem>(
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
                      financeCell(fmtMoney(e.totalPerformance),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(fmtMoney(e.directPerformance),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(fmtMoney(e.otherPerformance),
                          style: const TextStyle(
                            color: Color(0xFFFED49C),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                      // 如需两行显示：'${e.calculationTime.ymd}\n${e.calculationTime.hms}'
                      financeCell(fmtDate(e.calculationTime),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 11,
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
