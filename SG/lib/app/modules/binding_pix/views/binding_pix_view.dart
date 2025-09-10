import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/binding_bank_card_controller.dart';
import '../../../../pages/personal_center/wallet/binding_pix.dart';
import '../../../../widget/custom_back_icon_button.dart';
import '../controllers/binding_pix_controller.dart';

class BindingPixView extends GetView<BindingPixController> {
  const BindingPixView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.context = context ;
    return Scaffold(
      appBar: AppBar(
        leading:const CustomBackIconButton(style: CustomBackIconButtonStyle.normal,),
        title: Text(S.current.bind_pix_account,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: BindingPix(flag: "2",)),
    );
  }
}
