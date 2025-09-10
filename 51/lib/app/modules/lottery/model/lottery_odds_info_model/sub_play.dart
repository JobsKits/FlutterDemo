import 'package:json_annotation/json_annotation.dart';

part 'sub_play.g.dart';

@JsonSerializable()
class SubPlay {
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
  @JsonKey(name: 'is_pk')
  int? isPk;
  @JsonKey(name: 'sub_play_plan_num')
  int? subPlayPlanNum;

  SubPlay({
    this.baseNoteNum,
    this.playId,
    this.subPlayPlanNumWin,
    this.playCname,
    this.oddsRatio,
    this.pkMaxNoteNum,
    this.isPk,
    this.subPlayPlanNum,
  });

  @override
  String toString() {
    return 'SubPlay(baseNoteNum: $baseNoteNum, playId: $playId, subPlayPlanNumWin: $subPlayPlanNumWin, playCname: $playCname, oddsRatio: $oddsRatio, pkMaxNoteNum: $pkMaxNoteNum, isPk: $isPk, subPlayPlanNum: $subPlayPlanNum)';
  }

  factory SubPlay.fromJson(Map<String, dynamic> json) {
    return _$SubPlayFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SubPlayToJson(this);

  SubPlay copyWith({
    int? baseNoteNum,
    int? playId,
    int? subPlayPlanNumWin,
    String? playCname,
    int? oddsRatio,
    int? pkMaxNoteNum,
    int? isPk,
    int? subPlayPlanNum,
  }) {
    return SubPlay(
      baseNoteNum: baseNoteNum ?? this.baseNoteNum,
      playId: playId ?? this.playId,
      subPlayPlanNumWin: subPlayPlanNumWin ?? this.subPlayPlanNumWin,
      playCname: playCname ?? this.playCname,
      oddsRatio: oddsRatio ?? this.oddsRatio,
      pkMaxNoteNum: pkMaxNoteNum ?? this.pkMaxNoteNum,
      isPk: isPk ?? this.isPk,
      subPlayPlanNum: subPlayPlanNum ?? this.subPlayPlanNum,
    );
  }
}
