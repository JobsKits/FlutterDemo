import 'package:flutter_bet/generated/l10n.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../utils/url_launch_util.dart';

class CommunityController extends GetxController {
  CommunityController();

  final brandDetail = {}.obs;
  var loading = false.obs;
  var dataList = [S.current.home_forum,'Facebook','Twitter','Instagram','Youtube','Tiktok'];
  var imgList = ['community','facebook','twitter','instagram','youtube','tiktok'];

  _initData() {
    update(["community"]);
    getData();
  }

  getData() async {
    loading.value = true;
    await ApiService.instance.getBrandDetail(
        tag: 'bottom',
        success: (dynamic) {
          brandDetail.value = dynamic;
          loading.value = false;
        },
        fail: (String? message) {loading.value = false;});
  }

  void onTap(dic) {
    UrlLaunchUtil.launchURL(dic['url']);
  }

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
