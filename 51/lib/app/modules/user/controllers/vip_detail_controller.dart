import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/vip_controller.dart';
import 'package:get/get.dart';

class VipDetailController extends GetxController {
  late VipController vipController = Get.find();
  RxString htmlStr = "".obs;
  @override
  void onInit() async {
    super.onInit();
    htmlStr.value = await UserApi().reqVipRule() ?? "";
  }
}
