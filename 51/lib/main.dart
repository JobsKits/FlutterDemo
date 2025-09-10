import 'dart:io';

import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_plugin_engagelab/flutter_plugin_engagelab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/api/log_service.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/home_data_manager.dart';
import 'package:flutter_tiyu_app/app_lifecycle_controller.dart';
import 'package:flutter_tiyu_app/app_navigator_observer.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/mian_bindings.dart';
import 'package:flutter_tiyu_app/theme/base.theme.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/translations/app_translations.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:oktoast/oktoast.dart';
import 'app/routes/app_pages.dart';

void main() async {
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   // 打印错误到控制台
  //   FlutterError.dumpErrorToConsole(details);

  //   final errorMessage = details.exceptionAsString();
  //   reportError(details.exception, details.stack, errorMessage);
  // };

  // 设置状态栏样式
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.white, // 状态栏背景颜色
  //   statusBarIconBrightness: Brightness.dark, // 状态栏图标颜色（黑色）
  //   statusBarBrightness: Brightness.light, // 适用于iOS
  //
  //   systemNavigationBarColor: Colors.white, // 导航栏背景颜色
  //   systemNavigationBarIconBrightness: Brightness.dark, // 导航栏图标为黑色
  //   systemNavigationBarDividerColor: Colors.white, // 导航栏分割线颜色（可选）
  // ));

  // 设置系统 UI 样式：状态栏 + 底部小横条
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light, // 状态栏图标为亮色（适合深色背景）
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  Get.lazyPut(() => HomeRequestManager(), fenix: true);

  WidgetsFlutterBinding.ensureInitialized();
  initPlatformState();
  DartPingIOS.register();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    WakelockPlus.enable();
    Get.put(AppLifecycleController()); // 注册生命周期监听

    String currentLanguage =
        await SpUtil.getString("currentLanguageType") ?? "zh";
    NetworkService().setLanguageNum(currentLanguage);
    final AppNavigatorObserver appNavigatorObserver = AppNavigatorObserver();
    Get.put(ThemeService(), permanent: true);

    ThemeService.to.handleUpdateTheme(ThemeObjMode.blackGold);
    runApp(OKToast(
      child: ScreenUtilInit(
        designSize: const Size(1125, 2436), //目前给到的设计图尺寸，如有变动，后续再改
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: '澳门新葡京',
            navigatorObservers: [appNavigatorObserver],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeService.light, // Use light theme
            darkTheme: ThemeService.dark, // Use dark them
            themeMode: ThemeMode.light,
            supportedLocales: supportedLocales,
            initialRoute: AppPages.INITIAL,
            initialBinding: MainBindings(),
            getPages: AppPages.routes,
            builder: EasyLoading.init(),
            translations: AppTranslations(),
            locale: Locale(currentLanguage),
            fallbackLocale: const Locale("en"),
          );
        },
      ),
    ));

    configLoading();
  });
}

void configLoading() {
  // EasyLoading.instance
  //   ..loadingStyle = EasyLoadingStyle.light
  //   ..backgroundColor = Colors.white // 自定义背景颜色
  //   ..dismissOnTap = true; // 点击不能关闭加载框

  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..indicatorColor = BaseTheme.primaryBlueLight
    ..textColor = BaseTheme.primaryBlueLight
    ..dismissOnTap = true; // 点击不能关闭加载框
  // ..maskType = EasyLoadingMaskType.custom
  // ..maskColor = Colors.black.withOpacity(0.1)
}

Future<void> initPlatformState() async {
  FlutterPluginEngagelab.addEventHandler(
      onMTCommonReceiver: (Map<String, dynamic> message) async {
    FlutterPluginEngagelab.printMy("flutter onMTCommonReceiver: $message");
    String eventName = message["event_name"];
    String eventData = message["event_data"];
    FlutterPluginEngagelab.printMy(
        "flutter onMTCommonReceiver event_name: $eventName");
    FlutterPluginEngagelab.printMy(
        "flutter onMTCommonReceiver event_data: $eventData");
    // debugLable = "flutter onMTCommonReceiver: $message";
    if (Comparable.compare(eventName, "onConnectStatus") == 0 ||
        Comparable.compare(eventName, "networkDidLogin") == 0) {
      FlutterPluginEngagelab.getRegistrationId().then((rid) async {
        // print('推送信息rid2: $rid');
        LoginManager.instance.registrationId = rid;
        await SystemApi.addPushInfo();
        SystemApi.updatePushInfo();
      });
    }
  });
  FlutterPluginEngagelab.configDebugMode(false);
  if (Platform.isIOS) {
    FlutterPluginEngagelab.initIos(
      appKey: "f3753a029629ef899069e6c4",
      channel: "testChannel",
    );
    FlutterPluginEngagelab.checkNotificationAuthorizationIos();
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    FlutterPluginEngagelab.initAndroid();
  }

  // App 启动后将角标置为0
  FlutterPluginEngagelab.setNotificationBadge(0);
  FlutterPluginEngagelab.resetNotificationBadge();
  await initOpeninstall();
}

void reportError(dynamic error, StackTrace? stackTrace, dynamic errormessage) {
  String logText =
      "---Flutter App---租户:${TenantManager.instance.tenantBean?.tenant?.tenantName ?? ''} -------- \n--- Error ---: $error, \n --- stackTrace ---: $stackTrace \n--- errormessage ---: $errormessage, \n--- 日期 ---:${getNowTime()}";
  LogClient(Dio()).getLog(logText);
}

Future<void> initOpeninstall() async {
  OpeninstallFlutterPlugin openinstallFlutterPlugin =
      OpeninstallFlutterPlugin();
  openinstallFlutterPlugin.setDebug(true);
  openinstallFlutterPlugin.init(wakeupHandler);
  // 错误：应该在业务需要时再调用 install 获取参数
  // openinstallFlutterPlugin.install(installHandler);
}

Future wakeupHandler(Map<String, Object> data) async {
  print("wakeupHandler: $data");
}

/// 获取当前时间
String getNowTime() {
  final time = DateTime.now();
  DateFormat formatter = DateFormat('yyyy/MM/ddTHH:mm:ss.SSS');
  String formattedDate = formatter.format(time);
  DateFormat amPmFormatter = DateFormat('a');
  String amPm = amPmFormatter.format(time);
  return '$formattedDate ${amPm == 'AM' ? 'AM' : 'PM'}';
}
