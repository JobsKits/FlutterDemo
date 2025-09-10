///收件箱消息详情的item实体类
class InboxDetailMsgItemBean {
  InboxDetailMsgItemBean({
    this.custName,
    this.sendTime,
    this.replyContent,
  });

  InboxDetailMsgItemBean.fromJson(dynamic json) {
    custName = json['cust_name'];
    sendTime = json['send_time'];
    replyContent = json['reply_content'];
  }
  String? custName;
  int? sendTime;
  String? replyContent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cust_name'] = custName;
    map['send_time'] = sendTime;
    map['reply_content'] = replyContent;
    return map;
  }
}
