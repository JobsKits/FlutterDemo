import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/personal_center/vault/vault_tabbar.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/vault/vault_controller.dart';
import '../../../../widget/custom_back_icon_button.dart';

class VaultView extends GetView<VaultController> {
  const VaultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
        appBar: AppBar(
            leading: const CustomBackIconButton(
              style: CustomBackIconButtonStyle.normal,
            ),
            title: Text(S.current.vault,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
            centerTitle: true),
        body: const VaultTabBar());
  }
}
