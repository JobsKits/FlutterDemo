import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/snack_bar/custom_snack_bar.dart';
import '../../alliance_plan/widget_cell/money_coin_cell_widget.dart';
import '../a_model/activity_common_params.dart';

///活动 SnackBar 工具类
class ActivitySnackBarHelper {
  ////
  ///显示 推广活动 领取状态 SnackBar
  static void showReceiveSnackBar({
    required ActivityReceiveState receiveState,
    String? bonusAmount,
    CurrencyBean? coinBean,
  }) {
    CustomSnackBar.show(
      title: receiveState.getTipTitle(),
      // resultData.message ?? "",
      // receiveState.getTipContent(),
      "",
      Get.overlayContext!,
      preIcon: Image.asset(receiveState.msgIcon),
      // preIcon: CustomSnackBarIcons.verifySucceed,
      // title: S.current.random_text_757,
      // preIcon: CustomSnackBarIcons.verifySucceed,
      subContent: receiveState.isShowReceiveMoney()
          ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              CustomText(
                receiveState.getTipContent(),
                style: ThemeService()
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 1),
              MoneyCoinCellWidget(money: bonusAmount, coinBean: coinBean),
              const SizedBox(width: AppValues.defaultMargin),
            ])
          : Row(
              children: [
                CustomText(
                  receiveState.getTipContent(),
                  style: ThemeService()
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: AppValues.defaultMargin),
              ],
            ),
    );
  }
}
