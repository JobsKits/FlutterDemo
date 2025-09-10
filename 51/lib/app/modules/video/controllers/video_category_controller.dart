import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/video_api.dart';
import 'package:get/get.dart';

import '../../../widget/common_loading_view.dart';
import '../data/video_home_bean.dart';

class VideoCategoryController extends GetxController {
  RxList<VideoSecondList> categoryList = <VideoSecondList>[].obs;
  String title = "分类";
  int id = 0;
  String type = "cate";
  @override
  void onInit() async {
    super.onInit();
    // 获取传递的参数
    final arguments = Get.arguments as Map<String, dynamic>;
    id = arguments['id'] ?? '';
    title = arguments['title'] ?? "分类";
    type = arguments['type'] ?? "cate";
    EasyLoading.show(indicator: CommonLoadingView());
    categoryList.value = await VideoApi.reqVideoList(
        id: id, type: type, page: 1, pageSize: 1000);
    EasyLoading.dismiss();
  }
}
