import '../../alliance_plan/widget/custom_select_model.dart';
import '../../../generated/l10n.dart';
///体育赛事-下拉盘口-model :
@Deprecated("废弃掉")
class SportHandicapSelectModel extends CustomSelectModel {
  final SportHandicapType handicapType;

  SportHandicapSelectModel({required this.handicapType}) : super(handicapType.getLabelName());

  @override
  String toString() {
    S.current.sport_champion;
    S.current.sport_bet_score;
    return 'SportHandicapSelectModel{handicapType: $handicapType}';
  }
}



///1：让分盘， 2：总分盘， 3或者4 获胜盘(依照不同的球种)
enum SportHandicapType {
  ///S.current.sport_bet_handicap
  rfHandicap(type: "1"),
  ///S.current.sport_bet_score
  zfHandicap(type: "2"),
  ///S.current.sport_bet_winning 3或4
  hsHandicap(type: "34");

  final String type;
  // final String name;

  const SportHandicapType({required this.type}) ;

  String getLabelName(){
    switch(type){
      case "1":
        return S.current.sport_bet_handicap;
      case "2":
        return S.current.sport_bet_score;
      case "34":
        return S.current.sport_bet_winning;
      default:
        return "";
    }
  }
}


