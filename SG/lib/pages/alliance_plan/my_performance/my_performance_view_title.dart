import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_alliance_sort_widget.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import '../wmodel/alliance_common_params.dart';
import '../wmodel/alliance_sort_model.dart';

///联盟计划-tab-我的业绩界面-
class MyPerformanceTitleView extends StatefulWidget {
  const MyPerformanceTitleView({super.key, this.onAnyOneSortCallback});

  ///排序回调
  final ParamThreeCallback<dynamic, dynamic, AllianceSortModel>? onAnyOneSortCallback;

  @override
  State<MyPerformanceTitleView> createState() => _MyPerformanceTitleViewState();
}

class _MyPerformanceTitleViewState extends State<MyPerformanceTitleView> {
  AllianceSortModel sortModel = AllianceSortModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      color: ThemeService().theme.scaffoldBackgroundColor,
      height: 54,
      child: CustomRowExpandedWidget(
        expanded: AllianceWidthConfig.myPerformance().expends,
        children: [
          Center(child: AllianceItemCellWidget(S.current.random_text_49, isTitle: true)),
          Center(child: AllianceItemCellWidget(S.current.random_text_53, isTitle: true)),
          //下级人数
          Center(
            child: CustomAllianceSortWidget(
              label: S.current.random_text_134,
              sortState: sortModel.personAmount,
              callback: (data) {
                if (widget.onAnyOneSortCallback != null) {
                  sortModel = AllianceSortModel();
                  sortModel.personAmount = data;
                  // widget.onAnyOneSortCallback!(null, null, sortModel);
                  onCallback(sortModel);
                }
              },
            ),
          ),

          //业绩
          Center(
            child: CustomAllianceSortWidget(
              label: S.current.random_text_129,
              sortState: sortModel.performance,
              callback: (data) {
                if (widget.onAnyOneSortCallback != null) {
                  sortModel = AllianceSortModel();
                  sortModel.performance = data;
                  // widget.onAnyOneSortCallback!(null, null, sortModel);
                  onCallback(sortModel);
                }
              },
            ),
          ),

          //贡献佣金
          Align(
            alignment: Alignment.center,
            child: CustomAllianceSortWidget(
              label: S.current.random_text_135,
              sortState: sortModel.contributeCommission,
              callback: (data) {
                if (widget.onAnyOneSortCallback != null) {
                  sortModel = AllianceSortModel();
                  sortModel.contributeCommission = data;
                  // widget.onAnyOneSortCallback!(null, null, sortModel);
                  onCallback(sortModel);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //回调处理， 需要对还原其他的排序，只排序一个
  void onCallback(AllianceSortModel newSortModel) {
    //还原之后更新
    setState(() {});
    //对调处理
    widget.onAnyOneSortCallback!(null, null, newSortModel);
  }
}
