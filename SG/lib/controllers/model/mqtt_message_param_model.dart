import 'package:get/get.dart';

///MqttMessageNotifyApiModel  中的type  对用该通知下 的不同内容的通知
enum MqttMessageNotifyTypeEnum {
  promo(flagValue: "promo"); //推广活动 领取 通知

  final String flagValue; //标签

  const MqttMessageNotifyTypeEnum({required this.flagValue});

  ///String 匹配 状态
  static MqttMessageNotifyTypeEnum? adaptor(String? value) {
    var state =
        MqttMessageNotifyTypeEnum.values.firstWhereOrNull((element) => element.flagValue == value);
    return state;
  }
}
