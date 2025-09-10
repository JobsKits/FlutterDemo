import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_list_item_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_offline_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_online_controller.dart';
// import 'package:get/get.dart';

import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_rich_title_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/wallet_input_field_widget.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';

// ignore: must_be_immutable
class WalletInputFieldWidget2 extends StatefulWidget {
  final String title;
  final bool required;
  final bool autofocus;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final String? defaultContent;
  final int? maxLength;
  late TextInputType textInputType;
  final String placeholder;
  CurrencyType? currencyType;
  final double? minValue;
  final double? maxValue;
  final DisplayType? displayType;
  bool? obscureText;
  bool? isOffline;
  Widget? child;
  ValueChanged<CurrencyType>? typeChange;

  WalletInputFieldWidget2({
    super.key,
    required this.title,
    this.onChanged,
    this.autofocus = false,
    this.readOnly = false,
    this.required = true,
    this.defaultContent,
    this.maxLength,
    this.textInputType = TextInputType.text,
    this.placeholder = "请输入",
    this.currencyType,
    this.minValue,
    this.maxValue,
    this.displayType = DisplayType.none,
    this.obscureText = false,
    this.isOffline = false,
    this.child,
    this.typeChange,
  });

  @override
  State<WalletInputFieldWidget2> createState() => _WalletInputFieldWidget2();
}

class _WalletInputFieldWidget2 extends State<WalletInputFieldWidget2> {
  late TextEditingController editingController;
  late TextInputType textInputType;
  late RechargeOnlineController onlineController = Get.find();
  late RechargeOfflineController offlineController = Get.find();
  @override
  void initState() {
    super.initState();
    editingController = TextEditingController(text: widget.defaultContent);
  }

