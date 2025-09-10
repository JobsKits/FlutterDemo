import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/personal_center/transactions/detail_wallet/controller.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:flutter_bet/services/api/extension/alliance_api_service.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../constant/app_urls_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../pages/activity/a_model/activity_cash_back.dart';
import '../../../../widget/share/custom_share_params.dart';
import '../../../../widget/share/custom_share_widget_model.dart';
import '../../../../pages/home/home_logic.dart';
import '../../../../services/api/api_service.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/lang_util.dart';
import '../../../../utils/route_util.dart';
import '../../../../utils/url_launch_util.dart';
import '../../../../widget/custom_toast.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../redPacket/controllers/exchange_controller.dart';
import '../views/invite_friends_view.dart';

final titleStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
class RotaryController extends GetxController with GetTickerProviderStateMixin ,ExchangeCurrencyMixin{
  final HomeLogic homeLogic = Get.find<HomeLogic>();
  final TrWalletDetailsController trWalletDetailsController = Get.put(TrWalletDetailsController());
  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";
  // final prizeList = [].obs;
  final reportList = [].obs;
  final uidList = [].obs;
  final usernameList = [].obs;
  final phoneList=<dynamic>[].obs;
  final model = ConfigModel().obs;
  final detail = "".obs;
  final roll_condition = 0.obs;/// 邀请多少个好友
  final roll_times = 0.obs;/// 奖励的次数
  final shareModelList = [
    CustomShareModel(
        typeEnum: ShareTypeEnum.Facebook,
        assetPath: "assets/images/share/ic_share_facebook.webp",
        name: "Facebook"),
    CustomShareModel(
        typeEnum: ShareTypeEnum.Telegram,
        assetPath: "assets/images/share/ic_share_telegram.webp",
        name: "Telegram"),
    CustomShareModel(
        typeEnum: ShareTypeEnum.Instagram,
        assetPath: "assets/images/share/ic_share_instagram.webp",
        name: "Instagram"),
    CustomShareModel(
        typeEnum: ShareTypeEnum.YouTube,
        assetPath: "assets/images/share/ic_share_youtube.webp",
        name: "YouTube"),
    CustomShareModel(
        typeEnum: ShareTypeEnum.WhatsApp,
        assetPath: "assets/images/share/ic_share_whatsapp.webp",
        name: "WhatsApp"),
    CustomShareModel(
        typeEnum: ShareTypeEnum.Twitter,
        assetPath: "assets/images/share/ic_share_x.webp",
        name: "X"),
    CustomShareModel(
        typeEnum: ShareTypeEnum.TikTok,
        assetPath: "assets/images/share/ic_share_tiktok.webp",
        name: "TikTok"),
    CustomShareModel(
        typeEnum: ShareTypeEnum.LINE,
        assetPath: "assets/images/share/ic_share_line.webp",
        name: "LINE"),
    CustomShareModel(
        typeEnum: ShareTypeEnum.Gmail,
        assetPath: "assets/images/share/ic_share_gmail.webp",
        name: "Gmail"),
  ];
  final isLoading = true.obs;/// 加载中
  final isError = false.obs;/// 加载失败
  final count = 0.obs;
  final currencyId = '701'.obs;
  final recordData = {}.obs;
  final isClickLuckyWheel = false.obs;
  final day = 0.obs;
  final time = "00:00:00".obs;
  final myLink = "".obs;
  final symbol = "".obs;
  final bonus = 0.00.obs;
  final isFull = false.obs;
  final coinSymbol = "".obs;/// 货币符号
  late TabController tabController;
  late ScrollController? scrollController;
  ScrollController? prizeScrollController;
  Timer? _timer;
  Timer? _prizeTimer;
  Timer? _ActivityTimers;
  String id = '';
  var termTypeStr = "" ,termTypeDesStr="" ,progressDesStr= "" ,completeDesStr ="";
  var rollType = 0;
  var tab = [
    Tab(
      child: Text("\t\t\t\t" + S.current.random_text_831 + "\t\t\t\t", style: titleStyle),
    ),
    // Tab(
    //   child: Text(S.current.random_text_832, style: titleStyle),
    // ),
    Tab(
      child: Text("\t\t\t\t" + S.current.random_text_833 + "\t\t\t\t", style: titleStyle),
    )
  ];

