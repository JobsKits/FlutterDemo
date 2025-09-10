import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

class DropdownSelectBean {
  DropdownSelectBean({
    required this.label,
    required this.value,
  });

  String label;
  String value;
}

class DropdownSelect extends StatelessWidget {
  final String? currentValue; // 当前选择的值
  final List<DropdownSelectBean> options; // 可供选择的选项
  final ValueChanged<String?> onChanged; // 值改变的回调
  final String? placeholder;

  const DropdownSelect({
    super.key,
    required this.currentValue,
    required this.options,
    required this.onChanged,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h, bottom: 60.h),
      padding: EdgeInsets.only(left: 30.w),
      height: 124.h,
      decoration: BoxDecoration(
          color: const Color(colorF4F4F4),
          borderRadius: BorderRadius.circular(30.r)),
      child: DropdownButtonHideUnderline(child: _buildDropdownButton()),
    );
  }

  // 下拉按钮
  _buildDropdownButton() {
    // 获取屏幕宽度并计算需要的宽度
    // final double menuWidth = MediaQuery.of(Get.context!).size.width - 126.w;
    return DropdownButton<String>(
      value: currentValue,
      items: options.map((DropdownSelectBean item) {
        return DropdownMenuItem<String>(
          value: item.value,
          child: Text(
            item.label,
            style: TextStyle(
              fontSize: 36.sp,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged, // 当选项改变时触发
      hint: Text(
        placeholder ?? '请选择',
        style: TextStyle(
          fontSize: 36.sp,
          color: const Color(color666666),
        ),
      ),
      icon: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Icon(
          Icons.arrow_drop_down_rounded,
          size: 80.w,
          color: const Color(0xFFB5B5B5),
        ),
      ),
      underline: const SizedBox.shrink(),
      isExpanded: true, // 确保下拉菜单宽度与容器宽度一致
      isDense: true,
      // menuWidth: menuWidth,
      dropdownColor: Colors.white,
      alignment: AlignmentDirectional.center,
    );
  }
}
