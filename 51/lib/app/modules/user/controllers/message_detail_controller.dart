import 'package:get/get.dart';

class MessageDetailController extends GetxController {
  RxBool isImgType = false.obs;
  @override
  void onInit() {
    super.onInit();
    isImgType.value = Get.arguments["isImgType"];
  }
}
