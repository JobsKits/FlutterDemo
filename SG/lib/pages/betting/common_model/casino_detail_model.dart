import '../../../model/yulecheng/casino_record_model.dart';
import 'betting_common_params.dart';

///娱乐城 - 我的投注- 对话框 详情model
class CasinoDetailModel {
  CasinoRecordModel recordModel;
  CasinoGameTypeEnum gameType;

  CasinoDetailModel({
    required this.recordModel,
    required this.gameType,
  });
}
