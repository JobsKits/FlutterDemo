import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constant/app_cache_key.dart';

class CurrentLocale with ChangeNotifier {
  Locale _locale = const Locale("en", "US");

  Locale get value => _locale;

  set setLocale(locale) {
    _locale = locale;
    notifyListeners();
  }

  Locale? getLocale() {
    var type = SPUtil().getInt(CacheKey.langType);
    if (type == 1) {
      return const Locale('zh', 'CN');
    } else if (type == 2) {
      return const Locale("en", "US");
    } else if (type == 3) {
      return const Locale("pt", "BR");
    } else if (type == 4) {
      return const Locale("vi", "VN");
    } else if (type == 5) {
      return const Locale("th", "TH");
    } else if (type == 6) {
      return const Locale("hi", "IN");
    } else {
      return Get.deviceLocale;
    }
  }
}
