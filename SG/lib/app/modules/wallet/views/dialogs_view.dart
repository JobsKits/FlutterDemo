import 'package:flutter_bet/app/modules/wallet/views/payment_details_crypto_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/payment_details_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/payment_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/wd_limit_view.dart';

import '../../../../utils/route_util.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

const kCustomPaymentMethodWidget = 'PaymentMethod';

Future<void> showPaymentMethodWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomPaymentMethodWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            PaymentView(),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}

Future<void> showPaymentDetailsWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomPaymentMethodWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            PaymentDetailsView(),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}

Future<void> showPaymentDetailsCryptoWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            const CryptoDetails(),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}

Future<void> showWdLimitWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            WdLimit(),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
