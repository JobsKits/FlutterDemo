import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';


/// 货币符号 / 货币名称 / 箭头 Btn
/// /*
//  常用范例
//   final _widgetKey = GlobalKey();
//   final _arrowKey  = GlobalKey<RotatingArrowState>();
// * CustomCurrencyBtn(
//         bean: controller.selCoin,
//         widgetKey: _widgetKey,
//         arrowKey: _arrowKey,
//         onTap: (bean) {
//           showPopCurrencyWidget(
//               context: ctx,
//               popPage: PopCurrencyPage(
//                 widgetKey: _widgetKey,
//                 arrowKey: _arrowKey,
//                 didSelCurrency: (bean){
//                   print(bean.name);
//                 },
//               )
//           );
//         },
//       ),
// * */
class CustomCurrencyBtn extends StatelessWidget {

  // 货币类型信息
  final CurrencyBean bean;
  // 用于外部获取组件信息Key
  final GlobalKey widgetKey;
  // 记录箭头信息
  final GlobalKey<RotatingArrowState> arrowKey;

  // 点击回调
  Function(CurrencyBean)? onTap;
  // 顺序排列 iconFirst ? icon/name : name/icon
  bool iconFirst;
  // 基础属性配置
  double height;
  TextStyle? textStyle;
  double iconSize;
  double radiusCircular;
  Color? bgColor;

  CustomCurrencyBtn({
    super.key,
    required this.bean,
    required this.widgetKey,
    required this.arrowKey,
    this.onTap,
    this.iconFirst      = true,
    this.height         = 44,
    this.textStyle,
    this.iconSize       = AppValues.iconSmallSize,
    this.radiusCircular = 4,
    this.bgColor,
  });

  final _scalingKey = GlobalKey<ScalingTextState>();

  @override
  Widget build(BuildContext context) {

    final dTextStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);

    return <Widget>[
      const SizedBox(width: AppValues.defaultMargin),
      CustomNetWorkImage(
        imageUrl: bean.coinImgUrl,
        width: iconSize,
        height: iconSize,
      ).paddingRight(AppValues.smallMargin)
          .visibility(iconFirst),
      ScalingText(
        text: bean.name ?? "...",
        textStyle: textStyle ?? dTextStyle!,
        key: _scalingKey
      ).paddingRight(AppValues.smallMargin),
      CustomNetWorkImage(
        imageUrl: bean.coinImgUrl,
        width: iconSize,
        height: iconSize,
      ).paddingRight(AppValues.smallMargin)
          .visibility(!iconFirst),
      const SizedBox(width: AppValues.smallMargin),
      RotatingArrow(key: arrowKey),
      const SizedBox(width: AppValues.halfMargin)
    ].toRow(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, key: widgetKey)
        .backgroundColor(bgColor ?? ThemeService().colorScheme.surface)
        .height(height)
        .clipRRect(all: radiusCircular)
        .onTap(_onTap);
  }

  void _onTap(){
    _startAnimation(arrowKey);
    _startScaleAnimation(_scalingKey);
    onTap?.call(bean);
  }

  // 箭头
  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }
  // 缩放
  void _startScaleAnimation(GlobalKey<ScalingTextState> key) {
    key.currentState?.startAnimation();
  }
}
