import 'dart:ui';

import 'package:flutter_tiyu_app/translations/app_ar.dart';
import 'package:flutter_tiyu_app/translations/app_en.dart';
import 'package:flutter_tiyu_app/translations/app_es.dart';
import 'package:flutter_tiyu_app/translations/app_hi.dart';
import 'package:flutter_tiyu_app/translations/app_id.dart';
import 'package:flutter_tiyu_app/translations/app_pt.dart';
import 'package:flutter_tiyu_app/translations/app_th.dart';
import 'package:flutter_tiyu_app/translations/app_tr.dart';
import 'package:flutter_tiyu_app/translations/app_vi.dart';
import 'package:get/get.dart';

import 'app_zh.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en": appEn,
        "zh": appZh,
        "hi": appHi,
        "ar": appAr,
        "es": appES,
        "id": appId,
        "pt": appPt,
        "th": appTh,
        "tr": appTr,
        "vi": appVi,
      };
}

var supportedLocales = [
  const Locale('en'), // 英文
  const Locale('zh', 'CN'), // 中文简体
  const Locale('hi'), // 印度语
  const Locale('ar'), // 阿拉伯语
  const Locale('es'), // 西班牙语
  const Locale('id'), // 印尼语
  const Locale('pt'), // 葡萄牙语
  const Locale('th'), // 泰语
  const Locale('tr'), // 土耳其语
  const Locale('vi'), // 越南语
];
