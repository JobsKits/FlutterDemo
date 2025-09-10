import 'package:json_annotation/json_annotation.dart';

part 'activity_redbag_detail_model.g.dart';

@JsonSerializable()
class ActivityRedbagDetailModel {
  @JsonKey(name: 'tasks_id')
  int? tasksId;
  @JsonKey(name: 'tasks_name')
  String? tasksName;
  String? terminal;
  int? coding;
  @JsonKey(name: 'account_money')
  int? accountMoney;
  @JsonKey(name: 'name_money')
  int? nameMoney;
  @JsonKey(name: 'phone_money')
  int? phoneMoney;
  @JsonKey(name: 'card_money')
  int? cardMoney;
  @JsonKey(name: 'secondary_money')
  int? secondaryMoney;
  @JsonKey(name: 'three_money')
  int? threeMoney;
  @JsonKey(name: 'account_integral')
  int? accountIntegral;
  @JsonKey(name: 'name_integral')
  int? nameIntegral;
  @JsonKey(name: 'phone_integral')
  int? phoneIntegral;
  @JsonKey(name: 'card_integral')
  int? cardIntegral;
  @JsonKey(name: 'secondary_integral')
  int? secondaryIntegral;
  @JsonKey(name: 'three_integral')
  int? threeIntegral;
  @JsonKey(name: 'three_times')
  int? threeTimes;
  @JsonKey(name: 'secondary_times')
  int? secondaryTimes;
  @JsonKey(name: 'mail_title')
  String? mailTitle;
  @JsonKey(name: 'mail_content')
  String? mailContent;
  @JsonKey(name: 'mail_content1')
  String? mailContent1;
  @JsonKey(name: 'mail_content2')
  String? mailContent2;
  @JsonKey(name: 'mail_content3')
  String? mailContent3;
  @JsonKey(name: 'mail_content4')
  String? mailContent4;
  @JsonKey(name: 'mail_content5')
  String? mailContent5;
  int? state;
  int? tid;
  @JsonKey(name: 'ip_count')
  int? ipCount;
  @JsonKey(name: 'phone_count')
  int? phoneCount;
  @JsonKey(name: 'card_count')
  int? cardCount;
  @JsonKey(name: 'name_count')
  int? nameCount;
  @JsonKey(name: 'balance_type_id')
  int? balanceTypeId;
  @JsonKey(name: 'android_amount')
  int? androidAmount;
  @JsonKey(name: 'h5_android_amount')
  int? h5AndroidAmount;
  @JsonKey(name: 'ios_amount')
  int? iosAmount;
  @JsonKey(name: 'h5_ios_amount')
  int? h5IosAmount;
  @JsonKey(name: 'web_amount')
  int? webAmount;
  @JsonKey(name: 'homescreen_android_amount')
  int? homescreenAndroidAmount;
  @JsonKey(name: 'homescreen_ios_amount')
  int? homescreenIosAmount;
  @JsonKey(name: 'android_integral')
  int? androidIntegral;
  @JsonKey(name: 'h5_android_integral')
  int? h5AndroidIntegral;
  @JsonKey(name: 'ios_integral')
  int? iosIntegral;
  @JsonKey(name: 'h5_ios_integral')
  int? h5IosIntegral;
  @JsonKey(name: 'web_integral')
  int? webIntegral;
  @JsonKey(name: 'homescreen_android_integral')
  int? homescreenAndroidIntegral;
  @JsonKey(name: 'homescreen_ios_integral')
  int? homescreenIosIntegral;
  @JsonKey(name: 'mail_content6')
  String? mailContent6;
  @JsonKey(name: 'mail_content7')
  String? mailContent7;
  @JsonKey(name: 'mail_content8')
  String? mailContent8;
  @JsonKey(name: 'mail_content9')
  String? mailContent9;
  @JsonKey(name: 'mail_content10')
  String? mailContent10;
  @JsonKey(name: 'mail_content11')
  String? mailContent11;
  @JsonKey(name: 'mail_content12')
  String? mailContent12;
  @JsonKey(name: 'send_type')
  String? sendType;
  @JsonKey(name: 'need_mobile_valid')
  String? needMobileValid;
  @JsonKey(name: 'login_android_amount')
  int? loginAndroidAmount;
  @JsonKey(name: 'login_h5_android_amount')
  int? loginH5AndroidAmount;
  @JsonKey(name: 'login_ios_amount')
  int? loginIosAmount;
  @JsonKey(name: 'login_h5_ios_amount')
  int? loginH5IosAmount;
  @JsonKey(name: 'login_web_amount')
  int? loginWebAmount;
  @JsonKey(name: 'login_homescreen_android_amount')
  int? loginHomescreenAndroidAmount;
  @JsonKey(name: 'login_homescreen_ios_amount')
  int? loginHomescreenIosAmount;
  @JsonKey(name: 'login_h5_amount')
  int? loginH5Amount;
  @JsonKey(name: 'login_app_amount')
  int? loginAppAmount;
  @JsonKey(name: 'bind_domain')
  String? bindDomain;
  @JsonKey(name: 'block_invite_codes')
  String? blockInviteCodes;
  @JsonKey(name: 'valid_day')
  int? validDay;
  @JsonKey(name: 'device_count')
  int? deviceCount;
  @JsonKey(name: 'login_before_pop')
  int? loginBeforePop;
  @JsonKey(name: 'login_after_pop')
  int? loginAfterPop;
  @JsonKey(name: 'vest_package_amount')
  int? vestPackageAmount;
  @JsonKey(name: 'vest_package_integral')
  int? vestPackageIntegral;
  @JsonKey(name: 'users_all')
  int? usersAll;
  @JsonKey(name: 'recharge_amount')
  int? rechargeAmount;
  @JsonKey(name: 'play_amount')
  int? playAmount;
  @JsonKey(name: 'activity_rules')
  String? activityRules;
  @JsonKey(name: 'activity_cycle')
  int? activityCycle;
  @JsonKey(name: 'first_recharge_amount')
  int? firstRechargeAmount;
  int? receipt;
  @JsonKey(name: 'weekly_giveaway')
  int? weeklyGiveaway;
  @JsonKey(name: 'lasts_weeks')
  int? lastsWeeks;
  @JsonKey(name: 'week_recharge_times')
  int? weekRechargeTimes;
  @JsonKey(name: 'week_recharge_amount')
  int? weekRechargeAmount;
  @JsonKey(name: 'recharge_type')
  String? rechargeType;
  @JsonKey(name: 'start_date')
  int? startDate;
  @JsonKey(name: 'end_date')
  int? endDate;
  @JsonKey(name: 'activity_remark')
  String? activityRemark;
  @JsonKey(name: 'receive_log_id')
  int? receiveLogId;

