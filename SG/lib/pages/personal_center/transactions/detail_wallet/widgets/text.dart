import 'package:flutter/material.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_text.dart';

class TrDetailsText extends StatelessWidget {

  /// 文字字符串
  final String text;

  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;

  // CustomText(content, maxLines: 2, style: showCopy ? textTheme.bodyMedium : textStyle, textAlign: TextAlign.left);

  const TrDetailsText({
    Key? key,
    required this.text,
    this.style,
    this.maxLines,
    this.textAlign,
  }) : super(key: key);

  /// title 金额
  TrDetailsText.titleAmount(this.text, {
        Key? key,
    this.maxLines,
    this.textAlign,
  }): style = ThemeService().theme.textTheme.titleLarge, super(key: key);

  /// title 货币类型
  TrDetailsText.titleCoinType(this.text, {
    Key? key,
    this.maxLines,
    this.textAlign,
  }): style = ThemeService().theme.textTheme.bodyMedium, super(key: key);

  /// 默认body
  TrDetailsText.body(this.text, {
    Key? key,
    this.maxLines,
    this.textAlign,
  }): style = ThemeService().textTheme.bodyMedium?.
  copyWith(color: CustomTextColorStyle.secondary.value, fontWeight: FontWeight.w500), super(key: key);

  /// 强调body
  TrDetailsText.bodyLight(this.text, {
    Key? key,
    this.maxLines,
    this.textAlign,
  }): style = ThemeService().textTheme.bodyMedium?.
  copyWith(color: CustomTextColorStyle.white.value, fontWeight: FontWeight.w500), super(key: key);

  /// 特殊-区块链地址
  TrDetailsText.blockChanAddres(this.text, {
    Key? key,
    this.maxLines  = 2,
    this.textAlign = TextAlign.left,
  }): style = ThemeService().textTheme.bodyMedium?.
  copyWith(color: CustomTextColorStyle.secondary.value, fontWeight: FontWeight.w500), super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == "") {
      return const SizedBox();
    }
    return CustomText(
        text,
        style: style,
        maxLines: maxLines,
        textAlign: textAlign,
    );
  }


}
