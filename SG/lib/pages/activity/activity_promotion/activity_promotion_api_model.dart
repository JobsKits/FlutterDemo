import 'package:flutter_bet/generated/l10n.dart';

///推广活动页面 api model  {{url}}/member/agency/config?pid=40039904499718196
class ActivityPromotionApiModel {
  // "detail": "一、活动要求：\n存款+投注（连续7天后重置）\n\n二、活动内容：\n1.每日存款及下注需满足活动条件，成功签到即可领取相应的固定奖金或神秘奖金，最高可达55。 \n2.本次活动为连续签到活动（如遇以下情况，则从第一天开始恢复）中断）；\n3.奖励只能在iOS、Android、H5、PC上手动领取。 \n4.本次活动所发放的奖金（不含本金）需要1倍流水（即验证、下注或有效投注）才能提现，下注不支持仅限于游戏平台；\n5.本活动仅限账户所有者正常手动操作，禁止出租、使用作弊软件、机器人、不同账户之间赌博、相互操纵、套利、API、协议、利用漏洞、群控或其他技术手段，否则奖励可能被取消、扣除，账户可能被冻结甚至列入黑名单；\n6.为了避免文字理解上的差异，平台保留对本次活动的最终解释权。", //规则说明
  // "button": 2, //按钮状态 1显示 2不显示
  // "button_text": "{}", //按钮文字(多种语言) //{"zh_CN": "0", "original": "0"}
  // "button_redirect": "", //按钮跳转地址
  // "settings": null, //有效推广人数的级距设定, ppl: 人数, bonus: 奖励金额(U)
  // "first_deposit_amount": "", //有效会员标准 - 账号首充金额
  // "total_deposit_amount": "", //有效会员标准 - 累计充值
  // "total_bet_amount": "", //有效会员标准 - 累计打码
  // "total_deposit_days": "", //有效会员标准 - 累计充值天数
  // "total_deposit_times": "", //有效会员标准 - 累计充值次数
  // "condition_type": "", //有效会员标准 - 满足条件
  // "bonus_tpl": "", //奖励样式 1:开红包 2:开宝箱
  // "show_amount": "", //显示金额 1:显示 2:不显示
  // "start_at": 1693567400, //活动开始时间
  // "end_at": 1712489021, //活动结束时间
  // "display_start_at": 1693567418, //展示开始时间
  // "display_end_at": 1712489030, //展示结束时间
  // "link_url": "/?u=100007" //推广链接地址
  // "image": "promos/zh_CN/1711605517945.webp"
  // "bonus_type": "1", //奖金方式 1:固定金额 2:累计日结
  // "automatic": "1" //1: 自动派发 2:手动领取
  // "button_type": "4",//跳转类型 1自定义 2娱乐城 3体育 4保险库 5VIP 6联盟计划 7优惠活动 8在线客服
  // "currency_id": "701" //领取之后的固定的币种
  String? detail;
  int? button;
  String? buttonText;
  String? buttonRedirect;
  List<Setting>? settings;
  String? firstDepositAmount;
  String? totalDepositAmount;
  String? totalBetAmount;
  String? totalDepositDays;
  String? totalDepositTimes;
  String? conditionType; //有效会员标准 - 满足条件
  String? bonusTpl;
  String? showAmount;
  String? bonusType;
  int? startAt;
  int? endAt;
  int? displayStartAt;
  int? displayEndAt;
  String? linkUrl;
  String? image;
  String? automatic;
  String? buttonType;

  int? ruleType; //1 需要替换最高金额， 2 自定义金额， 给什么显示什么
  String? currencyId; //领取之后的固定的币种

  ///按钮状态 1显示 2不显示
  bool showButton() {
    return button != null && button == 1;
  }

  ///"bonus_tpl": "", //奖励样式 1:开红包 2:开宝箱
  ///是否是红包
  bool isBox() {
    return bonusTpl == "2";
  }

  /// "show_amount": "", //显示金额 1:显示 2:不显示
  /// 是否显示金额，显示：则显示在外面， 不显示 打开显示在里面， 外面不显示
  bool isShowMoney() {
    return showAmount == "1";
  }

