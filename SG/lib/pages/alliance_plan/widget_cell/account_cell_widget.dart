import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/utils/text_util.dart';
import 'package:flutter_bet/widget/cell/custom_tooltip_widget.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';

import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/branch/branch_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/cell/custom_tooltip_hint_widget.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_bubble.dart';
import '../../../widget/custom_text.dart';
import '../whepler/alliance_biz_helper.dart';

//联盟计划 - 列表 list 的账号
class AccountCellWidget extends StatelessWidget {
  const AccountCellWidget({
    super.key,
    this.username,
    this.vip,
    this.padding,
    this.showVip = true,
    this.maxLength = 10,
    this.showTip = true,
  });

  final String? username;
  final String? vip;
  final int maxLength;
  final EdgeInsetsGeometry? padding;
  final bool showVip;
  final bool? showTip;

  @override
  Widget build(BuildContext context) {
    var nameTarget = TextUtil.clipping(username, maxLength);
    return CustomTooltipWidget(
      isShow: nameTarget.length > maxLength,
      padding: EdgeInsets.zero,
      verticalOffset: 10,
      decoration: const BoxDecoration(color: Colors.transparent),
      richMessage: WidgetSpan(
        child: UnconstrainedBox(
          child: BubbleView(
            direction: ArrowDirection.bottom,
            arrowWidth: 8,
            arrowHeight: 4,
            borderRadius: const Radius.circular(4.0),
            arrowBasisOffset: 0,
            arrowPeakOffset: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: CustomText(
              username ?? '',
              style: ThemeService().textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF13212D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // CustomAssetIcon(name: getVipAsset(vip), size: 16),
          Visibility(
            visible: showVip,
            child: CustomNetWorkImage(
                showErrorMsg: false, imageUrl: getVipAsset(vip), width: 16, height: 16),
          ),
          Visibility(visible: showVip, child: const SizedBox(width: AppValues.margin_2)),
          CustomText(nameTarget,
              style: ThemeService().textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500)),
          // const SizedBox(width: AppValues.margin_2),
          //是否显示tooltip
          _buildCopyIcon(),
        ],
      ),
    );
  }

  ///是否显示tooltip
  Widget _buildCopyIcon() {
    return showTip == true
        ? CustomTooltipHintWidget(
            contentTip: S.current.random_text_1221,
            contentBack: username,
            tipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            style: ThemeService().textTheme.labelMedium?.copyWith(
                  // color: const Color(0xFF13212D).withOpacity(0.5),
                  color: ThemeService().colorScheme.tertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
            onTriggered: (data) {
              // Clipboard.setData(ClipboardData(text: data));
              AllianceBizHelper.copyText(data, toast: false);
            },
            contentWidget: const Padding(
              // padding: EdgeInsets.all(AppValues.smallPadding),
              padding: EdgeInsets.all(0),
              child:
                  CustomAssetIcon(name: "assets/images/alliance/ic_alliance_copy.webp", size: 12),
            ),
          )
        : InkWell(
            onTap: () => onClickCopy(username),
            child: Padding(
              padding: padding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppValues.smallPadding,
                    vertical: AppValues.halfPadding,
                  ),
              child: const CustomAssetIcon(
                  name: "assets/images/alliance/ic_alliance_copy.webp", size: 12),
            ),
          );
  }

  //复制账号,toast 提示
  void onClickCopy(String? content) {
    AllianceBizHelper.copyText(content);
  }

  //复制账号,tooltip 提示
  void onClickCopyTip(String? content) {
    AllianceBizHelper.copyText(content, toast: false);
  }

  ///获取vip 对应的图标
  String getVipAsset(String? vip) {
    var vipLevel = 0;
    // if (vip == null || vip.isEmpty) {
    //   return "assets/images/alliance/ic_alliance_vip_0.webp";
    // }
    // return "assets/images/alliance/ic_alliance_vip_${vip}.webp";
    if (vip != null && vip.isNotEmpty) {
      vipLevel = int.parse(vip);
    }
    return "${BranchService().current.asset_url}/images/vip/$vipLevel.webp";
    // return AllianceBizHelper.getVipLevelAsset(vipLevel);
  }
}