  ActivityRedbagDetailModel({
    this.tasksId,
    this.tasksName,
    this.terminal,
    this.coding,
    this.accountMoney,
    this.nameMoney,
    this.phoneMoney,
    this.cardMoney,
    this.secondaryMoney,
    this.threeMoney,
    this.accountIntegral,
    this.nameIntegral,
    this.phoneIntegral,
    this.cardIntegral,
    this.secondaryIntegral,
    this.threeIntegral,
    this.threeTimes,
    this.secondaryTimes,
    this.mailTitle,
    this.mailContent,
    this.mailContent1,
    this.mailContent2,
    this.mailContent3,
    this.mailContent4,
    this.mailContent5,
    this.state,
    this.tid,
    this.ipCount,
    this.phoneCount,
    this.cardCount,
    this.nameCount,
    this.balanceTypeId,
    this.androidAmount,
    this.h5AndroidAmount,
    this.iosAmount,
    this.h5IosAmount,
    this.webAmount,
    this.homescreenAndroidAmount,
    this.homescreenIosAmount,
    this.androidIntegral,
    this.h5AndroidIntegral,
    this.iosIntegral,
    this.h5IosIntegral,
    this.webIntegral,
    this.homescreenAndroidIntegral,
    this.homescreenIosIntegral,
    this.mailContent6,
    this.mailContent7,
    this.mailContent8,
    this.mailContent9,
    this.mailContent10,
    this.mailContent11,
    this.mailContent12,
    this.sendType,
    this.needMobileValid,
    this.loginAndroidAmount,
    this.loginH5AndroidAmount,
    this.loginIosAmount,
    this.loginH5IosAmount,
    this.loginWebAmount,
    this.loginHomescreenAndroidAmount,
    this.loginHomescreenIosAmount,
    this.loginH5Amount,
    this.loginAppAmount,
    this.bindDomain,
    this.blockInviteCodes,
    this.validDay,
    this.deviceCount,
    this.loginBeforePop,
    this.loginAfterPop,
    this.vestPackageAmount,
    this.vestPackageIntegral,
    this.usersAll,
    this.rechargeAmount,
    this.playAmount,
    this.activityRules,
    this.activityCycle,
    this.firstRechargeAmount,
    this.receipt,
    this.weeklyGiveaway,
    this.lastsWeeks,
    this.weekRechargeTimes,
    this.weekRechargeAmount,
    this.rechargeType,
    this.startDate,
    this.endDate,
    this.activityRemark,
    this.receiveLogId,
  });

