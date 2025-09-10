import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/controllers/agent_center_withdraw_record_controller.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E6%8F%90%E7%8E%B0%E8%AE%B0%E5%BD%95%F0%9F%91%8C/WithdrawRecordQueryController.dart';
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

class WithdrawRecordPage extends StatefulWidget {
  const WithdrawRecordPage({super.key});
  @override
  State<WithdrawRecordPage> createState() => _WithdrawRecordState();
}

class _WithdrawRecordState extends State<WithdrawRecordPage>
    with FinanceCommonToolsMixin, FinanceCommonWidgetMixin {
  // ✅ 新增：分页控制器
  late final JobsRefreshLoadController<WithdrawRecordItem> _rl;
  late final AgentCenterWithdrawRecordController s;
  late final WithdrawRecordQueryController q;

  @override
  void initState() {
    super.initState();
    q = Get.put(WithdrawRecordQueryController());
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
    _rl.dispose(); // ✅ 释放 WithdrawRecordItem
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return [
      // ===== 顶部搜索栏（保持你的风格） ===== username.value
      [
        darkTextField(
          height: 26,
          controller: q.memberCtrl,
          hint: memberHint,
          leading: const Icon(Icons.search, size: 18, color: Color(0xFF9AA3B2)),
        ).expanded(), // 给 Row 有限宽度
        const SizedBox(width: 12),
        Text(searchButtonText)
            .sizeBy(w: 57, h: 26)
            .radiusBy(4)
            .bgCorByInt(0xFFFED49C)
            .onTap(() {
          s.username.value = q.memberCtrl.text.trim();
          // ✅ 触发刷新；把筛选条件带进 fetchPage 即可
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
                financeCell('状态',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('提现金额',
                    style: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    )),
                financeCell('申请时间',
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
              child: JobsRefreshLoadList<WithdrawRecordItem>(
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
                      financeCell(e.usrID.toString(),
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(e.withdrawStatus,
                          style: const TextStyle(
                            color: Color(0xFFE6EBF2),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                      financeCell(e.withdrawValue,
                          style: const TextStyle(
                            color: Color(0xFFFED49C),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          )),
                      // 如需两行显示日期+时间：'${e.withdrawTime.ymd}\n${e.withdrawTime.hms}'
                      financeCell(e.withdrawTime,
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
