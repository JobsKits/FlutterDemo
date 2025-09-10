import 'package:flutter_bet/model/login_log.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/utils/widget_util.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:get/get.dart';

class LoginLogLogic extends GetxController {
  int curPage = 1;
  final memPage = 1.obs;
  int memPageSize = 10;
  final showEmpty = true.obs;
  final dataArray = <LoginLogModel>[].obs;
  final poolArray = <LoginLogModel>[];
  final loading = true.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _fetchData(true);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> _fetchData(bool refresh) async {
    ApiService.instance.loginLog(
        page: curPage,
        success: (pageModel) {
          loading.value = false;
          if (pageModel.content.isEmpty && curPage == 1) {
            showEmpty.value = true;
            return;
          }
          pageModel.content.sort((a,b)=>b.createdAt!.compareTo(a.createdAt!));
          showEmpty.value = false;
          dataArray.clear();
          if (refresh) {
            poolArray.clear();
            poolArray.assignAll(pageModel.content);
            dataArray.addAll(poolArray.sublist(
                0,
                poolArray.length < memPageSize
                    ? poolArray.length
                    : memPageSize));
          }
        },
        fail: (String? message) {
          loading.value = false;
          CustomSnackBar.showError(message!, WidgetUtil.getCurrentContext());
        });
  }

  Future<void> onNextPage() async {
    final offset = memPage.value * memPageSize;
    if (offset >= poolArray.length) return;
    dataArray.clear();
    if ((offset + memPageSize) > poolArray.length) {
      dataArray.addAll(poolArray.sublist(offset, poolArray.length));
    } else {
      dataArray.addAll(poolArray.sublist(offset, offset + memPageSize));
    }
    memPage.value++;
  }

  //是否有下一页
    bool ifNextPage(){
    final offset = memPage.value * memPageSize;
    if (offset >= poolArray.length){
      return false ;
    }
    return true;
  }

  Future<void> onLastPage() async {
    if(memPage.value <= 1) return;
    dataArray.clear();
    memPage.value--;
    final offset = memPage.value * memPageSize;
    dataArray.addAll(poolArray.sublist(offset - memPageSize, offset));
  }


}
