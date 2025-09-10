import 'dart:ui';

import 'package:get/get.dart';

import '../../../generated/l10n.dart';

///活动模块 公共 参数 model
class ActivityCommonParams {
  static const String apiMessageRefresh = "refresh";

  static bool needRefresh(String? message) {
    return message == apiMessageRefresh;
  }
}

/// 促销活动 item  活动类型枚举, 对应不同的页面
/// ty 1-轮盘抽奖 2-推广 3-抢红包活动 4-负盈利 5-自定义
enum ActivityTypeEnum {
  //id 属于自定义， 跟后端ty 接口类型匹配
  lottery(type: 2222, localIcon: ""), //抽奖活动
  race(type: 3333, localIcon: ""), //竞赛活动
  airdrop(type: 4444, localIcon: ""), //空投活动
  //自定义
  custom(type: 5, localIcon: "assets/images/activity/menu/ic_activity_menu_custom.webp"),
  //负盈利
  negativeProfit(
      type: 4, localIcon: "assets/images/activity/menu/ic_activity_menu_negativeProfit.webp"),
  //红包活动
  redPacket(type: 3, localIcon: "assets/images/activity/menu/ic_activity_menu_redPacket.webp"),
  //推广活动
  promotion(type: 2, localIcon: "assets/images/activity/menu/ic_activity_menu_promotion.webp"),
  //转盘活动
  turntable(type: 1, localIcon: "assets/images/activity/menu/ic_activity_menu_turntable.webp"),
  all(type: 0, localIcon: "assets/images/activity/menu/ic_activity_menu.webp"), //查看全部
  nothing(type: -1, localIcon: "assets/images/activity/menu/ic_activity_menu.webp"); //什么都没有

  final int type;
  final String localIcon; //菜单侧边栏 本地icon

  const ActivityTypeEnum({required this.type, required this.localIcon});

  ///int 匹配状态, 没有的话。给全部all
  static ActivityTypeEnum? adaptor(int? value) {
    return ActivityTypeEnum.values.firstWhereOrNull((element) => element.type == value);
  }
}

/// display_type 展示方式 1:内置页面 2:跳转外部链接
/// button_type 跳转类型 1自定义 2娱乐城 3体育 4保险库 5VIP 6联盟计划 7优惠活动 8在线客服
enum ActivityCustomJumpEnum {
  custom(type: 1, label: ""), //"1自定义"),
  casino(type: 2, label: ""), //"2娱乐城"),
  sport(type: 3, label: ""), //"3体育"),
  vault(type: 4, label: ""), //4保险库
  vip(type: 5, label: ""),
  alliance(type: 6, label: ""), //6联盟计画
  activity(type: 7, label: ""), //7优惠活动
  onlineService(type: 8, label: ""); //"8在线客服");

  final int type;
  final String label;

  const ActivityCustomJumpEnum({required this.type, required this.label});

  ///int 匹配状态, 没有的话。给全部all
  static ActivityCustomJumpEnum? adaptor(int? value) {
    return ActivityCustomJumpEnum.values.firstWhereOrNull((element) => element.type == value);
  }
}

///活动二级列表 类型,有可能涉及到 网络请求的 参数配置
enum ActivityListTypeEnum {
  all(category: ""),
  casino(category: "1"),
  sport(category: "2");

  final String category; // w网络请求用到分类 1娱乐城 2体育
  const ActivityListTypeEnum({required this.category});

  static ActivityListTypeEnum? adaptor(String index) {
    return ActivityListTypeEnum.values.firstWhereOrNull((element) => element.category == index);
  }
}

///活动转盘
enum LuckyRecordState {
  noData,
  first,
  records,
}

/// 邀请状态
/// "state": 1, //该子会员是否为有效推广，1：有效、2：无效
/// 0：全部、1：有效、2：无效
enum ActivityInviteState {
  all(type: 0), //全部
  efficient(type: 1), //有效
  invalid(type: 2); //无效

  final int type;

  const ActivityInviteState({required this.type});

  ///是否有效
  static bool isEfficient(int? state) {
    return efficient.type == state;
  }

  String getLabel() {
    if (this == all) {
      return S.current.sport_all;
    } else if (this == efficient) {
      return S.current.random_text_918;
    } else if (this == invalid) {
      return S.current.random_text_919;
    } else {
      return "";
    }
  }

  ///String 匹配 状态
  static ActivityInviteState? adaptor(int? value) {
    return ActivityInviteState.values.firstWhereOrNull((element) => element.type == value);
  }
}

