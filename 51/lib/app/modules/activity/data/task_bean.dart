// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'task_bean.g.dart';

/// 活动tab数据
@JsonSerializable()
class TaskTabBean {
  TaskTabBean(this.data);

  List<TaskTabItemBean>? data;

  factory TaskTabBean.fromJson(List<dynamic>? list) {
    var result = list
        ?.map((json) => TaskTabItemBean.fromJson(json as Map<String, dynamic>))
        .toList();
    return TaskTabBean(result);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((item) => item.toJson()).toList();
  }
}

@JsonSerializable()
class TaskTabItemBean {
  TaskTabItemBean({
    this.activity_standard,
    this.answer_reward,
    this.balance,
    this.borrow_code,
    this.borrow_day,
    this.charge_reward,
    this.content,
    this.content_type,
    this.create_time,
    this.cumulative_coding,
    this.cumulative_recharge,
    this.cumulative_recharge_cnt,
    this.cust_reward,
    this.custom_name,
    this.deposit_amount_mini,
    this.eff_time,
    this.exp_time,
    this.game_reward,
    this.ip_limit,
    this.is_automatic,
    this.is_bank_card,
    this.is_money,
    this.is_multiple,
    this.level_reward,
    this.limit_type,
    this.loss_reward,
    this.lucky_reward,
    this.marking_quantity,
    this.min_balance,
    this.month_reward,
    this.oper_code,
    this.percentage,
    this.play_amount,
    this.play_amount_compare,
    this.play_ids,
    this.play_reward,
    this.receiver_type,
    this.recharge_type,
    this.red_reward,
    this.represent,
    this.reward_type,
    this.share_reward,
    this.sign_reward,
    this.sign_type,
    this.sort_v,
    this.standara,
    this.standaraList,
    this.state,
    this.state_time,
    this.sub_limit,
    this.tid,
    this.title,
    this.type,
    this.valid_days,
    this.virtual_reward,
    this.week_reward,
  });

  num? activity_standard;
  bool? answer_reward;
  bool? balance;
  num? borrow_code;
  num? borrow_day;
  bool? charge_reward;
  String? content;
  int? content_type; // ActivityContentType
  num? create_time;
  num? cumulative_coding;
  num? cumulative_recharge;
  num? cumulative_recharge_cnt;
  bool? cust_reward;
  String? custom_name;
  num? deposit_amount_mini;
  num? eff_time;
  num? exp_time;
  bool? game_reward;
  num? ip_limit;
  num? is_automatic;
  num? is_bank_card;
  num? is_money;
  num? is_multiple;
  bool? level_reward;
  String? limit_type;
  bool? loss_reward;
  bool? lucky_reward;
  num? marking_quantity;
  num? min_balance;
  bool? month_reward;
  String? oper_code;
  num? percentage;
  num? play_amount;
  num? play_amount_compare;
  String? play_ids;
  bool? play_reward;
  String? receiver_type;
  num? recharge_type;
  bool? red_reward;
  String? represent;
  num? reward_type;
  bool? share_reward;
  bool? sign_reward;
  num? sign_type;
  int? sort_v;
  int? state;
  num? state_time;
  num? sub_limit;
  int? tid;
  String? title;
  int? type; // ActivityType
  num? valid_days;
  bool? virtual_reward;
  bool? week_reward;
  Map<String, dynamic>? standara;
  List<StandaraListBean>? standaraList;

  factory TaskTabItemBean.fromJson(Map<String, dynamic> json) =>
      _$TaskTabItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$TaskTabItemBeanToJson(this);
}

@JsonSerializable()
class StandaraListBean {
  StandaraListBean({
    //  this.playAmount,
    this.completed,
    this.endTime,
    this.explains,
    this.fraction,
    this.icon_url,
    this.imgUrl,
    this.index,
    this.isReceive,
    this.percentage,
    this.reward,
    this.standara_name,
    this.activity_standard,
    this.startTime,
    this.activitiesName,
    this.taskDate,
    this.alreadyNumber,
    this.needNumber,
    this.custState,
    this.recharge_type,
    this.scope,

    // 会员任务用到的
    this.amount,
    this.autoReceive,
    this.receiveTime,
    this.receiveMethod,
    this.standaraNumber,
    this.standaraType,
    this.custTaskId,
    this.missionScope,
    // 活动奖金使用
    this.desc_info,
    this.task_id,
    this.id,
    this.type,
  });

  num? completed;
  num? endTime;
  String? explains;
  num? fraction;
  String? icon_url;
  String? imgUrl;
  int? index;
  int? isReceive;
  num? percentage;
  num? reward;
  String? standara_name;
  String? activitiesName;
  num? activity_standard;
  num? startTime;
  String? taskDate;
  num? alreadyNumber;
  String? needNumber;
  int? custState;
  num? recharge_type;
  String? scope;
  num? amount;
  int? autoReceive;
  num? receiveTime;
  int? receiveMethod;
  num? standaraNumber;
  int? standaraType;
  int? custTaskId;
  String? missionScope;
  String? desc_info;
  num? task_id;
  num? id;
  num? type;

