import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:get/get.dart';
import '../../../model/wallet/ExpandBean.dart';
import 'cardbag_exoansion.dart';

class CardBag extends StatelessWidget{
  const CardBag({super.key, required this.controller});

  final WalletController controller;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Expanded(
          child: CardExpansionTile(
              onExpansionTap: (String data) {}, controller: controller),
        ),
      ],
    );
  }

}