import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:get/get.dart';

import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/expansion/custom_expansion_tile.dart';
import 'expansion_logic.dart';

class ExpansionPage extends BaseView<ExpansionLogic> {
  final logic = Get.find<ExpansionLogic>();

  ExpansionPage({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return const CustomAppBar(
      appBarTitleText: '测试折叠菜单',
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return CustomExpansionTile(
      onExpansionTap: (value) {
        print('点击了$value');
      },
      data: logic.expandData,
    );
  }
}
