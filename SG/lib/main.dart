import 'dart:async';
import 'dart:io';

import 'package:flutter_bet/constant/app_cache_key.dart';
import 'package:flutter_bet/pages/splash/binding.dart';
import 'package:flutter_bet/pages/splash/view.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/device_service.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/services/ulog_service.dart';
import 'package:flutter_bet/utils/channel_util.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:flutter_bet/widget/custom_route_listen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/widget/custom_toast.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'model/language/session_change_notifier.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    /// 将错误信息打印到控制台
    JobsPrint(details.toString());
  };
  /// 初始化时区数据库
  tz.initializeTimeZones();
  /// 用于确保Flutter框架已经初始化(某些情况下可以省略，最新版本的Flutter中不需要显示调用，但是为了确保向下兼容，还是加上)
  WidgetsFlutterBinding.ensureInitialized();
  /// SPUtil必须启动时预初始化
  await SPUtil.perInit();

  runZonedGuarded(() {
    // runApp(MyApp());
    /// 设置应用的屏幕方向为竖屏。
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
      runApp(MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => CurrentLocale())],
        child: const MyApp(),
      ));
    });
  }, (error, stackTrace) {
    /// 处理未捕获的异常
    JobsPrint(error.toString());
    JobsPrint(stackTrace.toString());
  });

  if(Platform.isAndroid){
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        /// 这是设置状态栏的图标和字体的颜色
        /// Brightness.light  一般都是显示为白色
        /// Brightness.dark 一般都是显示为黑色
        statusBarIconBrightness: Brightness.light
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }
  /// 获取设备的高级ID信息。
  await DeviceService.instance.getAdvanceDeviceId();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  // late final SetupContactController? setupcontroller;
  @override
  void initState() {
    // if (Get.isRegistered<SetupContactController>()) {
    //   setupcontroller = Get.find<SetupContactController>();
    // }
    super.initState();
    /// 统计首次安装app
    FlutterPluginName.installApp(CacheKey.installApp);
    /// 统计启动app
    FlutterPluginName.callMethod(CacheKey.launchApp);
    WidgetsBinding.instance.addObserver(this);
    /// 根据设计稿，这个App默认使用暗黑模式的风格
    ThemeService.instance.initTheme(ThemeMode.dark);
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: _buildMaterialApp(context));
  }
  Widget _buildMaterialApp(BuildContext mContext) {
    JobsPrint('当前语言包---：${Get.locale}---${Get.deviceLocale}----${LangService().lang.toLocaleValue}');
    return Consumer<CurrentLocale>(
      builder: (context, currentLocale, child) {
        return GetMaterialApp(
          locale: currentLocale.getLocale(),
          fallbackLocale: Get.deviceLocale,
          // fallbackLocale: LangService().lang.toLocaleValue,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            CustomRouteListenWidget.routeObserver,
            CustomGlobalNavigatorObserver()
          ],
          initialRoute: '/',
          getPages: [...Routes.routePage],
          theme: ThemeService.instance.lightTheme,
          darkTheme: ThemeService.instance.darkTheme,
          themeMode: ThemeService.instance.themeMode,
          defaultTransition: Transition.cupertino,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          initialBinding: SplashBinding(),
          home: SplashPage(
            onFinish: (context) async {
              // _initThirdSDK();
              await AccountService().initAsync();
              Future.delayed(const Duration(seconds: 1), () {
                RouteUtil.pushToView(Routes.mainPage, offAll: true);
              });
            },
          ),
        );
      },
    );
  }
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.inactive:
  //     // 应用程序处于非活动状态
  //       debugPrint('应用程序处于非活动状态');
  //       break;
  //     case AppLifecycleState.paused:
  //     // 应用程序处于后台
  //       debugPrint('应用程序处于后台');
  //       toEnd();
  //       break;
  //     case AppLifecycleState.resumed:
  //     // 应用程序处于前台并可交互
  //       debugPrint('应用程序处于前台并可交互');
  //       toFront();
  //       break;
  //     case AppLifecycleState.detached:
  //     // 应用程序没有关联的 Flutter 引擎
  //       debugPrint('应用程序没有关联的 Flutter 引擎');
  //       break;
  //   // case AppLifecycleState.hidden:
  //   // TODO: Handle this case.
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  // void toEnd(){
  //   if(setupcontroller != null){
  //     SPUtil().setJson('seconds', {
  //       'seconds': setupcontroller!.seconds.value,
  //       'date': DateTime.now().millisecondsSinceEpoch
  //     });
  //     /// 记录当前倒计时的秒数
  //     SPUtil().setBool(CacheKey.isShowTime,false);
  //     /// 离开这个页面，按钮就当没有点按过
  //     SPUtil().setBool(CacheKey.isClick,false);
  //     /// 第一次灌入数据，不管有没有数据，都不能编辑（其实这句写不写都无所谓，因为本次操作是杀进程）
  //     GlobalState.instance.isEdit = false;
  //     setupcontroller!.isShowTime.value = (SPUtil().getBool(CacheKey.isShowTime))!;
  //     if (setupcontroller!.timer.isActive) setupcontroller!.timer.cancel();
  //   }
  // }
  //
  // void toFront(){
  //   // 程序没有杀死，有倒计时。杀死了就不管了，一切从0开始
  //   if(setupcontroller != null){
  //     setupcontroller!.countdown(false, setupcontroller!.seconds.value);
  //   }
  // }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
