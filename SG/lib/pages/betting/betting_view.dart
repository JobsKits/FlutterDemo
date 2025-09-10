import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/betting/casino/betting_casino_logic.dart';
import 'package:get/get.dart';
import '../../controllers/global_state_controller.dart';
import 'betting_logic.dart';
import 'casino/betting_casino_view.dart';
import 'sport/betting_sport_view.dart';

///投注单主页
class BettingPage extends StatelessWidget {
  BettingPage({super.key});

  final Widget bettingCasinoPage = BettingCasinoPage();
  final Widget bettingSportPage = BettingSportPage();
  final BettingLogic logic =  Get.put<BettingLogic>(BettingLogic());

  final GlobalStateController appController = Get.find<GlobalStateController>();

  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    // Get.lazyPut(()=>BettingCasinoLogic());
    // log("菜单投注页...hashCode:${widget.hashCode}");
    // log("菜单投注页...hashCode.State:${hashCode}");
    // log("菜单投注页...bettingCasinoPage:${bettingCasinoPage.hashCode}...bettingSportPage:${bettingSportPage.hashCode}");
    //菜单投注页...build()...671776233
    //菜单投注页...build()...671776233
    //菜单投注页...build()...140735040...1007627785
    //菜单投注页...build()...140735040...1007627785
    //菜单投注页...bettingCasinoPage:295913823...bettingSportPage:951447957
    //菜单投注页...bettingCasinoPage:830643462...bettingSportPage:80215137
    //菜单投注页...bettingCasinoPage:563222874...bettingSportPage:973816033
    //菜单投注页...bettingCasinoPage:563222874...bettingSportPage:973816033
    //菜单投注页...bettingCasinoPage:563222874...bettingSportPage:973816033
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        // margin: EdgeInsets.only(bottom: AppValues.barBottomHeight),
        child: Stack(
          children: [
            ///娱乐城投注单
            Visibility(
              visible: appController.betSlipType.value == 0,
              child: bettingCasinoPage,
            ),

            ///体育投注单
            Visibility(
              visible: appController.betSlipType.value == 1,
              child: bettingSportPage,
            )
          ],
        ),
      ),
    );
  }
}
