import 'package:get/get.dart';

class AnnouncementController extends GetxController {
  AnnouncementController();

  _initData() {
    update(["announcement"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
