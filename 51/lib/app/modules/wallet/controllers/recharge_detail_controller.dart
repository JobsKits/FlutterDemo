import 'package:get/get.dart';

class RechargeDetailController extends GetxController {
  late RxString title = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // 获取传递的参数
    final arguments = Get.arguments as Map<String, dynamic>;

    title.value = arguments['title'] ?? '';
  }
}
