import 'package:json_annotation/json_annotation.dart';

import 'task_config.dart';
import 'wheel_config.dart';

part 'action_cfg.g.dart';

@JsonSerializable()
@JsonSerializable()
class ActionCfg {
  Map<String, String>? gameType;
  String? popupContent;
  String? postLoginModal;
  String? preLoginModal;
  List<SingleRechargeConfig>? singleRechargeConfigs;
  List<dynamic>? taskConfigs;
  int? type;
  int? validityTime;
  List<WheelConfig>? wheelConfigs;
  List<int>? wheelSwitch;
  dynamic betSource;

  ActionCfg({
    this.gameType,
    this.popupContent,
    this.postLoginModal,
    this.preLoginModal,
    this.singleRechargeConfigs,
    this.taskConfigs,
    this.type,
    this.validityTime,
    this.wheelConfigs,
    this.wheelSwitch,
    this.betSource,
  });

  factory ActionCfg.fromJson(Map<String, dynamic> json) =>
      _$ActionCfgFromJson(json);

  Map<String, dynamic> toJson() => _$ActionCfgToJson(this);
}

@JsonSerializable()
class SingleRechargeConfig {
  int? amount; // // 充值门槛金额（单位：分）。例如：10000 表示 10.00 元
  int? configId; // 配置项ID（唯一标识）
  double? giftPercentage; // 赠送百分比（小数形式）。例如：0.1 表示 10%，0.15 表示 15%

  SingleRechargeConfig({
    this.amount,
    this.configId,
    this.giftPercentage,
  });

  factory SingleRechargeConfig.fromJson(Map<String, dynamic> json) =>
      _$SingleRechargeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SingleRechargeConfigToJson(this);
}
