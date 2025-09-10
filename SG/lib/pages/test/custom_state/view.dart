import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_loading_widget.dart';
import 'package:flutter_bet/widget/network_image/custom_netework_error_view.dart';
import 'package:flutter/material.dart';
import 'logic.dart';

class TestCustomStatePage extends BaseView<TestCustomStateLogic> {
  TestCustomStatePage({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return CustomAppBar(
      appBarTitleText: '测试自定义状态页面',
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return SingleChildScrollView(
      child: Column(
        children: [
          const CustomLoadingWidget(
            width: 200,
            height: 200,
            color: Colors.black,
          ),
          CustomNetWorkErrorView(
            color: Colors.blue.withOpacity(0.2),
          ),
          const SizedBox(
            height: 20,
          ),
          const CustomEmptyWidget(
            backgroundColor: Colors.greenAccent,
            imgPath: 'assets/images/ic_no_bet_bill.png',
          ),
          CustomEmptyWidget(
            backgroundColor: Colors.blueGrey,
            imgPath: 'assets/images/ic_on_game_state.png',
            textBuilder: (context) {
              return Column(
                children: [
                  Text(
                    '我们搜索不到任何游戏',
                    style: ThemeService()
                        .theme
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '您所在的地区也许无法使用',
                    style: ThemeService().theme.textTheme.titleSmall?.copyWith(
                        color: ThemeService().theme.colorScheme.onSurface),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 100,),
        ],
      ),
    );
  }
}
