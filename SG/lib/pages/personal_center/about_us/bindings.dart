import 'package:get/get.dart';

import 'controller.dart';

class AboutUsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutUsController>(() => AboutUsController());
  }
}