///活动列表 状态
enum ActivityTimeState {
  doing(type: 1, fontColor: Color(0xFF000000), bgColor: Color(0xFF47E444)), //进行中
  finished(type: 2, fontColor: Color(0xFFB1BAD3)), //已结束
  unstarted(type: 3, fontColor: Color(0xFFB1BAD3)), //未开启
  nothing(type: -100, fontColor: Color(0xFFB1BAD3)); //都不是

  final int type;
  final Color fontColor; //字体颜色
  final Color? bgColor; //背景颜色

  const ActivityTimeState({required this.type, required this.fontColor, this.bgColor});

  ///String 匹配 状态
  static ActivityTimeState adaptor(int? value) {
    var state = ActivityTimeState.values.firstWhereOrNull((element) => element.type == value);
    return state ?? nothing;
  }

  ///是否已结束
  bool isFinished() {
    return this == finished;
  }

  ///未开始
  bool isUnStarted() {
    return this == unstarted;
  }

  String getLabel() {
    if (this == doing) {
      return S.current.random_text_963;
    } else if (this == unstarted) {
      return S.current.random_text_964;
    } else if (this == finished) {
      return S.current.sport_event_list_over;
    } else {
      return "";
    }
  }
}

///推广活动领取 api model
///{{url}}/member/agency/bonus/apply?pid=911065750483031&currency_id=701

///这是一键领取接口放回的。 "state": 1, //状态 1:待审核 2:已审核 3:已发放(领取) 4:待领取 5:拒绝
///todo:[0601]注意状态api接口 和 通知不一样：
///这是推送通知的payload中" type":"1"。//状态 0:审核通过 1:审核拒绝 2:领取成功 3:领取失败 4:派发成功(自动) 5:审核中
enum ActivityReceiveState {
  awaitCheck(
      type: 1,
      msgTitle: "", //待审核
      msgIcon: "assets/images/snack_bar/ic_snack_bar_activity_success_submit.webp"),
  alreadyCheck(
      type: 2,
      msgTitle: "", //已审核,
      msgIcon: "assets/images/snack_bar/ic_snack_bar_activity_success.webp"),
  alreadyReceive(
      type: 3,
      msgTitle: "", //已发放,
      msgIcon: "assets/images/snack_bar/ic_snack_bar_activity_success.webp"),
  awaitReceive(
      type: 4,
      msgTitle: "", //待领取,
      msgIcon: "assets/images/snack_bar/ic_snack_bar_activity_success.webp"),
  denial(
      type: 5,
      msgTitle: "", //拒绝,
      msgIcon: "assets/images/snack_bar/ic_snack_bar_activity_deny.webp"),
  nothing(
      type: -100,
      msgTitle: "",
      msgIcon: "assets/images/snack_bar/ic_snack_bar_activity_success.webp"), //自定义
  failReceive(
      type: -200,
      msgTitle: "",
      msgIcon: "assets/images/snack_bar/ic_snack_bar_activity_warn.webp"), //自定义 领取失败
  finishActivity(
      type: -300,
      msgTitle: "",
      msgIcon: "assets/images/snack_bar/ic_snack_bar_error.png"), //自定义 活动已结束
  alert(
      type: -1,
      msgTitle: "", //活动未开始,请稍后再试...
      msgIcon: "assets/images/snack_bar/ic_snack_bar_activity_alert.webp"), //自定义
  warn(
      type: 0,
      msgTitle: "", //您当前未满足领取条件
      msgIcon: "assets/images/snack_bar/ic_snack_bar_activity_warn.webp"); //自定义

  ///自定义

  final int type;
  final String msgTitle;
  final String msgIcon;

  const ActivityReceiveState({required this.type, required this.msgTitle, required this.msgIcon});

  ///String 匹配 状态
  static ActivityReceiveState adaptor(int? value) {
    var state = ActivityReceiveState.values.firstWhereOrNull((element) => element.type == value);
    return state ?? nothing;
  }

  ///String 匹配 mqtt 通知的状态，注意不一样
  ///todo: 只能给mqtt 通知 数据 使用
  static ActivityReceiveState adaptorMqtt(int? value) {
    ///这是推送通知//状态 0:审核通过 1:审核拒绝 2:领取成功 3:领取失败 4:派发成功(自动) 5:审核中
    switch (value) {
      case 0:
        return alreadyCheck;
      case 1:
        return denial;
      case 2:
        return alreadyReceive;
      case 3:
        return failReceive;
      case 4:
        return alreadyReceive;
      case 5:
        return awaitCheck;
      default:
        return nothing;
    }
  }

