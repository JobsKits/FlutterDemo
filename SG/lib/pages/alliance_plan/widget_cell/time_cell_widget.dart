import 'package:flutter/widgets.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../whepler/alliance_biz_helper.dart';
import 'alliance_item_cell_widget.dart';

///联盟计划 - 列表 list 的时间格式， 上下两格
///【0302】有些表格 是不换行的。
class TimeCellWidget extends StatelessWidget {
  const TimeCellWidget({
    super.key,
    this.time,
    this.twoLine = false,
    this.secondUnit = false,
    this.showHms = true,
    this.style,
  });

  final int? time; //默认毫秒
  final bool secondUnit; //是否是秒单位， 如果是秒一定要secondUnit设置为true
  final bool showHms; //是否显示时分秒
  final bool twoLine;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    //是秒的话，x1000
    var timeDeal = (time ?? 0) * (secondUnit ? 1000 : 1);
    //是否两行显示, 显示单行 且 显示分秒
    return (!twoLine && showHms)
        ? AllianceItemCellWidget(
            AllianceBizHelper.getTimeFormatOneLines(timeDeal, secondUnit: false),
            style: style,
          )
        : Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                AllianceBizHelper.getTimeFormatTwoLines(timeDeal, true),
                style: style ??
                    ThemeService().textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
              ),
              Visibility(
                visible: showHms,
                child: CustomText(
                  AllianceBizHelper.getTimeFormatTwoLines(timeDeal, false),
                  style: style ??
                      ThemeService().textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                ),
              ),
            ],
          );
  }
}
