/// [{"tid":3,"mail_id":18582,"theme":"321","content":"<p>321</p>\n","send_time":1726734215000,"from_user":"system","put_cust_name":"system","send_cust_name":"17600001001","type":0,"is_annex":0,"annex_type":0,"code_multiple":0,"gift_amount":0,"is_receive":0,"is_reply":1},{"tid":3,"mail_id":18581,"theme":"*的大幅度","content":"<p>大幅度水电费 *的</p>\n","send_time":1726687685000,"from_user":"system","put_cust_name":"system","send_cust_name":"17600001001","type":0,"is_annex":0,"annex_type":0,"code_multiple":0,"gift_amount":0,"is_receive":0,"is_reply":1},{"tid":3,"mail_id":18580,"theme":"大大方方","content":"<p>反反复复凤飞飞反反复复*************</p>\n","send_time":1726687655000,"from_user":"system","put_cust_name":"system","send_cust_name":"17600001001","type":0,"is_annex":0,"annex_type":0,"code_multiple":0,"gift_amount":0,"is_receive":0,"is_reply":1}]

class InboxMsgItemBean {
  InboxMsgItemBean({
    this.tid,
    this.mailId,
    this.theme,
    this.content,
    this.sendTime,
    this.fromUser,
    this.putCustName,
    this.sendCustName,
    this.type,
    this.isAnnex,
    this.annexType,
    this.codeMultiple,
    this.giftAmount,
    this.isReceive,
    this.isReply,
  });

  InboxMsgItemBean.fromJson(dynamic json) {
    tid = json['tid'];
    mailId = json['mail_id'];
    theme = json['theme'];
    content = json['content'];
    sendTime = json['send_time'];
    fromUser = json['from_user'];
    putCustName = json['put_cust_name'];
    sendCustName = json['send_cust_name'];
    type = json['type'];
    isAnnex = json['is_annex'];
    annexType = json['annex_type'];
    codeMultiple = json['code_multiple'];
    giftAmount = json['gift_amount'];
    isReceive = json['is_receive'];
    isReply = json['is_reply'];
  }
  num? tid;
  int? mailId;
  String? theme;
  String? content;
  int? sendTime;
  String? fromUser;
  String? putCustName;
  String? sendCustName;
  num? type;
  num? isAnnex;
  num? annexType;
  num? codeMultiple;
  num? giftAmount;
  num? isReceive;
  num? isReply;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tid'] = tid;
    map['mail_id'] = mailId;
    map['theme'] = theme;
    map['content'] = content;
    map['send_time'] = sendTime;
    map['from_user'] = fromUser;
    map['put_cust_name'] = putCustName;
    map['send_cust_name'] = sendCustName;
    map['type'] = type;
    map['is_annex'] = isAnnex;
    map['annex_type'] = annexType;
    map['code_multiple'] = codeMultiple;
    map['gift_amount'] = giftAmount;
    map['is_receive'] = isReceive;
    map['is_reply'] = isReply;
    return map;
  }

  @override
  String toString() {
    return 'InboxMsgItemBean{tid: $tid, mailId: $mailId, theme: $theme, content: $content, sendTime: $sendTime, fromUser: $fromUser, putCustName: $putCustName, sendCustName: $sendCustName, type: $type, isAnnex: $isAnnex, annexType: $annexType, codeMultiple: $codeMultiple, giftAmount: $giftAmount, isReceive: $isReceive, isReply: $isReply}';
  }
}