  ///判断是否点击领取
  bool isCanReceive() {
    //状态 1:待审核 2:已审核 3:已发放(领取) 4:待领取 5:拒绝
    return this == awaitReceive;
  }

  ///提示是否显示 领取 "金额 2.00"
  bool isShowReceiveMoney() {
    return this == alreadyCheck || this == alreadyReceive || this == awaitReceive || this == denial;
  }

  ///获取提示 标题， 为了适配多语言
  String getTipTitle() {
    switch (this) {
      case awaitCheck:
        return S.current.random_text_1053;
      case alreadyCheck:
        return S.current.random_text_1054;
      case alreadyReceive:
        return S.current.random_text_96;
      case awaitReceive:
        return S.current.feedback_transfer_await;
      case denial:
        return S.current.random_text_1055;
      case nothing:
        return "";
      case failReceive:
        return S.current.random_text_695;
      case finishActivity:
        return S.current.error_title_text;
      case alert:
        return S.current.random_text_1005;
      case warn:
        return S.current.snack_bar_normal_tips;
      default:
        return "";
    }
  }

  ///获取提示 标题， 为了适配多语言
  ///状态 1:待审核 2:已审核 3:已发放(领取) 4:待领取 5:拒绝
  String getTipContent() {
    switch (this) {
      case awaitCheck:
        return S.current.random_text_1216;
      case alreadyCheck:
        //金额 2.00
        return S.current.vault_amount;
      case alreadyReceive:
        //金额 2.00
        return S.current.vault_amount;
      case awaitReceive:
        //金额 2.00
        return S.current.vault_amount;
      case denial:
        //金额 2.00
        return S.current.vault_amount;
      case nothing:
        return "";
      case failReceive:
        //金额 2.00
        return S.current.vault_amount;
      case finishActivity:
        return S.current.random_text_1217;
      case alert:
        //活动未开始,请稍后再试...
        return S.current.random_text_1056;
      case warn:
        //您当前未满足领取条件
        return S.current.random_text_1057;
      default:
        return "";
    }
  }

  ///是否领取流程正常
  bool isSubmitSuccess() {
    return this == alreadyReceive;
  }

  ///领取成功
  bool isReceiveSuccess() {
    return this == awaitCheck || this == alreadyCheck || this == alreadyReceive;
  }

  //是否在审核中
  bool isChecking() {
    return this == awaitCheck;
  }
}

///活动推广 奖励
enum ActivityAwardState {
  //宝箱
  box_unopen(
      type: 1,
      nextState: box_opened,
      nextStateInside: box_opened_inside,
      asset: "assets/images/activity/gift/ic_activity_box_unopen.webp"),
  box_opened(type: 2, asset: "assets/images/activity/gift/ic_activity_box_opened.webp"),
  box_opened_inside(
      type: 3, asset: "assets/images/activity/gift/ic_activity_box_opened_inside.webp"),
  box_close(type: 4, asset: "assets/images/activity/gift/ic_activity_box_close.webp"),

  //红包
  packet_unopen(
      type: 11,
      nextState: packet_opened,
      nextStateInside: packet_opened_inside,
      asset: "assets/images/activity/gift/ic_activity_packet_unopen.webp"),
  packet_opened(type: 12, asset: "assets/images/activity/gift/ic_activity_packet_opened.webp"),
  packet_opened_inside(
      type: 13, asset: "assets/images/activity/gift/ic_activity_packet_opened_inside.webp"),
  packet_close(type: 14, asset: "assets/images/activity/gift/ic_activity_packet_close.webp");

  final int type;
  final String asset;
  final ActivityAwardState? nextState;
  final ActivityAwardState? nextStateInside;

  const ActivityAwardState(
      {required this.type, required this.asset, this.nextState, this.nextStateInside});

  ///是否 内部显示金额
  bool isOpenInside() {
    return this == box_opened_inside || this == packet_opened_inside;
  }

  //是否可以 领取奖励
  bool isCanReceiveAward() {
    return this == packet_unopen || this == box_unopen;
  }

  //是否可以点击, 包括关闭状态 也可以 点击 提示
  bool isCanClickAward() {
    return this == packet_unopen || this == box_unopen;
  }

  ///是否是关闭状态
  bool isCloseAward() {
    return this == box_close || this == packet_close;
  }

  ///是否是红包
  bool isRedPacket() {
    return this == packet_unopen ||
        this == packet_opened ||
        this == packet_opened_inside ||
        this == packet_close;
  }
}
