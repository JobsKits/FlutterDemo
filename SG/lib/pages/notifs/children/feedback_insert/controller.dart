import 'dart:async';

import 'package:flutter_bet/generated/l10n.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/notifs_api_service.dart';
import 'package:flutter_bet/widget/custom_progress_hud.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FeedbackInsertController extends GetxController {
  FeedbackInsertController();

  /// 文本输入控制器
  TextEditingController textController = TextEditingController(text: "");
  /// 已选图像
  List<AssetEntity> assets = [];

  FocusNode focusNode = FocusNode();

  var textLength = 0.obs;

  /// 控制输入提示
  var showEmptyHint = false.obs;

  /// 控制输入提示-参照h5显示逻辑所需(此处用于文本内容变化控制)
  var showEmptyHint2 = false.obs;

  /// 倒计时
  final maxSeconds   = 10;
  var currentSeconds = 0.obs;
  Timer? timer;

  _initData() {
    textController.addListener(_onTextChanged);
    update(["feedback_insert"]);
  }

  /// 文本变化时的回调函数
  void _onTextChanged() {

    if(textController.text.isNotEmpty) {
      showEmptyHint2.value = true;
    }
    textLength.value = textController.text.length;
  }

  /// 图像选择
  Future<void> pickAssets() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: AssetPickerConfig(
        selectedAssets: assets,
        maxAssets: 5,
        requestType: RequestType.image,
        // filterOptions: CustomFilter.sql(where: '',)
      ),
    );
    assets = result ?? [];
    update(["feedback_insert"]);
  }

  /// 取消事件
  void cancelAction() {
    assets = [];
    textController.text = '';
    update(["feedback_insert"]);
  }

  /// 反馈提交
  void feedbackSubAction(context) {
    if(textController.text.isEmpty) {
      showEmptyHint.value = true;
      return;
    }
    CustomProgressHUD.show(context, content: S.current.random_text_4);
    if(assets.isEmpty) {
      reqFeedbackInsert(context, '');
    }else {
      reqImgUpload(context);
    }
  }

  /// 图像上传
  Future<void> reqImgUpload(context) async {

    var imgPaths = [];
    for (AssetEntity element in assets) {
      await ApiService.instance.uploadImg(
          asset: element,
          success: (imgPath) {
            imgPaths.add(imgPath);
          },
          fail: (errorMessage) {
            CustomProgressHUD.dismiss(context);
            CustomSnackBar.showError(errorMessage!, context);
            return;
          }
      );
    }

    reqFeedbackInsert(context, json.encode(imgPaths));
  }

  /// 反馈上传
  Future<void> reqFeedbackInsert(context, String imgPaths) async {

    await ApiService.instance.feedbackInsert(
        description: textController.text,
        images: imgPaths,
        success: (data) {
          CustomProgressHUD.dismiss(context);
          CustomSnackBar.show(
              S.current.random_text_821,
              context,
              title: S.current.success_pwd,
              preIcon: CustomSnackBarIcons.verifySucceed
          );
          startTimer();
          assets = [];
          textController.text = '';
          update(["feedback_insert"]);
        },
        fail: (errorMessage) {
          CustomProgressHUD.dismiss(context);
          CustomSnackBar.showError(errorMessage!, context);
        }
    );
  }

  void startTimer() {
    currentSeconds.value = maxSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentSeconds > 0) {
        currentSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    focusNode.dispose();
    textController.removeListener(_onTextChanged);
  }
}
