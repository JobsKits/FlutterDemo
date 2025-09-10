
import '../../../utils/date_util.dart';

class AgentLevelModel {
  int type; //货币类型
  int level; //代理等级
  double money; //晋升条件

  AgentLevelModel({
    required this.type,
    required this.level,
    required this.money,
  }); //兑换汇率



  String getLevel(){
    return "LV$level";
  }

  String getLevelImageAsset(){
    String assetPath = "";
    // switch(level){
    //   case 1:
    //     assetPath = "assets/images/alliance/ic_alliance_agent_level_01.webp";
    //     break;
    //
    // }
    ///取巧写法：
    if(level<10){
      assetPath = "assets/images/alliance/ic_alliance_agent_level_0${level}.webp";
    }else{
      assetPath = "assets/images/alliance/ic_alliance_agent_level_${level}.webp";
    }
    return assetPath;
  }

}
