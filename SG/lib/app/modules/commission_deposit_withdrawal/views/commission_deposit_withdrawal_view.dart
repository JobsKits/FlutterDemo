import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/utils/route_util.dart';

import 'package:get/get.dart';

import '../../../../routes/routes.dart';
import '../../../../widget/custom_back_icon_button.dart';
import '../controllers/commission_deposit_withdrawal_controller.dart';

class CommissionDepositWithdrawalView
    extends GetView<CommissionDepositWithdrawalController> {
  const CommissionDepositWithdrawalView({Key? key}) : super(key: key);

  static openPage() {
    RouteUtil.pushToView(Routes.commissionDepositWithDrawalView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:const CustomBackIconButton(style: CustomBackIconButtonStyle.normal,),
        title: Text(S.current.random_text_755,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18)),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CommissionDepositWithdrawalView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
