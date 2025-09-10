import 'package:get/get.dart';

import '../controllers/statistical_data_controller.dart';

class StatisticalDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticalDataController>(
      () => StatisticalDataController(),
    );
  }
}
