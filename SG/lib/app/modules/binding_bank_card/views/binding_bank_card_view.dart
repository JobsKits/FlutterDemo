import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/binding_bank_card/controllers/binding_bank_card_controller.dart';

import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/binding_bank_card.dart';
import '../../../../widget/custom_back_icon_button.dart';


class BindingBankCardView extends GetView<BindingBankCardController> {
  const BindingBankCardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.context =context ;
    return Scaffold(
      appBar: AppBar(
        leading:const CustomBackIconButton(style: CustomBackIconButtonStyle.normal,),
        title: Text(S.current.binding_bank_card,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18)),
        centerTitle: true,
      ),
      body:
      const SingleChildScrollView(child: BindingBankCard(flag: "2",)),
    );
  }
}
