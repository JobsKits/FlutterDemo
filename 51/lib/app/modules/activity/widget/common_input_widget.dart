import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity_detail_view.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

// 输入框类型
enum InputWidgetTypeEnum {
  pwdInputType, // 密码模式
  customeType, // 自定义类型
}

class MinMaxInputFormatter extends TextInputFormatter {
  final double? minValue;
  final double? maxValue;

  MinMaxInputFormatter({
    this.minValue = 0,
    this.maxValue = 10e8,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 如果新输入的值为空，则返回空
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // 尝试将输入的新值转换为整数
    final double newValueDouble = double.parse(newValue.text);

    // 检查并设置最小值或最大值
    if (newValueDouble < minValue!) {
      return TextEditingValue(
        text: parseNumber(minValue),
        selection:
            TextSelection.collapsed(offset: parseNumber(minValue).length),
      );
    }

    if (newValueDouble > maxValue!) {
      return TextEditingValue(
        text: parseNumber(maxValue),
        selection:
            TextSelection.collapsed(offset: parseNumber(maxValue).length),
      );
    }

    // 返回更新的新值
    return newValue;
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  DecimalInputFormatter({required this.decimalPlaces});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 正则表达式判断有效输入
    final regex = RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}$');

    // 如果新输入的值为空或者符合正则，则返回新值
    if (newValue.text.isEmpty || regex.hasMatch(newValue.text)) {
      return newValue;
    }

    // 否则返回旧值
    return oldValue;
  }
}

// ignore: must_be_immutable
class CommonInputWidget extends StatefulWidget {
  final bool required; // 无用
  final bool autofocus; // 自动聚焦
  final bool readOnly; // 只读模式
  final bool isShowPwd; // 密码***
  final EdgeInsetsGeometry? margin;
  final ValueChanged<String>? onChanged; // 输入框值变化的回掉
  final VoidCallback? onTap; // 右侧按钮点击回掉
  final String? defaultContent; // 默认文本，用于初始化或者更新
  late InputWidgetTypeEnum? inputWidgetType; // 输入框布局类型
  final double? minValue; // 输入框最大值
  final double? maxValue; // 输入框最小值
  final String placeholder; // 占位符
  late TextInputType textInputType; // 输入框模式
  final int? maxLength; // 输入框支持最大长度
  final int maxLines; // 最大显示行数
  final FocusNode? outsideFocus; //外部传递的焦点管理
  final Widget? rightWidget; // 自定义右侧组件
  Color? color;
  Color? readOnlyColor;

  CommonInputWidget({
    super.key,
    this.autofocus = false,
    this.readOnly = false,
    this.required = true,
    this.isShowPwd = false,
    this.margin,
    this.onChanged,
    this.onTap,
    this.defaultContent,
    this.inputWidgetType,
    this.minValue,
    this.maxValue,
    this.placeholder = "请输入",
    this.textInputType = TextInputType.text,
    this.maxLength = 50,
    this.maxLines = 1,
    this.outsideFocus,
    this.rightWidget,
    this.color,
    this.readOnlyColor = const Color(colorD4D4D4),
  });

  @override
  State<CommonInputWidget> createState() => _CommonInputWidget();
}

