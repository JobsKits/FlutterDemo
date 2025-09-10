import 'package:get/get.dart';

import '../controllers/cs_webview_controller.dart';

class CsWebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CsWebViewController>(
          () => CsWebViewController(),
    );
  }
}
