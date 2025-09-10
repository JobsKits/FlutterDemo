import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_bean.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/activity_coding_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/action_cfg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/activity_turntable_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/sign_in_bean.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_newcomers_model/task_newcomers_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_newcomers_manager.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_rechrge_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_turntable_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_signin_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/models/activity_float_model/activity_float_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/models/redbag_rain_detail_model/redbag_rain_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/reabag_rain_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/dialog_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivitysComponentController extends GetxController {
  final redRainStatus = true.obs;
  final rainAnimation = false.obs;

  RxList<RedbagRainDetailModel> models = <RedbagRainDetailModel>[].obs;
  Rx<RedbagRainDetailModel> model = RedbagRainDetailModel().obs;
  Rx<ActivityFloatModel> floatModel = ActivityFloatModel().obs;
  final TabsController tabs = Get.put(TabsController());

  Rx<SignInBean> signInData = SignInBean().obs;

  final firstLoginRecharge = false.obs;
  final firstLoginSignIn = false.obs;
  RxString dispatchTime = "".obs;

  RxInt rewardMethod = 0.obs;

  @override
  void onInit() async {
    super.onInit();

    reqRadbagRainDetail();
    reqFirstRechrgeData();
    reqSignInData();
    reqFloatList((s) => {});
    reqActivityNewcomersDialog();

    if (LoginManager.instance.isLogin.value) {
      reqRadbagRainSearch();
    }
    // 监听登录
    ever(LoginManager.instance.isLogin, (isLogin) async {
      models.value = [];
      if (isLogin) {
        firstLoginRecharge.value = false;
        firstLoginSignIn.value = false;
        saveRainIds('redRain${LoginManager.instance.loginInfo?.custId}');
        reqRadbagRainDetail();
        reqFirstRechrgeData();
        reqSignInData();
        reqFloatList((s) => {});
        reqRadbagRainSearch();
        reqActivityNewcomersDialog();
      } else {
        reqFloatList((s) => {});
        saveInfo('newcomersEveryLoginShow', false);
      }
    });

    ever(tabs.currentIndex, (index) async {
      if (index == 0 && LoginManager.instance.isLogin.value == true) {
        reqRadbagRainDetail();
        reqFloatList((s) => {});
        reqRadbagRainSearch();
      }

      if (index == 0) {
        reqFirstRechrgeData();
        reqSignInData();
        reqActivityNewcomersDialog();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 红包雨查询
  Future<void> reqRadbagRainSearch({int? id}) async {
    if (id != null) {
      DialogManager.showDialogWithQueue(
        dialog: RedBagRainStartModal(
          id: id,
          onClose: () => {Get.back()},
        ),
      );
    } else {
      final response = await ActivityApi.reqRadbagRainSearch();
      if (response.type == NetworkService.networkTypeSuccess) {
        List<String>? existingIds = await loadLoaclIdsList(
            'redRain${LoginManager.instance.loginInfo?.custId}');
        List<dynamic> datas = response.data;
        if (datas.isNotEmpty) {
          final filteredDatas = existingIds == null
              ? datas
              : datas
                  .where((item) => !existingIds.contains(item.toString()))
                  .toList();
          for (var item in filteredDatas) {
            DialogManager.showDialogWithQueue(
              dialog: RedBagRainStartModal(
                id: item,
                onClose: () => {Get.back()},
              ),
            );
          }
        }
      }
    }
  }

  Future<List<String>?> loadLoaclIdsList(String key) async {
    return await SpUtil.getStringList(key);
  }

  void saveRainIds(String saveName) async {
    List<String>? existingIds = [];
    await SpUtil.saveStringList(saveName, existingIds);
  }

  /// 红包雨活动详情
  Future<void> reqRadbagRainDetail() async {
    final response = await ActivityApi.reqRedbagRainDetail();
    if (response.type == NetworkService.networkTypeSuccess) {
      models.value = (response.data as List) // 将动态类型转换为 List
          .map((item) => RedbagRainDetailModel.fromJson(
              item as Map<String, dynamic>)) // 转换为模型
          // .where((model) =>
          //     model.activityType == '10') // 过滤出 activityType == '10' 的数据
          .toList(); // 转换为列表
    }
  }

  /// 浮窗列表
  ///
  Future<void> reqFloatList(Function(bool) callback) async {
    final response = await ActivityApi.reqFloatList();
    if (response.type == NetworkService.networkTypeSuccess) {
      final floats = ActivityFloatModel.fromJson(response.data);

      var filteredData = floats.data?.where((model) {
        if ((signInData.value.hasVipConfig == 0 ||
                signInData.value.hasVipConfig == null) &&
            model.slideshowAddress!.contains('/activity/?tab=5')) {
          return false;
        }
        return true;
      }).toList();

      filteredData?.sort((a, b) => a.sortV!.compareTo(b.sortV!));

      floats.data = filteredData;
      floatModel.value = floats;
      callback(true);
    }
  }

  String? getMatchingEndTime(List datas) {
    // 获取当前时间
    final now = DateTime.now();
    final currentTime = DateFormat.Hm().format(now);

    for (var range in datas) {
      final startTime = range['startTime']!;
      final endTime = range['endTime']!;

      // 比较时间
      if (currentTime.compareTo(startTime) >= 0 &&
          currentTime.compareTo(endTime) <= 0) {
        return '进行中';
      }
    }

    return ''; // 如果没有匹配到，返回 null
  }

  /// 红包雨活动详情
  Future<void> reqActivityDetails(id) async {
    final res = await ActivityApi.reqActivityDetails(id);
    if (res.type == NetworkService.networkTypeSuccess) {
      final data = ActivityCodingModel.fromJson(res.data);
      Get.toNamed(
        Routes.REDBAG_DETAIL,
        arguments: {
          "model": data.t,
        },
      );
    }
  }

  /// 红包雨活动详情
  Future<void> reqActivityNewcomersDialog() async {
    final res = await ActivityApi.reqNewcomersWelfareData();
    if (res.type == NetworkService.networkTypeSuccess) {
      final data = TaskNewcomersModel.fromJson(res.data);

      if (data.t == null || data.data == null) {
        print({'Newcomers  ======= null'});
        return;
      }

      print({'Newcomers preLoginModal  ======= ${data.t?.preLoginModal}'});
      print({'Newcomers postLoginModal ====== ${data.t?.postLoginModal}'});

      ActivityNewcomersManager.handleNewcomersDialog(data);
    }
  }

  /// 首次充值弹窗
  Future<void> reqFirstRechrgeData() async {
    final response = await ActivityApi.reqFirstRechrgeData();

    if (response.type == NetworkService.networkTypeSuccess) {
      final List<ActivityListItemBean> result = (response.data as List)
          .map((item) => ActivityListItemBean.fromJson(item))
          .toList();

      final matchingItems =
          result.where((item) => item.activityType == '1').toList();
      if (matchingItems.isNotEmpty) {
        final ActivityListItemBean model =
            matchingItems.firstWhere((item) => item.isShowIndex == '0');
        if (LoginManager.instance.isLogin.value) {
          final rechargeData =
              await ActivityApi.reqRechargRewards(model.id.toString());
          if (rechargeData.type == NetworkService.networkTypeSuccess &&
              rechargeData.data != null &&
              (rechargeData.data['state'] == 0 ||
                  rechargeData.data['state'] == 5)) {
            // Handle success case
          } else {
            displayRechrge(model);
          }
        } else {
          displayRechrge(model);
        }
      }

      final turntableModels =
          result.where((item) => item.activityType == '8').toList();
      if (turntableModels.isNotEmpty) {
        final ActivityListItemBean model = turntableModels.reduce((a, b) =>
            int.parse(a.isShowIndex ?? '0') < int.parse(b.isShowIndex ?? '0')
                ? a
                : b);
        reqActivityTurntable(model.id.toString());
      }
    }
  }

  Future<void> displayRechrge(ActivityListItemBean? model) async {
    final config = jsonDecode(model?.actionCfg ?? '');
    String? loaclPreLogin = await loadLoaclData('rechargePreLogin');
    String? loaclNxetLogin = await loadLoaclData('rechargeLoginShow');
    if ((config['preLoginModal']) != loaclPreLogin && loaclPreLogin != null) {
      saveToday('${'preLoginModal'}rechargeToday', false);
      saveInfo('${'preLoginModal'}rechargeNaver', false);
      saveToday('${'local'}rechargeToday', false);
      saveInfo('${'local'}rechargeNaver', false);
    }

    if (LoginManager.instance.isLogin.value) {
      if (((config['postLoginModal']) != loaclNxetLogin &&
              loaclNxetLogin != null) ||
          (config['postLoginModal'] == 'EVERY_LOGIN' &&
              firstLoginRecharge.value == false)) {
        if (tabs.currentIndex.value == 0) {
          firstLoginRecharge.value = true;
        }
        saveToday(
            '${'postLoginModal'}rechargeLoginToday${LoginManager.instance.loginInfo?.custId}',
            false);
        saveInfo(
            '${'postLoginModal'}rechargeLoginNaver${LoginManager.instance.loginInfo?.custId}',
            false);
        saveToday('${'local'}rechargeLoginToday', false);
        saveInfo('${'local'}rechargeLoginNaver', false);
      }
    }

    bool localToday = LoginManager.instance.isLogin.value
        ? await loadTodayData('${'local'}rechargeLoginToday')
        : await loadTodayData('${'local'}rechargeToday');
    bool localNaver = LoginManager.instance.isLogin.value
        ? await loadNaverData('${'local'}rechargeLoginNaver')
        : await loadNaverData('${'local'}rechargeNaver');
    if (localToday || localNaver) {
      return;
    }

    bool today = LoginManager.instance.isLogin.value
        ? await loadTodayData('${'preLoginModal'}rechargeLoginToday')
        : await loadTodayData('${'preLoginModal'}rechargeToday');
    bool loginToday = LoginManager.instance.isLogin.value
        ? await loadTodayData(
            '${'postLoginModal'}rechargeLoginToday${LoginManager.instance.loginInfo?.custId}')
        : await loadTodayData(
            '${'postLoginModal'}rechargeToday${LoginManager.instance.loginInfo?.custId}');
    bool naver = LoginManager.instance.isLogin.value
        ? await loadNaverData('${'preLoginModal'}rechargeLoginNaver')
        : await loadNaverData('${'preLoginModal'}rechargeNaver');
    bool loginNaver = LoginManager.instance.isLogin.value
        ? await loadNaverData(
            '${'postLoginModal'}rechargeLoginNaver${LoginManager.instance.loginInfo?.custId}')
        : await loadNaverData(
            '${'postLoginModal'}rechargeNaver${LoginManager.instance.loginInfo?.custId}');

    bool preLogin = await loadTypeData('preLoginModal',
        config['preLoginModal'] ?? 'rechargePreLoginModal', 'rechrge');
    bool loginShow = await loadTypeData('postLoginModal',
        config['postLoginModal'] ?? 'rechargePostLoginModal', 'rechrge');

    if ((LoginManager.instance.isLogin.value == false
            ? today == false
            : loginToday == false) &&
        (LoginManager.instance.isLogin.value == false
            ? naver == false
            : loginNaver == false) &&
        model != null &&
        (LoginManager.instance.isLogin.value == false ? preLogin : loginShow) &&
        tabs.currentIndex.value == 0) {
      final config = jsonDecode(model?.actionCfg ?? '');
      String url = config['popupContent'] ?? '';
      var imageProvider = CachedNetworkImageProvider(url);
      await precacheImage(imageProvider, Get.context!);
      DialogManager.showDialogWithQueue(
        dialog: ActivityRechrgeDialog(
          model: model,
          imageProvider: imageProvider,
          onClose: () => {Get.back()},
        ),
        priority: 2,
      );
    }

    saveLocal(
        'rechargePreLogin', config['preLoginModal'] ?? 'rechargePreLoginModal');
    saveLocal('rechargeLoginShow',
        config['postLoginModal'] ?? 'rechargePostLoginModal');
  }

  Future<void> reqActivityTurntable(id) async {
    final res = await ActivityApi.reqActivityDetails(id);
    if (res.type == NetworkService.networkTypeSuccess) {
      final data = ActivityTurntableDetailModel.fromJson(res.data['t']);
      final ActionCfg config = data.actionCfg as ActionCfg;
      print({'preLoginModal  ======= ${config.preLoginModal}'});
      print({'postLoginModal ====== ${config.postLoginModal}'});
      String? loaclPreLogin = await loadLoaclData('turntablePreLogin');
      String? loaclNxetLogin = await loadLoaclData('turntableLoginShow');

      if ((config.preLoginModal) != loaclPreLogin && loaclPreLogin != null) {
        saveToday('${'preLoginModal'}turntableToday', false);
        saveInfo('${'preLoginModal'}turntableNaver', false);
        saveToday("{'local'}turntableToday", false);
        saveInfo("{'local'}turntableNaver", false);
      }

      if (LoginManager.instance.isLogin.value) {
        if (((config.postLoginModal) != loaclNxetLogin &&
                loaclNxetLogin != null) ||
            (config.postLoginModal == 'EVERY_LOGIN' &&
                firstLoginRecharge.value == false)) {
          if (tabs.currentIndex.value == 0) {
            firstLoginRecharge.value = true;
          }
          saveToday('${'postLoginModal'}turntableLoginToday', false);
          saveInfo('${'postLoginModal'}turntableLoginNaver', false);
          saveToday("{'local'}turntableLoginToday", false);
          saveInfo("{'local'}turntableLoginNaver", false);
        }
      }

      bool localToday = LoginManager.instance.isLogin.value
          ? await loadTodayData("{'local'}turntableLoginToday")
          : await loadTodayData("{'local'}turntableToday");
      bool localNaver = LoginManager.instance.isLogin.value
          ? await loadNaverData("{'local'}turntableLoginNaver")
          : await loadNaverData("{'local'}turntableNaver");
      if (localToday || localNaver) {
        return;
      }

      bool today = LoginManager.instance.isLogin.value
          ? await loadTodayData('${'preLoginModal'}turntableLoginToday')
          : await loadTodayData('${'preLoginModal'}turntableToday');
      bool loginToday = LoginManager.instance.isLogin.value
          ? await loadTodayData('${'postLoginModal'}turntableLoginToday')
          : await loadTodayData('${'postLoginModal'}turntableToday');
      bool naver = LoginManager.instance.isLogin.value
          ? await loadNaverData('${'preLoginModal'}turntableLoginNaver')
          : await loadNaverData('${'preLoginModal'}turntableNaver');
      bool loginNaver = LoginManager.instance.isLogin.value
          ? await loadNaverData('${'postLoginModal'}turntableLoginNaver')
          : await loadNaverData('${'postLoginModal'}turntableNaver');

      bool preLogin = await loadTypeData(
          'preLoginModal', config.preLoginModal ?? "", 'turntable');
      bool loginShow = await loadTypeData(
          'postLoginModal', config.postLoginModal ?? "", 'turntable');

      if ((LoginManager.instance.isLogin.value == false
              ? today == false
              : loginToday == false) &&
          (LoginManager.instance.isLogin.value == false
              ? naver == false
              : loginNaver == false) &&
          (LoginManager.instance.isLogin.value == false
              ? preLogin
              : loginShow) &&
          tabs.currentIndex.value == 0) {
        DialogManager.showDialogWithQueue(
          dialog: ActivityTurntableDialog(model: data),
          priority: 2,
        );
      }

      saveLocal('turntablePreLogin', config.preLoginModal!);
      saveLocal('turntableLoginShow', config.postLoginModal!);
    }
  }

  /// 签到弹窗
  Future<void> reqSignInData() async {
    final response = await ActivityApi.reqSignInData();
    if (response.type == NetworkService.networkTypeSuccess) {
      signInData.value = SignInBean.fromJson(response.data);

      print({
        'before_login_modal  ======= ${signInData.value.before_login_modal}'
      });
      print({'after_login_modal ====== ${signInData.value.after_login_modal}'});

      if (signInData.value.activityRuleConf?.reward_method == 1) {
        if (!LoginManager.instance.isLogin.value ||
            signInData.value.hasVipConfig == 0) {
          return;
        }
      }

      if (signInData.value.day_type == 1 && signInData.value.sign_day! > 0) {
        return;
      }
      String? loaclPreLogin = await loadLoaclData('signinPreLogin');
      String? loaclNxetLogin = await loadLoaclData('signinLoginShow');
      if ((signInData.value.before_login_modal ?? '') != loaclPreLogin &&
          loaclPreLogin != null) {
        saveToday('${'before_login_modal'}signInToday', false);
        saveInfo('${'before_login_modal'}signInNaver', false);
        saveToday('${'local'}signInToday', false);
        saveInfo('${'local'}signInNaver', false);
      }
      if (((signInData.value.after_login_modal ?? '') != loaclNxetLogin &&
              loaclNxetLogin != null) ||
          (signInData.value.after_login_modal == 'EVERY_LOGIN' &&
              firstLoginSignIn.value == false)) {
        if (tabs.currentIndex.value == 0) {
          firstLoginSignIn.value = true;
        }
        saveToday(
            '${'after_login_modal'}signInLoginToday${LoginManager.instance.loginInfo?.custId}',
            false);
        saveInfo(
            '${'after_login_modal'}signInLoginNaver${LoginManager.instance.loginInfo?.custId}',
            false);
        saveToday('${'local'}signInLoginToday', false);
        saveInfo('${'local'}signInLoginNaver', false);
      }

      bool localToday = LoginManager.instance.isLogin.value
          ? await loadTodayData('${'local'}signInLoginToday')
          : await loadTodayData('${'local'}signInToday');
      bool localNaver = LoginManager.instance.isLogin.value
          ? await loadNaverData('${'local'}signInLoginNaver')
          : await loadNaverData('${'local'}signInNaver');
      if (localToday || localNaver) {
        return;
      }

      bool today = LoginManager.instance.isLogin.value
          ? await loadTodayData('${'before_login_modal'}signInLoginToday')
          : await loadTodayData('${'before_login_modal'}signInToday');
      bool loginToday = LoginManager.instance.isLogin.value
          ? await loadTodayData(
              '${'after_login_modal'}signInLoginToday${LoginManager.instance.loginInfo?.custId}')
          : await loadTodayData(
              '${'after_login_modal'}signInToday${LoginManager.instance.loginInfo?.custId}');
      bool naver = LoginManager.instance.isLogin.value
          ? await loadNaverData('${'before_login_modal'}signInLoginNaver')
          : await loadNaverData('${'before_login_modal'}signInNaver');
      bool loginNaver = LoginManager.instance.isLogin.value
          ? await loadNaverData(
              '${'after_login_modal'}signInLoginNaver${LoginManager.instance.loginInfo?.custId}')
          : await loadNaverData(
              '${'after_login_modal'}signInNaver${LoginManager.instance.loginInfo?.custId}');

      bool preLogin = await loadTypeData('before_login_modal',
          signInData.value.before_login_modal ?? '', 'signin');
      bool loginShow = await loadTypeData('after_login_modal',
          signInData.value.after_login_modal ?? '', 'signin');

      if ((LoginManager.instance.isLogin.value == false
              ? today == false
              : loginToday == false) &&
          (LoginManager.instance.isLogin.value == false
              ? naver == false
              : loginNaver == false) &&
          (LoginManager.instance.isLogin.value == false
              ? preLogin
              : loginShow) &&
          tabs.currentIndex.value == 0) {
        DialogManager.showDialogWithQueue(
          dialog: ActivitySigninDialog(
            model: signInData.value,
            onClose: () => {Get.back()},
          ),
          priority: 2,
        );
      }

      saveLocal('signinPreLogin', signInData.value.before_login_modal ?? '');
      saveLocal('signinLoginShow', signInData.value.after_login_modal ?? '');
    }
  }

  Future<bool> loadTypeData(String key, String value, String type) async {
    bool display = false;
    if (value == 'NO_POPUP') {
      display = false;
    } else if (value == 'DAILY_ONCE') {
      if (type == 'rechrge') {
        if (LoginManager.instance.isLogin.value && key == 'postLoginModal') {
          saveToday(
              '${key}rechargeLoginToday${LoginManager.instance.loginInfo?.custId}',
              true);
        } else if (key == 'preLoginModal') {
          saveToday('${key}rechargeToday', true);
        }
      } else if (type == 'turntable') {
        if (LoginManager.instance.isLogin.value && key == 'postLoginModal') {
          saveToday('${key}turntableLoginToday', true);
        } else if (key == 'preLoginModal') {
          saveToday('${key}turntableToday', true);
        }
      } else {
        if (LoginManager.instance.isLogin.value && key == 'after_login_modal') {
          saveToday(
              '${key}signInLoginToday${LoginManager.instance.loginInfo?.custId}',
              true);
        } else if (key == 'before_login_modal') {
          saveToday('${key}signInToday', true);
        }
      }
      display = true;
    } else if (value == 'HIGH_FREQUENCY') {
      display = true;
    } else if (value == 'EVERY_LOGIN') {
      if (type == 'rechrge') {
        if (LoginManager.instance.isLogin.value && key == 'postLoginModal') {
          saveToday(
              '${key}rechargeLoginToday${LoginManager.instance.loginInfo?.custId}',
              true);
        }
      } else if (type == 'turntable') {
        if (LoginManager.instance.isLogin.value && key == 'postLoginModal') {
          saveToday('${key}turntableLoginToday', true);
        }
      } else {
        if (LoginManager.instance.isLogin.value && key == 'after_login_modal') {
          saveToday(
              '${key}signInLoginToday${LoginManager.instance.loginInfo?.custId}',
              true);
        }
      }
      display = true;
    } else if (value == 'ONLY_ONCE') {
      if (type == 'rechrge') {
        if (LoginManager.instance.isLogin.value && key == 'postLoginModal') {
          saveInfo(
              '${key}rechargeLoginNaver${LoginManager.instance.loginInfo?.custId}',
              true);
        } else if (key == 'preLoginModal') {
          saveInfo('${key}rechargeNaver', true);
        }
      } else if (type == 'turntable') {
        if (LoginManager.instance.isLogin.value && key == 'postLoginModal') {
          saveInfo('${key}turntableLoginNaver', true);
        } else if (key == 'preLoginModal') {
          saveInfo('${key}turntableNaver', true);
        }
      } else {
        if (LoginManager.instance.isLogin.value && key == 'after_login_modal') {
          saveInfo(
              '${key}signInLoginNaver${LoginManager.instance.loginInfo?.custId}',
              true);
        } else if (key == 'before_login_modal') {
          saveInfo('${key}signInNaver', true);
        }
      }
      display = true;
    }
    return display;
  }

  Future<bool> loadTodayData(String key) async {
    var today = await SpUtil.getInt(key);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(today ?? 0);
    DateTime now = DateTime.now();
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
    return today == null ? false : isToday;
  }

  Future<bool> loadNaverData(String key) async {
    var naver = await SpUtil.getBool(key);
    return naver ?? false;
  }

  Future<String?> loadLoaclData(String key) async {
    var string = await SpUtil.getString(key);
    return string;
  }

  void saveToday(String saveName, bool value) async {
    if (value) {
      int timestampSeconds = DateTime.now().millisecondsSinceEpoch;
      await SpUtil.saveInt(saveName, timestampSeconds);
    } else {
      await SpUtil.saveInt(saveName, 0);
    }
  }

  void saveInfo(String saveName, bool value) async {
    await SpUtil.saveBool(saveName, value);
  }

  void saveLocal(String saveName, String value) async {
    await SpUtil.saveString(saveName, value);
  }

  void removeActivityItem(int index) {
    if (index >= 0 && index < models.length) {
      models.removeAt(index);
    } else {
      print("Invalid index: $index");
    }
  }
}
