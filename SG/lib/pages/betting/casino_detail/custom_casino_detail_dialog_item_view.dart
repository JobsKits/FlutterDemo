import 'package:flutter/material.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import '../common_helper/betting_biz_helper.dart';
import '../common_model/casino_detail_item_model.dart';

class CasinoDetailDialogItemView extends StatelessWidget {
  const CasinoDetailDialogItemView({super.key, required this.model});

  // final String? label;
  // final String? content;
  final CasinoDetailItemModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: model.showLabel,
            child: CustomText(model.label ?? "",
                style: ThemeService().textTheme.labelMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
          ),
          const SizedBox(height: AppValues.margin_2),
          Container(
            height: 36,
            //如果有显示action icon  则有icon 来确定高度， 为了扩大点击范围
            padding: EdgeInsets.symmetric(
              vertical: model.showAction ? AppValues.padding_2 : AppValues.halfPadding,
            ),
            decoration: BoxDecoration(
              color: ThemeService().colorScheme.tertiary,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              //阴影处理
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1.5, 1.5),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(width: AppValues.margin_12),
                //显示内容
                Expanded(
                  child: CustomText(model.content ?? "",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: ThemeService().textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: model.contentColor,
                          )),
                ),
                // Spacer(),
                //显示右边action图标
                Visibility(
                  visible: model.showAction,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppValues.padding_10, vertical: AppValues.padding_10),
                      child: CustomAssetIcon(
                        // name: "assets/images/common/ic_common_copy_gray.webp",
                        name: model.actionEnum.icon,
                        size: 14,
                        color: model.iconColor,
                      ),
                    ),
                    onTap: () => onClickAction(model.actionEnum),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppValues.margin_10),
        ],
      ),
    );
  }

  void onClickAction(ContentActionEnum actionEnum) {
    if (actionEnum.isActionCopy()) {
      BettingBizHelper.onClickCopyToast(model.content,showToast: true);
    }
  }
}
