import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onDateTime.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadController.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadList.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/FinanceCommonMixin.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onWidgets.dart';

class CommissionRecordPage extends StatefulWidget {
  const CommissionRecordPage({super.key});
  @override
  State<CommissionRecordPage> createState() => _CommissionRecordPageState();
}

class _CommissionRecordPageState extends State<CommissionRecordPage>
    with FinanceCommonToolsMixin, FinanceCommonWidgetMixin {
  String? _selectedGame;

  // ✅ 下拉刷新 + 上拉加载控制器（按“组”分页）
  late final JobsRefreshLoadController<DayGroup> _rl;

  @override
  void initState() {
    super.initState();

    // ✅ 初始化分页控制器：把 fetchPage 换成你的真实接口即可
    _rl = JobsRefreshLoadController<DayGroup>(
      pageSize: 10,
      fetchPage: (page, size) async {
        // TODO：接后端时根据 _selectedGame 等筛选条件去请求
        await Future.delayed(const Duration(milliseconds: 300)); // 模拟网络
        final all = _allMockGroups(); // 模拟完整数据源
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

  // 汇总：当前已加载分组的小计之和（真实项目应由后端返回聚合总额）
  num get total =>
      _rl.items.fold<num>(0, (a, g) => a + (g.subtotal)); // g.subtotal 来自你的模型

  @override
  Widget build(BuildContext context) {
    return [
      // 顶部汇总条
      commissionSummaryBar(total),
      const SizedBox(height: 16),

      // 过滤栏 + 列表
      [
        filterBar(
          selected: _selectedGame,
          onChanged: (v) => setState(() => _selectedGame = v),
          onSearch: _onSearch, // 点击会触发 _rl.refresh()
        ),
        const SizedBox(height: 16),

        // ✅ 用通用组件替换原来的 ListView.separated
        JobsRefreshLoadList<DayGroup>(
          controller: _rl,
          refreshColor: const Color(0xFFFED49C),
          // 这里是“分组列表”，不需要 zebra 行条纹；separator 用分组间距
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          padding: EdgeInsets.zero,
          itemBuilder: (context, indexItem, i) {
            final g = indexItem;
            return daySection(
              dateText: g.day.ymd, // 你已有的日期格式扩展
              subtotalText: fmtMoney1(g.subtotal), // 你已有的金额格式
              children: g.items.map((e) {
                return recordTile(
                  relation: e.relation,
                  amountText: '+${fmtMoney1(e.delta)}',
                  timeText: e.time.ymdHms,
                );
              }).toList(),
            );
          },
          // 空态
          emptyBuilder: (_) => JobsEmptyView(),
          // 底部：加载中
          footerLoadingBuilder: (_) => JobsLoadingView(),
          // 底部：没有更多
          footerNoMoreBuilder: (_) => JobsNoMoreView(),
        ).expanded(),
      ]
          .column()
          .style
          .paddingBy(const EdgeInsets.symmetric(vertical: 10, horizontal: 14))
          .bgCorBy(const Color(0xFF3B3F53))
          .radiusBy(10)
          .expanded(),
    ]
        .column()
        .style
        .paddingBy(const EdgeInsets.symmetric(vertical: 14, horizontal: 0));
  }

  void _onSearch() {
    // 真实项目：带上 _selectedGame 重置查询条件后刷新
    _rl.refresh();
    // 也可以保留提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('搜索：${_selectedGame ?? "全部"}')),
    );
  }

  // ======= 演示用的分组数据源（用于分页切片） =======
  List<DayGroup> _allMockGroups() {
    // 构造 12 天 * 每天 3 条 的示例分组（与原先结构一致）
    final now = DateTime(2025, 6, 17);
    final List<DayGroup> groups = [];
    for (int d = 0; d < 12; d++) {
      final day = now.subtract(Duration(days: d));
      final t = DateTime(day.year, day.month, day.day, 16, 12, 41);
      final items = List.generate(
        3,
        (_) => AgentRecord(relation: '(直属) 7848121', delta: 2312.00, time: t),
      );
      groups.add(DayGroup(day, items));
    }
    return groups;
  }
}