  @override
  void didUpdateWidget(WalletInputFieldWidget2 oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 检查 defaultContent 是否变化
    if (oldWidget.defaultContent != widget.defaultContent) {
      setState(() {
        editingController.text = widget.defaultContent ?? ""; // 更新现有文本
        editingController.selection = TextSelection.fromPosition(
          TextPosition(offset: editingController.text.length),
        ); // 将光标移动到文本末尾
      });
    }
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (widget.textInputType == TextInputType.number) {
      List<TextInputFormatter> inputList = [];

      inputList.add(
        FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
      );

      if (widget.minValue != null && widget.maxValue != null) {
        // inputList.add(MinMaxInputFormatter(
        //   minValue: widget.minValue!,
        //   maxValue: widget.maxValue!,
        // ));
      }

      return inputList;
    }

    if (widget.textInputType ==
        const TextInputType.numberWithOptions(decimal: true)) {
      List<TextInputFormatter> inputList = [];

      // inputList.add(
      //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // 允许数字和小数点
      // );
      inputList.add(
        FilteringTextInputFormatter.allow(RegExp(r'^\d*')), // 禁止输入小数点，只允许整数
      );
      inputList.add(DecimalInputFormatter(decimalPlaces: 2));

      if (widget.minValue != null && widget.maxValue != null) {
        inputList.add(MinMaxInputFormatter(
          minValue: widget.minValue!,
          maxValue: widget.maxValue!,
        ));
      }
      return inputList;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == '') {
      return Container(
        margin: EdgeInsets.only(top: 27.h, bottom: 40.h),
        height: 130.h,
        decoration: BoxDecoration(
            color: widget.readOnly
                ? const Color(colorE5E5E5)
                : context.customTheme?.pageBg,
            borderRadius: BorderRadius.circular(30.r)),
        child: _buildInputRow(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RechargeRichTitleWidget(
          str: widget.title,
          fontSize: 45.sp,
          required: widget.required,
          child: widget.child,
        ),
        Container(
          margin: EdgeInsets.only(top: 27.h, bottom: 40.h),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 130.h,
                  decoration: BoxDecoration(
                      color: widget.readOnly
                          ? const Color(colorE5E5E5)
                          : context.customTheme?.pageBg,
                      borderRadius: BorderRadius.circular(30.r)),
                  child: _buildInputRow(),
                ),
              ),
              if (widget.displayType == DisplayType.virtual) ...[
                SizedBox(
                  width: 20.w,
                ),
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    setState(() {
                      if (widget.isOffline ?? false) {
                        if (offlineController.currencyType.value ==
                            CurrencyType.crypto) {
                          widget.currencyType = CurrencyType.fiat;
                          widget.typeChange!(CurrencyType.fiat);
                        } else {
                          widget.currencyType = CurrencyType.crypto;
                          widget.typeChange!(CurrencyType.crypto);
                        }
                      } else {
                        if (onlineController.currencyType.value ==
                            CurrencyType.crypto) {
                          widget.currencyType = CurrencyType.fiat;
                          widget.typeChange!(CurrencyType.fiat);
                        } else {
                          widget.currencyType = CurrencyType.crypto;
                          widget.typeChange!(CurrencyType.crypto);
                        }
                      }
                    });
                  },
                  child: Container(
                    width: 170.w,
                    height: 130.h,
                    decoration: BoxDecoration(
                        color: context.customTheme?.pageBg,
                        borderRadius: BorderRadius.circular(30.r)),
                    child: UnconstrainedBox(
                      child: Image.asset(
                        width: 58.w,
                        height: 50.h,
                        Assets.theme1.images.recharge.iconVirtualChange.path,
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAddOnBefore() {
    // 法币
    if (widget.currencyType == CurrencyType.fiat) {
      return Row(
        children: [
          SizedBox(width: 30.w),
          Text(
            "￥",
            style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
          ),
        ],
      );
      return SizedBox.shrink();
    }
    // 虚拟币
    if (widget.currencyType == CurrencyType.crypto) {
      return Row(
        children: [
          SizedBox(width: 30.w),
          Image.asset(
            Assets.theme1.images.recharge.iconCrypto.path,
            width: 46.w,
            height: 49.h,
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildInputRow() {
    return Row(
      children: [
        _buildAddOnBefore(),
        Expanded(
          flex: 1,
          child: TextField(
            controller: editingController,
            keyboardType: widget.textInputType,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            maxLength: widget.maxLength,
            obscureText: widget.obscureText ?? false,
            readOnly: widget.readOnly, // 只读模式
            cursorColor: context.theme.primaryColor,
            inputFormatters: _getInputFormatters(),
            style: TextStyle(
                color: context.customTheme?.rechargeSecondTypeBgColor),
            buildCounter: (context,
                    {required currentLength,
                    required isFocused,
                    required maxLength}) =>
                null, // 不显示计数器
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 60.h, left: 36.w),
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                fontSize: 36.sp,
                color: const Color(colorBCBCBC),
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
        if (widget.displayType == DisplayType.password) ...[
          InkWell(
            onTap: () {
              AppManager.instance.tapVibrate();
              setState(() {
                widget.obscureText = !(widget.obscureText ?? false);
              });
            },
            child: SvgPicture.asset(
              widget.obscureText == true
                  ? Assets.theme1.images.login.iconInputEyeClose
                  : Assets.theme1.images.login.iconInputEyeOpen,
              width: 40.w,
              height: 40.h,
            ),
          ),
          const SizedBox(width: 10)
        ],
        if (widget.displayType == DisplayType.paste) ...[
          InkWell(
            onTap: () async {
              AppManager.instance.tapVibrate();
              editingController.text = (await readFromClipboard())!;
              if (widget.onChanged != null) {
                widget.onChanged!(editingController.text);
              }
            },
            child: Text(
              '粘贴',
              style: TextStyle(color: context.theme.primaryColor),
            ),
          ),
          const SizedBox(width: 10)
        ],
      ],
    );
  }

  Future<String?> readFromClipboard() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    String? text = clipboardData?.text;
    return text;
  }
}
