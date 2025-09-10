import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_small_mian_button.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';

import 'logic.dart';

class TestSnackBarPage extends BaseView<TestSnackBarLogic> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return const CustomAppBar(appBarTitleText: '测试SnackBar',);
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Center(
          child: CustomSmallMainButton(
            title: '测试Toast',
            onTap: () {
              CustomSnackBar.show(title: '这是标题','发生了错误', context, preIcon: CustomSnackBarIcons.error);
            },
          ),
        ),
      ],
    );
  }

}
