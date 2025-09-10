import 'dart:ui';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';

class CustomSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
        SpecialTextGestureTapCallback? onTap,
        required int index}) {
    // TODO: implement createSpecialText
    if (flag == '') {
      return null;
    }
    if (isStart(flag, _SpecialText.flag)) {
      return _SpecialText(textStyle,
          start: index! - (_SpecialText.flag.length - 1));
    }
    return null;
  }
}

class _SpecialText extends SpecialText {
  _SpecialText(TextStyle? textStyle, {this.start})
      : super(_SpecialText.flag, ']', textStyle);
  static const String flag = '[';
  final int? start;

  @override
  InlineSpan finishText() {
    // TODO: implement finishText
    final String text = getContent();
    return SpecialTextSpan(
      text: text,
      actualText: toString(),
      start: start!,
      ///caret can move into special text
      deleteAll: true,
      style: textStyle?.copyWith(
          color: ThemeService().colorScheme.inverseSurface,
          fontWeight: FontWeight.w500,
          fontSize: 14),
    );
  }
}