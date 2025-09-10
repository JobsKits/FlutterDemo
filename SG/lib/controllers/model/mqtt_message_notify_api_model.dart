///普通消息通知，存取款、活动领取通知
class MqttMessageNotifyApiModel {
  // 比如：这是推广活动 的领取状态 通知
  // "id": "166611422472041840",
  // "type": "promo",
  // "title": "agent",
  // "content": "1,706,4.00000000",
  // "is_read": 1,
  // "timestamp": 1717163450,
  // "target": "",
  // "target_id": "396",
  // "payload": "{\"currency_id\":\"706\",\"promo_type\":\"2\",\"type\":\"1\",\"promo_name\":\"\",\"bonus_amount\":\"4.00000000\",\"from_bonus_amount\":\"4.00000000\"}"
  String? id;
  String? type;
  String? title;
  String? content;
  int? isRead;
  int? timestamp;
  String? target;
  String? targetId;
  dynamic payload;

  MqttMessageNotifyApiModel({
    this.id,
    this.type,
    this.title,
    this.content,
    this.isRead,
    this.timestamp,
    this.target,
    this.targetId,
    this.payload,
  });

  factory MqttMessageNotifyApiModel.fromJson(Map<String, dynamic> json) =>
      MqttMessageNotifyApiModel(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        content: json["content"],
        isRead: json["is_read"],
        timestamp: json["timestamp"],
        target: json["target"],
        targetId: json["target_id"],
        payload: json["payload"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "title": title,
        "content": content,
        "is_read": isRead,
        "timestamp": timestamp,
        "target": target,
        "target_id": targetId,
        "payload": payload,
      };
}
