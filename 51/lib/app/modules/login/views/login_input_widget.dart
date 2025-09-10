import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/widget/common_gradient.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_common_drop_menu.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';

//登录输入组件的类型
enum LoginInputWidgetType {
  textInputType, //文本
  phoneInputType, //电话
  userPwdInputType, //用户密码
  emailPwdInputType, //邮箱密码
  emailInputType, //邮箱
  codeType, //验证码
  imageVerifyType, // 图形验证码
}

// 定义含有callback的函数类型
typedef CallbackFunction = Function(Function callback);
// 定义返回选中国家的函数类型
typedef CountryCallBack = Function(CountryCode);

//登录输入框组件
class LoginInputWidget extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final CountryCallBack? onCounrtyChanged;
  final VoidCallback? onTap;
  final LoginInputWidgetType loginInputType;
  final String headIconPath;
  final bool autofocus;
  final bool isShowPwd;
  final bool isNewPhone;
  final String? defaultContent;
  final EdgeInsetsGeometry? margin;
  final String? imageUrl;
  final CountryCode? countryCode;
  final List<CountryCode>? countrys;
  final int? maxLength;
  final CallbackFunction? onValid;
  final bool? isShowLeftIcon;
  final int? borderRadius;
  final bool? isShowCountryCode;
  final FocusNode? focusNode;
  final VoidCallback? clickInput;
  final double? height;
  final bool? isCanCN; //能否输入中文
  const LoginInputWidget({
    super.key,
    required this.hint,
    this.onChanged,
    this.onCounrtyChanged,
    this.onTap,
    this.loginInputType = LoginInputWidgetType.textInputType,
    required this.headIconPath,
    this.autofocus = false,
    this.defaultContent,
    this.margin,
    this.imageUrl,
    this.countryCode,
    this.countrys,
    this.maxLength,
    this.height,
    this.onValid,
    this.isShowPwd = false,
    this.isNewPhone = false,
    this.isShowLeftIcon = true,
    this.borderRadius = 77,
    this.isShowCountryCode = true,
    this.focusNode,
    this.clickInput,
    this.isCanCN = false,
  });

  @override
  State<LoginInputWidget> createState() => _LoginInputWidgetState();
}

