import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:get/get.dart';

import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_icon.dart';
import '../index.dart';

/// 挑战
class TabGameChallengeView extends GetView<YulechenggamedetailsController> {
  const TabGameChallengeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 200,
      color: ThemeService().theme.colorScheme.surface,
      child: <Widget>[
        CustomIcon(
            asset: 'assets/images/game/ic_game_statistics.webp',
            size: AppValues.iconExtraLargerSize),
        Text(
          S.current.random_text_275,
          style: ThemeService().theme.textTheme.bodyMedium,
        ),
      ].toColumn(),
    ).paddingHorizontal(AppValues.defaultPadding);
  }
}
