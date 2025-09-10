import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/pop_currency/widgets/triangle_painter.dart';
import 'logic.dart';
import 'package:get/get.dart';

/// 货币选择弹窗View
///*
//  范例
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
class PopCurrencyPage extends GetView<PopCurrencyLogic> {

  // 响应Widget Key
  final GlobalKey widgetKey;

  // 箭头控制
  GlobalKey<RotatingArrowState>? arrowKey;
  // 是否展示搜索
  bool showSearchBar;
  // 是否展示余额
  bool showBalance;
  // 屏幕最多同时展示货币 item数量 TODO：未完成 根据上下屏幕剩余Size计算默认数量
  int screenMaxItemLength;
  // 货币类型item高度
  double coinItemHeight;
  // 自定义宽度
  double? viewWidth;
  // coins == null ? 全部币种 : 指定币种
  List<CurrencyBean>? coins;
  // selCoin == null ? 无选中效果 : 选中币种 TODO：未完成
  CurrencyBean? selCoin;
  // 选中 回调
  Function(int)? didSelIndex;
  Function(CurrencyBean)? didSelCurrency;
  // 取消 回调
  Function(void)? dismis;


  PopCurrencyPage({
    super.key,
    required this.widgetKey,
    this.arrowKey,
    this.showSearchBar       = true,
    this.showBalance         = false,
    this.screenMaxItemLength = 6,
    this.coinItemHeight      = 35,
    this.coins,
    this.selCoin,
    this.didSelIndex,
    this.didSelCurrency,
    this.dismis,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PopCurrencyLogic>(
        init: PopCurrencyLogic(),
        id: "popCurrencyLogic_index",
        builder: (controller){
          if(controller.coins.isEmpty) {
            controller.initCoins(coins);
          }
          return body(context);
    });
  }

  // 默认宽度
  static double defaultWidth      = 115.0;
  // 余额风格宽度
  static double balanceStyleWidth = 200.0;
  // 搜索框 高度
  static double searchBarHeight   = 54.0;
  // 三角宽高
  static double triangleHeight    = 10.0;
  static double triangleWidth     = 15.0;

  Widget body(BuildContext context){

    // 屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // 列表数据 length
    final showCoinsLength = controller.showCoins.length;
    // 默认画布高度
    var mapViewHeight = showCoinsLength < screenMaxItemLength ?
    coinItemHeight * showCoinsLength : coinItemHeight * screenMaxItemLength;
    if(showSearchBar) {
      mapViewHeight += searchBarHeight;
    }
    // 内容宽高
    final popViewWidth  = viewWidth ?? (showBalance ? balanceStyleWidth : defaultWidth);
    final popViewHeight = mapViewHeight;

    // widgetKey对应组件信息
    if (widgetKey.currentContext == null) {
      return Text(S.current.random_text_1292).onTap(() {
        RouteUtil.popView();
      });
    }
    final RenderBox renderBox = widgetKey.currentContext!.findRenderObject() as RenderBox;
    final Offset keyPosition = renderBox.localToGlobal(Offset.zero);
    final Size keySize = renderBox.size;

    // PopView方向
    var isUpward = !(controller.focusNode.hasFocus && keyPosition.dy > screenHeight / 2.5);
    // 靠近屏幕底部默认显示在上方
    if(keyPosition.dy > screenHeight * 0.7) {
      isUpward = false;
    }

    // 三角位置定位计算
    final triangleLeft = keyPosition.dx + (keySize.width - triangleWidth) / 2;
    final triangleTop  = isUpward ?
    (keyPosition.dy + keySize.height + 1) : (keyPosition.dy - (triangleHeight) - 1);

    // PopView位置定位计算
    var left = keyPosition.dx - (popViewWidth - keySize.width) / 2;
    final top  = isUpward ?
    (keyPosition.dy + keySize.height + triangleHeight) : (keyPosition.dy - popViewHeight - triangleHeight);
    // PopView出屏幕/距离屏幕右侧过近 调整
    if((left + popViewWidth) > (screenWidth - 10)) {
      left = screenWidth - popViewWidth - 20;
    }

    // final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    // print("键盘高度:" + bottomInset.toString());

    return <Widget>[
      // 搜索框，币种列表
      popView(mapViewHeight).positioned(
        left: left,
        top: top,
      ),
      // 三角
      CustomPaint(
        size: Size(triangleWidth, triangleHeight),
        painter: TrianglePainter(isUpward: isUpward),
      ).positioned(
        left: triangleLeft,
        top: triangleTop,
      ),
    ].toStack().onTap(() {
      controller.isDismis = true;
      dismis?.call;
      _resetAnimation();
      Get.back();
    }).visibility(!controller.isDismis);
  }


  Widget popView(double mapViewHeight) {

    return <Widget>[
      // 搜索框
      _buildSearchBar().visibility(showSearchBar),
      // 货币列表
      SingleChildScrollView(
        child: <Widget>[
          for(int index = 0; index < controller.showCoins.length; index++)
            CupertinoButton(
              borderRadius: BorderRadius.zero,
              padding: EdgeInsets.zero,
              child: _buildCoinItem(controller.showCoins[index]),
              onPressed: () {
                didSelIndex?.call(index);
                didSelCurrency?.call(controller.showCoins[index]);
                _resetAnimation();
                Get.back();
              },
            ).height(coinItemHeight)
        ].toColumn(),
      ).expanded()
    ].toColumn()
        .tight(width: showBalance ? balanceStyleWidth : defaultWidth, height: mapViewHeight)
        .backgroundColor(AppThemes.widgetColorWhite)
        .clipRRect(all: 3);
  }

  // 搜索框
  Widget _buildSearchBar() {
    const vertical = 8.0;
    return Container(
      height: searchBarHeight - vertical * 2,
      margin: const EdgeInsets.symmetric(horizontal: AppValues.margin_10, vertical: vertical),
      child: CupertinoSearchTextField(
        focusNode: controller.focusNode,
        prefixInsets: const EdgeInsets.only(left: 10),
        prefixIcon: const CustomAssetIcon(
          name: "assets/images/top_search_ic.png",
          size: 16,
        ),
        itemColor: AppThemes.secondaryIconColor,
        placeholder: S.current.wallet_search,
        placeholderStyle:
        TextStyle(color: ThemeService().colorScheme.tertiary, fontWeight: FontWeight.w500),
        suffixMode: OverlayVisibilityMode.never,
        decoration: BoxDecoration(
          color: AppThemes.widgetColorWhite,
          border: Border.all(color: AppThemes.whiteD5DCEB, width: 2.0),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // 阴影颜色
              spreadRadius: 0, // 扩散半径
              blurRadius: 2, // 模糊半径
              offset: const Offset(0, 1), // 阴影偏移量
            ),
          ],
        ),
        style: TextStyle(
            fontSize: 14, color:ThemeService().colorScheme.tertiary, fontWeight: FontWeight.w500),
        onChanged: (String value) {
          controller.onSearchTextChanged(value);
        },
        onSubmitted: (String value) {
        },
      ),
    );
  }

  // 货币item
  Widget _buildCoinItem(CurrencyBean bean) {

    final textStyle = ThemeService().theme.textTheme.bodyMedium
        ?.copyWith(color: ThemeService().colorScheme.tertiary);

    return <Widget>[
      const SizedBox(width: AppValues.defaultMargin),
      CustomNetWorkImage(
        width: 18,
        height: 18,
        imageUrl: bean.coinIc ?? "",
      ),
      const SizedBox(width: 8),
      CustomText(bean.name ?? "", style: textStyle),

      CustomText(bean.amount ?? "", style: textStyle, textAlign: TextAlign.end)
          .visibility(showBalance)
          .expanded(),
      const SizedBox(width: AppValues.defaultMargin)
          .visibility(showBalance)
    ].toRow(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center);
  }

  void _resetAnimation() {
    arrowKey?.currentState?.resetAnimation();
  }
}
