import 'package:flutter_bet/generated/l10n.dart';
import 'package:get/get.dart';

class TransactionsDetailSportController extends GetxController {
  TransactionsDetailSportController();

  // tap
  void handleTap(int index) {
    Get.snackbar(
      S.current.random_text_388,
      S.current.random_text_389,
    );
  }

  void exchange() {

  }

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
