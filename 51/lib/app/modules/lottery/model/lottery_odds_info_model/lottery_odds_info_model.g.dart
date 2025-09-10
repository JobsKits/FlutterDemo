// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lottery_odds_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LotteryOddsInfoModel _$LotteryOddsInfoModelFromJson(
        Map<String, dynamic> json) =>
    LotteryOddsInfoModel(
      baseNoteNum: (json['base_note_num'] as num?)?.toInt(),
      playId: (json['play_id'] as num?)?.toInt(),
      subPlayPlanNumWin: (json['sub_play_plan_num_win'] as num?)?.toInt(),
      playCname: json['play_cname'] as String?,
      oddsRatio: (json['odds_ratio'] as num?)?.toInt(),
      pkMaxNoteNum: (json['pk_max_note_num'] as num?)?.toInt(),
      subPlay: (json['subPlay'] as List<dynamic>?)
          ?.map((e) => SubPlay.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPk: (json['is_pk'] as num?)?.toInt(),
      subPlayPlanNum: (json['sub_play_plan_num'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LotteryOddsInfoModelToJson(
        LotteryOddsInfoModel instance) =>
    <String, dynamic>{
      'base_note_num': instance.baseNoteNum,
      'play_id': instance.playId,
      'sub_play_plan_num_win': instance.subPlayPlanNumWin,
      'play_cname': instance.playCname,
      'odds_ratio': instance.oddsRatio,
      'pk_max_note_num': instance.pkMaxNoteNum,
      'subPlay': instance.subPlay,
      'is_pk': instance.isPk,
      'sub_play_plan_num': instance.subPlayPlanNum,
    };