  @override
  void onInit() {
    // isClickLuckyWheel.value = GlobalState.instance.isClickLuckyWheel.value;
    initExchangeData();
    var arguments = Get.arguments;
    if (arguments != null) {
      if (arguments.containsKey('id')) {
        id = arguments['id'];
      }
      // if (arguments.containsKey('currencyId')) {
      //   currencyId.value = arguments['currencyId'];
      // }
    }

    tabController = TabController(vsync: this, length: tab.length);
    tabController.addListener(() {
      if (tabController.indexIsChanging && tabController.index == 1) {
        prizeScrollController = ScrollController();
        // _rollingData(prizeScrollController!, _prizeTimer, prizeList);
      }
    });

    scrollController = ScrollController();
    _rollingData(scrollController!,
        _timer,
        reportList);

    ever(globalController.reportList, (callback) {
      reportList.addAll(globalController.reportList);
    });
    ever(globalController.eventNotice, (callback) {
      // getPrizeList();
      getRecord();
    });
    ever(globalController.currTypeSelected, (callback) {
      currencyId.value = globalController.currTypeSelected.value.cur!;
      getRecord();
      getConfig();
    });
    super.onInit();
  }

  @override
  void onReady() {
    getFirstReportList();/// 活动领取记录(虚假数据)
    // getPrizeList();
    getRecord();/// 活动记录
    getShareLink();/// 我的推广
    getConfig();/// 获取抽奖次数
    getPhoneList();/// 获取手机号
    /// 如果不是登录状态，根据语言显示币种
    if(globalController.isLogin.value){
      currencyId.value = globalController.currTypeSelected.value.cur!;
    } else {
      currencyId.value = globalController.getCurrencyId();
    }
    getCurrencySymbol2();/// 获取币种信息
    super.onReady();
  }

  @override
  void onClose() {
    log("neco onClose");
    scrollController?.dispose();
    _timer?.cancel();
    prizeScrollController?.dispose();
    _prizeTimer?.cancel();
    _ActivityTimers?.cancel();
    // homeLogic.getAllPromotions();
    // homeLogic.updateActivityMenu();
    super.onClose();
  }

  @override
  void dispose() {
    log("neco dispose");
    prizeScrollController?.dispose();
    scrollController?.dispose();
    super.dispose();
  }