class _CommonInputWidget extends State<CommonInputWidget>
    with WidgetsBindingObserver {
  bool isShowPwd = false;
  late TextEditingController editingController;
  late TextInputType textInputType;
  late FocusNode focusNode; // 添加 FocusNode

  String rightText = "获取验证码";
  bool isCanClickRightText = true; //是否可点击
  int countdownTime = 60;
  String? errorText; // 错误信息
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    editingController = TextEditingController(text: widget.defaultContent);
    isShowPwd = widget.isShowPwd;
    if (widget.outsideFocus != null) {
      //如果外面有传递焦点，使用外面的
      focusNode = widget.outsideFocus!;
    } else {
      focusNode = FocusNode();
    }
  }

  @override
  void didUpdateWidget(CommonInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 检查 defaultContent 是否变化
    if (oldWidget.defaultContent != widget.defaultContent &&
        editingController.text != widget.defaultContent) {
      setState(() {
        editingController.text = widget.defaultContent ?? ""; // 更新现有文本
        editingController.selection = TextSelection.fromPosition(
          TextPosition(offset: editingController.text.length),
        ); // 将光标移动到文本末尾
      });
    }

    // 如果 autofocus 改变，重新请求焦点
    if (widget.autofocus && !oldWidget.autofocus) {
      FocusScope.of(context).requestFocus(focusNode);
    } else if (!widget.autofocus && oldWidget.autofocus) {
      focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    editingController.dispose();
    _timer?.cancel(); // 释放定时器
    focusNode.dispose(); // 释放 FocusNode
    super.dispose();
  }

  List<TextInputFormatter>? _getInputFormatters() {
    /// 输入数字模式
    if (widget.textInputType == TextInputType.number) {
      List<TextInputFormatter> inputList = [];

      inputList.add(
        FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
      );

      if (widget.minValue != null && widget.maxValue != null) {
        inputList.add(MinMaxInputFormatter(
          minValue: widget.minValue!,
          maxValue: widget.maxValue!,
        ));
      }

      return inputList;
    }

    /// 输入带小数点的
    if (widget.textInputType ==
        const TextInputType.numberWithOptions(decimal: true)) {
      List<TextInputFormatter> inputList = [];

      inputList.add(
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // 允许数字和小数点
      );
      inputList.add(DecimalInputFormatter(decimalPlaces: 3));

      if (widget.minValue != null && widget.maxValue != null) {
        inputList.add(MinMaxInputFormatter(
          minValue: widget.minValue!,
          maxValue: widget.maxValue!,
        ));
      }
      return inputList;
    }
    if (widget.textInputType == TextInputType.visiblePassword) {
      List<TextInputFormatter> inputList = [
        FilteringTextInputFormatter.deny(
          RegExp(r'\s'), // 禁止空格字符
        ),
      ];
      return inputList;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.color != null
        ? widget.color!
        : context.customTheme?.inputBgColor ??
            const Color(colorDDDDDD).withOpacity(0.4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: widget.margin ?? EdgeInsets.only(top: 10.h),
          height: widget.maxLines == 1 ? 124.h : null,
          decoration: BoxDecoration(
              color: widget.readOnly ? widget.readOnlyColor! : bgColor,
              borderRadius: BorderRadius.circular(24.r)),
          child: _buildInputRow(context),
        ),
      ],
    );
  }

  Widget _buildInputRow(BuildContext context) {
    return Row(
      children: [
        _buildLeftWidget(),
        Expanded(
          flex: 1,
          child: TextFormField(
            obscureText: isShowPwd,
            controller: editingController,
            keyboardType: widget.textInputType,
            focusNode: focusNode,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            maxLength: widget.maxLength,
            readOnly: widget.readOnly,
            cursorColor: context.theme.primaryColor,
            inputFormatters: _getInputFormatters(),
            maxLines: widget.maxLines,
            textInputAction: widget.maxLines > 1
                ? TextInputAction.newline
                : TextInputAction.done,
            buildCounter: (context,
                    {required currentLength,
                    required isFocused,
                    required maxLength}) =>
                null, // 不显示计数器
            style: TextStyle(
                fontSize: 36.sp, color: context.customTheme?.titleColor),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 30.h),
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                fontSize: 36.sp,
                color: context.customTheme?.title2Color,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none, // 去除边框线
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none, // 去除边框线
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none, // 去除边框线
              ),
            ),
          ),
        ),
        _buildRightWidget(),
      ],
    );
  }

  // 左侧
  Widget _buildLeftWidget() {
    Widget leftWidget = const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(left: 30.w),
      child: leftWidget,
    );
  }

  // 右侧
  Widget _buildRightWidget() {
    Widget rightWidget = const SizedBox.shrink();
    // 自定义右侧
    if (widget.inputWidgetType == InputWidgetTypeEnum.customeType) {
      return widget.rightWidget ?? const SizedBox();
    }

    // 密码输入框
    if (widget.inputWidgetType == InputWidgetTypeEnum.pwdInputType) {
      rightWidget = InkWell(
        onTap: () {
          AppManager.instance.tapVibrate();
          setState(() {
            isShowPwd = !isShowPwd;
          });
        },
        child: SvgPicture.asset(
          isShowPwd
              ? Assets.theme1.images.login.iconInputEyeClose
              : Assets.theme1.images.login.iconInputEyeOpen,
          width: 40.w,
          height: 40.h,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: 30.w),
      child: rightWidget,
    );
  }
}
