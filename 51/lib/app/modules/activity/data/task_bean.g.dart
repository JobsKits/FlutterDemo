// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskTabBean _$TaskTabBeanFromJson(Map<String, dynamic> json) => TaskTabBean(
      (json['data'] as List<dynamic>?)
          ?.map((e) => TaskTabItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskTabBeanToJson(TaskTabBean instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

TaskTabItemBean _$TaskTabItemBeanFromJson(Map<String, dynamic> json) =>
    TaskTabItemBean(
      activity_standard: json['activity_standard'] as num?,
      answer_reward: json['answer_reward'] as bool?,
      balance: json['balance'] as bool?,
      borrow_code: json['borrow_code'] as num?,
      borrow_day: json['borrow_day'] as num?,
      charge_reward: json['charge_reward'] as bool?,
      content: json['content'] as String?,
      content_type: (json['content_type'] as num?)?.toInt(),
      create_time: json['create_time'] as num?,
      cumulative_coding: json['cumulative_coding'] as num?,
      cumulative_recharge: json['cumulative_recharge'] as num?,
      cumulative_recharge_cnt: json['cumulative_recharge_cnt'] as num?,
      cust_reward: json['cust_reward'] as bool?,
      custom_name: json['custom_name'] as String?,
      deposit_amount_mini: json['deposit_amount_mini'] as num?,
      eff_time: json['eff_time'] as num?,
      exp_time: json['exp_time'] as num?,
      game_reward: json['game_reward'] as bool?,
      ip_limit: json['ip_limit'] as num?,
      is_automatic: json['is_automatic'] as num?,
      is_bank_card: json['is_bank_card'] as num?,
      is_money: json['is_money'] as num?,
      is_multiple: json['is_multiple'] as num?,
      level_reward: json['level_reward'] as bool?,
      limit_type: json['limit_type'] as String?,
      loss_reward: json['loss_reward'] as bool?,
      lucky_reward: json['lucky_reward'] as bool?,
      marking_quantity: json['marking_quantity'] as num?,
      min_balance: json['min_balance'] as num?,
      month_reward: json['month_reward'] as bool?,
      oper_code: json['oper_code'] as String?,
      percentage: json['percentage'] as num?,
      play_amount: json['play_amount'] as num?,
      play_amount_compare: json['play_amount_compare'] as num?,
      play_ids: json['play_ids'] as String?,
      play_reward: json['play_reward'] as bool?,
      receiver_type: json['receiver_type'] as String?,
      recharge_type: json['recharge_type'] as num?,
      red_reward: json['red_reward'] as bool?,
      represent: json['represent'] as String?,
      reward_type: json['reward_type'] as num?,
      share_reward: json['share_reward'] as bool?,
      sign_reward: json['sign_reward'] as bool?,
      sign_type: json['sign_type'] as num?,
      sort_v: (json['sort_v'] as num?)?.toInt(),
      standara: json['standara'] as Map<String, dynamic>?,
      standaraList: (json['standaraList'] as List<dynamic>?)
          ?.map((e) => StandaraListBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      state: (json['state'] as num?)?.toInt(),
      state_time: json['state_time'] as num?,
      sub_limit: json['sub_limit'] as num?,
      tid: (json['tid'] as num?)?.toInt(),
      title: json['title'] as String?,
      type: (json['type'] as num?)?.toInt(),
      valid_days: json['valid_days'] as num?,
      virtual_reward: json['virtual_reward'] as bool?,
      week_reward: json['week_reward'] as bool?,
    );

Map<String, dynamic> _$TaskTabItemBeanToJson(TaskTabItemBean instance) =>
    <String, dynamic>{
      'activity_standard': instance.activity_standard,
      'answer_reward': instance.answer_reward,
      'balance': instance.balance,
      'borrow_code': instance.borrow_code,
      'borrow_day': instance.borrow_day,
      'charge_reward': instance.charge_reward,
      'content': instance.content,
      'content_type': instance.content_type,
      'create_time': instance.create_time,
      'cumulative_coding': instance.cumulative_coding,
      'cumulative_recharge': instance.cumulative_recharge,
      'cumulative_recharge_cnt': instance.cumulative_recharge_cnt,
      'cust_reward': instance.cust_reward,
      'custom_name': instance.custom_name,
      'deposit_amount_mini': instance.deposit_amount_mini,
      'eff_time': instance.eff_time,
      'exp_time': instance.exp_time,
      'game_reward': instance.game_reward,
      'ip_limit': instance.ip_limit,
      'is_automatic': instance.is_automatic,
      'is_bank_card': instance.is_bank_card,
      'is_money': instance.is_money,
      'is_multiple': instance.is_multiple,
      'level_reward': instance.level_reward,
      'limit_type': instance.limit_type,
      'loss_reward': instance.loss_reward,
      'lucky_reward': instance.lucky_reward,
      'marking_quantity': instance.marking_quantity,
      'min_balance': instance.min_balance,
      'month_reward': instance.month_reward,
      'oper_code': instance.oper_code,
      'percentage': instance.percentage,
      'play_amount': instance.play_amount,
      'play_amount_compare': instance.play_amount_compare,
      'play_ids': instance.play_ids,
      'play_reward': instance.play_reward,
      'receiver_type': instance.receiver_type,
      'recharge_type': instance.recharge_type,
      'red_reward': instance.red_reward,
      'represent': instance.represent,
      'reward_type': instance.reward_type,
      'share_reward': instance.share_reward,
      'sign_reward': instance.sign_reward,
      'sign_type': instance.sign_type,
      'sort_v': instance.sort_v,
      'state': instance.state,
      'state_time': instance.state_time,
      'sub_limit': instance.sub_limit,
      'tid': instance.tid,
      'title': instance.title,
      'type': instance.type,
      'valid_days': instance.valid_days,
      'virtual_reward': instance.virtual_reward,
      'week_reward': instance.week_reward,
      'standara': instance.standara,
      'standaraList': instance.standaraList,
    };

StandaraListBean _$StandaraListBeanFromJson(Map<String, dynamic> json) =>
    StandaraListBean(
      completed: json['completed'] as num?,
      endTime: json['endTime'] as num?,
      explains: json['explains'] as String?,
      fraction: json['fraction'] as num?,
      icon_url: json['icon_url'] as String?,
      imgUrl: json['imgUrl'] as String?,
      index: (json['index'] as num?)?.toInt(),
      isReceive: (json['isReceive'] as num?)?.toInt(),
      percentage: json['percentage'] as num?,
      reward: json['reward'] as num?,
      standara_name: json['standara_name'] as String?,
      activity_standard: json['activity_standard'] as num?,
      startTime: json['startTime'] as num?,
      activitiesName: json['activitiesName'] as String?,
      taskDate: json['taskDate'] as String?,
      alreadyNumber: json['alreadyNumber'] as num?,
      needNumber: json['needNumber'] as String?,
      custState: (json['custState'] as num?)?.toInt(),
      recharge_type: json['recharge_type'] as num?,
      scope: json['scope'] as String?,
      amount: json['amount'] as num?,
      autoReceive: (json['autoReceive'] as num?)?.toInt(),
      receiveTime: json['receiveTime'] as num?,
      receiveMethod: (json['receiveMethod'] as num?)?.toInt(),
      standaraNumber: json['standaraNumber'] as num?,
      standaraType: (json['standaraType'] as num?)?.toInt(),
      custTaskId: (json['custTaskId'] as num?)?.toInt(),
      missionScope: json['missionScope'] as String?,
      desc_info: json['desc_info'] as String?,
      task_id: json['task_id'] as num?,
      id: json['id'] as num?,
      type: json['type'] as num?,
    );

Map<String, dynamic> _$StandaraListBeanToJson(StandaraListBean instance) =>
    <String, dynamic>{
      'completed': instance.completed,
      'endTime': instance.endTime,
      'explains': instance.explains,
      'fraction': instance.fraction,
      'icon_url': instance.icon_url,
      'imgUrl': instance.imgUrl,
      'index': instance.index,
      'isReceive': instance.isReceive,
      'percentage': instance.percentage,
      'reward': instance.reward,
      'standara_name': instance.standara_name,
      'activitiesName': instance.activitiesName,
      'activity_standard': instance.activity_standard,
      'startTime': instance.startTime,
      'taskDate': instance.taskDate,
      'alreadyNumber': instance.alreadyNumber,
      'needNumber': instance.needNumber,
      'custState': instance.custState,
      'recharge_type': instance.recharge_type,
      'scope': instance.scope,
      'amount': instance.amount,
      'autoReceive': instance.autoReceive,
      'receiveTime': instance.receiveTime,
      'receiveMethod': instance.receiveMethod,
      'standaraNumber': instance.standaraNumber,
      'standaraType': instance.standaraType,
      'custTaskId': instance.custTaskId,
      'missionScope': instance.missionScope,
      'desc_info': instance.desc_info,
      'task_id': instance.task_id,
      'id': instance.id,
      'type': instance.type,
    };

TaskDetailBean _$TaskDetailBeanFromJson(Map<String, dynamic> json) =>
    TaskDetailBean(
      title: json['title'] as String,
      description: json['description'] as String,
      detail: json['detail'] as String,
      scope: json['scope'] as String,
      taskType: (json['taskType'] as num).toInt(),
      time: json['time'] as String,
    );

Map<String, dynamic> _$TaskDetailBeanToJson(TaskDetailBean instance) =>
    <String, dynamic>{
      'title': instance.title,
      'time': instance.time,
      'scope': instance.scope,
      'description': instance.description,
      'detail': instance.detail,
      'taskType': instance.taskType,
    };

MemberTaskBean _$MemberTaskBeanFromJson(Map<String, dynamic> json) =>
    MemberTaskBean(
      (json['data'] as List<dynamic>?)
          ?.map((e) => MemberTaskItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MemberTaskBeanToJson(MemberTaskBean instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

MemberTaskItemBean _$MemberTaskItemBeanFromJson(Map<String, dynamic> json) =>
    MemberTaskItemBean(
      alreadyNumber: json['alreadyNumber'] as num?,
      autoReceive: (json['autoReceive'] as num?)?.toInt(),
      custTaskId: (json['custTaskId'] as num?)?.toInt(),
      days: (json['days'] as num?)?.toInt(),
      desc: json['desc'] as String?,
      endTime: json['endTime'] as num?,
      explains: json['explains'] as String?,
      icon_url: json['icon_url'] as String?,
      introduction: json['introduction'] as String?,
      markingTimes: json['markingTimes'] as num?,
      missionScope: json['missionScope'] as String?,
      needNumber: json['needNumber'] as num?,
      playNames: json['playNames'] as String?,
      receiveMethod: (json['receiveMethod'] as num?)?.toInt(),
      receiveTime: json['receiveTime'] as num?,
      reward: json['reward'] as num?,
      standaraNumber: json['standaraNumber'] as num?,
      standaraType: (json['standaraType'] as num?)?.toInt(),
      standara_name: json['standara_name'] as String?,
      startTime: json['startTime'] as num?,
      statDateType: (json['statDateType'] as num?)?.toInt(),
      statDateTypeDetail: json['statDateTypeDetail'] as String?,
      statProject: (json['statProject'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MemberTaskItemBeanToJson(MemberTaskItemBean instance) =>
    <String, dynamic>{
      'alreadyNumber': instance.alreadyNumber,
      'autoReceive': instance.autoReceive,
      'custTaskId': instance.custTaskId,
      'days': instance.days,
      'desc': instance.desc,
      'endTime': instance.endTime,
      'explains': instance.explains,
      'icon_url': instance.icon_url,
      'introduction': instance.introduction,
      'markingTimes': instance.markingTimes,
      'missionScope': instance.missionScope,
      'needNumber': instance.needNumber,
      'playNames': instance.playNames,
      'receiveMethod': instance.receiveMethod,
      'receiveTime': instance.receiveTime,
      'reward': instance.reward,
      'standaraNumber': instance.standaraNumber,
      'standaraType': instance.standaraType,
      'standara_name': instance.standara_name,
      'startTime': instance.startTime,
      'statDateType': instance.statDateType,
      'statDateTypeDetail': instance.statDateTypeDetail,
      'statProject': instance.statProject,
      'status': instance.status,
      'tid': instance.tid,
      'type': instance.type,
    };

GameTaskBean _$GameTaskBeanFromJson(Map<String, dynamic> json) => GameTaskBean(
      (json['data'] as List<dynamic>?)
          ?.map((e) => GameTaskItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameTaskBeanToJson(GameTaskBean instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

GameTaskItemBean _$GameTaskItemBeanFromJson(Map<String, dynamic> json) =>
    GameTaskItemBean(
      bet_amout: json['bet_amout'] as num?,
      bet_loss_amout: json['bet_loss_amout'] as num?,
      cal: (json['cal'] as num?)?.toInt(),
      completed: json['completed'] as num?,
      count: json['count'] as num?,
      describe: json['describe'] as String?,
      effective_bet_amount: json['effective_bet_amount'] as num?,
      explains: json['explains'] as String?,
      gtype: json['gtype'] as String?,
      headName: json['headName'] as String?,
      heat: json['heat'] as num?,
      icon_url: json['icon_url'] as String?,
      imgUrl: json['imgUrl'] as String?,
      is_draw: json['is_draw'] as num?,
      mission_objective_id: (json['mission_objective_id'] as num?)?.toInt(),
      percentage: json['percentage'] as num?,
      play_cat: (json['play_cat'] as num?)?.toInt(),
      play_cname: json['play_cname'] as String?,
      play_id: json['play_id'],
      playid: json['playid'],
      playId: json['playId'],
      play_name: json['play_name'] as String?,
      proxy: json['proxy'] as num?,
      standara_name: json['standara_name'] as String?,
      state: (json['state'] as num?)?.toInt(),
      terrace_id: (json['terrace_id'] as num?)?.toInt(),
      terrace_name: json['terrace_name'] as String?,
      tid: (json['tid'] as num?)?.toInt(),
      type_c: (json['type_c'] as num?)?.toInt(),
      type_name: json['type_name'] as num?,
      upToStandard: (json['upToStandard'] as num?)?.toInt(),
      win_lose_amount: json['win_lose_amount'] as num?,
      winnings_amount: json['winnings_amount'] as num?,
    );

Map<String, dynamic> _$GameTaskItemBeanToJson(GameTaskItemBean instance) =>
    <String, dynamic>{
      'bet_amout': instance.bet_amout,
      'bet_loss_amout': instance.bet_loss_amout,
      'cal': instance.cal,
      'completed': instance.completed,
      'count': instance.count,
      'describe': instance.describe,
      'effective_bet_amount': instance.effective_bet_amount,
      'explains': instance.explains,
      'gtype': instance.gtype,
      'headName': instance.headName,
      'heat': instance.heat,
      'icon_url': instance.icon_url,
      'imgUrl': instance.imgUrl,
      'is_draw': instance.is_draw,
      'mission_objective_id': instance.mission_objective_id,
      'percentage': instance.percentage,
      'play_cat': instance.play_cat,
      'play_cname': instance.play_cname,
      'play_id': instance.play_id,
      'playid': instance.playid,
      'playId': instance.playId,
      'play_name': instance.play_name,
      'proxy': instance.proxy,
      'standara_name': instance.standara_name,
      'state': instance.state,
      'terrace_id': instance.terrace_id,
      'terrace_name': instance.terrace_name,
      'tid': instance.tid,
      'type_c': instance.type_c,
      'type_name': instance.type_name,
      'upToStandard': instance.upToStandard,
      'win_lose_amount': instance.win_lose_amount,
      'winnings_amount': instance.winnings_amount,
    };
