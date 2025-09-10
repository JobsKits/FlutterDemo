import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onString.dart';
import 'package:flutter_tiyu_app/theme/base.theme.dart';
import 'package:flutter_tiyu_app/theme/log.utils.dart';
import 'package:flutter_tiyu_app/theme/storage.utils.dart';
import 'package:flutter_tiyu_app/theme/theme.custom.dart';
import 'package:get/get.dart';

const themeLocal = {
  "ThemeMode.light": ThemeMode.light,
  "ThemeMode.dark": ThemeMode.dark,
  "ThemeMode.system": ThemeMode.system
};

enum ThemeState {
  dark(
    ThemeMode.dark,
    "LocaleKeys.nightModal",
  ),
  light(ThemeMode.light, "LocaleKeys.dayModal"),
  paying(ThemeMode.system, "LocaleKeys.followingSystem");

  const ThemeState(this.number, this.value);

  final ThemeMode number;

  final String value;

  static ThemeState getType(ThemeMode number) =>
      ThemeState.values.firstWhere((activity) => activity.number == number);

  static String getValue(ThemeMode number) => ThemeState.values
      .firstWhere((activity) => activity.number == number)
      .value;
}

class ThemeService extends GetxService {
  static ThemeService get to => Get.find<ThemeService>();

  ThemeMode mode = ThemeMode.system;

  // 0 -> 夜间 1 -> 日间
  final model = (ThemeMode.system).obs;

