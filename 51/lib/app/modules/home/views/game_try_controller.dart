import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../api/home_api.dart';
import '../../../../native_utils.dart';
import '../../../../kernel/network/service.dart';
import '../../../../kernel/utils/game_utils.dart';
import '../../../../utils/sp_util.dart';
import '../../../../utils/url_utils.dart';
import '../../../data/home_main_info_bean.dart';
import '../../../routes/app_pages.dart';
import '../../../widget/common_loading_view.dart';
import '../../login/views/login_dialog.dart';
import '../controllers/home_controller_data_process.dart';

class GameTryController extends GetxController {
  late RxString searchName = "".obs; //搜索关键词
  late TextEditingController searchNameController;
  late FocusNode searchFocusNode; // 创建 FocusNode
  late RxBool isSearch = false.obs; // 是否是搜索状态

  RxInt leftMenuIndex = 0.obs;
  RxList<GamesTryBean> leftList = <GamesTryBean>[].obs;
  RxList<GamesTryItemBean> rightList = <GamesTryItemBean>[].obs;
  RxBool isEmpty = false.obs;
  var callbackChannel = MethodChannel('native_webview_callback');
  void initNativeCallbackListener() {
    callbackChannel.setMethodCallHandler((call) async {
      if (call.method == 'onExitConfirmed') {
        Get.dialog(
          LoginDialog(
            isShowLogin: false,
            callback: () {
              Get.back();
            },
          ),
          barrierDismissible: false,
        );
      }
    });
  }

  @override
  void onInit() async {
    super.onInit();
    if (Platform.isIOS) {
      initNativeCallbackListener();
    }
    searchFocusNode = FocusNode(); // 初始化 FocusNode
    searchNameController = TextEditingController();
    searchNameController.addListener(() {
      changeSearchStatus(searchNameController.text.isNotEmpty);
      searchName.value = searchNameController.text;
      refreshRightList(leftMenuIndex.value, searchName.value);
    });
    await reqLeftList();
  }

  void changeSearchStatus(bool isSearch) {
    this.isSearch.value = isSearch;
  }

  void changeLeftMenuIndex(int index) {
    searchFocusNode.unfocus();
    leftMenuIndex.value = index;
    refreshRightList(index, searchName.value);
  }

  //刷新右侧列表
  void refreshRightList(int index, String searchKey) {
    var tempLeftBean = leftList[leftMenuIndex.value];
    var tempList = tempLeftBean.subList ?? [];
    if (tempList.isEmpty) return;
    var searchList =
        tempList.where((item) => item.play_cname!.contains(searchKey)).toList();
    rightList.value = searchList;
  }

  Future<void> reqLeftList() async {
    EasyLoading.show(indicator: const CommonLoadingView());
    HomeMainInfoBean? spHomeData;
    try {
      spHomeData = await SpUtil.getBean<HomeMainInfoBean>("homeBean", (json) {
        return HomeMainInfoBean.fromJson(json);
      });
    } catch (e) {
      print('读取对象失败: $e');
    }
    leftList.value = spHomeData?.gamesTry ?? [];
    if (leftList.isEmpty) {
      isEmpty.value = true;
    } else {
      refreshRightList(0, searchName.value);
    }
    EasyLoading.dismiss();
  }

// 获取试玩地址
  final specialGame = {
    297: 'https://yl.kocms397.com/', // 开元棋牌
    401: 'https://nw.kocms397.com/', // 新世界棋牌
    707: 'https://fungaming.com/#/game', // FG电子
  };
  Future<void> openGame(GamesTryItemBean gameItem) async {
    EasyLoading.show(
      indicator: const CommonLoadingView(),
    );

    /// 检测3方游戏
    final res = await HomeApi.checking3Game(gameItem.play_id!.toInt());

    if (res.type == NetworkService.networkTypeSuccess &&
        res.data['response_code'] == '9999') {
      if (specialGame.containsKey(gameItem.upper_play_id)) {
        if (Platform.isIOS) {
          //ios 并且地址是html 使用原生webview打开游戏
          NativeWebView.open(specialGame[gameItem.upper_play_id] ?? "",
              gameItem.play_cname ?? '');
        } else {
          Get.toNamed(Routes.WEB_VIEW, arguments: {
            "url": specialGame[gameItem.upper_play_id] ?? "", //请求地址
            "isShowGameBack": true,
            "isShowTitle": false, //是否显示title
            "isShowRecharge": true,
            "title": gameItem.play_cname ?? '',
            'playId': gameItem.play_id,
          })?.then((_) => Get.dialog(
                LoginDialog(
                  isShowLogin: false,
                  callback: () {
                    Get.back();
                  },
                ),
                barrierDismissible: false,
              ));
        }
        EasyLoading.dismiss();
        return;
      }

      var payload = HomeControllerDataProcess.getPayload(
        playId: gameItem.play_id?.toInt() ?? 0,
        playName: gameItem.play_name ?? '',
        gameType: gameItem.big_type,
        upperPlayId: gameItem.upper_play_id?.toInt(),
        gtype: GameUtils.determineTypeConst2(gameItem.play_id?.toInt() ?? 0),
      );

      payload['isMobileOpen'] = 1;
      payload['isMobileOpenNew'] = 1;

      final result = await HomeApi.reqTryGameUrl(payload);
      print("这里就错了?${gameItem.upper_play_id}");
      if (result.type == NetworkService.networkTypeSuccess) {
        String? url = result.data['url'];

        // debugPrint('第三方游戏URL: ${url}');
        print("打开游戏:${url}");
        if (url?.isNotEmpty ?? false) {
          String? linkUrl =
              url!.contains('https:') ? url : url.replaceAll('http:', 'https:');
          int webPlayId =
              gameItem.upper_play_id?.toInt() ?? gameItem.play_id!.toInt();
          if (Platform.isIOS) {
            //ios 并且地址是html 使用原生webview打开游戏
            NativeWebView.open(linkUrl, gameItem.play_cname ?? '');
          } else {
            Get.toNamed(Routes.WEB_VIEW, arguments: {
              "url": linkUrl, //请求地址
              "isShowGameBack": true,
              "isShowTitle": false, //是否显示title
              "isShowRecharge": true,
              "title": gameItem.play_cname ?? '',
              'playId': webPlayId,
            })?.then((_) => Get.dialog(
                  LoginDialog(
                    isShowLogin: false,
                    callback: () {
                      Get.back();
                    },
                  ),
                  barrierDismissible: false,
                ));
          }

          // 路由跳转
          // Get.toNamed(Routes.WEB_VIEW, arguments: {
          //   "url": linkUrl, //请求地址
          //   "isShowGameBack": true,
          //   "isShowTitle": false, //是否显示title
          //   "isShowRecharge": true,
          //   "title": gameItem.play_cname ?? '',
          //   'playId': webPlayId,
          // })?.then((_) => {
          //       Get.dialog(
          //         LoginDialog(
          //           isShowLogin: false,
          //           callback: () {
          //             Get.back();
          //           },
          //         ),
          //         barrierDismissible: false,
          //       )
          //     });
        } else {
          EasyLoading.showToast('未获取到三方平台地址');
        }
      } else {
        EasyLoading.showToast('${result.data}');
      }
    }

    EasyLoading.dismiss();
  }
}