  void _rollingData(ScrollController scroll,
      Timer? timer,
      List<dynamic> list) {
    timer ??= Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (scroll.hasClients) {
        // 如果当前位置在列表底部
        if (scroll.offset >= scroll.position.maxScrollExtent) {
          int endIdx = list.length - 1;
          int startIdx = endIdx - 100;
          if (startIdx < 0) startIdx = 0;
          // 循环滚动
          List<dynamic> copyList = List.from(list.sublist(startIdx, endIdx + 1));
          list.insertAll(0, copyList);
          list.removeRange(endIdx + 1, list.length);
          scroll.jumpTo(0); // 滚动到顶部
        } else {
          scroll.animateTo(
            scroll.offset + 800,
            // scroll.position.maxScrollExtent,
            // duration: const Duration(milliseconds: 2000),
            duration: const Duration(seconds: 10),
            // curve: Curves.ease,
            curve: Curves.linear,
          );
        }
      }
    });
  }

  void sendMsg(
      String message,
      List<dynamic> recipents,
      BuildContext context ) async {
    if(Platform.isAndroid){
      requestPermission(message,
          recipents,context);
    }else{
      sends(message,
          recipents.cast<String>().toList(),
          context);
    }
  }

  void requestPermission(
      String message,
      List<dynamic> recipents ,
      BuildContext context) async {
    PermissionStatus status = await Permission.sms.request();
    if (status.isGranted) {
      sends(message,
          recipents.cast<String>().toList(),
          context);
    } else if (status.isDenied) {
      print("权限已拒");
    }
  }

  void sends(
      String message,
      List<String> recipents,
      BuildContext context) async{
    String result = await sendSMS(
        message: message,
        recipients: recipents,
        sendDirect: false)
        .catchError((onError) {
      CustomToast.show("$onError", context);
      print("发送失败 ${recipents[0]} $onError");
    });
    print(result);
  }

  String getShortfallAmount() {
    double amount;
    String totalPrizeStr = recordData['total_prize'] ?? "0.0";
    double totalPrize = double.parse(totalPrizeStr);
    if (totalPrize < bonus.value) {
      amount = 0;
    } else {
      amount = double.parse(recordData['total_prize'] ?? "0.0") - bonus.value;
      if (!globalController.isLogin.value) {
        amount = 100;
      }
    }return amount.toStringAsFixed(2);
  }

  String maskSensitiveData(
      String uid,
      {int count = 5}) {
    int length = uid.length;
    if (length < 7) {
      return uid;
    }return uid.substring(0, 4) + '*' * count + uid.substring(length - 3);
  }

  back() {
    var data = SPUtil().getJson(id);
    if (data != null) {
      RouteUtil.popView();
    } else {
      SPUtil().setJson(id, {});
      showCustomInviteFriendsWidget(
          context: Get.context!,
          achievedPrize: bonus.value,
          totalPrize: double.parse(recordData['total_prize'] ?? '0.0'));
    }
  }

  refreshBonus(double money) {
    bonus.value = bonus.value + money;
    String totalPrize = recordData['total_prize'];
    if (bonus.value >= double.parse(totalPrize)) {
      getRecord();
    }
  }

  void getCurrencySymbol() {
    for (int i = 0; i < globalController.currTypeInitialLists.length; i++) {
      if (recordData['currency_id'].toString() == globalController.currTypeInitialLists[i].cur) {
        symbol.value = globalController.currTypeInitialLists[i].symbol ?? "";
        break;
      }
    }
  }
  /// 获取币种信息
  Future<void> getCurrencySymbol2() async {
    print(currencyId.value);
    var symbol = await trWalletDetailsController.reqGetCoinTypeInfos(current_id: currencyId.value);/// 获取币种信息
    coinSymbol.value = symbol ?? "";
  }

  String getTitle() {
    var title = "";
    try {
      print("oooo");
      print(recordData);
      print(recordData['total_prize']);
      print("oooo");
      if(recordData?['total_prize'] != null){
        double totalPrize = double.parse(recordData['total_prize']);
        title = S.current.random_text_863 + totalPrize.toStringAsFixed(0) + S.current.random_text_864;/// 免费获得_钱币
        if (LangUtil().isViVn()) {
          title = "${S.current.random_text_863} ${totalPrize.toStringAsFixed(0)} ${S.current.random_text_864}";/// 免费获得_钱币
        } else {
          title = "${S.current.random_text_863}${totalPrize.toStringAsFixed(0)}${S.current.random_text_864}";/// 免费获得_钱币
        }
      }
    } catch (e) {
      print("wwwww");
      print(e);
    }return title;
  }

  getTime() {
    print("LLLLL");
    // 活动期限的天数（秒）  根据period计算
    int period = recordData['period'];
    if (period == 0) return;
    // int actPeriod  = period == 1?172800:recordData['period']; //后台数据配置有误  暂定2天
    int actPeriod = recordData['period'];
    int dayTotalSecond = 24 * 60 * 60; //一天的秒数
    int deadlineDays = actPeriod ~/ dayTotalSecond;
    log("neco 天数  $deadlineDays");
    int deadlineMilliseconds = deadlineDays * 24 * 60 * 60 * 1000;
    // 首次旋转时间的时间戳（秒）
    int firstConversionTimestamp = recordData['first_roll_at'];
    // 计算活动的结束时间戳
    int expirationTimestamp = firstConversionTimestamp + (deadlineMilliseconds ~/ 1000);
    // 创建一个计时器，每秒更新一次倒计时
    _ActivityTimers = Timer.periodic(const Duration(seconds: 1), (timer) {
      // 获取当前时间戳（秒）
      int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      // 计算剩余的时间差（秒数）
      int remainingSeconds = expirationTimestamp - currentTimestamp;
      // 如果剩余时间小于等于 0，停止计时器
      if (remainingSeconds < 0) {
        timer.cancel();
        refreshData();
        return;
      }
      // 将剩余的秒数转换为 Duration 对象
      Duration remainingDuration = Duration(seconds: remainingSeconds);
      // 将 Duration 对象格式化为天、小时、分钟和秒
      int days = remainingDuration.inDays;
      int hours = remainingDuration.inHours.remainder(24);
      int minutes = remainingDuration.inMinutes.remainder(60);
      int seconds = remainingDuration.inSeconds.remainder(60);
      print("112233");
      day.value = days;
      time.value =
          "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    });
  }

  refreshData() {
    homeLogic.getAllPromotions();
    homeLogic.updateActivityMenu();
    // RouteUtil.popView();
  }

  String termType(int type){
    switch(type){
      case 1:
        return  S.current.random_text_1081;/// 获得更多次数
      case 2:
        return  S.current.random_text_1082;/// 下级累计存款
      case 3:
        return  S.current.random_text_1083;/// 下级累计打码
      case 4:
        return  S.current.random_text_1084;/// 下级首存人数
      case 5:
        return  S.current.random_text_1085;/// 下级打码人数
      case 6:
        return  S.current.random_text_1086;/// 自身累计存款
      case 7:
        return  S.current.random_text_1087;/// 自身累计打码
      case 8:
        return  S.current.random_text_1088;/// 自身存款次数
      default:
        return  "";
    }
  }

  String termTypeDes(
      int type,
      int rollCondition){
    switch(type){
      case 1:
        return  "${S.current.random_text_1089}$rollCondition${S.current.random_text_1090}";/// 邀请_个好友
      case 2:
        return "${S.current.random_text_1082}$rollCondition";/// 下级累计存款_
      case 3:
        return  "${S.current.random_text_1083}$rollCondition";/// 下级累计打码_
      case 4:
        return  "${S.current.random_text_1091}$rollCondition${S.current.random_text_528}";/// 下级首存_人
      case 5:
        return  "${S.current.random_text_1092}$rollCondition${S.current.random_text_528}";/// 下级打码_人
      case 6:
        return  "${S.current.random_text_1093}$rollCondition";/// 累计存款_
      case 7:
        return  "${S.current.random_text_1094}$rollCondition";/// 累计打码_
      case 8:
        return  "${S.current.wallet_deposit}$rollCondition${S.current.random_text_120}";/// 存款_次
      default:
        return   "";
    }
  }

  String progressDes(
      int type,
      String achievedRollCondition){
    switch(type){
      case 1:
        return  "${S.current.random_text_1095}$achievedRollCondition${S.current.random_text_528}";/// 已邀请_人
      case 2:
        return "${S.current.random_text_1096}$achievedRollCondition";/// 下级已存款_
      case 3:
        return  "${S.current.random_text_1097}$achievedRollCondition";/// 下级已打码_
      case 4:
        return  "${S.current.random_text_1098}$achievedRollCondition${S.current.random_text_528}";/// 下级已首存_人
      case 5:
        return "${S.current.random_text_1099}$achievedRollCondition${S.current.random_text_528}";/// 下级已打码人_人
      case 6:
        return  "${S.current.random_text_1100}$achievedRollCondition";/// 已存款_
      case 7:
        return  "${S.current.random_text_1101}$achievedRollCondition";/// 已打码_
      case 8:
        return  "${S.current.random_text_1100}$achievedRollCondition${S.current.random_text_120}";/// 已存款_次
      default:
        return   "";
    }
  }

  String completeDes(
      int type,
      String totalAchievedRollCondition){
    switch(type){
      case 1:
        return  "${S.current.random_text_1102} $totalAchievedRollCondition ${S.current.random_text_1090}";/// 已累计邀请_个好友
      case 2:
        return "${S.current.random_text_1103} $totalAchievedRollCondition";/// 下级已累计存款_
      case 3:
        return  "${S.current.random_text_1104} $totalAchievedRollCondition";/// 下级已累计打码_
      case 4:
        return  "${S.current.random_text_1105} $totalAchievedRollCondition ${S.current.random_text_528}";/// 下级已累计首存_人
      case 5:
        return "${S.current.random_text_1104} $totalAchievedRollCondition";/// 下级已累计打码_
      case 6:
        return  "${S.current.random_text_1106} $totalAchievedRollCondition";/// 已累计存款_
      case 7:
        return  "${S.current.random_text_1107} $totalAchievedRollCondition";/// 已累计打码_
      case 8:
        return  "${S.current.random_text_1106} $totalAchievedRollCondition ${S.current.random_text_120}";/// 已累计存款_次
      default:
        return   "";
    }
  }

  String numRewards(int rollTimes){
    return "${S.current.random_text_1108}$rollTimes${S.current.random_text_1109}";/// 奖励_次抽奖次数
  }

  String  numDoneRewards(int prizeRollTimes){
    return "${S.current.random_text_1110}$prizeRollTimes${S.current.random_text_1109}";/// 已奖励_次抽奖次数
  }

  String getLink() {
    return '${AppUrlsValues.envConfig.api_url}${myLink.value}';
  }

  String getTimeOutText() {
    if(LangUtil().isViVn()) {
      return '${S.current.random_text_865} ${this.recordData['total_prize']}';/// 1小时内提取_
    }
    if(LangUtil().isTh()) {
      return '${this.recordData['total_prize']} ${S.current.random_text_865}';/// _1小时内提取
    }
    return '${S.current.random_text_865} ${this.recordData['total_prize']}';/// 1小时内提取_
  }
  /// 复制链接
  void onClickCopyLink(BuildContext context,GlobalKey globalKey) {
    Clipboard.setData(ClipboardData(text: getLink()));
    DialogUtils.onClickCopy(context,S.current.random_text_151,globalKey);
  }
  /// 跳转分享链接
  void onClickShareLaunchLink(BuildContext context, ShareTypeEnum typeEnum) {
    var shareUrl = '${typeEnum.baseShare}${getLink()}';
    UrlLaunchUtil.launchURL(shareUrl).then((message) {
      if (message.isNotEmpty) {
        print("---677");
        CustomToast.show(message, context);
      }
    });
  }
  // 启动 WhatsApp 并拨打电话
  launchWhatsAppCall(String phone) async {
    ///需要包含国家代码无+
    final url = "https://wa.me/$phone";
    UrlLaunchUtil.launchWhatsAppCall(url);
  }
  // 以下是网络请求
  /// 累计奖金
  Future<void> getPrizeList() async {
    await ApiService.instance.prizeList(
      success: (list) {
        // prizeList.value = list;
        // log("neco 我的邀请${prizeList.length}");
      },
      fail: (errorMessage) {
        if (errorMessage != null) {}
      },
      page: 1,
      pageSize: 60,
      pid: id);
  }
  /// 活动领取记录(虚假数据)
  Future<void> getFirstReportList() async {
    await ApiService.instance.firstReportList(
      success: (list) {
        print("QQQQ");
        reportList.assignAll(list);
        for (int i = 0; i < reportList.length; i++) {
          // uidList.add(maskSensitiveData(reportList[i]['uid'], count: reportList[i]['uid'].length - 7));
          usernameList.add(maskSensitiveData(reportList[i]['username'], count: reportList[i]['username'].length - 7));
        }
        log("neco 活动领取记录: ${list.length}");
      },
      fail: (errorMessage) {
        if (errorMessage != null) {}
      },
    );
  }
  /// 活动记录
  Future<void> getRecord() async {
    await ApiService.instance.getRecord(
      success: (record) {
        isLoading.value = false;
        if (!record.containsKey('data')) {
          if(record['data'] == null){
            roll_times.value = 1;/// 奖励的次数
            roll_condition.value = 1;/// 邀请多少个好友
            termTypeStr =  S.current.random_text_1081;/// 获得更多次数
            termTypeDesStr = "邀请10000个好友";//termTypeDes(rollType,recordData['roll_condition'] ??  1);
            progressDesStr = "已邀请0人";///progressDes(rollType,recordData['achieved_roll_condition']);
            completeDesStr = "已累计邀请0个好友";///completeDes(rollType,recordData['total_achieved_roll_condition']);
          }
          if (record.isNotEmpty) {
            recordData.value = record;
            roll_times.value = recordData['roll_times'] ?? 0;/// 奖励的次数
            roll_condition.value = recordData['roll_condition'] ?? 0;/// 邀请多少个好友
            bonus.value = double.parse(recordData['achieved_prize'] ?? '0.0');
            getTime();
            getCurrencySymbol();
            currencyId.value = recordData['currency_id'];
            if (bonus.value >= double.parse(recordData['total_prize'] ?? '0.0')) {
              isFull.value = true;
            }
            rollType = recordData['roll_type'] ??  1;
            // termTypeStr =  termType( rollType ); ui 已变更 暂注释
            termTypeStr =  S.current.random_text_1081;/// 获得更多次数
            termTypeDesStr = termTypeDes(rollType,recordData['roll_condition'] ??  1);
            progressDesStr = progressDes(rollType,recordData['achieved_roll_condition']);
            completeDesStr = completeDes(rollType,recordData['total_achieved_roll_condition']);
          }
        } else {
          // refreshData();
        }
      },
      fail: (errorMessage) {
        isError.value = true;
        if (errorMessage != null) {}
      },
      pid: id);
  }
  /// 获取抽奖次数
  Future<void> getConfig() async {
    await ApiService.instance.getConfig(
      success: (config) {
        if(config != null){
          model.value = ConfigModel.fromJson(config);
          detail.value = config['detail'].replaceAll(r"$$currency$$", '').replaceAll(r"$$freetimes$$", (recordData['left_roll'] ?? HomeLogic.of().state.rollTimes).toString()).replaceAll('\n', '\n •');
        }
      },
      fail: (errorMessage) {
        if (errorMessage != null) {}
      },
      pid: id,
      cur: globalController.currTypeSelected.value.cur??'701',
    );
  }
  /// 领奖
  Future<void> apply() async {
    await ApiService.instance.apply(
        success: (str) {
          if (recordData['withdraw_type'] != 2) {
            recordData['state'] = 4;
            _ActivityTimers?.cancel();
            RouteUtil.popView();
          }
        },
        fail: (errorMessage) {
          if (errorMessage != null) {}
        },
        pid: id, cur: exChangeCurrencyBean.value.cur ?? "706");
  }
  /// 我的推广
  Future<void> getShareLink() async {
    await ApiService.instance.getMyPromotion(
      success: (model) {
        myLink.value = model.linkUrl ?? "";
        // user.refresh();
      },
      fail: (isConnect, message, candy) {},
    );
  }
  /// 获取手机号
  Future<void> getPhoneList() async {
    await ApiService.instance.phoneList(
      success: (list) {
        phoneList.assignAll(list);
      },
      fail: (errorMessage) {
        if (errorMessage != null) {}
      }, pid: id,
    );
  }
}
