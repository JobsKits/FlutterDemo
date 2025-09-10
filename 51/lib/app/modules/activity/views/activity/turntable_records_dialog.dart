import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/turntable_records_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/funding_type_pop_widget.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:get/get.dart';

import '../../../../../utils/CommonRipple.dart';

class TurntableRecordsDialog extends StatefulWidget {
  final Map<String, dynamic> arguments;
  const TurntableRecordsDialog({super.key, required this.arguments});

  @override
  _TurntableRecordsDialogState createState() => _TurntableRecordsDialogState();
}

class _TurntableRecordsDialogState extends State<TurntableRecordsDialog> {
  late TurntableRecordsController controller;

  @override
  void initState() {
    super.initState();
    // 初始化 controller 并传递 arguments
    controller = Get.put(TurntableRecordsController(widget.arguments));
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text('抽奖记录'),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: 120,
              height: 32,
              child: _buildTimeView(context),
            ),
            // Expanded(child: _buildTimeView(context)),
            Obx(() => _buildTable(context))
          ],
        ));
  }

  Widget _buildTimeView(context) {
    return _buildSelectButton(context, onTap: () {
      dismissPop();
      FundingTypePopWidget.instance.show(
          context,
          _buildSelectList(
              child: _buildTimeGrid(),
              clickClose: () {
                FundingTypePopWidget.instance.hide();
              }),
          top: controller.timeWidgetHeight);
    }, key: controller.timeKey, showName: controller.selectDate);
  }

  //构建选择弹窗的列表
  Widget _buildSelectList({required Widget child, VoidCallback? clickClose}) {
    return CommonRipple(
      onTap: clickClose,
      child: Container(
        width: 1.sw, // 宽度为屏幕宽度
        height: 1.sh, // 高度为屏幕高度
        color: Colors.black.withOpacity(0.4), // 背景遮罩
        alignment: Alignment.bottomCenter, // 内容对齐到底部
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // 内容对齐到底部
          children: [
            Container(
              width: 1.sw, // 宽度为屏幕宽度
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r), // 顶部圆角
                  topRight: Radius.circular(40.r), // 顶部圆角
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
              alignment: Alignment.center, // 内容居中
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: controller.date.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 10,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              controller.currentTimeIndex.value = index;
              FundingTypePopWidget.instance.hide();
              dynamic item = controller.date[index];
              controller.selectedGame(item['value'], 'date');
            },
            child: Obx(
              () => Container(
                alignment: Alignment.center,
                height: 118.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(27.r)),
                child: Text(
                  "${controller.date[index]["name"]}",
                  style: TextStyle(
                      fontSize: 42.sp,
                      color: controller.currentTimeIndex.value == index
                          ? const Color(0xff000000)
                          : const Color(color6D6D6D)),
                ),
              ),
            ));
      },
    );
  }

  Widget _buildSelectButton(context,
      {VoidCallback? onTap, Key? key, required RxString showName}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        key: key,
        decoration: BoxDecoration(
            color: const Color(colorF8F8F8),
            borderRadius: BorderRadius.circular(71.r),
            border: Border.all(color: Colors.white)),
        height: 104.h,
        padding: EdgeInsets.only(left: 30.w, right: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Obx(
                () => Text(
                  textAlign: TextAlign.center,
                  showName.value,
                  style: TextStyle(
                    fontSize: 38.sp,
                    color: const Color(color6B6B6B),
                    height: 1,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(colorBCBCBC),
            )
          ],
        ),
      ),
    );
  }

  void dismissPop() {
    if (FundingTypePopWidget.instance.isShowing()) {
      FundingTypePopWidget.instance.hide();
    }
  }

  Widget _buildTable(BuildContext context) {
    List<String> titleList = ["转盘", "消耗幸运值", "奖品价值", "领取时间"];
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
          SizedBox(
            height: MediaQuery.of(context).size.height / 2 - 150,
            child: controller.models.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        controller.models.length,
                        (idx) {
                          final row = controller.models[idx];
                          final listRow = [
                            typeWithName(row.wheelType!.toInt()),
                            '${row.source}',
                            '${(row.rewordAmount ?? 0) == 0 ? '' : ((row.rewordAmount ?? 0) / 1000).truncateToFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}',
                            DateTimeUtils.formatTimestamp(
                              row.creatTime!.toInt(),
                              temp: 'yyyy/MM/dd HH:mm:ss',
                            ),
                          ];
                          return _rankItemRow(idx, listRow, '');
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  String typeWithName(int type) {
    String name = '';
    switch (type) {
      case 1:
        name = '白银';
        break;
      case 2:
        name = '黄金';
        break;
      case 3:
        name = '钻石';
        break;
      default:
    }
    return name;
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
        child: _rankItemCol(value, 100.w, style, true),
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
        child: _rankItemCol(entry.value, 80.w, defaultStyle, false),
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
      String val, double width, TextStyle style, bool isheader) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        height: 35,
        alignment: Alignment.center,
        width: width,
        child: Text(val,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: style));
  }
}
