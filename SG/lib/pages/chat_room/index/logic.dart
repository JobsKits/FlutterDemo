import 'dart:math';

import 'package:flutter_bet/generated/l10n.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/model/chat_message.dart';
import 'package:flutter_bet/pages/chat_room/emoji/emoji.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/im_api_service.dart';
import 'package:flutter_bet/services/chat_room_service.dart';
import 'package:flutter_bet/services/mqtt/mqtt_service.dart';
import 'package:flutter_bet/services/mqtt/mqtt_topic.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_ulog/flutter_ulog.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:intl/intl.dart';
import '../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../../account/login/login_widget.dart';

const int inputMaxLength = 160;

class ChatRoomLogic extends BaseController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController textCtrl = TextEditingController();
  late StreamSubscription<bool> _keyboardSubscription;
  AccountServiceListener? _accountServiceListener;
  ChatRoomServiceListener? _chatRoomServiceListener;
  MqttServiceListener? _mqttServiceListener;
  final isLogin = false.obs;
  String submitText = '';
  final inputText = ''.obs;
  final List<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final maxLessTextLen = 160.obs;
  final currCountryText = ''.obs;
  final iconPath = ''.obs;
  final isInitialized = false.obs;
  final showed = false.obs;
  final showedAt = false.obs;
  final emojiHighlight = false.obs;

  ///所有昵称
  final List<ChatMessageModel> nameAllList = <ChatMessageModel>[].obs;

  ///显示昵称
  final List<ChatMessageModel> nameList = <ChatMessageModel>[].obs;
  final modelTmp = ChatMessageModel(t: 1700000000);
  final emojiList = Emoji.list();
  final emojiFaceList = Emoji.allSmileFace;

  ///缩放比例
  final scale = 1.0.obs;
  final scaleBtn = 1.0.obs;
  final isFocus = false.obs;
  final focusNode = FocusNode();

  final online = '1,895'.obs;

  showKeyboard() async {
    if (!isLogin.value) {
      // RouteUtil.pushToView(Routes.loginPage);
      showCustomLoginWidget(context: Get.context!);
      return;
    }
    isFocus.value = true;
    await Future.delayed(const Duration(milliseconds: 50));
    focusNode.requestFocus();
  }

  @override
  touches() {
    isFocus.value = false;
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _accountServiceListener = AccountServiceListener(onLoginSuccess: (model) {
      isLogin.value = true;
      _asyncHistoryData();
    }, onLogout: () {
      isLogin.value = false;
    });
    isLogin.value = AccountService.sharedInstance.isLogin();
    AccountService.sharedInstance.addListener(_accountServiceListener!);
    final channel = ChatRoomService.sharedInstance.getChannel;
    currCountryText.value = channel.name;
    _asyncHistoryData();
    iconPath.value = channel.iconPath;
    numberFormat();
  }

  ///初始化在线人数
  numberFormat() {
    final random = Random();
    var number = (random.nextDouble() * 100).floor() + 1800;
    online.value = NumberFormat("#,###").format(number);
  }

  Future<void> _asyncHistoryData() async {
    isInitialized.value = false;
    await ApiService.instance.getChatRoomHistoryList(
        success: (list) {
          messages.clear();
          messages.assignAll(list);
          isInitialized.value = true;
          messageShowTime();
        },
        fail: (message) {});
  }

  void messageShowTime() {
    for (var i = 0; i < messages.length; i++) {
      ChatMessageModel model = messages[i];
      ChatMessageModel modelNext = i + 1 >= messages.length ? modelTmp : messages[i + 1];
      if (model.t! - modelNext.t! > 60) model.showed = true;
    }
    var tmps = messages.map((e) => e.n).toSet();
    nameAllList.addAll(messages);
    nameAllList.retainWhere((element) => tmps.remove(element.n));
    nameList.addAll(nameAllList);
  }

  Future<void> onInputMessage(String value) async {
    if (value.isNotEmpty && value[value.length - 1] == ":") showed.value = true;
    if (value.isEmpty ||
        (value.isNotEmpty &&
            value.length < submitText.length &&
            submitText[submitText.length - 1] == ":" &&
            value[value.length - 1] != ":")) {
      showed.value = false;
    }
    if (value.isNotEmpty && value[value.length - 1] == "@") showedAt.value = true;
    if (value.isEmpty ||
        (value.isNotEmpty &&
            value.length < submitText.length &&
            submitText[submitText.length - 1] == "@" &&
            value[value.length - 1] != "@")) {
      showedAt.value = false;
    }
    if (value.contains('@') && !value.contains(' ')) {
      nameList.clear();
      String str = value.split('@')[1];
      if (str.isNotEmpty) {
        var tmps = nameAllList.where((element) => element.n!.contains(str)).toList();
        if (tmps.isEmpty) tmps.add(ChatMessageModel(n: str));
        nameList.addAll(tmps);
      } else {
        nameList.addAll(nameAllList);
      }
    }
    submitText = value;
    inputText.value = value;
    maxLessTextLen.value = inputMaxLength - value.length;
  }

  Future<void> onInputMessageComplete(String value) async {
    maxLessTextLen.value = inputMaxLength - value.length;
  }

  Future<void> onSubmit(BuildContext context, CustomButtonController btnCtr) async {
    KeyboardUtils.hideKeyboard(context);
    if (submitText.isEmpty) return;
    if (CommonUtil.isStringOnlyWhitespace(submitText)) return;
    if (submitText.trim().isEmpty) return;
    if (!isLogin.value) {
      // RouteUtil.pushToView(Routes.loginPage);
      showCustomLoginWidget();
      return;
    }
    inputText.value = '';
    showed.value = false;
    showedAt.value = false;
    btnCtr.showAnimation();
    await ApiService.instance.sendMessage(
        msg: submitText,
        success: (String message) {},
        fail: (String? message) {
          if (message!.contains(S.current.random_text_1155)) {
            CustomSnackBar.show(
                title: S.current.random_text_1156,
                message,
                context,
                preIcon: CustomSnackBarIcons.chat);
          } else {
            CustomSnackBar.show(
                title: S.current.random_text_1157,
                message,
                context,
                preIcon: CustomSnackBarIcons.error);
          }
        });
    submitText = '';
    btnCtr.hideAnimation();
    maxLessTextLen.value = inputMaxLength;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _keyboardSubscription.cancel();
    AccountService.sharedInstance.removeListener(_accountServiceListener!);
    MqttService.instance?.unsubscribeChat(ChatRoomService.sharedInstance.getChannel);
    ChatRoomService.sharedInstance.removeListener(_chatRoomServiceListener!);
    MqttService.instance?.removeListener(_mqttServiceListener!);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      scrollToBottom();
    });
    _chatRoomServiceListener = ChatRoomServiceListener(
        onChannelChange: (ChatRoomChannelModel oldChannel, ChatRoomChannelModel newChannel) {
      MqttService.instance?.unsubscribeChat(oldChannel);
      MqttService.instance?.subscribeChat(ChatRoomService.sharedInstance.getChannel);
      _asyncHistoryData();
    });
    ChatRoomService.sharedInstance.addListener(_chatRoomServiceListener!);
    _mqttServiceListener = MqttServiceListener(onStatusChange: (event) {
      switch (event.status) {
        case 1: //连接成功
          MqttService.instance?.subscribeChat(ChatRoomService.sharedInstance.getChannel);
          break;
        case 2: //连接断开
          break;
      }
    }, onReceiveMessage: (event) {
      try {
        if (event.messageType == MqttMessageTypes.messageChat) {
          final recMess = event.originalMessage![0].payload as MqttPublishMessage;
          final msg = json.decode(utf8.decode(recMess.payload.message));
          final model = ChatMessageModel.fromJson(msg);
          onInsetNewMessage(model);
        }
      } catch (e) {
        ULog.d(e);
      }
    });
    MqttService.instance?.addListener(_mqttServiceListener!);

    ///判断mqtt是否链接成功，链接成功则订阅im消息
    bool? isConnected = MqttService.instance?.mClient.isConnected;
    if (isConnected == true) {
      MqttService.instance?.subscribeChat(ChatRoomService.sharedInstance.getChannel);
    }
  }

  Future<void> onInsetNewMessage(ChatMessageModel model) async {
    bool isRepeat = false;
    for (ChatMessageModel m in messages) {
      if (model.t == m.t) {
        isRepeat = true;
        break;
      }
    }
    if (!isRepeat) {
      if (messages.isNotEmpty) {
        ChatMessageModel modelNext = messages[0];
        if (model.t! - modelNext.t! > 60) model.showed = true;
      } else {
        model.showed = true;
      }
      messages.insert(0, model);
    }
  }

  /// 滚动到最底部
  void scrollToBottom({int milliseconds = 100}) {
    scrollController.jumpTo(0.0);
  }

  void onTap() {
    showed.value = !showed.value;
    emojiHighlight.value = !emojiHighlight.value;
    Future.delayed(const Duration(milliseconds: 200), () {
      emojiHighlight.value = !emojiHighlight.value;
    });
  }

  void onHidden() {
    showed.value = false;
  }

  onTapEmoji(String name) {
    if (submitText.isNotEmpty && submitText[submitText.length - 1] == ":") {
      inputText.value = submitText.substring(0, submitText.length - 1);
    }
    inputText.value += '%:$name:%';
    onTapText();
  }

  onTapEmojiFace(String name) {
    if (submitText.isNotEmpty && submitText[submitText.length - 1] == ":") {
      inputText.value = submitText.substring(0, submitText.length - 1);
    }
    inputText.value += name;
    onTapText();
  }

  onTapAtName(String name) {
    var index = inputText.value.indexOf('@');
    inputText.value = '${inputText.value.substring(0, index + 1)}$name ';
    showedAt.value = false;
    onTapText();
  }

  onTapText() {
    submitText = inputText.value;
    onInputMessageComplete(inputText.value);
    textCtrl.value = TextEditingValue(
        text: submitText,
        selection: TextSelection.fromPosition(TextPosition(offset: submitText.length)));
  }
}
