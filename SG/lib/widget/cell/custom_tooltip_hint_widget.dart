import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../services/theme/theme_service.dart';
import '../../utils/text_util.dart';
import '../custom_bubble.dart';
import '../custom_text.dart';
import 'custom_tooltip_widget.dart';

///触碰弹出Tooltip, 带箭头。与[CustomTooltipCellWidget] 的区别时 点击提示内容 没有...
///
class CustomTooltipHintWidget extends StatelessWidget {
  CustomTooltipHintWidget({
    super.key,
    this.content,
    this.contentTip,
    this.contentBack,
    // this.maxLength = 6,
    this.padding,
    this.tipPadding,
    this.style,
    this.styleTip,
    this.fontSize,
    this.isShow,
    this.contentWidget,
    this.onTriggered,

  });

  final String? content;
  final String? contentTip; //提示内容
  final String? contentBack; //回调 返回值， 不显示的
  final EdgeInsets? padding; //显示内容的padding
  final EdgeInsets? tipPadding; //提示内容的padding
  final TextStyle? style; //显示内容的
  final TextStyle? styleTip; //tip显示内容的
  final double? fontSize; //显示字体大小
  // final int maxLength; //超过多少
  final bool? isShow; //是否显示
  final Widget? contentWidget; //自定义显示组件， 优先级最高

  final GlobalKey _globalKeyCopy = GlobalKey();
  final GlobalKey _globalKeyTip = GlobalKey();

  final void Function(String? data)? onTriggered;

  @override
  Widget build(BuildContext context) {
    return CustomTooltipWidget(
        isShow: isShow ?? true,
        padding: EdgeInsets.zero,
        verticalOffset: 10,
        decoration: const BoxDecoration(color: Colors.transparent),
        richMessage: WidgetSpan(
          // alignment: PlaceholderAlignment.bottom,
          child: _buildTipContentView(contentTip, _globalKeyCopy),
        ),
        onTriggered: () {
          if (onTriggered != null) {
            onTriggered!.call(contentBack);
          }
        },
        child: Container(
          key: _globalKeyCopy,
          padding: padding ?? const EdgeInsets.all(5),
          child: contentWidget ??
              CustomText(
                content ?? "",
                style: style ??
                    ThemeService().textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: fontSize ?? 12,
                        ),
              ),
        ));
  }

  _buildTipContentView(String? content, GlobalKey iconKey) {
    return UnconstrainedBox(
      key: _globalKeyTip,
      child: BubbleView(
        direction: ArrowDirection.bottom,
        arrowWidth: 8,
        arrowHeight: 4,
        borderRadius: const Radius.circular(4.0),
        arrowBasisOffset: 0,
        arrowPeakOffset: 0,
        padding: tipPadding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: CustomText(
          content ?? '',
          style: styleTip ??
              ThemeService().textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF13212D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
        ),
        offsetCallback: (size, offset) {
          // 获取组件 icon大小和偏移
          final RenderBox iconRenderBox = iconKey.currentContext?.findRenderObject() as RenderBox;
          Size iconSize = iconRenderBox.size;
          final iconOffset = iconRenderBox.localToGlobal(Offset.zero);
          // log("offsetCallback...iconSize=$iconSize...iconOffset=$iconOffset");
          // 获取组件 tooltip大小和偏移
          final RenderBox tipRenderBox =
              _globalKeyTip.currentContext?.findRenderObject() as RenderBox;

          Size tipSize = tipRenderBox.size;
          final tipOffset = tipRenderBox.localToGlobal(Offset.zero);
          // log("offsetCallback...tipSize=$tipSize...tipOffset=$tipOffset");
          return iconOffset.dx - tipOffset.dx + iconSize.width / 2;
        },
      ),
    );
  }
}
