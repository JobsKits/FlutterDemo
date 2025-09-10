import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/t.dart';
import 'package:json_annotation/json_annotation.dart';

import 'activity.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  @JsonKey(name: 'slideshow_id')
  int? slideshowId;
  @JsonKey(name: 'pic_addr')
  String? picAddr;
  @JsonKey(name: 'slideshow_code')
  int? slideshowCode;
  @JsonKey(name: 'slideshow_address')
  String? slideshowAddress;
  @JsonKey(name: 'link_name')
  String? linkName;
  int? link;
  @JsonKey(name: 'oper_method')
  int? operMethod;
  @JsonKey(name: 'chan_con')
  int? chanCon;
  int? location;
  @JsonKey(name: 'sort_v')
  int? sortV;
  @JsonKey(name: 'create_time')
  int? createTime;
  @JsonKey(name: 'state_time')
  int? stateTime;
  @JsonKey(name: 'eff_time')
  int? effTime;
  @JsonKey(name: 'exp_time')
  int? expTime;
  int? state;
  @JsonKey(name: 'oper_code')
  String? operCode;
  int? tid;
  int? proxy;
  int? language;
  @JsonKey(name: 'link_type')
  int? linkType;
  T? activity;
  dynamic activityed;

  Datum({
    this.slideshowId,
    this.picAddr,
    this.slideshowCode,
    this.slideshowAddress,
    this.linkName,
    this.link,
    this.operMethod,
    this.chanCon,
    this.location,
    this.sortV,
    this.createTime,
    this.stateTime,
    this.effTime,
    this.expTime,
    this.state,
    this.operCode,
    this.tid,
    this.proxy,
    this.language,
    this.linkType,
    this.activity,
    this.activityed,
  });

  @override
  String toString() {
    return 'Datum(slideshowId: $slideshowId, picAddr: $picAddr, slideshowCode: $slideshowCode, slideshowAddress: $slideshowAddress, linkName: $linkName, link: $link, operMethod: $operMethod, chanCon: $chanCon, location: $location, sortV: $sortV, createTime: $createTime, stateTime: $stateTime, effTime: $effTime, expTime: $expTime, state: $state, operCode: $operCode, tid: $tid, proxy: $proxy, language: $language, linkType: $linkType, activity: $activity, activityed: $activityed)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);

  Datum copyWith({
    int? slideshowId,
    String? picAddr,
    int? slideshowCode,
    String? slideshowAddress,
    String? linkName,
    int? link,
    int? operMethod,
    int? chanCon,
    int? location,
    int? sortV,
    int? createTime,
    int? stateTime,
    int? effTime,
    int? expTime,
    int? state,
    String? operCode,
    int? tid,
    int? proxy,
    int? language,
    int? linkType,
    T? activity,
    dynamic activityed,
  }) {
    return Datum(
      slideshowId: slideshowId ?? this.slideshowId,
      picAddr: picAddr ?? this.picAddr,
      slideshowCode: slideshowCode ?? this.slideshowCode,
      slideshowAddress: slideshowAddress ?? this.slideshowAddress,
      linkName: linkName ?? this.linkName,
      link: link ?? this.link,
      operMethod: operMethod ?? this.operMethod,
      chanCon: chanCon ?? this.chanCon,
      location: location ?? this.location,
      sortV: sortV ?? this.sortV,
      createTime: createTime ?? this.createTime,
      stateTime: stateTime ?? this.stateTime,
      effTime: effTime ?? this.effTime,
      expTime: expTime ?? this.expTime,
      state: state ?? this.state,
      operCode: operCode ?? this.operCode,
      tid: tid ?? this.tid,
      proxy: proxy ?? this.proxy,
      language: language ?? this.language,
      linkType: linkType ?? this.linkType,
      activity: activity ?? this.activity,
      activityed: activityed ?? this.activityed,
    );
  }
}
