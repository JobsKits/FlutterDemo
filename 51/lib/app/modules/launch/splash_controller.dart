import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/api/tenant_api.dart';
import 'package:flutter_tiyu_app/app/data/tenant_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/home_data_manager.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/kernel/network/error.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';
import 'package:flutter_tiyu_app/utils/activity_manager.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SplashController extends GetxController {
  RxDouble progressValue = 0.0.obs;
  RxString versionStr = "".obs;
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() async {
    super.onInit();
    versionStr.value = await fetchVersionInfo();
    _checkAndHandleNetwork();
  }

  void _checkAndHandleNetwork() async {
    bool isChecking = true;
    bool isShowingError = false;
    while (isChecking) {
      bool hasNetwork = await AppManager.instance.checkNetwork();
      if (hasNetwork) {
        EasyLoading.dismiss();
        isChecking = false;
        fetchData();
      } else {
        if (!isShowingError) {
          isShowingError = true;
          EasyLoading.show(
            status: '网络未连接，请检查您的网络设置',
            maskType: EasyLoadingMaskType.black,
            dismissOnTap: false,
          );
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  Future<void> fetchData() async {
    // await initializeUrlList();
    NetworkService ns = NetworkService();
    // ns.setBaseURL('https://2505h5.mbwc321.com');
    ns.setBaseURL('https://test456.oossc360.icu');
    if (ns.baseURL.isEmpty) {
      // 域名获取失败，进入维护页面
      Get.offNamed(Routes.MAINTENANCE);
      return;
    }
    await reqTenantInfo();
    if (TenantManager.instance.tenantBean == null) {
      // 租户获取失败，进入维护页面
      Get.offNamed(Routes.MAINTENANCE);
      return;
    }
    //网易易盾 智能风控
    AppManager.instance.initHTP();
    await HomeRequestManager.to.fetchAllData();
    AppManager.instance.getRegistrationId();

    var displayAdUrl = TenantManager.instance.tenantBean!.appDisplayAdUrl;
    if (displayAdUrl != null && displayAdUrl.isNotEmpty) {
      // 下载并缓存图片
      var cacheManager = DefaultCacheManager();
      File adFile = await cacheManager.getSingleFile(displayAdUrl);
      progressValue.value = 1.0;
      Get.offNamed(Routes.DISPLAY_AD, arguments: {
        "adFile": adFile,
      });
      // Get.offNamed(Routes.AGENT_CENTER_NEW);
    } else {
      progressValue.value = 1.0;
      Get.offNamed(Routes.TABS);
    }
  }

  void animateProgressValueTo(double targetValue) {
    double startValue = progressValue.value;
    int duration = 5000;
    int steps = 50; // 动画步数
    double stepDuration = duration / steps;
    double stepIncrement = (targetValue - startValue) / steps;

    for (int i = 0; i < steps; i++) {
      Future.delayed(Duration(milliseconds: stepDuration.toInt()));
      progressValue.value += stepIncrement;
    }

    progressValue.value = targetValue;
  }

  Future<void> initializeUrlList() async {
    try {
      // 1.取本地缓存域名列表
      List<String>? urlList = await SpUtil.getStringList('urlList');
      if (urlList == null || urlList.isEmpty) {
        // 2.从阿里云等远端文件获取域名
        urlList = await AppManager.instance.fetchAndSaveUrlListFromFile();
      }
      // print('urlList: ${urlList}');
      // 3.通过3711361接口验证域名，并本地缓存返回的域名列表
      bool isUrlValid =
          await AppManager.instance.validateAndSetBaseUrl(urlList);
      if (!isUrlValid) {
        urlList = await AppManager.instance.fetchAndSaveUrlListFromFile();
        await AppManager.instance.validateAndSetBaseUrl(urlList);
      }
      // print('baseUrl: ${NetworkService().baseURL}');

      /*
      List<String>? urlList = await SpUtil.getStringList('urlList');
      if (urlList == null || urlList.isEmpty) {
        // 没缓存就直接拉远程
        urlList = await AppManager.instance.fetchAndSaveUrlListFromFile();
        await AppManager.instance.validateAndSetBaseUrl(urlList);
      } else {
        // 有缓存，先验证
        bool isUrlValid =
            await AppManager.instance.validateAndSetBaseUrl(urlList);

        // 先开始拉远程，但不等它（懒加载）
        final Future<List<String>> remoteFuture =
            AppManager.instance.fetchAndSaveUrlListFromFile();

        if (!isUrlValid) {
          // 缓存失效时，用刚刚启动的远程 Future
          List<String> newUrlList = await remoteFuture;
          await AppManager.instance.validateAndSetBaseUrl(newUrlList);
        }
      }
      */
    } catch (e, stacktrace) {
      print('Error initializing URL list: $e');
      print(stacktrace);
    }
  }

  //请求租户信息
  Future<void> reqTenantInfo() async {
    final res = await TenantApi.reqTenantInfo();
    if (res.type == NetworkService.networkTypeSuccess) {
      await TenantManager.instance.setTenantBean(TenantBean.fromJson(res.data));
      setActiveConfiguration();
    }
  }

  // 设置活动配置
  void setActiveConfiguration() {
    final tenantBean = TenantManager.instance.tenantBean!;
    var listShow = tenantBean.listShow;
    if (listShow != null && listShow.isNotEmpty) {
      Map<String, int> activeConfiguration = {};
      Map<String, String> activeConfigurationDesc = {};
      Map<String, String> activeConfigurationDescDetail = {};

      listShow.forEach((ele) {
        activeConfiguration[ele.name] = ele.showMobile.toInt();
        activeConfigurationDesc[ele.name] = ele.showDes.toString();
        activeConfigurationDescDetail[ele.name] = ele.detail.toString();
      });

      ActivityManager.instance.setActivityBean(
        activeConfiguration: activeConfiguration,
        activeConfigurationDesc: activeConfigurationDesc,
        activeConfigurationDescDetail: activeConfigurationDescDetail,
      );
    }
  }
}
