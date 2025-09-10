import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:get/get.dart';

import '../../../../utils/login_manager.dart';
import '../../../../utils/sp_util.dart';
import '../../../../utils/tenant_manager.dart';
import '../../../data/login_bean.dart';

class ChangeAvatarController extends GetxController {
  RxList<String> headerList = <String>[].obs;
  RxString currentHeaderUrl = "".obs;
  int currentSelectIndex = -1;
  String listImgDomain = '';
  @override
  void onInit() {
    super.onInit();
    reqHeaderList();
  }

  void reqHeaderList() async {
    listImgDomain = await TenantManager.instance.getCurrentImgDomain();

    //加载头像
    String head = LoginManager.instance.loginInfo?.head ?? '';
    if (head.startsWith('http')) {
      currentHeaderUrl.value = head;
    } else {
      if (listImgDomain.isNotEmpty) {
        currentHeaderUrl.value = "$listImgDomain/$head";
      }
    }
    //加载头像列表
    List<String> tempList = [];
    int maxHeadNum = 60;
    for (int i = 1; i <= maxHeadNum; i++) {
      String urlStr = 'static/heads/cn/head_${i}.png';
      tempList.add(urlStr);
    }
    headerList.value = tempList;
  }

  //切换头像显示的url
  void changeHeaderUrl(int index) {
    currentSelectIndex = index;
    var tempUrl = headerList[index];
    if (!tempUrl.contains("http")) {
      tempUrl = "${listImgDomain}/$tempUrl";
    }
    currentHeaderUrl.value = tempUrl;
  }

  void setHeader() async {
    if (currentSelectIndex != -1) {
      EasyLoading.show(indicator: CommonLoadingView());
      bool isSuccess =
          await UserApi().setHeader(headerList[currentSelectIndex]);
      EasyLoading.dismiss();
      if (isSuccess) {
        LoginManager.instance.loginInfo?.head = headerList[currentSelectIndex];
        //更新SP缓存
        await SpUtil.saveBean<LoginBean>(
            "loginBean", LoginManager.instance.loginInfo!);
        Get.back();
      }
    } else {
      Get.snackbar("温馨提示", "请选择需要更换的头像");
    }
  }
}
