import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_check_box.dart';
import 'package:flutter_bet/widget/custom_divider_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_radio_box.dart';
import 'package:flutter_bet/widget/custom_vip_progress_indicator.dart';
import 'package:flutter_bet/widget/progress/custom_linear_progress_indicator.dart';
import 'package:flutter_bet/widget/switch/custom_switch.dart';
import 'package:get/get.dart';

import 'logic.dart';

class TestOtherPage extends BaseView<TestOtherLogic> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return const CustomAppBar(
      appBarTitleText: '测试其它小部件',
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: 1200,
        padding:
            const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            Row(
              children: [
                const Text('CustomSwitch: '),
                Obx(() {
                  return CustomSwitch(
                    value: controller.switchValue.value,
                    onChanged: (value) {
                      controller.switchValue.value = value;
                    },
                  );
                }),
              ],
            ),

            Row(
              children: const [
                Text('CustomIcon: '),
                CustomIcon(
                  asset: 'assets/images/pe/ic_pe_football.png',
                  color: Colors.redAccent,
                ),
                CustomAssetIcon(name: 'assets/images/pe/ic_pe_global.png'),
              ],
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            Row(
              children: const [
                Text('CustomCheckBox: '),
                CustomCheckBox(
                  value: true,
                ),
                SizedBox(
                  width: AppValues.defaultPadding,
                ),
                CustomCheckBox(
                  value: false,
                ),
                SizedBox(
                  width: AppValues.defaultPadding,
                ),
                CustomCheckBox(
                  value: true,
                  isEnable: false,
                ),
                SizedBox(
                  width: AppValues.defaultPadding,
                ),
                CustomCheckBox(value: false, isEnable: false),
              ],
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            Row(
              children: const [
                Text('CustomRadioBox: '),
                CustomRadioBox(
                  value: true,
                ),
                SizedBox(
                  width: AppValues.defaultPadding,
                ),
                CustomRadioBox(
                  value: false,
                ),
                SizedBox(
                  width: AppValues.defaultPadding,
                ),
                CustomRadioBox(
                  value: true,
                  isEnable: false,
                ),
                SizedBox(
                  width: AppValues.defaultPadding,
                ),
                CustomRadioBox(value: false, isEnable: false),
              ],
            ),

            const SizedBox(
              height: AppValues.defaultPadding,
            ),
                Row(
                  children: const [
                    Text('CustomLinearProgressIndicator: '),
                    Expanded(
                      child: CustomLinearProgressIndicator(
                        value: 0.6,
                      ),
                    ),
                  ],
                ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            Row(
              children: const [
                Text('vip进度: '),
                Expanded(
                  child: CustomVipProgressIndicator(
                    value: 0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            Row(
              children: [
                Text('CustomCirclesDivider:'),
                Expanded(
                  child: CustomCirclesDivider(
                      type: DividerType.circle
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            Row(
              children: [
                Text('CustomCirclesDivider:'),
                Expanded(
                  child: CustomCirclesDivider(
                      type: DividerType.halfCircle,
                      height: 20,
                      circleRadius: 6,
                      color: ThemeService().theme.colorScheme.background,
                      backgroundColor: Colors.black12,
                  ),
                ),
              ],
            ),
            // Row(
            //   children: const [
            //     Text('CustomRadioBox: '),
            //     CustomLinearProgressIndicator(
            //       value: 0.6,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
