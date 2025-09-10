import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/utils/throttle_util.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';

import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/input/custom_text_field.dart';

///联盟计划-自定义widget-底部分页
class CustomAlliancePageWidget extends StatefulWidget {
  const CustomAlliancePageWidget({
    super.key,
    required this.currentPage,
    this.allPage = 98,
    this.hasMore = true,
    this.callback,
    this.color,
  });

  ///不处理逻辑， 只保存当前页码，数值来自上级，自己本身不执行加减；
  final int currentPage;
  final int allPage;
  final bool hasMore;
  final int firstPage = 1; //默认第一为1
  final Color? color;

  //bool, 是否点击下一页， int 当前页
  final ParamTwiceCallback<bool, int>? callback;

  @override
  State<CustomAlliancePageWidget> createState() => _CustomAlliancePageWidgetState();
}

class _CustomAlliancePageWidgetState extends State<CustomAlliancePageWidget> {
  // var nextFun;

  @override
  void initState() {
    super.initState();
    // nextFun = ThrottleUtil.throttle(() {
    //   log("点击防抖动...下一页...");
    //   widget.callback != null ? widget.callback!(true, widget.currentPage) : null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: AppValues.halfPadding),
      color: widget.color,
      // height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // CustomAssetIcon(name: "assets/images/alliance/ic_alliance_page_left.webp", size: 12),
          // SizedBox(width: 4),
          CustomButton(
            title: S.current.yulecheng_prepage,
            isEnable: widget.currentPage > widget.firstPage,
            textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                color: widget.currentPage == widget.firstPage
                    ? ThemeService().colorScheme.onSurface
                    : ThemeService().colorScheme.onBackground),
            // onTap: ThrottleUtil.throttle(() {
            //   log("点击防抖动...上一页...");
            //   widget.callback != null ? widget.callback!(false, widget.currentPage) : null;
            // }),
            onTap: () {
              widget.callback != null ? widget.callback!(false, widget.currentPage) : null;
            },
          ),
          SizedBox(width: 6),
          Container(
            height: 22,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: const BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(2))),
            child: CustomText(
              "${widget.currentPage}${S.current.random_text_191}${widget.allPage}${S.current.random_text_192}",
              style: ThemeService()
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Color(0xff333333), fontSize: 12),
            ),
          ),
          SizedBox(width: 6),
          CustomButton(
            title: S.current.yulecheng_nextpage,
            isEnable: widget.hasMore,
            textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                color: !widget.hasMore
                    ? ThemeService().colorScheme.onSurface
                    : ThemeService().colorScheme.onBackground),
            // onTap: ThrottleUtil.throttle(() {
            //   log("点击防抖动...下一页...");
            //   widget.callback != null ? widget.callback!(true, widget.currentPage) : null;
            // }),
              onTap: () {
                widget.callback != null ? widget.callback!(true, widget.currentPage) : null;
              },

          ),
          Spacer(),
          CustomText(S.current.random_text_194,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ThemeService().colorScheme.onSurface)),
          SizedBox(width: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 22,
                width: 36,
                // margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                height: 22,
                width: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.go,
                  // 设置为搜索操作
                  onSubmitted: (value) => _submitSearch(value),
                  // 提交（搜索）操作回调函数
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff333333),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // decoration: InputDecoration(
                  //   hintText: "TEST",
                  //   hintStyle: TextStyle(
                  //     fontSize: 12,
                  //     color: Color(0xff333333),
                  //   ),
                  //   border: InputBorder.none,
                  // ),
                ),
              )
            ],
          ),

          // Container(
          //   width: 38,
          //   height: 20,
          //   decoration: BoxDecoration(
          //       color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(2))),
          //   child: CustomTextField(
          //     text: "${widget.currentPage}",
          //     textInputAction: TextInputAction.done,
          //     keyboardType: TextInputType.number,
          //     inputCompletionCallBack: (value, isSubmitted) {
          //       log("inputCompletionCallBack...value:" + value.toString());
          //     },
          //     inputCallBack: (value) {
          //       log("inputCallBack...value:" + value.toString());
          //     },
          //   ),
          // ),

          SizedBox(width: 10),
          CustomText(S.current.random_text_192,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ThemeService().colorScheme.onSurface)),
        ],
      ),
    );
  }

  ///键盘回调
  _submitSearch(String value) {
    log("键盘回调...${value}");
  }
}
