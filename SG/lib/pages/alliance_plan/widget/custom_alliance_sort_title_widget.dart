import 'package:flutter/widgets.dart';

import '../../../utils/function.dart';
import '../wmodel/alliance_sort_model.dart';


///联盟计划- 列表 排序 title , 继承即， 就不用每次定义变量
abstract class CustomAllianceSortTitleWidget extends StatelessWidget {
  CustomAllianceSortTitleWidget({super.key, this.onAnyOneSortCallback});

  ///排序回调
  final ParamThreeCallback<dynamic, dynamic, AllianceSortModel>? onAnyOneSortCallback;
  final AllianceSortModel sortModel = AllianceSortModel();

}
