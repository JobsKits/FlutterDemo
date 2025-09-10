import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/controllers/agent_center_game_record_controller.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E6%B8%B8%E6%88%8F%E8%AE%B0%E5%BD%95%F0%9F%91%8C/GameRecordQueryController.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/Finance.const.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/widget/cascader/ym_cascader.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onList.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onText.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onWidgets.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

mixin class FinanceCommonToolsMixin {
  /// 简易格式化
  String fmtMoney1(num n) {
    final s = NumberFormat('#,##0.00', 'en_US').format(n);
    return s;
  }

  String fmtMoney(num n) {
    final s = n.toStringAsFixed(2);
    final parts = s.split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buf = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      final idxFromRight = intPart.length - i - 1;
      buf.write(intPart[i]);
      if (idxFromRight % 3 == 0 && i != intPart.length - 1) {
        buf.write(',');
      }
    }
    return '${buf.toString()}.${decPart}';
  }

  String fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}';

  String fmtYuan(num cents) {
    final yuan = (cents / 100).toStringAsFixed(2);
    final parts = yuan.split('.');
    final n = parts[0];
    final frac = parts[1];
    final buf = StringBuffer();
    for (int i = 0; i < n.length; i++) {
      buf.write(n[i]);
      final remain = n.length - i - 1;
      if (remain > 0 && remain % 3 == 0) buf.write(',');
    }
    return '${buf.toString()}.$frac';
  }

  String fmtTime(DateTime t) =>
      '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')} '
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';

  /// 提现状态码 → 中文文案
  String getWithdrawStatus(int state) {
    switch (state) {
      case 0:
        return '默认'.tr;
      case 1:
        return '申请中'.tr;
      case 2:
        return '已审核'.tr;
      case 3:
        return '已审批'.tr;
      case 4:
        return '已转款'.tr;
      case 5:
        return '已取消'.tr;
      case 6:
        return '已拒绝'.tr;
      case 7:
        return '已返还'.tr;
      case 8:
        return '已锁定'.tr;
      case 9:
        return '转款中'.tr;
      case 10:
        return '提现成功'.tr;
      default:
        return '';
    }
  }

  String memberHint = '请输入会员ID';
  String searchButtonText = '搜索';

  Color rowBgColor(int index) {
    return index.isEven
        ? const Color(0xFF1E232F) // 偶数行背景
        : const Color(0xFF262C39); // 奇数行背景
  }

// 背景/卡片/边框
  Color bgCor = const Color(0xFF171A22);
  Color cardCor = const Color(0xFF1F2430);
  Color cardHeaderCor = const Color(0xFF262C39);
  Color borderCor = const Color(0xFF2B3140);

// 文本
  Color textCor = const Color(0xFFE6EBF2);
  Color subTextCor = const Color(0xFFE6E7EC);
  Color positiveCor = const Color(0xFF23D17F);
  Color amountCor = const Color(0xFFFFD8A6);

// 交互
  Color buttonCor = const Color(0xFFFFC26B);
  Color buttonTextCor = const Color(0xFF2A2623);

