// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_play.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubPlay _$SubPlayFromJson(Map<String, dynamic> json) => SubPlay(
      baseNoteNum: (json['base_note_num'] as num?)?.toInt(),
      playId: (json['play_id'] as num?)?.toInt(),
      subPlayPlanNumWin: (json['sub_play_plan_num_win'] as num?)?.toInt(),
      playCname: json['play_cname'] as String?,
      oddsRatio: (json['odds_ratio'] as num?)?.toInt(),
      pkMaxNoteNum: (json['pk_max_note_num'] as num?)?.toInt(),
      isPk: (json['is_pk'] as num?)?.toInt(),
      subPlayPlanNum: (json['sub_play_plan_num'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SubPlayToJson(SubPlay instance) => <String, dynamic>{
      'base_note_num': instance.baseNoteNum,
      'play_id': instance.playId,
      'sub_play_plan_num_win': instance.subPlayPlanNumWin,
      'play_cname': instance.playCname,
      'odds_ratio': instance.oddsRatio,
      'pk_max_note_num': instance.pkMaxNoteNum,
      'is_pk': instance.isPk,
      'sub_play_plan_num': instance.subPlayPlanNum,
    };
