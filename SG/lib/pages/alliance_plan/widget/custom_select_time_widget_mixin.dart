import 'dart:developer';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../../services/lang_service.dart';

///时间选择器 mixin
mixin CustomSelectTimeWidgetMixin {
  ///获取组件对应的语言
  LocaleType getLocaleType() {
    LangType lang = LangService().lang;
    log("LangType语言...$lang");
    switch (lang) {
      case LangType.zhCN:
        return LocaleType.zh;
      case LangType.en:
        return LocaleType.en;
      case LangType.pt:
        return LocaleType.pt;
      case LangType.vi:
        return LocaleType.vi;
      case LangType.th:
        return LocaleType.th;
      default:
        return LocaleType.en;
    }
  }
}
