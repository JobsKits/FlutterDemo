///消息通知-我的消息的实体类
class MyMessageBean {
  MyMessageBean({
    this.count,
    this.data,
  });

  MyMessageBean.fromJson(dynamic json) {
    count = json['count'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(MyMessageItemBean.fromJson(v));
      });
    }
  }
  num? count;
  List<MyMessageItemBean>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class MyMessageItemBean {
  MyMessageItemBean({
    this.messageInstId,
    this.messageId,
    this.subject,
    this.contentType,
    this.content,
    this.detailType,
    this.detail,
    this.creatorType,
    this.creatorId,
    this.receivorType,
    this.receivorId,
    this.createTime,
    this.state,
    this.stateTime,
    this.partMon,
    this.tid,
    this.pushScheduleId,
    this.instanceId,
  });

  MyMessageItemBean.fromJson(dynamic json) {
    messageInstId = json['message_inst_id'];
    messageId = json['message_id'];
    subject = json['subject'];
    contentType = json['content_type'];
    content = json['content'];
    detailType = json['detail_type'];
    detail = json['detail'];
    creatorType = json['creator_type'];
    creatorId = json['creator_id'];
    receivorType = json['receivor_type'];
    receivorId = json['receivor_id'];
    createTime = json['create_time'];
    state = json['state'];
    stateTime = json['state_time'];
    partMon = json['part_mon'];
    tid = json['tid'];
    pushScheduleId = json['push_schedule_id'];
    instanceId = json['instance_id'];
  }
  int? messageInstId;
  num? messageId;
  String? subject;
  num? contentType;
  String? content;
  num? detailType;
  String? detail;
  num? creatorType;
  num? creatorId;
  num? receivorType;
  num? receivorId;
  int? createTime;
  num? state;
  num? stateTime;
  int? partMon;
  num? tid;
  num? pushScheduleId;
  num? instanceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message_inst_id'] = messageInstId;
    map['message_id'] = messageId;
    map['subject'] = subject;
    map['content_type'] = contentType;
    map['content'] = content;
    map['detail_type'] = detailType;
    map['detail'] = detail;
    map['creator_type'] = creatorType;
    map['creator_id'] = creatorId;
    map['receivor_type'] = receivorType;
    map['receivor_id'] = receivorId;
    map['create_time'] = createTime;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['part_mon'] = partMon;
    map['tid'] = tid;
    map['push_schedule_id'] = pushScheduleId;
    map['instance_id'] = instanceId;
    return map;
  }

  @override
  String toString() {
    return 'MyMessageItemBean{messageInstId: $messageInstId, messageId: $messageId, subject: $subject, contentType: $contentType, content: $content, detailType: $detailType, detail: $detail, creatorType: $creatorType, creatorId: $creatorId, receivorType: $receivorType, receivorId: $receivorId, createTime: $createTime, state: $state, stateTime: $stateTime, partMon: $partMon, tid: $tid, pushScheduleId: $pushScheduleId, instanceId: $instanceId}';
  }
}
