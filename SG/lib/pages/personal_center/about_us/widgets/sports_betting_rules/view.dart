import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../../constant/app_values.dart';
import 'package:get/get.dart';

import 'index.dart';

class SportsBettingRulesPage extends GetView<SportsBettingRulesController> {
  const SportsBettingRulesPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
   return Container(
      margin: const EdgeInsets.only(bottom: AppValues.defaultMargin),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        child: InAppWebView(
          initialFile: 'assets/html/sports_betting_rules.html',
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(transparentBackground: true),
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SportsBettingRulesController>(
      init: SportsBettingRulesController(),
      id: "sports_betting_rules",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("sports_betting_rules")),
          body: _buildView(),
        );
      },
    );
  }
}
