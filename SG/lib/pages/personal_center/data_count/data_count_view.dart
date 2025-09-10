import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/personal_center/data_count/sub_tab_bar_view.dart';

import '../../../base/getx/base_view.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../routes/routes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import 'data_count_logic.dart';

///对外显示页面方法
Future<void> showDataCountWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kDataCountPage,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return DataCountPage();
      });
}

///个人中心-数据统计
const kDataCountPage = 'DataCountPage';

class DataCountPage extends BaseView<DataCountLogic> {
  DataCountPage({super.key});

  ///打开页面
  static openPage() {
    RouteUtil.pushToView(Routes.personalDataCount);
  }


  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleView: Text(S.current.tab_bar_title_data_statistics_text),
      showLeading: true,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin,vertical: AppValues.largeMargin),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTop(),
          _buildContent(),
        ],
      ),
    );
  }

  _buildTop() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const CustomIcon(
            color: AppThemes.iconColor,
            asset: "assets/images/personal_center_icon/count_data.webp",
            size: 18,
          ),
          const SizedBox(
            width: 4,
          ),
          CustomText(
            "test001",
            style:
                ThemeService().theme.textTheme.labelLarge,
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              S.current.random_text_357,
              style:
                  ThemeService().theme.textTheme.labelLarge,
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomIcon(
              color: AppThemes.iconColor,
              asset: "assets/images/personal_center_icon/count_data.webp",
              size: 16,
            ),
            const CustomIcon(
              color: AppThemes.iconColor,
              asset: "assets/images/personal_center_icon/count_data.webp",
              size: 16,
            ),
          ],
        ),
      ],
    );
  }

  _buildContent() {
    return const SubTabBarView();
  }
}