/// 关闭软键盘
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}

void _initThirdSDK() async {
  ULogService.instance;

//Remove this method to stop OneSignal Debugging    推送初始化方法
//   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//   OneSignal.initialize("af0766d6-ec19-4b29-bb78-718d1961380f");
// // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//   OneSignal.Notifications.requestPermission(true);

  // AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
  //     afDevKey: "LkQ6kpwrrmBYiAwehr6Wkh",
  //     appId: "com.tggroup.flutter_bet",
  //     showDebug: true);
  //
  // AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  //
  // appsflyerSdk.initSdk(
  //     registerConversionDataCallback: true,
  //     registerOnAppOpenAttributionCallback: true,
  //     registerOnDeepLinkingCallback: true
  // );

  // AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
  //   afDevKey: "LkQ6kpwrrmBYiAwehr6Wkh",
  //   appId: "com.tggroup.fb4748",
  //   showDebug: true,
  //   timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
  //   // appInviteOneLink: oneLinkID, // Optional field
  //   disableAdvertisingIdentifier: false, // Optional field
  //   disableCollectASA: false, //Optional field
  //   manualStart: false, ); // Optional field
  //
  // AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  // appsflyerSdk.initSdk(
  //     registerConversionDataCallback: true,
  //     registerOnAppOpenAttributionCallback: true,
  //     registerOnDeepLinkingCallback: true);

  //Here we start the SDK
  // appsflyerSdk.startSDK();
  // bool? result = false;
  // try {
  //   Map<String, String> eventValues = Map<String, String>();
  //   eventValues['af_re_engage1'] = 'value1';
  //   eventValues['af_re_engage2'] = 'value2';
  //   result = await appsflyerSdk.logEvent("af_login", eventValues);
  // } on Exception catch (e) {
  //   JobsPrint("Result logEvent87222: -------------失败了！！！！！！");
  // }
  // JobsPrint("Result logEvent87222: $result");

  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //请求获取设备id需要的权限，iOS-ATT广告追踪，Android-根据系统版本oaid或者imie
  // final success = await FlutterAdvertisingId.requestPermissionIfNecessary();
  // ULog.i("请求获取设备id需要的权限：$success");
  // final deviceId = await FlutterAdvertisingId.getDeviceId();
  // ULog.i("设备id：$deviceId");

  // PushService.instance.initSDK(AppValues.jPushKey, AppValues.channel);
  // Future.delayed(const Duration(seconds: 1), () {
  //   RouteUtil.pushToView(Routes.mainPage, offAll: true);
  // });

  //   if (flag) {
  //     _showSplashAdView();
  //   } else {
  //     RouteUtil.pushToView(Routes.mainPage, offAll: true);
  //   }
  // });
}

class CustomGlobalNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    CustomSnackBar.dismiss();
    CustomToast.dismiss();
  }
}
