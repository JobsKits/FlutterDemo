import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/binding_bank_card_controller.dart';
import '../../../../pages/personal_center/wallet/binding_virtual_address.dart';
import '../../../../widget/custom_back_icon_button.dart';
import '../controllers/binding_virtual_address_controller.dart';

class BindingVirtualAddressView
    extends GetView<BindingVirtualAddressController> {
  const BindingVirtualAddressView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.context = context ;
    return Scaffold(
      appBar: AppBar(
        leading:const CustomBackIconButton(style: CustomBackIconButtonStyle.normal,),
        title: Text('${S.current.binding_bank_card_binding}${controller.name}',style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 18)),
        centerTitle: true,
      ),
      body:  const SingleChildScrollView(child: BindingVirtualAddress(flag: "2",)),
    );
  }
}