// 圆角 & 间距
  Radius r4 = const Radius.circular(4);
  Radius r6 = const Radius.circular(6);
  Radius r8 = const Radius.circular(8);
  double gap = 12.0;

  TextStyle titleStyle() => TextStyle(
        color: textCor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  TextStyle amountStyle() => TextStyle(
        color: amountCor,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      );

  TextStyle cellTitleStyle() => TextStyle(
        color: textCor,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      );
  TextStyle cellAmountStyle() => TextStyle(
        color: textCor,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      );

  TextStyle cellTimeStyle() => TextStyle(
        color: subTextCor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  TextStyle textStyleBy(dynamic ok) => switch (ok) {
        true => const TextStyle(
            color: Color(0xFFFF5A5A),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        false => const TextStyle(
            color: Color(0xFF23D17F),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        null => const TextStyle(
            color: Color(0xFFE6EBF2),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        _ => const TextStyle(
            // 兜底：任何其他类型
            color: Color(0xFF9AA3B2),
            fontSize: 12,
            fontWeight: FontWeight.w400),
      };

  TextStyle TextStyle1 = const TextStyle(
    color: Color(0xFF9AA3B2),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// 默认样式（可被外部传入的 style 覆盖）
  TextStyle kHeaderCellDefaultStyle = const TextStyle(
    color: Color(0xFF9AA3B2),
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  TextStyle kSummaryLabelStyle =
      const TextStyle(color: Color(0xFF9AA3B2), fontSize: 12);

  TextStyle kSummaryValueStyle = const TextStyle(
    color: Color(0xFFFFD8A6),
    fontSize: 14,
    fontWeight: FontWeight.w800,
  );

  /// 在 children 之间插入固定间距
  List<Widget> withSpacing(List<Widget> children, double gap) {
    if (children.isEmpty) return children;
    final out = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      out.add(children[i]);
      if (i != children.length - 1) out.add(SizedBox(height: gap));
    }
    return out;
  }
}

/// 这里是公用的（函数式）Widget
mixin FinanceCommonWidgetMixin on FinanceCommonToolsMixin {
  ///
  Widget KVLine(
    bool? ok, {
    String? title,
    String? msg,
  }) {
    return Row(
      children: [
        Text(
          title ?? '主标题@暂无数据',
        ).textStyle(TextStyle1),
        const SizedBox(width: 8),
        Text(
          msg ?? '副标题@暂无数据',
        ).textStyle(textStyleBy(ok)).expanded(),
      ],
    );
  }

  /// 深色输入框（函数式）
  Widget darkTextField({
    required TextEditingController controller,
    String? hint,
    Widget? leading,
    double height = 36,
  }) {
    return [
      if (leading != null) ...[
        leading,
        const SizedBox(width: 6),
      ],
      TextField(
        controller: controller,
        cursorColor: const Color(0xFFFFD8A6),
        style: const TextStyle(color: Color(0xFFE6EBF2), fontSize: 12),
        decoration: InputDecoration(
          isCollapsed: true,
          hintText: hint ?? memberHint,
          hintStyle: const TextStyle(color: Color(0xFF9AA3B2), fontSize: 12),
          border: InputBorder.none,
        ),
      ).expanded(),
    ].row().container(
        decoration: BoxDecoration(
          color: const Color(0xFF151922),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF2B3140)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        height: height);
  }

  /// 深色下拉框（函数式）
  Widget darkDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    double height = 26,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2B3140)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1F2430),
          style: const TextStyle(color: Color(0xFF9AA3B2), fontSize: 12),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9AA3B2)),
          items: items
              .map((e) => DropdownMenuItem<T>(value: e, child: Text('$e')))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// 记录搜索栏（函数式、无内部状态）
  Widget recordSearchBar(
    BuildContext context, {
    required TextEditingController memberCtrl,
    required ValueChanged<String> onCategoryChanged,
    required void Function(RecordQuery query) onSearch,
    double height = 26,
  }) {
    AgentCenterGameRecordController ctrl =
        Get.find<AgentCenterGameRecordController>();
    final q = Get.find<GameRecordQueryController>();
    return Row(
      children: [
        SizedBox(
          width: 140,
          height: height,
          child: darkTextField(
            height: height,
            controller: memberCtrl,
            hint: memberHint,
            leading:
                const Icon(Icons.search, size: 18, color: Color(0xFF9AA3B2)),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 125,
          height: height,
          child: Obx(() => TextField(
                readOnly: true, // ✅ 不弹键盘
                onTap: () {
                  AppManager.instance.tapVibrate();
                  showGamePicker(ctrl, onPicked: (label) {
                    onCategoryChanged(label);
                  });
                },
                controller:
                    TextEditingController(text: q.category.value), // 显示当前选中
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFE6EBF2), fontSize: 12),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: '请选择',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  suffixIcon: const Icon(Icons.arrow_drop_down,
                      size: 18, color: Color(0xFF9AA3B2)),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: double.infinity,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF171925),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                ),
              )),
        ),
        const Spacer(),
        const SizedBox(width: 8),
        SizedBox(
          width: 57,
          height: height,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD8A6),
              foregroundColor: const Color(0xFF2B2B2B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              textStyle:
                  const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              /// TODO 搜索
              final RecordQuery query = q.buildQuery();
              onSearch(query);
            },
            child: Center(child: Text(searchButtonText)),
          ),
        ),
      ],
    );
  }

  void showGamePicker(
    AgentCenterGameRecordController controller, {
    required ValueChanged<String> onPicked,
  }) {
    showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext builder) {
        return Obx(() {
          if (!controller.isInit.value) {
            return const SizedBox();
          }
          return YmCascader(
            data: controller.gameListData,
            dataMap: controller.gameListMap,
            currentIndex:
                controller.isNeedReset.value ? [0, 0] : controller.gameIndex,
            isFixed: true,
            onOkClick: (list) async {
              Get.back();
              // 等内部状态更新
              await Future.delayed(const Duration(milliseconds: 100));
              controller.confirmGame(list);

              // —— 把“展示给 Dropdown 的文案”拼出来 —— //
              final left = controller.gameListData[0][list[0]].label;
              final rightList = controller.gameListMap?[list[0]] ?? const [];
              final right = (list.length > 1 && list[1] < rightList.length)
                  ? rightList[list[1]].label
                  : null;

              final label = right == null ? left : '$left / $right';
              onPicked(label); // 关键：回传给 recordSearchBar
            },
            onCancelClick: () {
              Get.back();
            },
            onChanged: (position, index, value) {
              // 可选：需要联动时加逻辑
            },
          );
        });
      },
    );
  }

  // ====== 细节组件 ======
  Widget vDivider() => Container(
        width: 1,
        height: 28,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: const Color(0xFF2B3140),
      );

  // 统一的 cell（表头/表体都能用）
  Widget financeCell(
    String text, {
    int flex = 1,
    TextStyle? style,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 8),
  }) {
    return Expanded(
      flex: flex, // 👈 撑开整行（按比例分配宽度）
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center, // ✅ 居中对齐
          style: style,
          maxLines: null, // ✅ 允许无限行
          overflow: TextOverflow.visible, // ✅ 不截断
          softWrap: true, // ✅ 自动换行
        ).sizeBy(w: 74, h: 28).center(),
      ),
    );
  }

  Widget darkPanel({
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color color = const Color(0xFF0F1218),
    double radius = 8,
    Color borderColor = const Color(0xFF2B3140),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  Widget summaryCell({
    required String label,
    required String value,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    final TextStyle labelStyle = kSummaryLabelStyle;
    final TextStyle valueStyle = kSummaryValueStyle;
    final labelWidget = Text(label, style: labelStyle);
    final valueWidget = Text(value, style: valueStyle);

    return Expanded(
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          labelWidget.center(),
          const SizedBox(height: 6),
          valueWidget.center(),
        ],
      ),
    );
  }

  /// 单条记录小部件
  Widget recordItem({
    required String userId,
    required double amount,
    required DateTime time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430), // 背景色
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一行：用户ID + 金额
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "(直属) $userId",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                "+${amount.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // 第二行：时间
          Text(
            "时间: ${time.toString().substring(0, 19)}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// 搜索栏小部件
  Widget searchBar({
    required TextEditingController controller,
    required VoidCallback onSearch,
    Color buttonColor = const Color(0xFFFFE0B2), // 按钮背景色（淡橙色）
  }) {
    return Row(
      children: [
        // 输入框
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1C1E28), // 输入框背景色
              hintText: memberHint,
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 搜索按钮
        ElevatedButton(
          onPressed: onSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            searchButtonText,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ],
    );
  }

// 函数式小部件：直接返回 Widget，外部用法：betRecordTile(record)
  Widget betRecordTile(BetHistoryRecord record, {Key? key}) {
    // —— 业务派生状态 ——
    final statusTxt = record.status == BetStatus.success ? '成功' : '失败';

    // —— UI ——（保持与你原来完全一致）
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2B3140)),
      ),
      child: Column(
        children: [
          // 头部
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF262C39),
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: Row(
              children: [
                const SizedBox.shrink(),
                Expanded(
                  child: Text(
                    record.gameName,
                    style: const TextStyle(
                      color: Color(0xFFFED49C),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const Text(
                  '投注金额：',
                  style: TextStyle(
                    color: Color(0xFF9AA3B2),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  fmtYuan(record.amount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),

          // 内容
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              children: [
                [
                  KVLine(null, title: '会员ID：', msg: record.memberId).expanded(),
                  const SizedBox(width: 8),
                  KVLine(false, title: '状态：', msg: statusTxt).expanded(),
                ].row(),
                const SizedBox(height: 10),
                [
                  KVLine(null, title: '订单号：', msg: '1234567890').expanded(),
                  const SizedBox(width: 8),
                  KVLine(true, title: '游戏输赢', msg: '赢').expanded(),
                ].row(),
                const SizedBox(height: 10),
                KVLine(null, title: '投注时间：', msg: fmtTime(record.betTime)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 顶部筛选 + 搜索
  Widget filterBar({
    required String? selected,
    required ValueChanged<String?> onChanged,
    required VoidCallback onSearch,
    List<DropdownMenuItem<String>>? items,
  }) {
    items ??= const [
      DropdownMenuItem(value: 'all', child: Text('全部')),
      DropdownMenuItem(value: 'slot', child: Text('老虎机')),
      DropdownMenuItem(value: 'sport', child: Text('体育')),
    ];

    return Row(
      children: [
        // 下拉
        Expanded(
          child: Container(
            height: 34,
            decoration: BoxDecoration(
              color: cardCor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderCor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selected,
                hint: Text('选择游戏类别',
                    style: TextStyle(color: subTextCor, fontSize: 14)),
                dropdownColor: cardCor,
                iconEnabledColor: subTextCor,
                style: TextStyle(color: textCor, fontSize: 14),
                items: items,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 搜索按钮
        SizedBox(
          height: 34,
          child: TextButton(
            onPressed: onSearch,
            style: TextButton.styleFrom(
              backgroundColor: buttonCor,
              foregroundColor: buttonTextCor,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('搜索',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  // 日期分组区块
  Widget daySection({
    required String dateText,
    required String subtotalText,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(r6)),
      child: Column(
        children: [
          // 组头
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              children: [
                Text(dateText,
                    style: TextStyle(color: subTextCor, fontSize: 14)),
                const Spacer(),
                Text(
                  subtotalText,
                  style: TextStyle(
                      color: amountCor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 列表
          ...withSpacing(children, 12),
        ],
      ),
    );
  }

  // 单条记录卡片
  Widget recordTile({
    required String relation, // “(直属) 7848121”
    required String amountText, // “+2,312.00”
    required String timeText, // “时间：2025-04-02 16:12:41”
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardCor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderCor),
      ),
      child: Column(
        children: [
          // 头部
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: cardHeaderCor,
              borderRadius: BorderRadius.vertical(top: r6),
            ),
            child: Row(
              children: [
                Text(relation, style: cellTitleStyle()),
                const Spacer(),
                Text(amountText, style: cellAmountStyle()),
              ],
            ),
          ),
          // 时间行
          KVLine(null, title: '时间', msg: timeText)
              .style
              .padding(const EdgeInsets.symmetric(horizontal: 16))
              .size(height: 38)
              .bgCorBy(const Color(0xFF34384C))
        ],
      ),
    );
  }

  /// 千分位格式化（保留两位），不依赖 intl
  String _fmtMoney(num n) {
    final s = n.toStringAsFixed(2);
    final parts = s.split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final regex = RegExp(r'\B(?=(\d{3})+(?!\d))');
    final withComma = intPart.replaceAllMapped(regex, (m) => ',');
    return '$withComma.$decPart';
  }

  /// 提成收益汇总条
  Widget commissionSummaryBar(
    num total, {
    Key? key,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2B3140)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            const Text(
              '提成收益',
              style: TextStyle(color: Color(0xFF9AA3B2), fontSize: 14),
            ),
            const Spacer(),
            Text(
              _fmtMoney(total),
              style: const TextStyle(
                color: Color(0xFFFFD8A6),
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
