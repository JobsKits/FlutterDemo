import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/utils/function.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import '../wmodel/alliance_common_params.dart';

//////联盟计划-自定义widget-排序
class CustomAllianceSortWidget extends StatefulWidget {
  const CustomAllianceSortWidget({
    super.key,
    this.sort = true,
    this.sortState = SortState.none,
    required this.label,
    this.subLabel = "",
    this.callback,
  });

  final bool sort; //是否可以进行排序
  final SortState? sortState; //配置排序
  final String label;
  final String subLabel;
  final ParamSingleCallback<SortState?>? callback;

  @override
  State<CustomAllianceSortWidget> createState() => _CustomAllianceSortWidgetState();
}

class _CustomAllianceSortWidgetState extends State<CustomAllianceSortWidget> {
  // SortState sortState = SortState.none;

  //当前排序状态
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.sort) {
          onClickEvent(widget.sortState);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ///label部分
          Row(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AllianceItemCellWidget(widget.label, isTitle: true),
              SizedBox(width: 4),
              //不排序直接隐藏
              Offstage(
                offstage: !widget.sort,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomAssetIcon(
                      name: "assets/images/alliance/ic_alliance_sort_up.webp",
                      size: 6,
                      color: widget.sortState == SortState.up ? Colors.white : null,
                    ),
                    SizedBox(width: 2),
                    CustomAssetIcon(
                      name: "assets/images/alliance/ic_alliance_sort_down.webp",
                      size: 6,
                      color: widget.sortState == SortState.down ? Colors.white : null,
                    ),
                  ],
                ),
              )
            ],
          ),

          ///label部分
          Offstage(
            offstage: widget.subLabel.isEmpty,
            child: AllianceItemCellWidget(widget.subLabel, cellStyle: AllianceCellStyle.small),
          )
        ],
      ),
    );
  }

  ///当点击事件
  onClickEvent(SortState? sortState) {
    log("onClickEvent...${widget.sortState}");

    ///排序循环逻辑判断
    if (sortState == SortState.none) {
      sortState = SortState.up;
    } else if (sortState == SortState.up) {
      sortState = SortState.down;
    } else if (sortState == SortState.down) {
      sortState = SortState.none;
    }

    ///改变界面状态
    setState(() {});

    ///回调
    if (widget.callback != null) {
      widget.callback!(sortState);
    }
  }
}
