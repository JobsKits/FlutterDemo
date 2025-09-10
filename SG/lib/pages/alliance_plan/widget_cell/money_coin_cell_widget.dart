import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/utils/json_util.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:flutter_bet/utils/text_util.dart';
import 'package:flutter_bet/widget/cell/custom_tooltip_widget.dart';
import 'package:money2/money2.dart';

import '../../../constant/app_values.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/num_util.dart';
import '../../../widget/cell/custom_text_coin_cell_widget.dart';
import '../../../widget/custom_bubble.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/network_image/custom_network_image.dart';

//联盟计划 - 列表 list 的金额带 coin 图标
class MoneyCoinCellWidget extends StatelessWidget {
  MoneyCoinCellWidget({
    super.key,
    this.money,
    this.coinBean,
    this.colorSwitch = false,
    this.colorSwitchValues,
    this.style,
    this.color,
    this.padding,
    this.fontSize,
    this.coinSize,
    this.maxLength = 11, //正数2位 + 小数点8位
    this.marginSpace,
    this.needDecimalDeal = true,
    this.showCoinName = false, //默认不显示
  });

  final String? money;

  // final String? coinIc;
  final CurrencyBean? coinBean;
  final bool colorSwitch; //是否切换不同颜色，比如总输/赢。 默认为false
  final List<Color>? colorSwitchValues; //是否切换不同颜色，[+,-,0]
  final TextStyle? style; //显示样式，优先级最高
  final Color? color; //优先级次，单一颜色。最后是getMoneyColor（）
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final double? coinSize;
  final int maxLength; //6 表示 xxxx.xx, 意味着超过万元的回...
  final double? marginSpace; //金额 与 货币图标的间距
  final bool needDecimalDeal; //是否需要小数点特殊处理
  final bool showCoinName;

  static const Color red = Color(0xFFE91134);
  static const Color green = Color(0xFF1FFF20);
  static const Color gray = Color(0xFFB1BAD3);

  @override
  Widget build(BuildContext context) {
    //小数保留处理
    var moneyDeal = _getMoneyDecimal(money, coinBean?.decimal_places, needDecimalDeal);
    //...处理
    var moneyTarget = _getMoneyTarget(moneyDeal, maxLength);
    var coinTargetUrl = _getCoinUrl(coinBean);
    return CustomTooltipWidget(
      // message: '',
      isShow: moneyTarget.length > maxLength,
      padding: EdgeInsets.zero,
      verticalOffset: 10,
      decoration: const BoxDecoration(color: Colors.transparent),
      richMessage: WidgetSpan(
        // alignment: PlaceholderAlignment.bottom,
        child: _buildTipContentView(moneyDeal, coinTargetUrl),
      ),

      child: _buildShowContentView(moneyTarget, coinTargetUrl),
    );
  }

  ///显示的widget
  Widget _buildShowContentView(String moneyTarget, String coinUrl) {
    return CustomMoneyCoinCellWidget(
      moneyTarget: moneyTarget,
      coinUrl: coinUrl,
      padding: padding,
      fontSize: fontSize,
      style: getStyle(),
      coinSize: coinSize,
      marginSpace: marginSpace,
      coinName: showCoinName ? (coinBean?.name) : null,
    );
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            moneyTarget,
            style: getStyle(),
          ),
          SizedBox(width: marginSpace ?? AppValues.margin_2),
          CustomNetWorkImage(
            width: coinSize ?? 12,
            height: coinSize ?? 12,
            imageUrl: coinUrl,
            showErrorMsg: false,
          ),
        ],
      ),
    );
  }

  ///提示的widget
  Widget _buildTipContentView(String moneyDeal, String coinDeal) {
    return UnconstrainedBox(
      child: BubbleView(
        // color:  Colors.red,
        direction: ArrowDirection.bottom,
        arrowWidth: 8,
        arrowHeight: 4,
        borderRadius: const Radius.circular(4.0),
        arrowBasisOffset: 0,
        arrowPeakOffset: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              moneyDeal,
              style: ThemeService().textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF13212D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: AppValues.margin_4),
            CustomNetWorkImage(
              width: 14,
              height: 14,
              imageUrl: coinDeal,
              showErrorMsg: false,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? getStyle() {
    if (colorSwitch) {
      return style ??
          ThemeService().textTheme.labelLarge?.copyWith(
              color: color ?? getMoneyColor(money),
              fontWeight: FontWeight.w500,
              fontSize: fontSize);
    } else {
      //主要是去掉 getMoneyColor(money)方法
      return style ??
          ThemeService()
              .textTheme
              .labelLarge
              ?.copyWith(color: color, fontWeight: FontWeight.w500, fontSize: fontSize);
    }
  }

  ///金钱， 小数处理 decimal 保留位数
  String _getMoneyDecimal(String? money, int? decimal, bool needDecimalDeal) {
    if (needDecimalDeal) {
      var dMoney = double.tryParse(money ?? '0');

      // if (dMoney != null) {
      //   return dMoney.toStringAsFixed(decimal ?? 2);
      // } else {
      //   return 0.toStringAsFixed(decimal ?? 2);
      // }
      //不四舍五入
      // NumUtil.keepDecimals(dMoney, digits: decimal)
      // Money.fromNum(NumUtil.keepDecimals(dMoney, digits: decimal).toString());
      return NumUtil.keepDecimals(dMoney, digits: decimal);
    } else {
      return money ?? "0";
    }
  }

  ///获取货币图标
  String _getCoinUrl(CurrencyBean? coinBean) {
    if (coinBean != null && coinBean.coinIc != null && coinBean.coinIc!.isNotEmpty) {
      return coinBean.coinIc ?? '';
    } else {
      return '';
    }
  }

  ///...处理
  String _getMoneyTarget(String? money, int maxLength) {
    return TextUtil.clipping(money, maxLength);
  }

  ///金额添加 +-
  String getMoneyWithSign(String? money) {
    if (money == null) {
      return '';
    } else {
      if (money.contains('-') || double.tryParse(money) == 0) {
        return money;
      } else {
        return '+$money';
      }
    }
  }

  final bool isCh = LangService().isChinese;

  ///获取总数输赢 的金额颜色 ,逻辑+红色， -绿色, 0灰色
  ///默认回调用
  Color getMoneyColor(String? money) {
    if (money != null && (money.contains('+') || double.tryParse(money)! > 0)) {
      return _colorSwitchValue(0) ?? (isCh ? green : red);
    }
    if (money != null && money.contains('-')) {
      return _colorSwitchValue(1) ?? (isCh ? red : green);
    } else {
      return _colorSwitchValue(2) ?? gray;
    }
  }

  Color? _colorSwitchValue(int index) {
    return colorSwitchValues?[index];
  }
}