  @override
  String toString() {
    return 'ActivityRedbagDetailModel(tasksId: $tasksId, tasksName: $tasksName, terminal: $terminal, coding: $coding, accountMoney: $accountMoney, nameMoney: $nameMoney, phoneMoney: $phoneMoney, cardMoney: $cardMoney, secondaryMoney: $secondaryMoney, threeMoney: $threeMoney, accountIntegral: $accountIntegral, nameIntegral: $nameIntegral, phoneIntegral: $phoneIntegral, cardIntegral: $cardIntegral, secondaryIntegral: $secondaryIntegral, threeIntegral: $threeIntegral, threeTimes: $threeTimes, secondaryTimes: $secondaryTimes, mailTitle: $mailTitle, mailContent: $mailContent, mailContent1: $mailContent1, mailContent2: $mailContent2, mailContent3: $mailContent3, mailContent4: $mailContent4, mailContent5: $mailContent5, state: $state, tid: $tid, ipCount: $ipCount, phoneCount: $phoneCount, cardCount: $cardCount, nameCount: $nameCount, balanceTypeId: $balanceTypeId, androidAmount: $androidAmount, h5AndroidAmount: $h5AndroidAmount, iosAmount: $iosAmount, h5IosAmount: $h5IosAmount, webAmount: $webAmount, homescreenAndroidAmount: $homescreenAndroidAmount, homescreenIosAmount: $homescreenIosAmount, androidIntegral: $androidIntegral, h5AndroidIntegral: $h5AndroidIntegral, iosIntegral: $iosIntegral, h5IosIntegral: $h5IosIntegral, webIntegral: $webIntegral, homescreenAndroidIntegral: $homescreenAndroidIntegral, homescreenIosIntegral: $homescreenIosIntegral, mailContent6: $mailContent6, mailContent7: $mailContent7, mailContent8: $mailContent8, mailContent9: $mailContent9, mailContent10: $mailContent10, mailContent11: $mailContent11, mailContent12: $mailContent12, sendType: $sendType, needMobileValid: $needMobileValid, loginAndroidAmount: $loginAndroidAmount, loginH5AndroidAmount: $loginH5AndroidAmount, loginIosAmount: $loginIosAmount, loginH5IosAmount: $loginH5IosAmount, loginWebAmount: $loginWebAmount, loginHomescreenAndroidAmount: $loginHomescreenAndroidAmount, loginHomescreenIosAmount: $loginHomescreenIosAmount, loginH5Amount: $loginH5Amount, loginAppAmount: $loginAppAmount, bindDomain: $bindDomain, blockInviteCodes: $blockInviteCodes, validDay: $validDay, deviceCount: $deviceCount, loginBeforePop: $loginBeforePop, loginAfterPop: $loginAfterPop, vestPackageAmount: $vestPackageAmount, vestPackageIntegral: $vestPackageIntegral, usersAll: $usersAll, rechargeAmount: $rechargeAmount, playAmount: $playAmount, activityRules: $activityRules, activityCycle: $activityCycle, firstRechargeAmount: $firstRechargeAmount, receipt: $receipt, weeklyGiveaway: $weeklyGiveaway, lastsWeeks: $lastsWeeks, weekRechargeTimes: $weekRechargeTimes, weekRechargeAmount: $weekRechargeAmount, rechargeType: $rechargeType, startDate: $startDate, endDate: $endDate, activityRemark: $activityRemark, receiveLogId: $receiveLogId)';
  }

  factory ActivityRedbagDetailModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityRedbagDetailModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityRedbagDetailModelToJson(this);

