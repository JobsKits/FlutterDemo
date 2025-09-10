// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'rebate_bean.g.dart';

// tab数据
class RebateTabBean {
  RebateTabBean({
    required this.amount,
    required this.gameName,
    required this.gameType,
    required this.imgUrl,
  });

  String gameName;
  String gameType;
  num amount;
  String imgUrl;

  @override
  String toString() {
    return 'RebateTabBean{gameName: $gameName, gameType: $gameType, amount: $amount, imgUrl: $imgUrl}';
  }
}

class RebateProportionDataBean {
  RebateProportionDataBean({
    required this.gameName,
    required this.type,
  });

  String gameName;
  int type;
}

/// 返水比例子项的数据
@JsonSerializable()
class RebateProportionItemBean {
  RebateProportionItemBean(this.data);

  List<RebateProportionChildItemBean>? data;

  factory RebateProportionItemBean.fromJson(List<dynamic>? list) {
    var result = list
        ?.map((json) => RebateProportionChildItemBean.fromJson(
            json as Map<String, dynamic>))
        .toList();
    return RebateProportionItemBean(result);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((item) => item.toJson()).toList();
  }
}

/// 返水比例数据 子项数据
@JsonSerializable()
class RebateProportionChildItemBean {
  RebateProportionChildItemBean({
    this.scale,
    this.shuffle_lower,
    this.vip,
  });

  num? scale;
  num? shuffle_lower;
  String? vip;

  factory RebateProportionChildItemBean.fromJson(Map<String, dynamic> json) =>
      _$RebateProportionChildItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$RebateProportionChildItemBeanToJson(this);
}

/// 返水列表的数据
@JsonSerializable()
class RebateDataBean {
  RebateDataBean({
    this.cust_id,
    this.cust_name,
    this.end_time,
    this.is_auto,
    this.list,
    this.play_amount_sum,
    this.settle_time,
    this.shuffle_amount_sum,
    this.t_shuffle_amount_sum,
    this.rule,
    this.rebate_time,
    this.tid,
    this.upper_id,
  });

  int? cust_id;
  String? cust_name;
  num? end_time;
  int? is_auto;
  num? play_amount_sum;
  String? settle_time;
  num? shuffle_amount_sum;
  num? t_shuffle_amount_sum;
  String? rule;
  int? rebate_time;
  int? tid;
  int? upper_id;
  Map<int, List<RebateDataChildItemBean>>? list;

  factory RebateDataBean.fromJson(Map<String, dynamic> json) =>
      _$RebateDataBeanFromJson(json);

  Map<String, dynamic> toJson() => _$RebateDataBeanToJson(this);
}

/// 返水列表 子项的数据
@JsonSerializable()
class RebateDataChildItemBean {
  RebateDataChildItemBean({
    this.end_time,
    this.game_type,
    this.play_amount,
    this.play_id,
    this.play_name,
    this.scale,
    this.sgame_type,
    this.shuffle_amount,
    this.next_scale,
    this.up_amount,
  });

  num? end_time;
  String? game_type;
  num? play_amount;
  String? play_id;
  String? play_name;
  num? scale;
  String? sgame_type;
  num? shuffle_amount;
  num? next_scale; // 比例
  num? up_amount; // 相差金额

  factory RebateDataChildItemBean.fromJson(Map<String, dynamic> json) =>
      _$RebateDataChildItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$RebateDataChildItemBeanToJson(this);
}

/// 返水历史记录
@JsonSerializable()
class RebateHistoryBean {
  RebateHistoryBean(this.data);

  List<RebateHistoryItemBean>? data;

  factory RebateHistoryBean.fromJson(List<dynamic>? list) {
    var result = list
        ?.map((json) =>
            RebateHistoryItemBean.fromJson(json as Map<String, dynamic>))
        .toList();
    return RebateHistoryBean(result);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((item) => item.toJson()).toList();
  }
}

/// 返水历史子项
@JsonSerializable()
class RebateHistoryItemBean {
  RebateHistoryItemBean({
    this.amount,
    this.create_time,
    this.cust_id,
    this.cust_name,
    this.data_type,
    this.game_name,
    this.log_id,
    this.part_mon,
    this.scale,
    this.shuffle_amount,
    this.tid,
    this.upper_id,
  });

  int? create_time;
  num? amount;
  num? shuffle_amount;
  int? tid;
  num? scale;
  num? part_mon;
  int? upper_id;
  int? data_type;
  int? log_id;
  int? cust_id;
  String? game_name;
  String? cust_name;

  factory RebateHistoryItemBean.fromJson(Map<String, dynamic> json) =>
      _$RebateHistoryItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$RebateHistoryItemBeanToJson(this);
}

List<T> _convertToList<T>(dynamic jsonList) {
  if (jsonList is List) {
    return jsonList
        .map((item) => RebateHistoryDetailItemBean.fromJson(item) as T)
        .toList();
  }
  return [];
}

/// 返水历史记录 - 详情
@JsonSerializable()
class RebateHistoryDetailBean {
  RebateHistoryDetailBean({
    required this.g100,
    required this.g101,
    required this.g102,
    required this.g103,
    required this.g104,
    required this.g105,
    required this.g106,
    required this.g109,
  });

  late List<RebateHistoryDetailItemBean> g100;
  late List<RebateHistoryDetailItemBean> g101;
  late List<RebateHistoryDetailItemBean> g102;
  late List<RebateHistoryDetailItemBean> g103;
  late List<RebateHistoryDetailItemBean> g104;
  late List<RebateHistoryDetailItemBean> g105;
  late List<RebateHistoryDetailItemBean> g106;
  late List<RebateHistoryDetailItemBean> g109;

  RebateHistoryDetailBean.fromJson(Map<String, dynamic> json) {
    g100 = _convertToList<RebateHistoryDetailItemBean>(json['100']);
    g101 = _convertToList<RebateHistoryDetailItemBean>(json['101']);
    g102 = _convertToList<RebateHistoryDetailItemBean>(json['102']);
    g103 = _convertToList<RebateHistoryDetailItemBean>(json['103']);
    g104 = _convertToList<RebateHistoryDetailItemBean>(json['104']);
    g105 = _convertToList<RebateHistoryDetailItemBean>(json['105']);
    g106 = _convertToList<RebateHistoryDetailItemBean>(json['106']);
    g109 = _convertToList<RebateHistoryDetailItemBean>(json['109']);
  }
}

@JsonSerializable()
class RebateHistoryDetailItemBean {
  RebateHistoryDetailItemBean({
    this.amount,
    this.create_time,
    this.cust_id,
    this.cust_name,
    this.data_type,
    this.game_name,
    this.log_id,
    this.part_mon,
    this.scale,
    this.shuffle_amount,
    this.tid,
    this.upper_id,
  });

  num? amount;
  int? create_time;
  int? cust_id;
  String? cust_name;
  num? data_type;
  String? game_name;
  int? log_id;
  num? part_mon;
  num? scale;
  num? shuffle_amount;
  int? tid;
  int? upper_id;

  factory RebateHistoryDetailItemBean.fromJson(dynamic json) =>
      _$RebateHistoryDetailItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$RebateHistoryDetailItemBeanToJson(this);
}
