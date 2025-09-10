import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/controllers/lottery_home_controller.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:get/get.dart';

class LotteryResultsPage extends StatefulWidget {
  const LotteryResultsPage({super.key});

  @override
  State<LotteryResultsPage> createState() => _LotteryResultsPageState();
}

class _LotteryResultsPageState extends State<LotteryResultsPage>
    with TickerProviderStateMixin {
  final LotteryController controller = Get.find();
  int selectIndex = 0;
  late final tabController =
      TabController(length: (controller.betList).length, vsync: this)
        ..addListener(listener);

  listener() {
    setState(() {
      selectIndex = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(controller: tabController, children: [
      Table(
          border: TableBorder.all(
              width: 0, color: Colors.transparent, style: BorderStyle.solid),
          children: [
                TableRow(children: [
                  _tableCell(context: context, title: '期号'),
                  _tableCell(context: context, title: '开奖号码'),
                  _tableCell(context: context, title: '和值'),
                  _tableCell(context: context, title: '大小'),
                  _tableCell(context: context, title: '单双'),
                ]),
                // 分隔线
                TableRow(children: [
                  Container(
                    height: 1, // 高度为1
                    color: Colors.black,
                    width: double.infinity, // 宽度为屏幕宽度
                  ),
                  Container(
                    height: 1, // 高度为1
                    color: Colors.black,
                    width: double.infinity, // 宽度为屏幕宽度
                  ),
                  Container(
                    height: 1, // 高度为1
                    color: Colors.black,
                    width: double.infinity, // 宽度为屏幕宽度
                  ), // 占位以保持列数一致
                  Container(
                    height: 1, // 高度为1
                    color: Colors.black,
                    width: double.infinity, // 宽度为屏幕宽度
                  ),
                  Container(
                    height: 1, // 高度为1
                    color: Colors.black,
                    width: double.infinity, // 宽度为屏幕宽度
                  ),
                ]),
              ] +
              controller.betList.map((row) {
                return TableRow(children: [
                  _tableCell(
                    context: context,
                    // customAlertDialog: customAlertDialog,
                    // row: row,
                    title: row,
                  ),
                  _tableCell(
                    context: context,
                    // customAlertDialog: customAlertDialog,
                    // row: row,
                    title: row,
                  ),
                  _tableCell(
                      context: context,
                      // customAlertDialog: customAlertDialog,
                      // row: row,
                      title: row),
                  _tableCell(
                      context: context,
                      // customAlertDialog: customAlertDialog,
                      // row: row,
                      title: row),
                  _tableCell(
                      context: context,
                      // customAlertDialog: customAlertDialog,
                      // row: row,
                      title: row),
                ]);
              }).toList()),
    ]);
  }

  Widget _tableCell({
    BuildContext? context,
    // CustomAlertDialog? customAlertDialog,
    // ListDataForWinLog? row,
    String? title,
  }) {
    return TableCell(
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title ?? '',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ).onTap(
        () {
          // controller.fetchApplyWinLogDetail(row?.id, customAlertDialog);
        },
      ),
    );
  }
}
