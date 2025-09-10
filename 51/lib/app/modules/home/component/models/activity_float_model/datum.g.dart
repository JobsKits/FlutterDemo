// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      slideshowId: (json['slideshow_id'] as num?)?.toInt(),
      picAddr: json['pic_addr'] as String?,
      slideshowCode: (json['slideshow_code'] as num?)?.toInt(),
      slideshowAddress: json['slideshow_address'] as String?,
      linkName: json['link_name'] as String?,
      link: (json['link'] as num?)?.toInt(),
      operMethod: (json['oper_method'] as num?)?.toInt(),
      chanCon: (json['chan_con'] as num?)?.toInt(),
      location: (json['location'] as num?)?.toInt(),
      sortV: (json['sort_v'] as num?)?.toInt(),
      createTime: (json['create_time'] as num?)?.toInt(),
      stateTime: (json['state_time'] as num?)?.toInt(),
      effTime: (json['eff_time'] as num?)?.toInt(),
      expTime: (json['exp_time'] as num?)?.toInt(),
      state: (json['state'] as num?)?.toInt(),
      operCode: json['oper_code'] as String?,
      tid: (json['tid'] as num?)?.toInt(),
      proxy: (json['proxy'] as num?)?.toInt(),
      language: (json['language'] as num?)?.toInt(),
      linkType: (json['link_type'] as num?)?.toInt(),
      activity: json['activity'] == null
          ? null
          : T.fromJson(json['activity'] as Map<String, dynamic>),
      activityed: json['activityed'],
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'slideshow_id': instance.slideshowId,
      'pic_addr': instance.picAddr,
      'slideshow_code': instance.slideshowCode,
      'slideshow_address': instance.slideshowAddress,
      'link_name': instance.linkName,
      'link': instance.link,
      'oper_method': instance.operMethod,
      'chan_con': instance.chanCon,
      'location': instance.location,
      'sort_v': instance.sortV,
      'create_time': instance.createTime,
      'state_time': instance.stateTime,
      'eff_time': instance.effTime,
      'exp_time': instance.expTime,
      'state': instance.state,
      'oper_code': instance.operCode,
      'tid': instance.tid,
      'proxy': instance.proxy,
      'language': instance.language,
      'link_type': instance.linkType,
      'activity': instance.activity,
      'activityed': instance.activityed,
    };
