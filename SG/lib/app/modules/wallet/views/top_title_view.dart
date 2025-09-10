import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/route_util.dart';

class TopTitleView extends GetView {
  const TopTitleView({super.key, this.title, this.name});

  final String? title;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return _rootView();
  }

  _rootView() {
    return Row(
      children: [
        InkWell(
            onTap: () => RouteUtil.popView(),
            child: CustomAssetIcon(name: name ?? "assets/images/setup/ic_left_arrow.png")),
        const SizedBox(
          width: 9,
        ),
        CustomText(
          title ?? S.current.wallet_deposit,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        InkWell(
          onTap: () => RouteUtil.popView(),
          child: const CustomAssetIcon(
            name: 'assets/images/normal/ic_normal_close.webp',
          ),
        ),
      ],
    );
  }
}
