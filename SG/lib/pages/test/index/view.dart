import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/test/dialog/test_dialog.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/theme/theme_color.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:flutter_bet/widget/input/custom_text_field.dart';
import 'package:flutter_bet/widget/custom_picker_action_sheet.dart';
import 'package:flutter_bet/widget/dialog/custom_dialog.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/update/custom_update_controller.dart';
import 'package:flutter_bet/widget/update/custom_update_dialog.dart';
import 'package:get/get.dart';

import 'logic.dart';

class TestPage extends BaseView<TestLogic> {
  TestPage({Key? key}) : super(key: key);
  final GlobalKey _widgetKey = GlobalKey(); // 创建一个GlobalKey
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return CustomAppBar(
      appBarTitleText: '测试',
      showLeading: false,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(AppValues.defaultPadding),
            child: CustomMainTextField(
              isShowDeleteBtn: true,
              hintText: "请输入用户名或邮箱",
              title: '密码 *',
              showError: true,
              errorText: '用户名不能为空',
              inputCallBack: (value) {},
            ),
          ),
          CustomButton(
            onTap: () {
              DialogUtils.showCustomBubbleDialog(
                  context, _viewBubbleChild(), 78,
                  widgetKey: _widgetKey, height: 150);
            },
            child: Text(
              'CustomButton点击弹出气泡',
            ),
            key: _widgetKey,
          ),
          CustomButton(
            onTap: () {
              DialogUtils.showCustomMineRightDialog(context);
            },
            child: Text(
              'CustomButton点击右侧弹窗',
            ),
          ),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testButtonPage);
              },
              child: const Text('CustomButton样例')),
          CustomButton(
              onTap: () {
                showCustomPickerActionSheet(context: context);
              },
              child: const Text('图片上传组件')),
          CustomButton(
              onTap: () async {
                final result = await showCustomDialog(
                  title: S.current.random_text_347,
                  confirm: S.current.random_text_529,
                  context: context,
                  content: '弹窗提示内容弹窗提示内容弹窗提示内容弹窗提示内容弹窗提示内容',
                );
                if (result == true) {
                  debugPrint('用户点击了确认按钮');
                }
              },
              child: const Text('通用弹窗样例')),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testStatePage);
              },
              child: const Text(
                '页面状态样例',
                style: TextStyle(color: Colors.cyan),
              )),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testCustomStatePage);
              },
              child: const Text('自定义页面状态样例')),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testLifeCyclePage);
              },
              child: const Text(
                '生命周期样例',
              )),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testHUDPage);
              },
              child: const Text('HUD样例')),
          CustomButton(
              onTap: () {
                showCustomUpdateDialog(
                    context: context,
                    title: 'APP更新',
                    remark: '备注',
                    canForceUpdate: true,
                    controller: CustomUpdateController(),
                    onConfirm: () {});
              },
              child: const Text('更新弹窗')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('开启暗黑模式'),
              Switch(
                  value: ThemeService.instance.isDarkMode,
                  onChanged: (value) {
                    if (value) {
                      ThemeService.instance.switchTheme(ThemeMode.dark);
                    } else {
                      ThemeService.instance.switchTheme(ThemeMode.light);
                    }
                  }),
            ],
          ),
          Column(
            children: [
              const Text('选择主题色(点击切换)'),
              _buildColorRow(),
            ],
          ),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.needLoginPage);
              },
              child: const Text('测试拦截器')),
          Text('国际化文本：${S.of(context).hello_text}'),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testTextPage);
              },
              child: const Text('测试Text配置')),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testColorPage);
              },
              child: const Text('测试颜色调色板配置')),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testTabbarPage);
              },
              child: const Text('测试自定义tabbar')),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testSnackBarPage);
              },
              child: const Text('测试SnackBar')),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testOtherPage);
              },
              child: const Text('测试其它Widget')),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testRefreshPage);
              },
              child: const Text('测试其它上拉下拉刷新')),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.expansionPage);
              },
              child: const Text('测试折叠菜单')),
          CustomButton(
              onTap: () {
                RouteUtil.pushToView(Routes.testKeyboardPage);
              },
              child: const Text('测试键盘')),

          CustomButton(
              onTap: () {
                showCustomTestDialog(context: context);
              },
              child: const Text('测试键盘')),

          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  _buildColorRow() {
    List<Widget> widgets = [];
    for (ThemeColor themeColor in ThemeService.instance.themeColors) {
      widgets.add(GestureDetector(
        onTap: () {
          ThemeService.instance.switchThemeColor(themeColor);
        },
        child: ThemeColorCard(
            color: Color(themeColor.value.value), label: themeColor.label),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  _viewBubbleChild() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Text(
            "总分盘",
            style: ThemeService().theme.textTheme.bodySmall?.copyWith(
                color: AppThemes.textColorDark,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "让分盘",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "获胜盘",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "总分盘",
            style: ThemeService().theme.textTheme.bodySmall?.copyWith(
                color: AppThemes.textColorDark,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "让分盘",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "获胜盘",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "总分盘",
            style: ThemeService().theme.textTheme.bodySmall?.copyWith(
                color: AppThemes.textColorDark,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "让分盘",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "获胜盘",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class ThemeColorCard extends StatelessWidget {
  final Color color;
  final String label;

  const ThemeColorCard({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 30,
          child: Container(
            color: color,
          ),
        ),
        Center(
          child: Text(label),
        )
      ],
    );
  }
}
