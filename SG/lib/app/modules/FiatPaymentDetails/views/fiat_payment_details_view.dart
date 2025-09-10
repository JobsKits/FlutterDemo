import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/fiat_currency_deatils.dart';
import '../../../../widget/custom_back_icon_button.dart';
import '../controllers/fiat_payment_details_controller.dart';

class FiatPaymentDetailsView extends GetView<FiatPaymentDetailsController> {
  const FiatPaymentDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:const CustomBackIconButton(style: CustomBackIconButtonStyle.normal,),
        title: Text(S.current.paymentDetails,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18)),
        centerTitle: true,
      ),
      body:  FiatCurrencyDetails(detailsController: controller),
    );
  }
}
