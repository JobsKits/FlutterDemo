import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/custom_icon.dart';

import '../../../widget/input/custom_main_text_field.dart';
import '../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

class SetupSocialAccountWidget extends StatefulWidget {
  final String iconAsset;
  final String name;
  final String text;
  final Function(String value) inputCompletionCallBack;
  final void Function(String value) inputCallBack;

  const SetupSocialAccountWidget({
    super.key,
    required this.iconAsset,
    required this.name,
    required this.text,
    required this.inputCompletionCallBack,
    required this.inputCallBack,
  });

  @override
  State<StatefulWidget> createState() => _SetupSocialAccountWidget();
}

class _SetupSocialAccountWidget extends State<SetupSocialAccountWidget> {
  String errorStr = "";
  bool editing = false;
  late String text; // 声明为late以便后续初始化
  String inputText = "";
  final FocusNode focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant SetupSocialAccountWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    text = widget.text;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Container(
        //   width: 40,
        //   height: 40,
        //   clipBehavior: Clip.hardEdge,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: Image.asset(
        //     widget.iconAsset,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        // const SizedBox(
        //   width: AppValues.padding_10,
        // ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomText(
              //   widget.name,
              //   textColorStyle: CustomTextColorStyle.normal,
              //   style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              // ),
              // const SizedBox(
              //   height: AppValues.smallPadding,
              // ),
              _buildTextFiled(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTextFiled() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            widget.iconAsset,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: AppValues.padding_10,
        ),
        Expanded(
          child: CustomMainTextField(
            errorText: errorStr,
            showError: errorStr.isNotEmpty,
            keyboardType:
                getMaxLength() == 19 ? const TextInputType.numberWithOptions() : TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter(getIpReg(), allow: true),
              // LengthLimitingTextInputFormatter(getMaxLength())
            ],
            maxLength: getMaxLength(),
            // text: text.isEmpty ? inputText : text,
            text: text,
            isShowDeleteBtn: false,
            focusNode: focusNode,
            contentPadding: const EdgeInsets.only(left: AppValues.defaultPadding),
            hintText: '',

            inputCompletionCallBack: (value, isCompleted) {
              widget.inputCompletionCallBack(value);
              inputText = value;
              if (isCompleted) {
                setState(() {
                  editing = false;
                });
              }
            },
            inputCallBack: (value) {
              log("录入  ${value}");
              // widget.inputCallBack(value);
              widget.inputCallBack(value);
              text = value;
              setState(() {
                editing = true;
                errorStr = getShowErr(value);
              });
            },
            // enabled: isTextFiledEnabled,
          ),
        ),
        // _buildTextFiledState(),
      ],
    );
  }

  Widget _buildTextFiledState() {
    if (text.isEmpty) return const SizedBox.shrink();
    return editing ? _buildTextFiledEditingState() : _buildTextFiledNormalState();
  }

  Widget _buildTextFiledEditingState() {
    return Row(
      children: [
        const SizedBox(
          width: AppValues.smallPadding,
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                text = '';
                widget.inputCompletionCallBack(text);
              });
            },
            child: const CustomIcon(asset: 'assets/images/setup/ic_text_filed_cancel.png')),
        const SizedBox(
          width: AppValues.defaultPadding,
        ),
        GestureDetector(
            onTap: () {
              widget.inputCompletionCallBack(text);
              focusNode.unfocus();
              setState(() {
                editing = false;
              });
            },
            child: const CustomIcon(asset: 'assets/images/setup/ic_text_filed_confirm.png')),
        const SizedBox(
          width: AppValues.defaultPadding,
        ),
      ],
    );
  }

  Widget _buildTextFiledNormalState() {
    return Row(
      children: [
        const SizedBox(
          width: AppValues.defaultPadding,
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                editing = true;
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                FocusScope.of(context).requestFocus(focusNode);
              });
            },
            child: const CustomIcon(asset: 'assets/images/setup/ic_text_filed_edit.png')),
        const SizedBox(
          width: AppValues.defaultPadding,
        ),
      ],
    );
  }

  bool get isTextFiledEnabled {
    if (text.isEmpty) return true;
    if (editing) return true;
    return false;
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    return colorScheme.tertiary;
  }

  String getShowErr(String input) {
    if (input.isEmpty) {
      return "";
    }
    switch (widget.name) {
      case "Telegram":
      case "Whatsapp":
      case "Line":
      case "X":
      case "Zalo":
      case "Viber":
      case "Wechat":
        if (widget.name == "Telegram" && !isFirstCharLetter(input)) {
          return S.current.random_text_1172;
        }
        if (input.length < getMinLength()) {
          return "${S.current.random_text_1173}${getMinLength()}${LangUtil().isHiIN() ? " है" : ""}";
        }
        return isSpecialChar(input);
      default:
        return "";
    }
  }

  int getMaxLength() {
    switch (widget.name) {
      case "Facebook":
        return 50;
      case "Whatsapp":
        return 19;
      case "Telegram":
        return 32;
      case "Line":
        return 50;
      case "X":
        return 15;
      case "Zalo":
        return 19;
      case "Viber":
        return 100;
      case "Wechat":
        return 20;
      default:
        return 200;
    }
  }

  int getMinLength() {
    switch (widget.name) {
      case "Facebook":
        return 0;
      case "Whatsapp":
        return 10;
      case "Telegram":
        return 5;
      case "Line":
        return 2;
      case "X":
        return 4;
      case "Zalo":
        return 10;
      case "Viber":
        return 6;
      case "Wechat":
        return 6;
      default:
        return 0;
    }
  }

  RegExp getIpReg() {
    final regexMap = {
      "Facebook": RegExp('.*'),
      "Whatsapp": RegExp(r'[0-9]'),
      "Telegram": RegExp(r'^[^\u4e00-\u9fff]*$'),
      "Line": RegExp(r'^[^\u4e00-\u9fff]*$'),
      "X": RegExp(r'^[^\u4e00-\u9fff]*$'),
      "Zalo": RegExp(r'[0-9]'),
      "Viber": RegExp(r'^[^\u4e00-\u9fff]*$'),
      "Wechat": RegExp(r'^[^\u4e00-\u9fff]*$'),
    };
    return regexMap[widget.name] ?? RegExp('.*');
  }

  bool isFirstCharLetter(String? input) {
    if (input != null && input.isNotEmpty) {
      String firstChar = input[0];
      return RegExp(r'[a-zA-Z]').hasMatch(firstChar);
    }
    return false;
  }

  String isSpecialChar(String input) {
    final regexMap = {
      "Facebook": {"reg": RegExp('.*'), "error": ""},
      "Whatsapp": {"reg": RegExp(r'[0-9]'), "error": ""},
      "Telegram": {"reg": RegExp(r'^[a-zA-Z0-9_]*$'), "error": "仅支持“_”"},
      "Line": {"reg": RegExp(r'^[a-zA-Z0-9-_]*$'), "error": "仅支持“-”“_”"},
      "X": {"reg": RegExp(r'^[a-zA-Z0-9_]*$'), "error": "仅支持“-”"},
      "Zalo": {"reg": RegExp(r'[0-9]'), "error": ""},
      "Viber": {"reg": RegExp(r'^[a-zA-Z0-9-_]*$'), "error": "仅支持“-”“_”"},
      "Wechat": {"reg": RegExp(r'^[a-zA-Z0-9-_]*$'), "error": "仅支持“-”“_”"},
    };
    RegExp? regex = regexMap[widget.name]!['reg'] as RegExp?;
    String? error = regexMap[widget.name]!['error'] as String?;
    if (regex != null && !regex.hasMatch(input)) {
      return "$error";
    } else {
      return "";
    }
  }
}
