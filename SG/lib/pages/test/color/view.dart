import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:get/get.dart';
import 'logic.dart';

class TestColorPage extends BaseView<TestColorLogic> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return const CustomAppBar(
      appBarTitleText: '测试调色板',
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: 1200,
        padding:
            const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            TestColorCard(
                title: '#1475E1主题色:',
                color: ThemeService().theme.colorScheme.primary),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            TestColorCard(
                title: '#1A2C38默认背景颜色:',
                color: ThemeService().theme.colorScheme.background),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            TestColorCard(
                title: '#0F212E Widget默认背景颜色:',
                color: ThemeService().theme.colorScheme.surface),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            TestColorCard(
                title: '#213743 第二种Widget默认背景颜色(例如ListView Card):',
                color: ThemeService().theme.colorScheme.surfaceVariant),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            TestColorCard(
                title: '#FF2F4553 Widget定制背景色(例如snack bar:)',
                color: ThemeService().theme.colorScheme.tertiary),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
             TestColorCard(
                title: '默认Icon的颜色:', color: ThemeService().theme.iconTheme.color ?? Colors.red),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: '正面状态的颜色:', color: AppThemes.frontStateColor),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: '负面状态的颜色:', color: AppThemes.reverseStateColor),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: '倒计时覆盖:', color: AppThemes.countDownOverColor),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: '倒计时图标:', color: AppThemes.countDownIconColor),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            TestColorCard(
                title: '默认文字颜色(兼容暗黑模式):',
                color: ThemeService().theme.colorScheme.onBackground),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: '文字颜色白色',
                color: AppThemes.textColorWhite),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: '文字颜色黑色',
                color: AppThemes.textColorDark),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: 'secondary文字颜色',
                color: AppThemes.textColorSecondary),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: '文字颜色灰色',
                color: AppThemes.textColorGrey),

            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            TestColorCard(
                title: '输入框提示颜色:', color: ThemeService().theme.colorScheme.error),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: '搜索图标:', color: AppThemes.secondaryIconColor),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: '登陆发送字体:', color: AppThemes.loginSendColor),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            TestColorCard(
                title: '按钮颜色:',
                color: ThemeService().theme.colorScheme.primary),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            TestColorCard(
                title: '#4391e7比主题色浅一点:', color: ThemeService().theme.colorScheme.secondary),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            TestColorCard(
                title: '聊天室按钮背景色:',
                color: ThemeService().theme.colorScheme.primaryContainer),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            const TestColorCard(
                title: '比分文本色:', color: AppThemes.scoreTextColor),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
          ],
        ),
      ),
    );
  }
}

class TestColorCard extends StatelessWidget {
  final String title;
  final Color color;

  const TestColorCard({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          title,
          maxLines: 2,
        )),
        const SizedBox(
          width: AppValues.defaultPadding,
        ),
        Container(
          width: 60,
          height: 33,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2), color: color),
        )
      ],
    );
  }
}
