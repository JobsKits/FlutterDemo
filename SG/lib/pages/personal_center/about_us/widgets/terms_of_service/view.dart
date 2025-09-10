import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../../constant/app_values.dart';
import 'package:get/get.dart';

import '../../../../../services/theme/theme_service.dart';
import 'index.dart';

class TermsOfServicePage extends GetView<TermsOfServiceController> {
  const TermsOfServicePage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppValues.defaultMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        color: ThemeService().colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        child: InAppWebView(
          initialFile: 'assets/html/terms_of_service.html',
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(transparentBackground: true),
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermsOfServiceController>(
      init: TermsOfServiceController(),
      id: "terms_of_service",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("terms_of_service")),
          body: _buildView(),
        );
      },
    );
  }
}
