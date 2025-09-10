import 'package:json_annotation/json_annotation.dart';

import 'sub_play.dart';

part 'lottery_odds_info_model.g.dart';

@JsonSerializable()
class LotteryOddsInfoModel {
  @JsonKey(name: 'base_note_num')
  int? baseNoteNum;
  @JsonKey(name: 'play_id')
  int? playId;
  @JsonKey(name: 'sub_play_plan_num_win')
  int? subPlayPlanNumWin;
  @JsonKey(name: 'play_cname')
  String? playCname;
  @JsonKey(name: 'odds_ratio')
  int? oddsRatio;
  @JsonKey(name: 'pk_max_note_num')
  int? pkMaxNoteNum;
  List<SubPlay>? subPlay;
  @JsonKey(name: 'is_pk')
  int? isPk;
  @JsonKey(name: 'sub_play_plan_num')
  int? subPlayPlanNum;

  LotteryOddsInfoModel({
    this.baseNoteNum,
    this.playId,
    this.subPlayPlanNumWin,
    this.playCname,
    this.oddsRatio,
    this.pkMaxNoteNum,
    this.subPlay,
    this.isPk,
    this.subPlayPlanNum,
  });

  @override
  String toString() {
    return 'LotteryOddsInfoModel(baseNoteNum: $baseNoteNum, playId: $playId, subPlayPlanNumWin: $subPlayPlanNumWin, playCname: $playCname, oddsRatio: $oddsRatio, pkMaxNoteNum: $pkMaxNoteNum, subPlay: $subPlay, isPk: $isPk, subPlayPlanNum: $subPlayPlanNum)';
  }

  factory LotteryOddsInfoModel.fromJson(Map<String, dynamic> json) {
    return _$LotteryOddsInfoModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LotteryOddsInfoModelToJson(this);

  LotteryOddsInfoModel copyWith({
    int? baseNoteNum,
    int? playId,
    int? subPlayPlanNumWin,
    String? playCname,
    int? oddsRatio,
    int? pkMaxNoteNum,
    List<SubPlay>? subPlay,
    int? isPk,
    int? subPlayPlanNum,
  }) {
    return LotteryOddsInfoModel(
      baseNoteNum: baseNoteNum ?? this.baseNoteNum,
      playId: playId ?? this.playId,
      subPlayPlanNumWin: subPlayPlanNumWin ?? this.subPlayPlanNumWin,
      playCname: playCname ?? this.playCname,
      oddsRatio: oddsRatio ?? this.oddsRatio,
      pkMaxNoteNum: pkMaxNoteNum ?? this.pkMaxNoteNum,
      subPlay: subPlay ?? this.subPlay,
      isPk: isPk ?? this.isPk,
      subPlayPlanNum: subPlayPlanNum ?? this.subPlayPlanNum,
    );
  }
}
