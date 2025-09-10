import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';

import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';

///联盟计划-自定义widget-底部分页
class CustomAlliancePageWidgetOld extends StatefulWidget {
  const CustomAlliancePageWidgetOld({
    super.key,
    required this.currentPage,
    this.hasMore = true,
    this.callback,
  });

  ///不处理逻辑， 只保存当前页码，数值来自上级，自己本身不执行加减；
  final int currentPage;
  final bool hasMore;
  final int firstPage = 1;//默认第一为1

  //bool, 是否点击下一页， int 当前页
  final ParamTwiceCallback<bool, int>? callback;

  @override
  State<CustomAlliancePageWidgetOld> createState() => _CustomAlliancePageWidgetState();
}

class _CustomAlliancePageWidgetState extends State<CustomAlliancePageWidgetOld> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: AppValues.halfPadding),
      // height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAssetIcon(name: "assets/images/alliance/ic_alliance_page_left.webp", size: 12),
          SizedBox(width: 4),
          CustomButton(
            title: S.current.yulecheng_prepage,
            isEnable: widget.currentPage > widget.firstPage,
            textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                color: widget.currentPage == widget.firstPage
                    ? ThemeService().colorScheme.onSurface
                    : ThemeService().colorScheme.onBackground),
            onTap: () =>
            widget.callback != null ? widget.callback!(false, widget.currentPage) : null,
          ),
          SizedBox(width: 20),
          CustomButton(
            title: S.current.yulecheng_nextpage,
            isEnable: widget.hasMore,
            textStyle: ThemeService().textTheme.bodyMedium?.copyWith(
                color: !widget.hasMore
                    ? ThemeService().colorScheme.onSurface
                    : ThemeService().colorScheme.onBackground),
            onTap: () =>
            widget.callback != null ? widget.callback!(true, widget.currentPage) : null,
          ),
          // CustomText("下一页", style: ThemeService().textTheme.bodyMedium),
          SizedBox(width: 4),
          CustomAssetIcon(name: "assets/images/alliance/ic_alliance_page_right.webp", size: 12),
        ],
      ),
    );
  }
}
