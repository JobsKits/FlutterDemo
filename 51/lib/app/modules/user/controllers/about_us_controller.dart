import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:get/get.dart';

import '../../home/controllers/new_home_controller.dart';

class AboutUsController extends GetxController {
  late NewHomeController homeController = Get.find();
  RxString desc = "".obs;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    desc.value = await UserApi().getPlatformIntroduction();
  }
}
