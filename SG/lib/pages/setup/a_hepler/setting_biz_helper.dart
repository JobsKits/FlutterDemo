

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import '../../../widget/custom_toast.dart';

class SettingBizHelper {
  ///复制
  static void copyText(String? content) {
    Clipboard.setData(ClipboardData(text: content));
    CustomToast.show(S.current.random_text_151, Get.overlayContext!);
  }
}