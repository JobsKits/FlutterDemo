import 'package:flutter/material.dart';

import '../../constant/app_values.dart';
import '../../generated/l10n.dart';
import '../../services/theme/theme_service.dart';
import '../button/custom_button.dart';
import '../custom_text.dart';

///上下页组件
class CustomPrevNextWidget extends StatelessWidget {
  const CustomPrevNextWidget({
    super.key,
    required this.hasPrevPage,
    required this.hasNextPage,
    required this.onClickPrevPage,
    required this.onClickNextPage,
    this.margin,
    this.spaceMargin,
  });

  final bool hasPrevPage; //还有上一页
  final bool hasNextPage; //还有下一页
  final void Function() onClickPrevPage;
  final void Function() onClickNextPage;
  final EdgeInsetsGeometry? margin;
  final double? spaceMargin;

  @override
  Widget build(BuildContext context) {
    return _buildPrevNextView();
  }

  Widget _buildPrevNextView() {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: AppValues.defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CustomText(
          //   S.current.yulecheng_prepage,
          //   textColorStyle: CustomTextColorStyle.secondary,
          // ),
          CustomButton(
            isEnable: hasPrevPage,
            title: S.current.yulecheng_prepage,
            padding: EdgeInsets.zero,
            textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                  // color: Color(0xFFB1BAD3),
                  color: hasPrevPage
                      ? CustomTextColorStyle.white.value
                      : CustomTextColorStyle.secondary.value?.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
            onTap: () {
              if (onClickPrevPage != null) {
                onClickPrevPage.call();
              }
            },
            // S.current.yulecheng_nextpage,
            // textColorStyle: CustomTextColorStyle.white,
            // textColorStyle: CustomTextColorStyle.secondary,
          ),
          // SizedBox(width: spaceMargin ?? AppValues.defaultMargin),
          SizedBox(width: spaceMargin ?? AppValues.largeMargin),
          CustomButton(
            isEnable: hasNextPage,
            title: S.current.yulecheng_nextpage,
            padding: EdgeInsets.zero,
            textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                  // color: Color(0xFFB1BAD3),
                  color: hasNextPage
                      ? CustomTextColorStyle.white.value
                      : CustomTextColorStyle.secondary.value?.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
            onTap: () {
              if (onClickNextPage != null) {
                onClickNextPage.call();
              }
            },
            // S.current.yulecheng_nextpage,
            // textColorStyle: CustomTextColorStyle.white,
            // textColorStyle: CustomTextColorStyle.secondary,
          ),
        ],
      ),
    );
  }
}
