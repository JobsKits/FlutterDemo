import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/transactions/wallet.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/dialog/bubble_dialog.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';
import '../detail/widgets/text.dart';
import 'controller.dart';
import '../index/state.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';



class TrWalletDetailsPage extends GetView<TrWalletDetailsController> {
  TrWalletDetailsPage(this.transactionsType, this.coinType, this.info, {Key? key}) : super(key: key);

  final TransactionsType transactionsType;
  final TransactionsCoinType coinType;
  final TrWalletModel info;

  final colorScheme = ThemeService().colorScheme;
  final textTheme   = ThemeService().theme.textTheme;


  double getTextWidth(String text, TextStyle style) {
    // 创建一个 TextPainter
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    // 进行布局
    textPainter.layout();
    // 返回文本的宽度
    return textPainter.width;
  }

  // 主视图
  Widget _buildView() {

    final bgColor =  ThemeService().colorScheme.surface;

    return <Widget>[
      // 内容
      _buildDetailDw(),
      // 联系客服
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
        child: CustomText(S.current.transactions_detail_help,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ).inkWell(onTap: controller.customerService)
          .backgroundColor(colorScheme.surfaceVariant)
          .tight(width: double.infinity, height:ThemeService().theme.buttonTheme.height)
          .clipRRect(all: AppValues.smallRadius),

      const SizedBox(height: AppValues.defaultMargin),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min)
        .marginSymmetric(horizontal: AppValues.defaultMargin)
        .backgroundColor(bgColor)
        .clipRRect(all: AppValues.smallRadius);
  }

