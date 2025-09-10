import 'dart:ui';

import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';

class LanguageUtil {
  // static final Rx<Locale> locale = const Locale("zh").obs;
  static void changeLanguage(String languageCode) {
    // locale.value = Locale(languageCode);
    Get.updateLocale(Locale(languageCode));
    SpUtil.saveString("currentLanguageType", languageCode);
  }

  static Future<String> getLanguageIconPath() async {
    String countryCode = await SpUtil.getString("currentLanguageType") ?? "zh";
    switch (countryCode) {
      case "zh":
        return Assets.theme1.images.language.iconCn.path;
      case "en":
        return Assets.theme1.images.language.iconEn.path;
      case "hi":
        return Assets.theme1.images.language.iconHi.path;
      case "ar":
        return Assets.theme1.images.language.iconAr.path;
      case "es":
        return Assets.theme1.images.language.iconEs.path;
      case "id":
        return Assets.theme1.images.language.iconId.path;
      case "pt":
        return Assets.theme1.images.language.iconPt.path;
      case "th":
        return Assets.theme1.images.language.iconTh.path;
      case "tr":
        return Assets.theme1.images.language.iconTr.path;
      case "vi":
        return Assets.theme1.images.language.iconVi.path;
      default:
        return Assets.theme1.images.language.iconCn.path;
    }
  }
}
