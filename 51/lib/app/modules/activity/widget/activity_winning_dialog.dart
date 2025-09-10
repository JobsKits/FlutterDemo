import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_winning_model/activity_winning_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_winning_model/datum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class ActivityWinningDialog extends StatefulWidget {
  final ActivityWinningModel? winnerModel;
  final int? bonusAmount;
  const ActivityWinningDialog({super.key, this.winnerModel, this.bonusAmount});

  @override
  State<ActivityWinningDialog> createState() => _ActivityWinningDialogState();
}

class _ActivityWinningDialogState extends State<ActivityWinningDialog> {
  late TextEditingController searchController = TextEditingController();
  List<Datum>? filteredWinnerData;


  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterData);
  }

  void _filterData() {
    final searchText = searchController.text.trim();
    if (searchText.isEmpty) {
      setState(() {
        filteredWinnerData = widget.winnerModel?.data;
      });
      return;
    }

    setState(() {
      filteredWinnerData = widget.winnerModel?.data?.where((item) {
        return item.platformOrderId?.toString().contains(searchText) ?? false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
        child: Stack(
          children: [
            Column(
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: _contentBuild(context),
                  ),
                ),
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: context.theme.cardColor.withOpacity(.9),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.close_sharp,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ).onTap(() {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  }),
                ),
                const Spacer(),
              ],
            ),
          ],
        ));
  }

  Widget _contentBuild(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text('中奖注单详情'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('总奖金: '),
                Text(
                  NumberFormat("#,##0.00").format((widget.bonusAmount ?? 0) / 1000),
                ),
                const Spacer(),
                Expanded(
                  child: Container(
                    height: 93.h,
                    width: 500.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(77.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center, // 垂直居中
                      children: [
                        Padding( // 使用 Padding 替代 margin，更符合 Flutter 最佳实践
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: SvgPicture.asset(
                            Assets.theme1.images.video.iconSearch,
                            width: 42.w,
                            height: 42.h,
                          ),
                        ),
                        Expanded( // 让 TextField 占据剩余空间
                          child: Align( // 确保 TextField 内容居中
                            alignment: Alignment.center,
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {},
                              cursorColor: const Color(theme01MainColor),
                              textAlignVertical: TextAlignVertical.center, // 垂直居中
                              decoration: InputDecoration(
                                hintText: "注单号",
                                hintStyle: TextStyle(
                                  fontSize: 33.sp,
                                  color: const Color(0xFFBCBCBC),
                                ),
                                border: InputBorder.none, // 移除边框
                                isCollapsed: true, // 减少默认 padding，让文字更居中
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _buildTable(context)
          ],
        ));
  }

  Widget _buildTable(BuildContext context) {
    List<String> titleList = ["注单号", "投注金额", "奖励金额", "中奖时间", "状态"];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: const Color(colorF6F6F7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.w),
                topRight: Radius.circular(15.w),
              ),
            ),
            child: _rankItemHeaderRow(titleList),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2 -
                150, // Set the fixed height of the ListView (e.g., 300h for responsive height)
            child: ListView.builder(
              shrinkWrap:
                  true, // Ensures that the ListView height is based on the content
              itemCount: filteredWinnerData?.length ?? widget.winnerModel?.data?.length ?? 0,
              itemBuilder: (context, idx) {
                final row = filteredWinnerData?[idx] ?? widget.winnerModel?.data?[idx];
                final listRow = [
                  row?.platformOrderId?.toString() ?? '',
                  (row!.playPlanAmount! / 1000).toString(),
                  (row.fortuneAmount! / 1000).toString(),
                  DateTimeUtils.formatTimestamp(row.createTime ?? 0,
                      temp: 'yyyy/MM/dd HH:mm:ss'),
                  row.state == 1 ? '已领取' : '未领取',
                ];
                return _rankItemRow(idx, listRow, '');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankItemHeaderRow(List<String> values) {
    TextStyle style = TextStyle(
        color: const Color(color6B6B6B),
        fontSize: 28.sp,
        fontWeight: FontWeight.bold);

    // Create a list of widget columns based on the values
    List<Widget> columns = values.asMap().entries.map((entry) {
      String value = entry.value;

      // For the first and last item, use fixed width
      return Expanded(
        flex: 1,
        child: _rankItemCol(1, value, 100.w, style, true),
      );
    }).toList();

    return Row(
      children: columns,
    );
  }

  Widget _rankItemRow(int index, List<String> values, String? rollingType) {
    TextStyle defaultStyle = TextStyle(
      color: const Color.fromRGBO(102, 102, 102, 1),
      fontSize: 28.sp,
    );

    // Map each value to a column widget, with specific styling for the last column
    List<Widget> columns = values.asMap().entries.map((entry) {
      return Expanded(
        flex: 1,
        child: _rankItemCol(entry.key, entry.value, 100.w, defaultStyle, false),
      );
    }).toList();
    return Container(
      color: index % 2 == 0 ? Colors.white : const Color(colorF6F6F7),
      child: Row(
        children: columns,
      ),
    );
  }

  Widget _rankItemCol(
    int index, String val, double width, TextStyle style, bool isheader) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      height: 35,
      alignment: Alignment.center,
      width: width,
      child: Text(
        index == 0 ? _getMiddleEllipsisText(val) : val,
        style: style,
        maxLines: 2,
        textAlign: TextAlign.center,
      )
    );
  }

  String _getMiddleEllipsisText(String text) {
    if (text.length <= 10) return text;
    final left = text.substring(0, 5);
    final right = text.substring(text.length ~/ 1.5);
    return '$left...$right';
  }
}
