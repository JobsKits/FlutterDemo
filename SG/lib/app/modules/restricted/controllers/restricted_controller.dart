import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:get/get.dart';

class RestrictedController extends GetxController {

  final count = 0.obs;

  final brandDetailUrl = ''.obs; //图片地址

  @override
  void onInit() {
    super.onInit();
  }

  _brandDetails() async {
    await ApiService.instance.brand(
        success: (bean) {
          brandDetailUrl.value = bean.mobile??'';
        },
        fail: (message) {},
        tag: "area");
  }

  @override
  void onReady() {
    super.onReady();
    _brandDetails();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
