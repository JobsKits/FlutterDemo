import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/personal_center/transactions/detail/widgets/bets_widget.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:get/get.dart';
import 'controller.dart';
import '../index/state.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

class TransactionDetailsPage extends GetView<TransactionDetailsController> {
  TransactionDetailsPage(this.transactionsType, this.coinType, {Key? key}) : super(key: key);

  final TransactionsType transactionsType;
  final TransactionsCoinType coinType;

  final colorScheme = ThemeService().colorScheme;
  final textTheme   = ThemeService().theme.textTheme;

  // 主视图
  Widget _buildView() {

    final isBets  = transactionsType == TransactionsType.bets;
    final bgColor =  isBets? ThemeService().theme.scaffoldBackgroundColor : ThemeService().colorScheme.surface;
    final horizontalMargin = isBets ? 0.0 : AppValues.defaultMargin;

    return <Widget>[
      _buildContent(),
      CustomButton(
        alignment: Alignment.center,
        title: S.current.transactions_detail_help,
        textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        onTap: controller.customerService,
      ).center()
          .backgroundColor(colorScheme.surfaceVariant)
          .tight(width: double.infinity, height:ThemeService().theme.buttonTheme.height)
          .clipRRect(all: AppValues.smallRadius).visibility(!isBets),

      CustomText(
        S.current.transactions_detail_play("GameName"),
        style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ).marginSymmetric(horizontal: AppValues.defaultMargin, vertical: AppValues.margin_12)
          .backgroundColor(ThemeService().theme.colorScheme.surfaceVariant)
          .clipRRect(all: AppValues.smallRadius).visibility(isBets),

      const SizedBox(height: AppValues.defaultMargin),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min)
        .marginSymmetric(horizontal: horizontalMargin)
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

  Widget _buildContent() {
    switch (transactionsType) {
      case TransactionsType.bets:
        return TransactionsDetailBets();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionDetailsController>(
        init: TransactionDetailsController(),
        id: "transaction_details",
        builder: (_) {
          return Material(
              color: Colors.transparent,
              child: <Widget>[
                _buildTransactionsTitle(),
                _buildView(),
              ].toColumn(mainAxisSize: MainAxisSize.min)
          );
        }
    );
  }

}

