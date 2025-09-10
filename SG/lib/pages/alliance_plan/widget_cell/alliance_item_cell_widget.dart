import 'package:flutter/material.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';

///联盟计划 - 列表 list cell  , 主要是控制样式
class AllianceItemCellWidget extends StatelessWidget {
  const AllianceItemCellWidget(
    this.text, {
    super.key,
    this.textAlign = TextAlign.center,
    this.style,
    this.cellStyle,
    this.isTitle = false,
  });

  final String text;
  final TextAlign? textAlign;
  final TextStyle? style; //优先级 style 大于 cellStyle
  final AllianceCellStyle? cellStyle;
  final bool isTitle; //是否是标题 cell

  //用于标题
  final defaultStyle_w600 = const TextStyle(
    color: Color(0xFFB1BAD3),
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  //用于文本
  final defaultStyle = const TextStyle(
    color: Color(0xFFB1BAD3),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  final smallStyle = const TextStyle(
    color: Color(0xFFB1BAD3),
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  final largerStyle = const TextStyle(
    color: Color(0xFFB1BAD3),
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      textAlign: textAlign,
      style: style ?? getCellStyle(isTitle, cellStyle),
    );
  }

  ///获取定制样式
  getCellStyle(bool isTitle, AllianceCellStyle? cellStyle) {
    if (cellStyle == null || cellStyle == AllianceCellStyle.def) {
      //是标题的话， 直接给w600;
      return isTitle ? defaultStyle_w600 : defaultStyle;
    } else if (cellStyle == AllianceCellStyle.defW600) {
      return defaultStyle_w600;
    } else if (cellStyle == AllianceCellStyle.small) {
      return smallStyle;
    } else if (cellStyle == AllianceCellStyle.larger) {
      return largerStyle;
    }
  }
}

enum AllianceCellStyle {
  def,
  defW600,
  small,
  larger;
}
