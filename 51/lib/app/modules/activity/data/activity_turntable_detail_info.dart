class ActivityTurntableDetailInfo {
  ActivityTurntableDetailInfo({
    this.availableSource,
    this.betAmount,
    this.expiredSource,
    this.totalSource,
    this.usedSource,
    this.taskConfigs,
    this.isDone,
  });

  ActivityTurntableDetailInfo.fromJson(dynamic json) {
    availableSource = json['availableSource'];
    betAmount = json['betAmount'];
    expiredSource = json['expiredSource'];
    totalSource = json['totalSource'];
    usedSource = json['usedSource'];
    isDone = json['isDone'];
    // if (json['taskConfigs'] != null) {
    //   taskConfigs = [];
    //   json['taskConfigs'].forEach((v) {
    //     taskConfigs?.add(TaskConfigs.fromJson(v));
    //   });
    // }
    taskConfigs = (json['taskConfigs'] as List<dynamic>?)
        ?.map((e) => TaskConfigs.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  int? availableSource;
  int? betAmount;
  int? expiredSource;
  int? totalSource;
  int? usedSource;
  bool? isDone;
  List<TaskConfigs>? taskConfigs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['availableSource'] = availableSource;
    map['betAmount'] = betAmount;
    map['expiredSource'] = expiredSource;
    map['totalSource'] = totalSource;
    map['usedSource'] = usedSource;
    map['isDone'] = isDone;
    if (taskConfigs != null) {
      map['taskConfigs'] = taskConfigs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class TaskConfigs {
  TaskConfigs({
    this.taskId,
    this.type,
    this.target,
    this.source,
    this.current,
    this.isDone,
    // this.rechargeMethod,
  });

  TaskConfigs.fromJson(dynamic json) {
    taskId = json['taskId'];
    type = json['type'];
    target = (json['target'] as num?)?.toInt();
    source = json['source'];
    current = (json['current'] as num?)?.toInt();
    isDone = json['isDone'];
    // rechargeMethod = json['rechargeMethod'];
  }
  int? taskId;
  String? type;
  num? target;
  num? source;
  num? current;
  bool? isDone;
  // int? rechargeMethod;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taskId'] = taskId;
    map['type'] = type;
    map['target'] = target;
    map['source'] = source;
    map['current'] = current;
    map['isDone'] = isDone;
    // map['rechargeMethod'] = rechargeMethod;
    return map;
  }
}

class TurntableRecordItem {
  TurntableRecordItem({
    this.activityId,
    this.wheelType,
    this.rewordAmount,
    this.creatTime,
    this.source,
  });

  TurntableRecordItem.fromJson(dynamic json) {
    activityId = json['activityId'];
    wheelType = json['wheelType'];
    rewordAmount = json['rewordAmount'];
    creatTime = json['creatTime'];
    source = json['source'];
  }
  num? activityId;
  num? wheelType;
  num? rewordAmount;
  num? source;
  num? creatTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['activityId'] = activityId;
    map['wheelType'] = wheelType;
    map['rewordAmount'] = rewordAmount;
    map['source'] = source;
    map['creatTime'] = creatTime;
    return map;
  }
}
