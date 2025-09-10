import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/custom_app_life_cycle_listen_widget.dart';
import 'package:flutter_bet/widget/custom_route_listen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class TestLifeCyclePage extends BaseView<TestLifeCycleLogic> {
  TestLifeCyclePage({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return const CustomAppBar(
      appBarTitleText: '测试生命周期',
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return CustomAppLifeCycleListenWidget(
        didChangeAppLifecycleState: (state) =>
            controller.onDidChangeAppLifecycleState(state),
        didChangeAccessibilityFeatures: () =>
            controller.onDidChangeAccessibilityFeatures(),
        didChangeDependencies: () => controller.onDidChangeDependencies(),
        didChangeMetrics: () => controller.onDidChangeMetrics(),
        didChangePlatformBrightness: () =>
            controller.onDidChangePlatformBrightness(),
        didChangeTextScaleFactor: () => controller.onDidChangeTextScaleFactor(),
        didHaveMemoryPressure: () => controller.onDidHaveMemoryPressure(),
        child: CustomRouteListenWidget(
          handler: (state) => controller.onRouteState(state),
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('App生命周期: ${controller.appStateText.value}'),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                Text('路由监听: ${controller.routeStateText.value}'),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                Text('Widget State: ${controller.widgetStateText.value}'),
              ],
            );
          }),
        ));
  }
}
