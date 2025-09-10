import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widget/custom_empty_widget.dart';
import '../../../../find/yulechengtouzhurank/widgets/logic.dart';
import '../../../../find/yulechengtouzhurank/widgets/view.dart';

class CompetitionView extends RankListCompetitionPage {
  CompetitionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RankListCompetitionLogic>(
      id: "Rank_list_competition",
      init: RankListCompetitionLogic(),
      builder: (controller) {
        return controller.list4.isEmpty
            ? const CustomEmptyWidget(height: 640,)
            : buildBody(context);
      },
    );
  }
}