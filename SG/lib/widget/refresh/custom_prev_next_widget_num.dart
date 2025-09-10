import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/app_values.dart';
import '../../generated/l10n.dart';
import '../../services/theme/theme_service.dart';
import '../button/custom_button.dart';
import '../custom_text.dart';
import '../input/custom_text_field.dart';

///上下页组件, 在logic中记得 可以with [CustomPrevNextMixin]
class CustomPrevNextNumWidget extends StatefulWidget {
  CustomPrevNextNumWidget({
    super.key,
    required this.hasPrevPage,
    required this.hasNextPage,
    required this.curPage,
    required this.totalPage,
    required this.onClickPrevPage,
    required this.onClickNextPage,
    this.onClickJumpPage,
    this.margin,
    this.spaceMargin,

    this.showWidget = false,
  });

  final bool hasPrevPage; //还有上一页
  final bool hasNextPage; //还有下一页
  final void Function() onClickPrevPage;
  final void Function() onClickNextPage;
  final void Function(int jumpPage)? onClickJumpPage;
  final EdgeInsetsGeometry? margin;
  final double? spaceMargin;
  final int curPage;
  final int totalPage;
  final bool showWidget;//是否显示组件

  @override
  State<CustomPrevNextNumWidget> createState() => _CustomPrevNextNumWidgetState();
}

class _CustomPrevNextNumWidgetState extends State<CustomPrevNextNumWidget> {
  final _jumpPageObs = 1.obs;
 //跳转到第几页
  @override
  Widget build(BuildContext context) {
    return _buildPrevNextView();
  }

  Widget _buildPrevNextView() {
    return Visibility(
      visible: widget.showWidget,
      child: Container(
        margin: widget.margin ?? const EdgeInsets.only(top: AppValues.margin_12,bottom: AppValues.margin_24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CustomText(
            //   S.current.yulecheng_prepage,
            //   textColorStyle: CustomTextColorStyle.secondary,
            // ),
            CustomButton(
              isEnable: widget.hasPrevPage,
              title: S.current.yulecheng_prepage,
              padding: EdgeInsets.symmetric(horizontal: 6,vertical: 8),
              textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                // color: Color(0xFFB1BAD3),
                color: widget.hasPrevPage
                    ? CustomTextColorStyle.white.value
                    : CustomTextColorStyle.secondary.value,
                fontWeight: FontWeight.w600,
              ),
              onTap: () {
                if (widget.onClickPrevPage != null) {
                  widget.onClickPrevPage.call();
                }
              },
              // S.current.yulecheng_nextpage,
              // textColorStyle: CustomTextColorStyle.white,
              // textColorStyle: CustomTextColorStyle.secondary,
            ),
            //上下页字体之间的间距
            SizedBox(width: widget.spaceMargin ?? AppValues.defaultMargin),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
              decoration: BoxDecoration(
                color: ThemeService().colorScheme.surface,
                border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: CustomText(
                "${widget.curPage}页/${widget.totalPage}页",
                style: ThemeService().textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: widget.spaceMargin ?? AppValues.defaultMargin),
            CustomButton(
              isEnable: widget.hasNextPage,
              title: S.current.yulecheng_nextpage,
              padding: EdgeInsets.symmetric(horizontal: 6,vertical: 8),
              textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                // color: Color(0xFFB1BAD3),
                color: widget.hasNextPage
                    ? CustomTextColorStyle.white.value
                    : CustomTextColorStyle.secondary.value,
                fontWeight: FontWeight.w600,
              ),
              onTap: () {
                if (widget.onClickNextPage != null) {
                  widget.onClickNextPage.call();
                }
              },
              // S.current.yulecheng_nextpage,
              // textColorStyle: CustomTextColorStyle.white,
              // textColorStyle: CustomTextColorStyle.secondary,
            ),
            SizedBox(width: widget.spaceMargin ?? AppValues.largeMargin),
            CustomText(
              "跳转",
              style: ThemeService().textTheme.labelLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              width: 40,
              height: 30,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: ThemeService().colorScheme.surface,
                border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Obx(() {
                return CustomTextField(
                  contentPadding: const EdgeInsets.only(left: 8, bottom: 0),
                  // const EdgeInsets.only(left: AppValues.defaultPadding),
                  text: "${_jumpPageObs.value}",
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  // isShowDeleteBtn: true,
                  // isDense: false,
                  //是否紧凑显示，
                  // hintText: widget.hintText ?? S.current.wallet_search,
                  // hintColor: widget.hintColor,
                  // hintStyle: widget.hintStyle,
                  // rightWidget:
                  // rightWidget: CustomA("assets/images/alliance/ic_alliance_search_data.webp"),
                  // const Icon(
                  //   size: 19,
                  //   Icons.search, // You can use any custom icon you want here.
                  //   // color: CupertinoColors.systemGrey, // Customize the icon color.
                  //   color: Color(0xFFB1BAD3), // Customize the icon color.
                  // ),

                  inputCompletionCallBack: (value, isSubmitted) {
                    //todo: 注意收起键盘会回调该方法。包括点击键盘外、执行done、点击搜索小图标。isSubmitted 点击done才是true
                    // 所以在 关键词没有任何变化时，不需要执行搜索操作，即不给被调者回调；
                    log("inputCompletionCallBack...value:$value...isSubmitted:$isSubmitted");
                    int inputValue = int.tryParse(value) ?? 1;
                    if (inputValue <= widget.totalPage) {
                      _jumpPageObs.value = inputValue;
                      if (widget.onClickJumpPage != null) {
                        widget.onClickJumpPage!.call(_jumpPageObs.value);
                      }
                    }
                  },
                  inputCallBack: (value) {
                    //正在输入
                    log("inputCallBack...value:$value");
                  },
                );
              }),
            ),
            CustomText(
              "页",
              style: ThemeService().textTheme.labelLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
