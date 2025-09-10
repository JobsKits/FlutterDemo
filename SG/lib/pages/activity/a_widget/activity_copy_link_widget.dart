import 'package:flutter/material.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';

///推广活动 分享链接  显示 和 copy view
class ActivityCopyLinkWidget extends StatelessWidget {
  const ActivityCopyLinkWidget({super.key, this.fullLink, this.onTapCopy});

  final String? fullLink;
  final GestureTapCallback? onTapCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      //由复制按钮来撑开
      padding: const EdgeInsets.only(
        // horizontal: AppValues.halfPadding,
        // vertical: AppValues.defaultPadding,
        left: AppValues.padding_8,
        top: AppValues.halfPadding,
        bottom: AppValues.halfPadding,
      ),
      // color: ThemeService().colorScheme.tertiary,
      decoration: BoxDecoration(
        // color: ThemeService().colorScheme.tertiary,
        color: ThemeService().colorScheme.surfaceVariant,
        // border: Border.all(color: const Color(0xFF557086), width: 1.0),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CustomText(
              fullLink ?? "",
              // '123',
              style: ThemeService().textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppValues.defaultPadding,
                vertical: AppValues.halfPadding,
              ),
              child: CustomAssetIcon(
                name: "assets/images/alliance/ic_alliance_copy.webp",
                size: 12,
              ),
            ),
            onTap: () {
              if (onTapCopy != null) onTapCopy!.call();
            },
          ),
        ],
      ),
    );
  }
}
