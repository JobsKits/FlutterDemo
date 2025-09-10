import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../../constant/app_values.dart';
import 'package:get/get.dart';

import 'index.dart';

class PrivacyPolicyPage extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppValues.defaultMargin),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        child: InAppWebView(
          initialFile: 'assets/html/privacy_policy.html',
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(transparentBackground: true),
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyPolicyController>(
      init: PrivacyPolicyController(),
      id: "privacy_policy",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("privacy_policy")),
          body: _buildView(),
        );
      },
    );
  }
}
