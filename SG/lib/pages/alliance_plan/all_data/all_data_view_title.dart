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
import '../wmodel/alliance_sort_model.dart';

class AllDataTitleView extends StatefulWidget {
  AllDataTitleView({super.key, this.onAnyOneSortCallback});

  ///排序回调
  final ParamThreeCallback<dynamic, dynamic, AllianceSortModel>? onAnyOneSortCallback;

  @override
  State<AllDataTitleView> createState() => _AllDataTitleViewState();
}

class _AllDataTitleViewState extends State<AllDataTitleView> {
  AllianceSortModel sortModel = AllianceSortModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      color: ThemeService().theme.scaffoldBackgroundColor,
      height: 50,
      child: CustomRowExpandedWidget(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        expanded: AllianceWidthConfig.allData().expends,
        children: [
          //统计时间
          Align(
              alignment: Alignment.center,
              child: CustomAllianceSortWidget(
                sort: false,
                // label: S.current.random_text_49,
                label: S.current.random_text_105,
                callback: (data) {
                  if (widget.onAnyOneSortCallback != null) {
                    sortModel.joinTime = data;
                    widget.onAnyOneSortCallback!(null, null, sortModel);
                  }
                },
              )),
          Center(child: AllianceItemCellWidget(S.current.random_text_53, isTitle: true)),
          //存款
          Center(
            child: CustomAllianceSortWidget(
              label: S.current.wallet_deposit,
              sortState: sortModel.deposit,
              callback: (data) {
                if (widget.onAnyOneSortCallback != null) {
                  sortModel = AllianceSortModel();
                  sortModel.deposit = data;
                  // widget.onAnyOneSortCallback!(null, null, sortModel);
                  onCallback(sortModel);
                }
              },
            ),
          ),

          //有效投注
          Center(
              child: CustomAllianceSortWidget(
            label: S.current.random_text_51,
            sortState: sortModel.validBet,
            callback: (data) {
              if (widget.onAnyOneSortCallback != null) {
                sortModel = AllianceSortModel();
                sortModel.validBet = data;
                // widget.onAnyOneSortCallback!(null, null, sortModel);
                onCallback(sortModel);
              }
            },
          )),
          //总输赢
          Center(
            child: CustomAllianceSortWidget(
              // label: S.current.random_text_52,
              label: S.current.random_text_150,
              sortState: sortModel.totalWinOrLoss,
              callback: (data) {
                if (widget.onAnyOneSortCallback != null) {
                  sortModel = AllianceSortModel();
                  sortModel.totalWinOrLoss = data;
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