  factory StandaraListBean.fromJson(Map<String, dynamic> json) =>
      _$StandaraListBeanFromJson(json);

  Map<String, dynamic> toJson() => _$StandaraListBeanToJson(this);

  @override
  String toString() {
    return 'StandaraListBean{completed: $completed, endTime: $endTime, explains: $explains, fraction: $fraction, icon_url: $icon_url, index: $index, isReceive: $isReceive, percentage: $percentage, reward: $reward, standaraName: $standara_name, activitiesName: $activitiesName, startTime: $startTime, taskDate: $taskDate, alreadyNumber: $alreadyNumber, needNumber: $needNumber, custState: $custState }';
  }
}

@JsonSerializable()
class TaskDetailBean {
  TaskDetailBean({
    required this.title,
    required this.description,
    required this.detail,
    required this.scope,
    required this.taskType,
    required this.time,
  });

  String title;
  String time;
  String scope;
  String description;
  String detail;
  int taskType;

  factory TaskDetailBean.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailBeanFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDetailBeanToJson(this);
}

//// 会员任务
@JsonSerializable()
class MemberTaskBean {
  MemberTaskBean(this.data);

  List<MemberTaskItemBean>? data;

  factory MemberTaskBean.fromJson(List<dynamic>? list) {
    var result = list
        ?.map(
            (json) => MemberTaskItemBean.fromJson(json as Map<String, dynamic>))
        .toList();
    return MemberTaskBean(result);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((item) => item.toJson()).toList();
  }
}

//// 会员任务子项
@JsonSerializable()
class MemberTaskItemBean {
  MemberTaskItemBean({
    this.alreadyNumber,
    this.autoReceive,
    this.custTaskId,
    this.days,
    this.desc,
    this.endTime,
    this.explains,
    this.icon_url,
    this.introduction,
    this.markingTimes,
    this.missionScope,
    this.needNumber,
    this.playNames,
    this.receiveMethod,
    this.receiveTime,
    this.reward,
    this.standaraNumber,
    this.standaraType,
    this.standara_name,
    this.startTime,
    this.statDateType,
    this.statDateTypeDetail,
    this.statProject,
    this.status,
    this.tid,
    this.type,
  });

  num? alreadyNumber;
  int? autoReceive;
  int? custTaskId;
  int? days;
  String? desc;
  num? endTime;
  String? explains;
  String? icon_url;
  String? introduction;
  num? markingTimes;
  String? missionScope;
  num? needNumber;
  String? playNames;
  int? receiveMethod;
  num? receiveTime;
  num? reward;
  num? standaraNumber;
  int? standaraType;
  String? standara_name;
  num? startTime;
  int? statDateType;
  String? statDateTypeDetail;
  int? statProject;
  int? status;
  int? tid;
  int? type;

  factory MemberTaskItemBean.fromJson(Map<String, dynamic> json) =>
      _$MemberTaskItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$MemberTaskItemBeanToJson(this);
}

/// 游戏任务
@JsonSerializable()
class GameTaskBean {
  GameTaskBean(this.data);

  List<GameTaskItemBean>? data;

  factory GameTaskBean.fromJson(List<dynamic>? list) {
    var result = list
        ?.map((json) => GameTaskItemBean.fromJson(json as Map<String, dynamic>))
        .toList();
    return GameTaskBean(result);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((item) => item.toJson()).toList();
  }
}

/// 游戏任务子项
@JsonSerializable()
class GameTaskItemBean {
  GameTaskItemBean({
    this.bet_amout,
    this.bet_loss_amout,
    this.cal,
    this.completed,
    this.count,
    this.describe,
    this.effective_bet_amount,
    this.explains,
    this.gtype,
    this.headName,
    this.heat,
    this.icon_url,
    this.imgUrl,
    this.is_draw,
    this.mission_objective_id,
    this.percentage,
    this.play_cat,
    this.play_cname,
    this.play_id,
    this.playid,
    this.playId,
    this.play_name,
    this.proxy,
    this.standara_name,
    this.state,
    this.terrace_id,
    this.terrace_name,
    this.tid,
    this.type_c,
    this.type_name,
    this.upToStandard,
    this.win_lose_amount,
    this.winnings_amount,
  });

  num? bet_amout;
  num? bet_loss_amout;
  int? cal;
  num? completed;
  num? count;
  String? describe;
  num? effective_bet_amount;
  String? explains;
  String? gtype;
  String? headName;
  num? heat;
  String? icon_url;
  String? imgUrl;
  num? is_draw;
  int? mission_objective_id;
  num? percentage;
  int? play_cat;
  String? play_cname;
  dynamic play_id;
  dynamic playid;
  dynamic playId;
  String? play_name;
  num? proxy;
  String? standara_name;
  int? state;
  int? terrace_id;
  String? terrace_name;
  int? tid;
  int? type_c;
  num? type_name;
  int? upToStandard;
  num? win_lose_amount;
  num? winnings_amount;

  factory GameTaskItemBean.fromJson(Map<String, dynamic> json) =>
      _$GameTaskItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$GameTaskItemBeanToJson(this);
}
