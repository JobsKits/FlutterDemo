import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/model/transactions/other.dart';
import 'package:flutter_bet/model/transactions/wallet.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/string_uril.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:get/get.dart';
import '../../detail/widgets/text.dart';

/// 箭头按钮及弹窗回调
class TRArrowButtonView extends StatelessWidget {

  final GlobalKey _viewKey  = GlobalKey();
  final GlobalKey<RotatingArrowState> _arrowKey  = GlobalKey<RotatingArrowState>();
  final GlobalKey<ScalingTextState> _scalingKey = GlobalKey<ScalingTextState>();

  /// 弹窗列表
  final List<String> titles;
  /// 当前选中
  final int selIndex;
  /// 弹窗点击回调
  final Function(int)? callback;

  TRArrowButtonView({
    super.key,
    required this.titles,
    required this.selIndex,
    this.callback
  });

  @override
  Widget build(BuildContext context) {

    final popTextStyle = ThemeService().textTheme.bodyMedium
        ?.copyWith(color: CustomTextColorStyle.lightDarkText.value, fontWeight: FontWeight.w600);

    final textStyle = ThemeService().textTheme.bodyMedium!
        .copyWith(color: CustomTextColorStyle.white.value, fontWeight: FontWeight.w500);

    return <Widget>[
      const SizedBox(width: 5, height: double.infinity),
      ScalingText(key: _scalingKey, text: titles[selIndex], textStyle: textStyle),
      const SizedBox(width: 2, height: double.infinity),
      RotatingArrow(key: _arrowKey),
    ]
        .toRow(mainAxisSize: MainAxisSize.min, key: _viewKey)
        .marginSymmetric(horizontal: AppValues.margin_12)
        .height(42)
        .backgroundColor(ThemeService().colorScheme.surface)
        .clipRRect(all: AppValues.smallRadius)
        .onTap(() {

      _startScaleAnimation(_scalingKey);
      _startArrowAnimation(_arrowKey);

      final maxWidth = StringUtil.textMaxWidth(titles, popTextStyle!);
      final popView  = TRPopListView(
        titles: titles,
        selIndex: selIndex,
        callback: (didSelIndex) {
          callback?.call(didSelIndex);
        },
      );

      DialogUtils.showCustomBubbleDialog(
          Get.context!,
          popView,
          maxWidth + 30,
          dxWidth: 0,
          widgetKey: _viewKey,
          backgroundColor: Colors.white,
          globalKey: _arrowKey
      );

    });
  }

  // 箭头动画
  void _startArrowAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  // 点击缩放动画
  void _startScaleAnimation(GlobalKey<ScalingTextState> key) {
    key.currentState?.startAnimation();
  }
}

/// 列表选择
class TRPopListView extends StatelessWidget {

  final List<String> titles;
  final int selIndex;
  final Function(int)? callback;

  const TRPopListView({super.key,
    required this.titles,
    required this.selIndex,
    this.callback
  });


  @override
  Widget build(BuildContext context) {

    final textStyle = ThemeService().textTheme.bodyMedium
        ?.copyWith(color: CustomTextColorStyle.lightDarkText.value, fontWeight: FontWeight.w600);
    final selTextStyle = ThemeService().textTheme.bodyMedium
        ?.copyWith(color: CustomTextColorStyle.blue.value, fontWeight: FontWeight.w600);

    return <Widget>[
      const SizedBox(height: AppValues.defaultPadding),
      for (int index = 0; index < titles.length; index++)
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(
              horizontal: AppValues.defaultPadding, vertical: AppValues.halfPadding),
          child: TrDetailsText(text: titles[index], style: index == selIndex ? selTextStyle : textStyle),
        ).onTap(() {
          if(index != selIndex) {
            RouteUtil.popView();
            callback?.call(index);
          }
        }),
      const SizedBox(height: AppValues.defaultPadding)
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }
}