class _LoginInputWidgetState extends State<LoginInputWidget> {
  bool isShowPwd = false;
  late TextEditingController editingController;
  late TextInputType textInputType;
  String rightText = "获取验证码";
  bool isCanClickRightText = true; //是否可点击
  int countdownTime = 60;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    editingController = TextEditingController(text: widget.defaultContent);
    textInputType = _getTextInputType(widget.loginInputType);
    isShowPwd = widget.isShowPwd;
  }

  @override
  void didUpdateWidget(LoginInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 检查 defaultContent 是否变化
    if (oldWidget.defaultContent != widget.defaultContent) {
      setState(() {
        editingController.text = widget.defaultContent ?? ""; // 更新现有文本
      });
    }
  }

  TextInputType _getTextInputType(LoginInputWidgetType type) {
    switch (type) {
      case LoginInputWidgetType.phoneInputType:
        return TextInputType.phone;
      case LoginInputWidgetType.userPwdInputType:
      case LoginInputWidgetType.emailPwdInputType:
        return TextInputType.emailAddress;
      case LoginInputWidgetType.codeType:
        return TextInputType.number;
      case LoginInputWidgetType.emailInputType:
        return TextInputType.emailAddress;
      default:
        return TextInputType.emailAddress;
    }
  }

  @override
  void dispose() {
    editingController.dispose();
    if (_timer != null) {
      if (_timer!.isActive) _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> list = [
      // FilteringTextInputFormatter.deny(RegExp(r' ')), // 禁止普通空格
      NoSpaceFormatter(),
      // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), // 只允许数字和字母
      // 排除中文字符
    ];
    if (!(widget.isCanCN ?? false)) {
      list.add(FilteringTextInputFormatter.deny(RegExp(r'[\u4e00-\u9fa5]')));
    }
    return Container(
        margin: widget.margin,
        key: _countryKey,
        height: widget.height ?? 114.h,
        padding: EdgeInsets.symmetric(horizontal: 53.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: context.customTheme?.inputBgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius!.r)),
        child: Row(
          children: [
            _buildLeftWidget(),
            Expanded(
              child: TextField(
                onTap: widget.clickInput,
                obscureText: isShowPwd,
                keyboardType: textInputType,
                controller: editingController,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                onChanged: widget.onChanged,
                cursorColor: context.theme.primaryColor,
                maxLength: widget.maxLength, // 设置最大字符数
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        required maxLength}) =>
                    null, // 不显示计数器
                style: TextStyle(
                    fontSize: 46.sp, color: context.customTheme?.titleColor),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  contentPadding: EdgeInsets.only(top: 60.h, left: 30.w),
                  hintStyle: TextStyle(
                      fontSize: 46.sp, color: context.customTheme?.title2Color),
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
                inputFormatters: list,
              ),
            ),
            _buildRightWidget()
          ],
        ));
  }

  Widget _buildLeftWidget() {
    final icon = Image.asset(
      widget.headIconPath,
      width: 48.w,
      height: 48.h,
    );
    if (widget.loginInputType == LoginInputWidgetType.phoneInputType) {
      return CommonRipple(
        onTap: () {
          AppManager.instance.tapVibrate();
          widget.onTap!();
        },
        child: Row(
          children: [
            widget.isShowLeftIcon == true ? icon : const SizedBox(),
            Visibility(
              visible:
                  widget.isShowLeftIcon == true && widget.countryCode != null,
              child: SizedBox(
                width: 33.w,
              ),
            ),
            widget.countryCode != null
                ? selectCountryDropdown(context)
                : const SizedBox()
          ],
        ),
      );
    }

    if (widget.isShowLeftIcon == false) {
      return const UnconstrainedBox(
        child: SizedBox.shrink(),
      );
    }
    return UnconstrainedBox(
      child: icon,
    );
  }

  Widget _buildRightWidget() {
    switch (widget.loginInputType) {
      case LoginInputWidgetType.userPwdInputType:
        return CommonRipple(
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
      case LoginInputWidgetType.codeType:
        return CommonRipple(
          onTap: () {
            AppManager.instance.tapVibrate();
            if (isCanClickRightText && widget.onValid != null) {
              // 通过验证
              widget.onValid!(() {
                if (!isCanClickRightText) return;
                setState(() {
                  isCanClickRightText = false;
                  countdownTime = 60;
                });
                _startCountdown();
              });
            }
          },
          child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                isCanClickRightText ? rightText : "$countdownTime秒后可再次获取",
                style: isCanClickRightText
                    ? TextStyle(
                        fontSize: 46.sp,
                        decoration: TextDecoration.underline, // 添加下划线
                        decorationColor: context.theme.primaryColor, // 下划线颜色
                        decorationThickness: 1.0,
                        color: context.theme.primaryColor,
                      )
                    : TextStyle(
                        fontSize: 32.sp,
                        color: Colors.grey,
                      ),
              )),
        );

      case LoginInputWidgetType.imageVerifyType:
        if (widget.imageUrl == null || widget.imageUrl == '') {
          return Container(
            width: 130.w,
            height: 65.h,
            decoration: BoxDecoration(
              gradient: CommonGradient.getRadialGradient(index: 0),
            ),
          );
        }
        // 去掉前缀
        String base64Image = widget.imageUrl!.split(',')[1];
        // 解码 Base64 字符串
        Uint8List bytes = const Base64Decoder().convert(base64Image);
        return CommonRipple(
          onTap: () {
            AppManager.instance.tapVibrate();
            widget.onTap!();
          },
          child: Container(
            width: 180.w,
            height: 90.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: MemoryImage(bytes),
              ),
              gradient: CommonGradient.getRadialGradient(index: 0),
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownTime == 0) {
        setState(() {
          isCanClickRightText = true;
        });
        timer.cancel();
      } else {
        setState(() {
          countdownTime--;
        });
      }
    });
  }

  //最近
  final GlobalKey _countryKey = GlobalKey();
  //选择钱包的组件
  Widget selectCountryDropdown(BuildContext context) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        print("执行了吗：${AppCommonDropMenu.instance.isShowing()}");
        if (AppCommonDropMenu.instance.isShowing()) {
          AppCommonDropMenu.instance.hide();
        } else {
          AppCommonDropMenu.instance.show(
            context,
            _countryKey,
            _buildCountryDropMenu(),
            width: 500.w, // 自定义宽度
            height: 0.3.sh, // 自定义高度
          );
        }
        setState(() {}); // 重新渲染
      },
      child: SizedBox(
          height: 56.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // 主轴方向居中
            crossAxisAlignment: CrossAxisAlignment.center, // 交叉轴方向居中
            children: [
              Text("+${widget.countryCode?.dialCode}",
                  style: TextStyle(color: context.customTheme?.titleColor)),
              Icon(Icons.arrow_drop_down,
                  size: 60.w, color: context.customTheme?.titleColor),
            ],
          )),
    );
  }

  /// 自定义弹出菜单内容
  Widget _buildCountryDropMenu() {
    // if (widget.countrys == null || widget.countrys!.isEmpty)
    //   return const SizedBox.shrink();
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: widget.countrys!.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1.h, color: Colors.grey, thickness: 1.h),
      itemBuilder: (context, index) {
        CountryCode item = widget.countrys![index];
        return CommonRipple(
          onTap: () {
            AppManager.instance.tapVibrate();
            widget.onCounrtyChanged!(widget.countrys![index]);
            AppCommonDropMenu.instance.hide(); // 选择后隐藏弹出框
          },
          child: Container(
            height: 100.h,
            alignment: Alignment.center,
            child: Text("${item.name!} ${item.code!} +${item.dialCode!}"),
          ),
        );
      },
    );
  }
}

class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 如果正在组合输入（如拼音输入法未完成输入），直接返回新值
    if (newValue.composing.isValid) {
      return newValue;
    }

    // 移除空格字符
    String filteredText = newValue.text.replaceAll(' ', '');

    // 返回新的 TextEditingValue，同时保持光标位置和组合状态
    return TextEditingValue(
      text: filteredText,
      selection: newValue.selection.copyWith(
        baseOffset: filteredText.length,
        extentOffset: filteredText.length,
      ),
      composing: TextRange.empty, // 确保组合状态清空
    );
  }
}
