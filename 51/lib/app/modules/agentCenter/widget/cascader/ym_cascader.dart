import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import '../../../../../utils/CommonRipple.dart';
import 'ym_picker.dart';
import 'ym_cascader_data_bean.dart';

typedef ConfirmCallback = void Function(List<int> list);

/// 级联选择器（多级）
class YmCascader extends StatefulWidget {
  //数据
  final List<List<YmPickerDataBean>> data;
  final Map<int, List<YmPickerDataBean>>? dataMap;
  //默认值
  final List<int> currentIndex;

  final Function onChanged;
  final ConfirmCallback onOkClick;
  final VoidCallback onCancelClick;
  final Color backgroundColor;
  final double itemHeight;
  final bool isFixed;
  final bool isOnlyOne;

  const YmCascader({
    super.key,
    required this.data,
    required this.onChanged,
    required this.onOkClick,
    required this.onCancelClick,
    this.dataMap,
    this.itemHeight = 36,
    this.isFixed = false,
    this.isOnlyOne = false,
    this.backgroundColor = const Color(0xffffffff),
    this.currentIndex = const [0, 0, 0, 0, 0],
  });

  @override
  State<YmCascader> createState() => _YmCascaderState();
}

class _YmCascaderState extends State<YmCascader> {
  int resetIndex = 0;
  List<YmPickerDataBean> resetData = [];
  List<int> resetCurrentIndex = [0, 0];

  @override
  void initState() {
    super.initState();

    if (widget.dataMap != null && resetData.isEmpty) {
      // 设置第一个
      setState(() {
        int index = widget.currentIndex[0];
        resetCurrentIndex = widget.currentIndex;
        resetIndex = index;
        resetData = widget.dataMap?[index] ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double pickerItemWidth = (MediaQuery.of(context).size.width) /
        (widget.isOnlyOne ? 1 : widget.data.length);
    return Container(
      height: 650.h,
      decoration: BoxDecoration(color: context.customTheme?.inputBgColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100.h,
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    widget.onCancelClick();
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 42.sp,
                        color: context.customTheme?.title2Color,
                      ),
                    ),
                  ),
                ),
                Text(
                  '选择游戏',
                  style: TextStyle(
                    fontSize: 54.sp,
                    color: context.customTheme?.titleColor,
                  ),
                ),
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    widget.onOkClick(resetCurrentIndex);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Text(
                      '确定',
                      style: TextStyle(
                        fontSize: 42.sp,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(
              widget.data.length,
              (position) {
                if (widget.isFixed == false) {
                  YmPicker picker = YmPicker(
                    backgroundColor:
                        context.customTheme?.dialogBgColor ?? Colors.white,
                    dataSource: widget.data[position],
                    currentIndex: widget.currentIndex[position],
                    width: pickerItemWidth,
                    itemHeight: 40,
                    height: 180,
                    onChanged: (index, val) {
                      print(
                          "Picker onChanged:  position=${position}, index=${index}, val=${val}");
                      widget.onChanged(position, index, val);
                    },
                  );
                  return picker;
                }

                if (widget.isFixed == true && widget.data.length == 2) {
                  if (position == 0) {
                    YmPicker picker = YmPicker(
                      backgroundColor:
                          context.customTheme?.dialogBgColor ?? Colors.white,
                      dataSource: widget.data[0],
                      currentIndex: resetCurrentIndex[position],
                      width: pickerItemWidth,
                      itemHeight: 40,
                      height: 180,
                      onChanged: (index, val) {
                        setState(() {
                          resetCurrentIndex[0] = index;
                          resetIndex = index;
                          resetData = widget.dataMap?[index] ?? [];
                        });
                        print(
                            "Picker onChanged:  position=${position}, index=${index}, val=${val}");
                        // widget.onChanged(position, index, val);
                      },
                    );
                    return picker;
                  }

                  if (position == 1 && !widget.isOnlyOne) {
                    YmPicker picker = YmPicker(
                      dataSource: resetData,
                      currentIndex: resetCurrentIndex[position],
                      width: pickerItemWidth,
                      itemHeight: 40,
                      height: 180,
                      onChanged: (index, val) {
                        setState(() {
                          resetCurrentIndex[1] = index;
                        });
                        print(
                            "Picker onChanged:  position=${position}, index=${index}, val=${val}");
                        // widget.onChanged(position, index, val);
                      },
                    );
                    return picker;
                  }
                }

                return const SizedBox();
              },
            ),
          )
        ],
      ),
    );
  }
}
