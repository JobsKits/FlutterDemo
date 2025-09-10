import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_small_mian_button.dart';
import 'package:flutter_bet/widget/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'logic.dart';

class TestStatePage extends BaseView<TestStateLogic> {
  TestStatePage({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return CustomAppBar(
      appBarTitleText: '测试状态页面',
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: CustomSmallMainButton(
            title: '测试3秒Loading',
            onTap: () => controller.onTestLoading(),
          ),
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        Center(
          child: CustomSmallMainButton(
            title: '测试5秒网络异常',
            onTap: () => controller.onTestNetWorkError(),
          ),
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        Center(
          child: CustomSmallMainButton(
            title: '测试3秒空状态',
            onTap: () => controller.onTestEmpty(),
          ),
        ),
      ],
    );
  }
}