  /// 构建title
  Widget _buildTransactionsTitle() {
    return <Widget>[
      const CustomIcon(
          asset: 'assets/images/bet_slip/ic_casino_bet_order.webp'
      ),
      const SizedBox(width: AppValues.extraSmallMargin),
      CustomText(
          LangUtil().isTh()?S.current.detailscopy2:
          transactionsType.title=="Nạp tiền "?'${S.current.wallet_deposit_copy}${S.current.detailscopy2}':
          '${transactionsType.title}${S.current.detailscopy2}',
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)
      ),
      const Spacer(),
      const CustomIcon(
        asset: 'assets/images/normal/ic_normal_close.png'
      ).onTap(() {RouteUtil.popView();})
    ].toRow()
        .marginOnly(left: AppValues.defaultMargin, top: AppValues.defaultMargin, right: AppValues.defaultMargin, bottom: AppValues.defaultPadding)
        .backgroundColor(ThemeService().theme.scaffoldBackgroundColor);
  }

  Widget _buildDetailDw() {
    switch (transactionsType) {
      case TransactionsType.deposits:
        return _buildDeposits();
      case TransactionsType.withdrawals:
        return _buildWithdrawals();
    }
    return Text(transactionsType.title);
  }

  Widget _buildDeposits() {
    return <Widget>[
      const SizedBox(height: AppValues.defaultPadding),
      <Widget>[
        <Widget>[
          const SizedBox(width: 16)
              .visibility(coinType == TransactionsCoinType.crypto && info.state == 1),
          // CustomNetWorkImage(
          //   imageUrl: info.coinUrlPath,
          //   width: AppValues.iconSize_20,
          //   height: AppValues.iconSize_20,
          // ).paddingRight(AppValues.smallPadding)
          //     .visibility(coinType == TransactionsCoinType.banking),
          TrDetailsText.titleCoinType(controller.getCoinSymbol(info))
              .paddingRight(AppValues.smallPadding)
              .visibility(coinType == TransactionsCoinType.banking),
          TrDetailsText.titleAmount(info.amountTitle),

          CustomNetWorkImage(
            imageUrl: info.coinUrlPath,
            width: AppValues.iconSize_20,
            height: AppValues.iconSize_20,
          ).paddingLeft(AppValues.smallPadding)
              .visibility(coinType == TransactionsCoinType.crypto),
        ].toRow(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center)
            .expanded(),
        CustomIcon(
          asset: 'assets/images/personal_center_icon/link.webp',
          size: 16,
          color: CustomTextColorStyle.secondary.value,
        ).onTap(() {
          controller.launchUrl(info.transNo);
        }).visibility(false),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),

      // 交易方式
      _buildTextRow(
          title: S.current.transactions_detail_means,
          content: info.payMethodName ?? ""
      ),
      // 币种
      _buildTextRow(
          title: S.current.transactions_detail_coin_type,
          iconPath: info.coinUrlPath,
          content: info.currencyName
      ),
      // 状态
      _buildTextRow(
          title: S.current.transactions_detail_state,
          iconPath: info.stateIcPath(transactionsType),
          content: info.stateTitle(transactionsType)
      ),
      // 交易时间
      _buildTextRow(
          title: S.current.transactions_detail_time,
          content: info.timeTitle
      ),
      // 订单编号
      _buildTextRow(
          title: S.current.transactions_detail_order_id,
          content: info.orderNumber,
          showCopy: true
      ),
      const SizedBox(height: AppValues.defaultPadding),
    ].toColumn();
  }

  Widget _buildWithdrawals() {

    return <Widget>[
      const SizedBox(height: AppValues.defaultPadding),
      <Widget>[
        <Widget>[
          const SizedBox(width: 16)
              .visibility(coinType == TransactionsCoinType.crypto && info.state == 1),
          TrDetailsText.titleCoinType(controller.getCoinSymbol(info))
              .paddingRight(AppValues.smallPadding)
              .visibility(coinType == TransactionsCoinType.banking),
          TrDetailsText.titleAmount(info.amountTitle),
          CustomNetWorkImage(
            imageUrl: info.coinUrlPath,
            width: AppValues.iconSize_20,
            height: AppValues.iconSize_20,
          ).paddingLeft(AppValues.smallPadding)
              .visibility(coinType == TransactionsCoinType.crypto),
        ].toRow(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center)
            .expanded(),
        CustomIcon(
          asset: 'assets/images/personal_center_icon/link.webp',
          size: 16,
          color: CustomTextColorStyle.secondary.value,
        ).onTap(() {
          controller.launchUrl(info.transNo);
        }).visibility(coinType == TransactionsCoinType.crypto && info.transNo != ""),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),

      // 虚拟币提款
      _buildTextRow(
          title: S.current.random_text_589,
          content: info.walletAddress ?? ""
      ).visibility(coinType == TransactionsCoinType.crypto),
      _buildTextRow(
          title: S.current.transactions_detail_blockchan_protocol,
          content: info.contractType ?? ""
      ).visibility(coinType == TransactionsCoinType.crypto),

      // 法币提款
      _buildTextRow(
          title: info.currencyName == "BRL" ? S.current.random_text_590 : S.current.random_text_591,
          content: info.bankName ?? ""
      ).visibility(coinType == TransactionsCoinType.banking),
      _buildTextRow(
          title: S.current.transactions_detail_card_number,
          content: info.bankAccount ?? ""
      ).visibility(coinType == TransactionsCoinType.banking),

      // 币种
      _buildTextRow(
        title: S.current.transactions_detail_coin_type,
        iconPath: info.coinUrlPath,
        content: info.currencyName,
      ),
      // 状态
      _buildTextRow(
        title: S.current.transactions_detail_state,
        iconPath: info.stateIcPath(transactionsType),
        content: info.stateTitle(transactionsType)
      ),
      // 交易时间
      _buildTextRow(
        title: S.current.transactions_detail_time,
        content: info.timeTitle,
      ),
      // 订单编号
      _buildTextRow(
          title: S.current.transactions_detail_order_id,
          content: info.orderNumber,
          showCopy: true
      ),
      const SizedBox(height: AppValues.defaultPadding),
    ].toColumn();
  }

  Widget _buildTextRow({String title = 'title:', String? iconPath,
    String content = 'content', showCopy = false}) {
    final isBlockChanAddres = content.length >= 30;
    final isHttpIcon = iconPath?.contains("http") ?? false;

    return <Widget>[
      // 标题
      TrDetailsText.body(title.contains(':') ? title : "$title:"),
      const SizedBox(width: AppValues.halfPadding),

      <Widget>[
        // 内容icon
        CustomAssetIcon(
            name: iconPath ?? "",
            size: AppValues.iconSmallSize
        ).visibility(iconPath != null).visibility(!isHttpIcon),
        CustomNetWorkImage(
          imageUrl: iconPath ?? "",
          width: AppValues.iconSmallSize,
          height: AppValues.iconSmallSize,
        ).visibility(iconPath != null).visibility(isHttpIcon),
        const SizedBox(width: AppValues.smallPadding),
        // 内容文字
        TrDetailsText.blockChanAddres(content).expanded().visibility(isBlockChanAddres),
        TrDetailsText.body(content, textAlign: TextAlign.end)
            .expanded().visibility(!isBlockChanAddres && !showCopy && iconPath == null),
        TrDetailsText.body(content).visibility(!isBlockChanAddres && !showCopy && iconPath != null),
        TrDetailsText.bodyLight(content).expanded().visibility(showCopy),
        const SizedBox(width: AppValues.smallPadding).visibility(showCopy),
      ].toRow(mainAxisAlignment: MainAxisAlignment.end).expanded(),

      // 内容copy
      CustomIcon(
        asset: 'assets/images/personal_center_icon/copy.webp',
        key: controller.globalKeyCopy,
        size: AppValues.iconSmallSize,
        color: CustomTextColorStyle.white.value,
      ).onTap(() {
        controller.copyAction(content);
      }).visibility(showCopy),

    ].toRow(crossAxisAlignment: CrossAxisAlignment.center).paddingTop(AppValues.defaultPadding);
  }

  // Copy提示组件
  Widget _buildCopyTip() {
    // 获取文本的宽度
    double textWidth = getTextWidth(S.current.successfullyCopi, ThemeService().theme.textTheme.bodyMedium!);
    return  BubbleDialog(
      arrowBasisOffset: textWidth / 2 - 13,
      backgroundColor: Colors.white,
      width: textWidth + 20,
      bubbleChild: CustomText(
        S.current.successfullyCopi,
        textColorStyle: CustomTextColorStyle.dark,
      ),
    );
  }


@override
  Widget build(BuildContext context) {
    return GetBuilder<TrWalletDetailsController>(
        init: TrWalletDetailsController(),
        id: "transaction_details",
        builder: (_) {
          controller.ctx = context;
          return Material(
              color: Colors.transparent,
              child: <Widget>[
                _buildTransactionsTitle(),
                <Widget>[
                  _buildView(),
                  // copy提示
                  _buildCopyTip()
                      .visibility(controller.copyTipVisibility)
                      .positioned(right: 0, bottom: 42)
                ].toStack()
              ].toColumn(mainAxisSize: MainAxisSize.min)
          );
        }
    );
  }

}