  final Map<ThemeObjMode, ThemeObj> themeObj = {
    ThemeObjMode.blue: ThemeObj(
        model: "blue",
        data: light.copyWith(
          extensions: [CustomTheme.blueLight],
          primaryColor: BaseTheme.primaryBlueLight,
          indicatorColor: BaseTheme.primaryBlueLight,
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                  color: BaseTheme.appbarTextBlueLight,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              iconTheme: IconThemeData(color: BaseTheme.appbarTextBlueLight)),
          tabBarTheme: TabBarTheme(
            indicatorColor: BaseTheme.primaryBlueLight,
          ),
          // tabBarTheme: TabBarThemeData(
          //   indicatorColor: BaseTheme.primaryBlueLight,
          // ),
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: BaseTheme.primaryBlueLight),
        )),
    ThemeObjMode.gold3: ThemeObj(
        model: "gold3",
        data: light.copyWith(
          extensions: [CustomTheme.gold3Light],
          primaryColor: BaseTheme.primaryGold3Light,
          indicatorColor: BaseTheme.primaryGold3Light,
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                  color: BaseTheme.appbarTextGold3Light,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              iconTheme: IconThemeData(color: BaseTheme.appbarTextGold3Light)),
          tabBarTheme: TabBarTheme(
            indicatorColor: BaseTheme.primaryGold3Light,
          ),
          // tabBarTheme: TabBarThemeData(
          //   indicatorColor: BaseTheme.primaryGold3Light,
          // ),
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: BaseTheme.primaryGold3Light),
        )),
    ThemeObjMode.blackGold: ThemeObj(
      model: "blackGold",
      data: light.copyWith(
        extensions: [CustomTheme.blackGoldLight],
        primaryColor: BaseTheme.primaryBlackGoldLight,
        indicatorColor: BaseTheme.primaryBlackGoldLight,
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                color: BaseTheme.appbarTextBlackGoldLight,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            iconTheme:
                IconThemeData(color: BaseTheme.appbarTextBlackGoldLight)),
        tabBarTheme: TabBarTheme(
          indicatorColor: BaseTheme.primaryBlackGoldLight,
        ),
        // tabBarTheme: TabBarThemeData(
        //   indicatorColor: BaseTheme.primaryBlackGoldLight,
        // ),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: BaseTheme.primaryBlackGoldLight),
      ),
    ),
  };

  late final currentTheme = (themeObj[ThemeObjMode.blue]).obs;

  final currentThemeLabel = (ThemeObjMode.blue).obs;

  SystemUiOverlayStyle get systemOverlay => model.value == ThemeMode.dark
      ? SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light)
      : SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark);

  updateStatusBar() {
    // #兼容 web，非 web 直接打开
    if (!kIsWeb) {
      SystemUiOverlayStyle uiStyle = SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.light);

      if (mode == ThemeMode.dark) {
        uiStyle = SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light);
      }

      /// 系统主题时，判断一下主题
      if (mode == ThemeMode.system) {
        if (Get.isDarkMode) {
          uiStyle = SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light);
        }
        LogUtil.w("是否是深色布局___${Get.isDarkMode}");
      } else {
        uiStyle = SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.white,
            statusBarIconBrightness: Brightness.light);
      }
      SystemChrome.setSystemUIOverlayStyle(uiStyle);
    }
  }

  handleSetTheme(ThemeMode value) {
    ThemeState.getType(value);
    StorageUtils().setStorage(key: StorageKeys.theme, value: "$value");
    LogUtil.w("value____$value");
    mode = value;
    model.value = value;
    LogUtil.w("主题切换 $mode");
    Get.changeThemeMode(mode);
    updateStatusBar();
  }

  @override
  void onInit() {
    final currentTheme = StorageUtils().getStorage(key: StorageKeys.theme);
    LogUtil.w("当前主题___${currentTheme} ");
    if (currentTheme != null) {
      themeObj.forEach((k, v) {
        if (k.name == currentTheme) {
          currentThemeLabel.value = k;
          handleUpdateTheme(k);
        }
      });
      // mode = themeLocal[currentTheme] ?? ThemeMode.system;
      // model.value = themeLocal[currentTheme] ?? ThemeMode.system;
      // handleUpdateTheme();
    } else {
      // mode = ThemeMode.light;
      // model.value = ThemeMode.light;
    }
    super.onInit();
  }

  //修改主题
  handleUpdateTheme(ThemeObjMode value) {
    currentThemeLabel.value = value;
    currentTheme.value = themeObj[value];
    Get.changeTheme(themeObj[value]!.data!);
    Get.changeThemeMode(ThemeMode.light);
    Get.forceAppUpdate();
    StorageUtils().save(StorageKeys.theme, jsonEncode(value.name));
  }

  // 依UI原型开发5种色系绿色 #07C160、蓝色 #4975be、红色 #f13131 、香槟色 #bfa46d、橘红色 #ff4500
  // 因为重写了 ThemeData, 所以需要全部重新配色
  static ThemeData get light => ThemeData(
        useMaterial3: false,
        extensions: [CustomTheme.light],
        scaffoldBackgroundColor: "#EDEDED".color(),
        primaryColor: BaseTheme.primaryBlueLight,
        indicatorColor: BaseTheme.notifyBlueLight,
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                color: BaseTheme.appbarTextBlueLight,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            iconTheme: IconThemeData(color: BaseTheme.appbarTextBlueLight)),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: BaseTheme.primaryBlueLight,
        )
        // tabBarTheme: TabBarThemeData(
        //   indicatorColor: BaseTheme.primaryBlueLight,
        // ),
      );

  static set light(ThemeData value) {
    light = value;
  }

  static ThemeData get dark => ThemeData(
        useMaterial3: false,
        extensions: [CustomTheme.dark],
        scaffoldBackgroundColor: "#4975be".color(),
        primaryColor: BaseTheme.primaryBlueDark,
        indicatorColor: BaseTheme.notifyBlueDark,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: BaseTheme.appbarTextBlueDark,
          ),
          titleTextStyle: TextStyle(
              color: BaseTheme.appbarTextBlueLight,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: BaseTheme.primaryBlueLight,
        )
        // tabBarTheme: TabBarThemeData(
        //   indicatorColor: BaseTheme.primaryBlueLight,
        // ),
      );

  static set dark(ThemeData value) {
    light = value;
  }
}

enum ThemeObjMode { blue, gold3, blackGold }

final themeData = {
  "#10C8E3": ThemeObjMode.blue,
  "#C69108": ThemeObjMode.gold3,
  "#FFD69F": ThemeObjMode.blackGold,
};

class ThemeObj {
  String? model;
  ThemeData? data;

  ThemeObj({this.model, this.data});

  ThemeObj.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['model'] = model;
    data['data'] = data;
    return data;
  }
}
