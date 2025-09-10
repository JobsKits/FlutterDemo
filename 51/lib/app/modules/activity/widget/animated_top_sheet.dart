import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../data/rebate_bean.dart';

typedef IntCallback = void Function(int type);

class AnimatedTopSheet extends StatefulWidget {
  final double topHeight;
  final List<RebateProportionDataBean> dataList;
  final int currentType;
  final IntCallback? onTap;

  const AnimatedTopSheet({
    super.key,
    required this.topHeight,
    required this.dataList,
    required this.currentType,
    this.onTap,
  });

  @override
  State<AnimatedTopSheet> createState() => _AnimatedTopSheetState();
}

class _AnimatedTopSheetState extends State<AnimatedTopSheet>
    with SingleTickerProviderStateMixin {
  double _height = 0.0; // 初始高度为 0
  bool _isVisible = false; // 控制显示状态

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      int maxShowCount = 8;
      int dataLength = widget.dataList.length;
      int maxHeight =
          dataLength > maxShowCount ? 8 * 120 + 80 : dataLength * 120 + 80;

      setState(() {
        _isVisible = true; // 更新状态为可见
        _height = maxHeight.h; // 设置最终高度
      });
    });
  }

  void _closeSheet() {
    AppManager.instance.tapVibrate();
    setState(() {
      _isVisible = false; // 更新为不可见
      _height = 0; // 设置高度为 0
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      Get.back(); // 动画结束后关闭弹出层
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 遮罩层
        InkWell(
          onTap: () {
            AppManager.instance.tapVibrate();
            _closeSheet(); // 点击遮罩区域时触发关闭动画
          },
          child: Container(
            color: context.customTheme?.navbarBg, // 遮罩颜色
            margin: EdgeInsets.only(top: widget.topHeight),
            height: MediaQuery.of(context).size.height -
                widget.topHeight, // 留出100的空间
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: widget.topHeight),
          child: Align(
            alignment: Alignment.topCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300), // 动画持续时间
              height: _isVisible ? _height : 0, // 根据状态控制高度
              curve: Curves.easeInOut,
              child: Material(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  decoration: BoxDecoration(
                    color: context.customTheme?.pageTwoBg,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => _closeSheet,
                          child: SizedBox(height: 40.h),
                        ),
                        ...List.generate(widget.dataList.length, (index) {
                          RebateProportionDataBean dataItem =
                              widget.dataList[index];
                          return _buildItemWidget(
                            title: dataItem.gameName,
                            type: dataItem.type,
                          );
                        }),
                        InkWell(
                          onTap: () => _closeSheet,
                          child: SizedBox(height: 40.h),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildItemWidget({
    required String title,
    required int type,
  }) {
    bool isChecked = type == widget.currentType;
    return InkWell(
      onTap: () async {
        AppManager.instance.tapVibrate();
        if (widget.onTap != null) {
          widget.onTap!(type);
        }
        _closeSheet();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 70.w),
        height: 120.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 42.sp,
                color: isChecked
                    ? context.theme.primaryColor
                    : const Color(color6B6B6B),
                height: 1.1,
              ),
            ),
            Visibility(
              visible: isChecked,
              child: Icon(
                Icons.check,
                size: 40.w,
                color: context.theme.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
