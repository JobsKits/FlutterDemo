import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_ok_button_widget.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_common_container.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';

import './recharge_protocol_widget.dart';

///快速充值方式
// ignore: must_be_immutable
class RechargeQuickView extends StatelessWidget {
  RechargeQuickView({super.key});
  late RechargeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return RechargeCommonContainer(
        child: Column(
      children: [
        RechargeProtocolWidget(),
        RechargeOkButtonWidget(
          text: '快速充值',
          clickButton: () {
            AppManager.instance.tapVibrate();
            DebounceThrottle.debounce(controller.clickQuickRecharge)();
          },
        )
      ],
    ));
  }
}
