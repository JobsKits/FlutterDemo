import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/controllers/agent_center_game_record_controller.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E6%B8%B8%E6%88%8F%E8%AE%B0%E5%BD%95%F0%9F%91%8C/GameRecordQueryController.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadController.dart';
import 'package:flutter_tiyu_app/utils/JobsRefreshLoad/JobsRefreshLoadList.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/FinanceCommonMixin.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onWidgets.dart';
import 'package:get/get.dart';

class GameRecordsPage extends StatefulWidget {
  final String title;
  const GameRecordsPage({super.key, required this.title});

  @override
  State<GameRecordsPage> createState() => _GameRecordsPageState();
}

class _GameRecordsPageState extends State<GameRecordsPage>
    with FinanceCommonToolsMixin, FinanceCommonWidgetMixin {
  // ------- 查询控件状态 -------
  final _memberCtrl = TextEditingController();
  late final GameRecordQueryController q;
  late final AgentCenterGameRecordController s;
  // ------- 下拉刷新 + 上拉加载 控制器 -------
  late final JobsRefreshLoadController<BetHistoryRecord> _rl;

  @override
  void initState() {
    super.initState();
    q = Get.put(GameRecordQueryController());
    AgentCenterGameRecordController s = Get.find();
    _rl = JobsRefreshLoadController<BetHistoryRecord>(
      pageSize: 10,
      fetchPage: (page, size) async {
        return await s.reqDataList(q.buildQuery(), page, size);
      },
    );
  }

  @override
  void dispose() {
    _memberCtrl.dispose();
    _rl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 14, right: 12, bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color.fromRGBO(43, 49, 64, 1)),
      ),
      child: [
        // 搜索栏
        recordSearchBar(
          context,
          memberCtrl: q.memberCtrl, // ✅ 接到 QueryController
          onCategoryChanged: (v) => q.category.value = v,
          onSearch: (query) async {
            // ✅ 提交：由 QueryController 产出“有效查询”，保存后刷新
            RecordQuery rQuery = q.buildQuery();
            // 确定查询
            s.handleConfirmQuery(rQuery);
            await _rl.refresh();
          },
        ),
        const SizedBox(height: 8),
        // 列表：通用刷新/加载组件
        JobsRefreshLoadList<BetHistoryRecord>(
          controller: _rl,
          refreshColor: const Color(0xFFFFD8A6),
          padding: const EdgeInsets.only(bottom: 12),
          // 空态
          emptyBuilder: (_) => JobsEmptyView(),
          // 底部：加载中
          footerLoadingBuilder: (_) => JobsLoadingView(),
          // 底部：没有更多
          footerNoMoreBuilder: (_) => JobsNoMoreView(),
          // 行渲染
          itemBuilder: (_, record, i) => betRecordTile(
            record,
            // 稳定 key，避免分页/刷新时闪烁
            key: ValueKey(record.orderNo.isNotEmpty
                ? record.orderNo
                : '$i-${record.memberId}-${record.betTime.millisecondsSinceEpoch}'),
          ),
          // 如需分割线/间距，可打开：
          // separatorBuilder: (_, __) => const SizedBox(height: 8),
          // zebra: true, // 如果你的 tile 背景是透明且想要斑马纹
          // zebraOddColor: const Color(0xFF262C39),
          // zebraEvenColor: const Color(0xFF1E232F),
        ).expanded(),
      ].column(),
    );
  }
}
