import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/video_api.dart';
import 'package:flutter_tiyu_app/app/modules/video/data/video_home_bean.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';

class VideoSearchController extends GetxController {
  late TextEditingController searchController;
  RxList<VideoSecondList> searchList = <VideoSecondList>[].obs;
  RxBool isShowDeleteIcon = false.obs;
  RxList<String> historyList = <String>[].obs;
  RxBool isDeleteMode = false.obs; //是否进入了删除模式，默认false
  @override
  void onInit() async {
    super.onInit();
    searchController = TextEditingController();
    searchController.addListener(() {
      isShowDeleteIcon.value = searchController.text.isNotEmpty;
    });
    historyList.value = await SpUtil.getStringList("history") ?? [];
  }

  void searchVideo() async {
    if (searchController.text.isEmpty) {
      Get.snackbar("请输入搜索关键词", "");
      return;
    }
    EasyLoading.show(indicator: CommonLoadingView());
    var searchText = searchController.text.trim();
    searchList.value = await VideoApi.searchVideo(searchText);
    if (!historyList.contains(searchText)) {
      //如果不包含，再添加
      historyList.add(searchText); //添加到搜索历史的集合
    }
    EasyLoading.dismiss();
  }

  void cleanInput() {
    searchController.text = "";
  }

  //点击了历史记录
  void clickHistory(int index) {
    searchController.text = historyList[index];
    searchVideo();
  }

  //删除指定历史记录
  void deleteHistory(int index) async {
    historyList.removeAt(index);
    SpUtil.saveStringList("history", historyList); //更新本地保存的集合
  }

  //删除所有历史记录
  void deleteAllHistory() {
    historyList.clear();
    SpUtil.remove("history");
  }

  void changeDeleteMode() {
    isDeleteMode.value = !isDeleteMode.value;
  }
}
