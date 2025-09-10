import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/utils/function.dart';

import '../../../services/theme/theme_service.dart';
import '../../../utils/keyboard_util.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/input/custom_text_field.dart';

///联盟计划-自定义widget-账号搜索输入框
class CustomAllianceSearchWidget extends StatefulWidget {
  const CustomAllianceSearchWidget({
    super.key,
    this.width,
    this.hintText,
    this.callback,
    this.borderShow = true,
    this.hintColor,
    this.hintStyle,
  });

  final double? width;
  final String? hintText;

  final ParamSingleCallback<String>? callback;
  final bool borderShow; //是否显示边框
  final Color? hintColor;
  final TextStyle? hintStyle;

  @override
  State<CustomAllianceSearchWidget> createState() => _CustomAllianceSearchWidgetState();
}

class _CustomAllianceSearchWidgetState extends State<CustomAllianceSearchWidget> {
  String inputTexted = ""; //输入完毕的，执行搜索的； 也可以表示上次的搜索关键字
  String inputTexting = ""; //正在输入的

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 100,
      height: 40,
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.surface,
        // border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2.0),
        border: widget.borderShow
            ? Border.all(color: ThemeService().colorScheme.tertiary, width: 2)
            : null,
        // Add a border
        borderRadius: BorderRadius.circular(4), // Set border radius to 0
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 4),
          Expanded(
            child: CustomTextField(
              contentPadding: const EdgeInsets.only(left: 8, bottom: 0),
              // const EdgeInsets.only(left: AppValues.defaultPadding),
              text: inputTexted,
              isShowDeleteBtn: true,
              isDense: false,
              //是否紧凑显示，
              hintText: widget.hintText ?? S.current.wallet_search,
              hintColor: widget.hintColor,
              hintStyle: widget.hintStyle,
              // rightWidget:
              // rightWidget: CustomA("assets/images/alliance/ic_alliance_search_data.webp"),
              leftWidgetConstraints: BoxConstraints.tight(Size.fromWidth(34)),
              leftWidget: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: CustomAssetIcon(
                  size: 14,
                  name: "assets/images/common/ic_common_search_gray0dp.webp",
                ),
              ),
              // const Icon(
              //   size: 19,
              //   Icons.search, // You can use any custom icon you want here.
              //   // color: CupertinoColors.systemGrey, // Customize the icon color.
              //   color: Color(0xFFB1BAD3), // Customize the icon color.
              // ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              inputCompletionCallBack: (value, isSubmitted) {
                //todo: 注意收起键盘会回调该方法。包括点击键盘外、执行done、点击搜索小图标。isSubmitted 点击done才是true
                // 所以在 关键词没有任何变化时，不需要执行搜索操作，即不给被调者回调；
                log("inputCompletionCallBack...value:$value...isSubmitted:$isSubmitted");
                if (inputTexted == value) {
                  return;
                }
                inputTexted = value;
                if (widget.callback != null) {
                  widget.callback!(inputTexted);
                }
              },
              inputCallBack: (value) {
                //正在输入
                log("inputCallBack...value:$value");
                inputTexting = value;
              },
            ),
          ),
          // Center(
          //   child: InkWell(
          //     onTap: () {
          //       KeyboardUtils.hideKeyboard(context);
          //       if (widget.callback != null) {
          //         inputTexted = inputTexting;
          //         widget.callback!(inputTexted);
          //       }
          //     },
          //     child: Container(
          //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          //         child: const CustomAssetIcon(
          //             name: "assets/images/alliance/ic_alliance_search_gray.webp", size: 12)),
          //   ),
          // ),
        ],
      ),
    );
  }
}
