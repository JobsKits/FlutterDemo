import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/custom_app_life_cycle_listen_widget.dart';
import 'package:flutter/material.dart';

import 'logic.dart';

class MatchDetailPage extends BaseView<MatchDetailLogic> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return CustomAppBar(
      appBarTitleText: S.current.random_text_352,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return CustomAppLifeCycleListenWidget(
        didChangeAppLifecycleState: (state) {
          print('app状态：${state}');
        },
        child: Container());
  }
}