  //是否内部显示金额
  bool isInsideMoney() {
    return !isShowMoney();
  }

  ///获取推广 条件文案
  String getConditionTypeLabel() {
    if (conditionType == "1") {
      return S.current.random_text_1191;
    } else if (conditionType == "2") {
      return S.current.random_text_1192;
    } else {
      return "";
    }
  }

  ///1: 自动派发 2:手动领取
  ///是否指定派发
  bool isAutomatic() {
    return automatic == "1";
  }

  ///是否指定派发
  bool isNotAutomatic() {
    return automatic == "2";
  }

  ///描述 是否替换。
  ///1 需要替换最高金额， 2 自定义金额， 给什么显示什么
  bool needReplace(){
    return ruleType ==1;
  }

  ActivityPromotionApiModel({
    this.detail,
    this.button,
    this.buttonText,
    this.buttonRedirect,
    this.settings,
    this.firstDepositAmount,
    this.totalDepositAmount,
    this.totalBetAmount,
    this.totalDepositDays,
    this.totalDepositTimes,
    this.conditionType,
    this.bonusTpl,
    this.showAmount,
    this.bonusType,
    this.startAt,
    this.endAt,
    this.displayStartAt,
    this.displayEndAt,
    this.linkUrl,
    this.image,
    this.automatic,
    this.buttonType,
    this.ruleType,
    this.currencyId,
  });

  factory ActivityPromotionApiModel.fromJson(Map<String, dynamic> json) =>
      ActivityPromotionApiModel(
        detail: json["detail"],
        button: json["button"],
        buttonText: json["button_text"],
        buttonRedirect: json["button_redirect"],
        settings: json["settings"] == null
            ? []
            : List<Setting>.from(json["settings"]!.map((x) => Setting.fromJson(x))),
        firstDepositAmount: json["first_deposit_amount"],
        totalDepositAmount: json["total_deposit_amount"],
        totalBetAmount: json["total_bet_amount"],
        totalDepositDays: json["total_deposit_days"],
        totalDepositTimes: json["total_deposit_times"],
        conditionType: json["condition_type"],
        bonusTpl: json["bonus_tpl"],
        showAmount: json["show_amount"],
        bonusType: json["bonus_type"],
        startAt: json["start_at"],
        endAt: json["end_at"],
        displayStartAt: json["display_start_at"],
        displayEndAt: json["display_end_at"],
        linkUrl: json["link_url"],
        image: json["image"],
        automatic: json["automatic"],
        buttonType: json["button_type"],
        ruleType: json["rule_type"],
        currencyId: json["currency_id"],
      );

  Map<String, dynamic> toJson() => {
        "detail": detail,
        "button": button,
        "button_text": buttonText,
        "button_redirect": buttonRedirect,
        "settings": settings == null ? [] : List<dynamic>.from(settings!.map((x) => x.toJson())),
        "first_deposit_amount": firstDepositAmount,
        "total_deposit_amount": totalDepositAmount,
        "total_bet_amount": totalBetAmount,
        "total_deposit_days": totalDepositDays,
        "total_deposit_times": totalDepositTimes,
        "condition_type": conditionType,
        "bonus_tpl": bonusTpl,
        "show_amount": showAmount,
        "bonus_type": bonusType,
        "start_at": startAt,
        "end_at": endAt,
        "display_start_at": displayStartAt,
        "display_end_at": displayEndAt,
        "link_url": linkUrl,
        "image": image,
        "automatic": automatic,
        "button_type": buttonType,
        "rule_type": ruleType,
        "currency_id": currencyId,
      };
}

class Setting {
  //有效推广人数的级距设定, ppl: 人数, bonus: 奖励金额(U)
  int? ppl; //人数
  String? bonus; //bonus: 奖励金额(U)

  Setting({
    this.ppl,
    this.bonus,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        ppl: json["ppl"],
        bonus: json["bonus"],
      );

  Map<String, dynamic> toJson() => {
        "ppl": ppl,
        "bonus": bonus,
      };
}
