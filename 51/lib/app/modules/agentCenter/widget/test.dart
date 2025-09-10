// return Column(
//   children: [
//     DataTable(
//       headingRowHeight: 100.h,
//       dataRowMinHeight: 100.h,
//       dataRowMaxHeight: 150.h,
//       horizontalMargin: 0,
//       columnSpacing: 0,
//       dividerThickness: 1.h,
//       columns: [
//         DataColumn(
//           label: _buildTableHeaderTitle(
//             '会员账号',
//             borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r)),
//           ),
//         ),
//         DataColumn(
//           label: _buildTableHeaderTitle('订单号', width: 300.w),
//         ),
//         DataColumn(label: _buildTableHeaderTitle('厅方名称')),
//         DataColumn(label: _buildTableHeaderTitle('游戏名称')),
//         DataColumn(label: _buildTableHeaderTitle('投注金额')),
//         DataColumn(label: _buildTableHeaderTitle('状态')),
//         DataColumn(label: _buildTableHeaderTitle('游戏输赢')),
//         DataColumn(
//           label: _buildTableHeaderTitle(
//             '时间',
//             borderRadius:
//                 BorderRadius.only(topRight: Radius.circular(20.r)),
//             width: 240.w,
//           ),
//         ),
//       ],
//       rows: controller.dataList.map((item) {
//         return DataRow(cells: [
//           DataCell(_buildTableBodyText(
//             '${item['cust_name'] ?? ''}',
//           )),
//           DataCell(_buildTableBodyText(
//             '${item['order_id'] ?? ''}',
//             width: 300.w,
//           )),
//           DataCell(_buildTableBodyText('${item['gameTypeId']}')),
//           DataCell(_buildTableBodyText('${item['playTypeId']}')),
//           DataCell(_buildTableBodyText(
//             parseNumber((item['effective_bets'] ?? 0) / 1000),
//           )),
//           DataCell(_buildTableBodyText(item['state'] == 4 ? '已结算' : '待结算')),
//           DataCell(_buildTableBodyText(
//             parseNumber((item['profit_loss'] ?? 0) / 1000),
//           )),
//           DataCell(_buildTableBodyText(
//             DateTimeUtils.formatTimestamp(item['bet_start_time']),
//             width: 240.w,
//           )),
//         ]);
//       }).toList(),
//     ),
//     // ElevatedButton(
//     //   onPressed: () {
//     //     // _loadData(); // 点击按钮加载更多数据
//     //   },
//     //   child: Text('加载更多'),
//     // ),
//   ],
// );
