import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/pop_currency/binding.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

import 'index.dart';

double bubbleWidth = 114;

/// 领取奖金弹窗
class FeedbackBonusPage extends GetView<FeedbackBonusController> {

  FeedbackBonusPage(this.feedId, this.bonus, {super.key});

  final String feedId;
  final String bonus;

  final _widgetKey = GlobalKey();
  final _arrowKey  = GlobalKey<RotatingArrowState>();

  final textStyle   = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
  final amountColor = const Color(0xFFFF9800);

  Widget _buildBody(context) {
    return <Widget>[
      const SizedBox(height: 3),
      _buildTransactionsTitle(),
      const SizedBox(height: AppValues.defaultMargin),
      _buildRichText(),
      const SizedBox(height: AppValues.defaultMargin),
      _buildExchangeRate(context),
      const SizedBox(height: AppValues.defaultMargin),
      _buildBtn(context),
      const SizedBox(height: AppValues.defaultMargin),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min).marginSymmetric(horizontal: AppValues.defaultMargin)
        .backgroundColor(ThemeService().theme.scaffoldBackgroundColor)
        .clipRRect(all: AppValues.smallRadius);
  }

  /// 构建title
  Widget _buildTransactionsTitle() {
    return <Widget>[
      const CustomAssetIcon(name: 'assets/images/personal_center_icon/notifs_claim_bonus.webp', size: AppValues.iconSmallSize),
      const SizedBox(width: AppValues.extraSmallMargin),
      CustomText(S.current.feedback_receive_title,
          style:  ThemeService().theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)
      ),
      const Spacer(),
      const CustomIcon(asset: 'assets/images/normal/ic_normal_close.png', size: AppValues.iconSize_18)
          .marginOnly(left: AppValues.defaultMargin).center().onTap(() {RouteUtil.popView();})
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center).height(44);
  }

  Widget _buildRichText() {
    // 您当前待领取金额为：20U 您可自由选择您想要的币种进行领取
    return RichText(
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(
            text: S.current.feedback_receive_amount_1,
          ),
          TextSpan(
            // text: MoneyUtil.toCoinAmountFormat("706", bonus),
            text: bonus,
            style: textStyle?.copyWith(color: amountColor),
          ),
          const WidgetSpan(
            child: Baseline(
              baseline: 0.0,
              baselineType: TextBaseline.alphabetic,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppValues.smallPadding),
                child: CustomAssetIcon(name: "assets/images/personal_center_icon/ic_usdt.webp", size: AppValues.iconSmallSize),
              ),
            )
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: S.current.feedback_receive_amount_2,
          ),
        ],
      ),
    );
  }


  Widget _buildExchangeRate(ctx){

    // 用户可领取对应金额
    final userCoinBounstFormat = MoneyUtil.toCoinAmountFormat(controller.selCoin.cur, controller.userCoinBonus);
    // 展示汇率
    final coinRate = controller.selCoinRate.toString().length > 8 ?
    controller.selCoinRate.toStringAsFixed(8) : controller.selCoinRate.toString();

    return <Widget>[
      // 货币选择Btn
      CustomCurrencyBtn(
        bean: controller.selCoin,
        widgetKey: _widgetKey,
        arrowKey: _arrowKey,
        onTap: (bean) {
          popCoinList(ctx);
        },
      ),
      const SizedBox(height: AppValues.smallMargin),
      // 汇率
      CustomText(S.current.feedback_rate(coinRate), style: textStyle, maxLines: 1, overflow: TextOverflow.clip),
      const SizedBox(height: AppValues.margin_14),
      // 预计可领取
      <Widget>[
        CustomText(S.current.feedback_expected_receive, style: textStyle),
        CustomText(userCoinBounstFormat, style: textStyle?.copyWith(color: amountColor)),
        const SizedBox(width: AppValues.halfMargin),
        CustomNetWorkImage(
          imageUrl: controller.selCoin.coinImgUrl,
          width: AppValues.iconSmallSize,
          height: AppValues.iconSmallSize,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center)
    ].toColumn();
  }

  // 取消/确认领取 Btn
  Widget _buildBtn(context) {
    return <Widget>[
      CustomText(S.current.wallet_cancel, style: ThemeService().theme.textTheme.bodyMedium)
          .center()
          .tight(height: 42)
          .backgroundColor(const Color(0xFF2E4553))
          .clipRRect(all: 4)
          .onTap(() {RouteUtil.popView();})
          .expanded(),
      const SizedBox(width: 12),
      CustomText(S.current.feedback_confirm_receive, style: ThemeService().theme.textTheme.bodyMedium)
          .center()
          .tight(height: 42)
          .backgroundColor(const Color(0xFF1475E1))
          .clipRRect(all: 4)
          .onTap((){controller.reqReceiveAction(context);})
          .expanded()
    ].toRow();
  }

  // pop货币选择
  void popCoinList(ctx) {
    showPopCurrencyWidget(
        context: ctx,
        popPage: PopCurrencyPage(
          widgetKey: _widgetKey,
          arrowKey: _arrowKey,
          screenMaxItemLength: 6,
          didSelCurrency: (bean){
            controller.changeCoinType(bean);
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedbackBonusController>(
      init: FeedbackBonusController(),
      id: "feedback_bonus",
      builder: (_) {
        controller.feedId = feedId;
        controller.bonus  = bonus;
        return Material(
          color: Colors.transparent,
          child: _buildBody(context)
        );
      }
    );
  }
}