  ActivityRedbagDetailModel copyWith({
    int? tasksId,
    String? tasksName,
    String? terminal,
    int? coding,
    int? accountMoney,
    int? nameMoney,
    int? phoneMoney,
    int? cardMoney,
    int? secondaryMoney,
    int? threeMoney,
    int? accountIntegral,
    int? nameIntegral,
    int? phoneIntegral,
    int? cardIntegral,
    int? secondaryIntegral,
    int? threeIntegral,
    int? threeTimes,
    int? secondaryTimes,
    String? mailTitle,
    String? mailContent,
    String? mailContent1,
    String? mailContent2,
    String? mailContent3,
    String? mailContent4,
    String? mailContent5,
    int? state,
    int? tid,
    int? ipCount,
    int? phoneCount,
    int? cardCount,
    int? nameCount,
    int? balanceTypeId,
    int? androidAmount,
    int? h5AndroidAmount,
    int? iosAmount,
    int? h5IosAmount,
    int? webAmount,
    int? homescreenAndroidAmount,
    int? homescreenIosAmount,
    int? androidIntegral,
    int? h5AndroidIntegral,
    int? iosIntegral,
    int? h5IosIntegral,
    int? webIntegral,
    int? homescreenAndroidIntegral,
    int? homescreenIosIntegral,
    String? mailContent6,
    String? mailContent7,
    String? mailContent8,
    String? mailContent9,
    String? mailContent10,
    String? mailContent11,
    String? mailContent12,
    String? sendType,
    String? needMobileValid,
    int? loginAndroidAmount,
    int? loginH5AndroidAmount,
    int? loginIosAmount,
    int? loginH5IosAmount,
    int? loginWebAmount,
    int? loginHomescreenAndroidAmount,
    int? loginHomescreenIosAmount,
    int? loginH5Amount,
    int? loginAppAmount,
    String? bindDomain,
    String? blockInviteCodes,
    int? validDay,
    int? deviceCount,
    int? loginBeforePop,
    int? loginAfterPop,
    int? vestPackageAmount,
    int? vestPackageIntegral,
    int? usersAll,
    int? rechargeAmount,
    int? playAmount,
    String? activityRules,
    int? activityCycle,
    int? firstRechargeAmount,
    int? receipt,
    int? weeklyGiveaway,
    int? lastsWeeks,
    int? weekRechargeTimes,
    int? weekRechargeAmount,
    String? rechargeType,
    int? startDate,
    int? endDate,
    String? activityRemark,
    int? receiveLogId,
  }) {
    return ActivityRedbagDetailModel(
      tasksId: tasksId ?? this.tasksId,
      tasksName: tasksName ?? this.tasksName,
      terminal: terminal ?? this.terminal,
      coding: coding ?? this.coding,
      accountMoney: accountMoney ?? this.accountMoney,
      nameMoney: nameMoney ?? this.nameMoney,
      phoneMoney: phoneMoney ?? this.phoneMoney,
      cardMoney: cardMoney ?? this.cardMoney,
      secondaryMoney: secondaryMoney ?? this.secondaryMoney,
      threeMoney: threeMoney ?? this.threeMoney,
      accountIntegral: accountIntegral ?? this.accountIntegral,
      nameIntegral: nameIntegral ?? this.nameIntegral,
      phoneIntegral: phoneIntegral ?? this.phoneIntegral,
      cardIntegral: cardIntegral ?? this.cardIntegral,
      secondaryIntegral: secondaryIntegral ?? this.secondaryIntegral,
      threeIntegral: threeIntegral ?? this.threeIntegral,
      threeTimes: threeTimes ?? this.threeTimes,
      secondaryTimes: secondaryTimes ?? this.secondaryTimes,
      mailTitle: mailTitle ?? this.mailTitle,
      mailContent: mailContent ?? this.mailContent,
      mailContent1: mailContent1 ?? this.mailContent1,
      mailContent2: mailContent2 ?? this.mailContent2,
      mailContent3: mailContent3 ?? this.mailContent3,
      mailContent4: mailContent4 ?? this.mailContent4,
      mailContent5: mailContent5 ?? this.mailContent5,
      state: state ?? this.state,
      tid: tid ?? this.tid,
      ipCount: ipCount ?? this.ipCount,
      phoneCount: phoneCount ?? this.phoneCount,
      cardCount: cardCount ?? this.cardCount,
      nameCount: nameCount ?? this.nameCount,
      balanceTypeId: balanceTypeId ?? this.balanceTypeId,
      androidAmount: androidAmount ?? this.androidAmount,
      h5AndroidAmount: h5AndroidAmount ?? this.h5AndroidAmount,
      iosAmount: iosAmount ?? this.iosAmount,
      h5IosAmount: h5IosAmount ?? this.h5IosAmount,
      webAmount: webAmount ?? this.webAmount,
      homescreenAndroidAmount:
          homescreenAndroidAmount ?? this.homescreenAndroidAmount,
      homescreenIosAmount: homescreenIosAmount ?? this.homescreenIosAmount,
      androidIntegral: androidIntegral ?? this.androidIntegral,
      h5AndroidIntegral: h5AndroidIntegral ?? this.h5AndroidIntegral,
      iosIntegral: iosIntegral ?? this.iosIntegral,
      h5IosIntegral: h5IosIntegral ?? this.h5IosIntegral,
      webIntegral: webIntegral ?? this.webIntegral,
      homescreenAndroidIntegral:
          homescreenAndroidIntegral ?? this.homescreenAndroidIntegral,
      homescreenIosIntegral:
          homescreenIosIntegral ?? this.homescreenIosIntegral,
      mailContent6: mailContent6 ?? this.mailContent6,
      mailContent7: mailContent7 ?? this.mailContent7,
      mailContent8: mailContent8 ?? this.mailContent8,
      mailContent9: mailContent9 ?? this.mailContent9,
      mailContent10: mailContent10 ?? this.mailContent10,
      mailContent11: mailContent11 ?? this.mailContent11,
      mailContent12: mailContent12 ?? this.mailContent12,
      sendType: sendType ?? this.sendType,
      needMobileValid: needMobileValid ?? this.needMobileValid,
      loginAndroidAmount: loginAndroidAmount ?? this.loginAndroidAmount,
      loginH5AndroidAmount: loginH5AndroidAmount ?? this.loginH5AndroidAmount,
      loginIosAmount: loginIosAmount ?? this.loginIosAmount,
      loginH5IosAmount: loginH5IosAmount ?? this.loginH5IosAmount,
      loginWebAmount: loginWebAmount ?? this.loginWebAmount,
      loginHomescreenAndroidAmount:
          loginHomescreenAndroidAmount ?? this.loginHomescreenAndroidAmount,
      loginHomescreenIosAmount:
          loginHomescreenIosAmount ?? this.loginHomescreenIosAmount,
      loginH5Amount: loginH5Amount ?? this.loginH5Amount,
      loginAppAmount: loginAppAmount ?? this.loginAppAmount,
      bindDomain: bindDomain ?? this.bindDomain,
      blockInviteCodes: blockInviteCodes ?? this.blockInviteCodes,
      validDay: validDay ?? this.validDay,
      deviceCount: deviceCount ?? this.deviceCount,
      loginBeforePop: loginBeforePop ?? this.loginBeforePop,
      loginAfterPop: loginAfterPop ?? this.loginAfterPop,
      vestPackageAmount: vestPackageAmount ?? this.vestPackageAmount,
      vestPackageIntegral: vestPackageIntegral ?? this.vestPackageIntegral,
      usersAll: usersAll ?? this.usersAll,
      rechargeAmount: rechargeAmount ?? this.rechargeAmount,
      playAmount: playAmount ?? this.playAmount,
      activityRules: activityRules ?? this.activityRules,
      activityCycle: activityCycle ?? this.activityCycle,
      firstRechargeAmount: firstRechargeAmount ?? this.firstRechargeAmount,
      receipt: receipt ?? this.receipt,
      weeklyGiveaway: weeklyGiveaway ?? this.weeklyGiveaway,
      lastsWeeks: lastsWeeks ?? this.lastsWeeks,
      weekRechargeTimes: weekRechargeTimes ?? this.weekRechargeTimes,
      weekRechargeAmount: weekRechargeAmount ?? this.weekRechargeAmount,
      rechargeType: rechargeType ?? this.rechargeType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      activityRemark: activityRemark ?? this.activityRemark,
      receiveLogId: receiveLogId ?? this.receiveLogId,
    );
  }
}
