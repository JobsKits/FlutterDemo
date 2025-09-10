import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';

import 'ym_cascader_data_bean.dart';

/// 滚动选择器
class YmPicker extends StatefulWidget {
  /// 数据格式：{"label": "请选择", "value": ""}
  final List<YmPickerDataBean> dataSource;

  /// 默认值
  final int currentIndex;

  /// 前方文字
  final String label;
  final double width;
  final double height;
  final Function onChanged;

  final double itemHeight;
  final Color backgroundColor;

  const YmPicker({
    super.key,
    this.label = "",
    this.currentIndex = 0,
    this.itemHeight = 36,
    this.backgroundColor = const Color(0xffffffff),
    this.height = 150,
    this.width = 150,
    required this.onChanged,
    required this.dataSource,
  });

  @override
  YmPickerState createState() => YmPickerState();
}

class YmPickerState extends State<YmPicker> {
  //设置防抖周期为300毫秒
  final Duration _durationTime = const Duration(milliseconds: 300);
  Timer _timer = Timer(const Duration(milliseconds: 300), () {});
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.currentIndex);
  }

  @override
  void didUpdateWidget(YmPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 更新数据
    _controller.jumpToItem(widget.currentIndex);
    print(
        "YmPickerState didUpdateWidget default index : ${widget.currentIndex}");
  }

  /// 触发值改变
  void _valueChanged(index) {
    _timer.cancel();
    _timer = new Timer(_durationTime, () {
      /// 触发回调函数
      widget.onChanged(index, widget.dataSource[index].value);
    });
  }

  Widget _getItemWidget(int index, List<YmPickerDataBean> items) {
    return Container(
      alignment: Alignment.center,
      height: widget.itemHeight,
      child: Text(
        items.elementAt(index).label,
        style: TextStyle(
          color: context.customTheme?.titleColor,
          fontSize: 40.sp,
          height: 1.2,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: CupertinoPageScaffold(
        child: Container(
          height: widget.height,
          color: context.customTheme?.inputBgColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              widget.label != ""
                  ? Positioned(
                      top: widget.height / 2 - (widget.itemHeight / 2),
                      left: 18.0,
                      child: Container(
                        alignment: Alignment.center,
                        height: widget.itemHeight,
                        child: Text(
                          widget.label,
                          style: TextStyle(
                            color: const Color(color333033),
                            fontSize: 40.sp,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : const Offstage(offstage: true),
              CupertinoPicker.builder(
                magnification: 1.0, // 整体放大率
                scrollController: _controller,
                itemExtent: widget.itemHeight, // 所有子节点统一高度
                useMagnifier: true, // 是否使用放大效果
                backgroundColor: Colors.transparent,
                childCount: widget.dataSource.length,
                onSelectedItemChanged: (int index) {
                  /// 当选项改变时的回调
                  if (mounted) {
                    /// print('onSelectedItemChanged:$index');
                    _valueChanged(index);
                  }
                },
                itemBuilder: (BuildContext context, int index) {
                  return _getItemWidget(index, widget.dataSource);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _timer.cancel();
  }
}
